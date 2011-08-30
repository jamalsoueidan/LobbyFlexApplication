package lobby.core 
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.Room;
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.entities.data.ISFSArray;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.entities.invitation.InvitationReply;
	import com.smartfoxserver.v2.exceptions.SFSError;
	import com.smartfoxserver.v2.requests.CreateRoomRequest;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.smartfoxserver.v2.requests.RoomExtension;
	import com.smartfoxserver.v2.requests.RoomSettings;
	import com.smartfoxserver.v2.requests.game.InvitationReplyRequest;
	
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import lobby.components.*;
	import lobby.events.*;
	import lobby.managers.*;
	import lobby.responses.CreateRoomResponse;
	
	import mx.events.FlexEvent;
	
	import spark.components.*;
	import spark.events.*;

	public class App extends Application
	{
		private var _entrance:Entrance;
		
		private var _server:Connector;
		private var _parameters:Object;
		
		private var _urlLoader:URLLoader;
		
		override protected function createChildren():void {
			super.createChildren();
			
			ApplicationManager.setInstance(this);
			_parameters = systemManager.loaderInfo.parameters
				
			if ( !_entrance ) {
				_entrance = new Entrance();
			}			
			
			if ( !_urlLoader ) {
				_urlLoader = new URLLoader();
				_urlLoader.addEventListener(Event.COMPLETE, configurationFileReady);
				_urlLoader.load(new URLRequest(_parameters.config));
			}
		}
		
		private function configurationFileReady(event:Event):void
		{
			_server = ConnectManager.getInstance();
			_server.parameters = _parameters;
			_server.addEventListener(SFSEvent.ROOM_JOIN, roomJoined);
			_server.addEventListener(SFSEvent.INVITATION_REPLY, invitationReply);
			_server.addResponseHandler(CreateRoomResponse.CREATE_ROOM, CreateRoomResponse);
			_server.start(_urlLoader.data);
		}
		
		private function roomJoined(evt:SFSEvent):void
		{	
			addElement(_entrance);
			_server.removeEventListener(SFSEvent.ROOM_JOIN, roomJoined);
		}
		
		protected function invitationReply(event:SFSEvent):void
		{
			if ( event.params.reply != InvitationReply.ACCEPT ) {
				return;
			}
						
			var params:ISFSObject = new SFSObject();
			
			// set all players
			var users:ISFSArray = new SFSArray();
			users.addInt(event.params.invitee.id);
			params.putSFSArray("users", users);
			
			// set game id
			params.putInt("game_id", _server.gameId);
			
			var extensionRequest:ExtensionRequest = new ExtensionRequest(CreateRoomResponse.CREATE_ROOM, params);
			_server.send(extensionRequest);
		}		
	}
}