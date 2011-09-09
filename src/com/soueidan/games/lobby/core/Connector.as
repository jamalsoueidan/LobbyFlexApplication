package com.soueidan.games.lobby.core
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.Room;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.logging.Logger;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.smartfoxserver.v2.requests.LoginRequest;
	import com.soueidan.games.lobby.events.*;
	import com.soueidan.games.lobby.responses.ServerResponseHandler;
	
	public class Connector extends SmartFox
	{
		private var _parameters:Object;
		private var _responseHandlers:Object = {};
		private var _xml:XML;
		
		public function Connector(debug:Boolean=false) {
			super(debug);
		}
		
		public function set parameters(value:Object):void {
			_parameters = value;
		}
		
		public function get gameId():int {
			return _xml.id;
		}
		
		public function get currentRoom():Room {
			return getRoomByName("lobby");
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
				if ( theClass is Function ) {
					theClass(event);
				} else {
					handler = new theClass();
					handler.action = action;
					handler.handleServerResponse(event)
				}
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
			params.putUtfString("room", "lobby");
			params.putInt("game_id", Number(_xml.id));
			
			var request:IRequest = new LoginRequest("","",_xml.zone, params);
			send(request);
		}	
	}
}