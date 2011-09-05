package com.soueidan.games.lobby.core 
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.entities.invitation.InvitationReply;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.soueidan.games.lobby.components.*;
	import com.soueidan.games.lobby.events.*;
	import com.soueidan.games.lobby.managers.*;
	import com.soueidan.games.lobby.responses.CreateRoomResponse;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import spark.components.*;
	import spark.events.*;

	[ResourceBundle("resources")] 
	public class App extends Application
	{
		private var _entrance:Entrance;
		
		private var _server:Connector;
		private var _parameters:Object;
		
		private var _urlLoader:URLLoader;
		
		public function App():void {
			super();
			
			ApplicationManager.setInstance(this);
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			_parameters = systemManager.loaderInfo.parameters	
				
			if ( _parameters.language == "ar" ) {
				resourceManager.localeChain = ['ar', 'en'];
			} else {
				resourceManager.localeChain = ['en', 'ar'];
			}
			
			layoutDirection = resourceManager.getString('resources','direction');
				
			if ( !_entrance ) {
				_entrance = new Entrance();
			}			
			
			if ( !_urlLoader ) {
				_urlLoader = new URLLoader();
				_urlLoader.addEventListener(Event.COMPLETE, configurationFileReady);
				_urlLoader.load(new URLRequest(_parameters.config));
			}
		}
		
		private var _timer:Timer;
		private function configurationFileReady(event:Event):void
		{
			trace("setup configuration");
			_server = ConnectManager.getInstance();
			_server.parameters = _parameters;
			_server.addEventListener(SFSEvent.CONNECTION_LOST, lostConnection);
			_server.addEventListener(SFSEvent.CONNECTION_RESUME, lostConnection);
			_server.addEventListener(SFSEvent.CONNECTION_RETRY, lostConnection);
			_server.addEventListener(SFSEvent.ROOM_JOIN, roomJoined);
			_server.addEventListener(SFSEvent.INVITATION_REPLY, invitationReply);
			_server.addResponseHandler(CreateRoomResponse.CREATE_ROOM, CreateRoomResponse);
			_server.start(_urlLoader.data);
			
			_timer = new Timer(1000,1000);
			_timer.start();
		}
		
		private function lostConnection(event:SFSEvent):void
		{
			trace(_timer.currentCount);
			trace(event.type);
		}
		
		private function roomJoined(evt:SFSEvent):void
		{	
			trace("room joined");
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