package lobby.core 
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.Room;
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.entities.invitation.InvitationReply;
	import com.smartfoxserver.v2.exceptions.SFSError;
	import com.smartfoxserver.v2.requests.CreateRoomRequest;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.smartfoxserver.v2.requests.RoomExtension;
	import com.smartfoxserver.v2.requests.RoomSettings;
	import com.smartfoxserver.v2.requests.game.InvitationReplyRequest;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	
	import lobby.components.*;
	import lobby.components.login.*;
	import lobby.events.*;
	import lobby.managers.*;
	
	import mx.events.FlexEvent;
	
	import spark.components.*;
	import spark.events.*;

	public class App extends Application
	{
		static public const URL:String = "http://localhost:3000/";
		static public const LOBBY:String = "Lobby";
		static public const GROUP_GAMES:String = "game";
		
		private var _login:Login;
		
		private var _entrance:Entrance;
		
		private var _server:Connector;
		
		override protected function createChildren():void {
			
			super.createChildren();
			
			if (!_login ) {
				_login = new Login();
				addElement(_login);
			}
			
			if ( !_entrance ) {
				_entrance = new Entrance();
			}
			
			_server = ConnectManager.server;
			_server.addEventListener(SFSEvent.ROOM_JOIN, roomJoined);
			_server.addEventListener(SFSEvent.EXTENSION_RESPONSE, extensionResponse);
		}
		
		private function roomJoined(evt:SFSEvent):void
		{	
			_server.removeEventListener(SFSEvent.ROOM_JOIN, roomJoined);
			
			removeElement(_login);
			addElement(_entrance);
			
			_server.addEventListener(SFSEvent.INVITATION_REPLY, invitationReply);
		}
		
		protected function invitationReply(event:SFSEvent):void
		{
			if ( event.params.reply != InvitationReply.ACCEPT ) {
				return;
			}
						
			var params:ISFSObject = new SFSObject();
			params.putUtfString("invitee", event.params.invitee.name); 
			
			var extensionRequest:ExtensionRequest = new ExtensionRequest(ExtensionResponse.CREATE_CUSTOM_ROOM, params);
			_server.send(extensionRequest);
		}
		
		protected function extensionResponse(event:SFSEvent):void
		{
			var action:String = event.params.cmd;
			var object:SFSObject = event.params.params as SFSObject;
	
			trace(action);
			
			switch(action)
			{
				case ExtensionResponse.CREATE_CUSTOM_ROOM:
				{
					_server.disconnect();
					ExternalInterface.call("redirectTo", object.getUtfString("roomName"), UserManager.getSession());
					break;
				}
				
				case ExtensionResponse.SESSION_KEY: 
				{
					UserManager.setSession(object.getUtfString("session"));
					CookieManager.setSession(object.getUtfString("session"));
					break;	
				}
				default:
				{
					break;
				}
			}
		}
		
	}
}