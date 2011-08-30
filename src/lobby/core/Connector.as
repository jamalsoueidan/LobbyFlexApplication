package lobby.core
{
	import com.adobe.crypto.SHA1;
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.exceptions.SFSError;
	import com.smartfoxserver.v2.logging.Logger;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.smartfoxserver.v2.requests.JoinRoomRequest;
	import com.smartfoxserver.v2.requests.LoginRequest;
	import com.smartfoxserver.v2.requests.PublicMessageRequest;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import lobby.events.*;
	import lobby.managers.UserManager;
	import lobby.responses.ServerResponseHandler;
	
	import mx.events.FlexEvent;
	
	import spark.components.Application;
	
	public class Connector extends SmartFox
	{
		private var _parameters:Object;
		private var _responseHandlers:Object = {};
		private var _xml:XML;
		
		public function set parameters(value:Object):void {
			_parameters = value;
		}
		
		public function get gameId():int {
			return _xml.id;
		}
		
		public function start(xmlData:String):void {
			addEventListener(SFSEvent.CONNECTION, connection);
			addEventListener(SFSEvent.EXTENSION_RESPONSE, responseHandler);
			
			_xml = new XML(xmlData);
			
			connect(_xml.host, _xml.port);
		}
		
		private function responseHandler(event:SFSEvent):void {
			var action:String = event.params.cmd;
			
			var handlers:Array = _responseHandlers[action];
			if ( !handlers ) {
				trace("No responseHandlers for", action);
				return;
			}
			
			trace("Executing", action);
			
			var handler:ServerResponseHandler;
			for each(var theClass:* in handlers) {
				handler = new theClass();
				handler.action = action;
				handler.handleServerResponse(event)
			}
		}
		
		public function addResponseHandler(requestId:String, theClass:*):void {
			var handlers:Array = _responseHandlers[requestId];
			if ( !handlers) {
				handlers = new Array();
			}
			
			handlers.push(theClass);
			_responseHandlers[requestId] = handlers;
		}
		
		
		private function connection(event:SFSEvent):void
		{
			Logger.getInstance().info("Connection made");
			
			var params:ISFSObject = new SFSObject();
			params.putUtfString("session", _parameters.session);
			params.putUtfString("room", _parameters.room);
			
			var request:IRequest = new LoginRequest("","",_xml.zone, params);
			send(request);
		}	
	}
}