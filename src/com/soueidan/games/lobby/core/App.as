package com.soueidan.games.lobby.core 
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.entities.invitation.InvitationReply;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.soueidan.games.lobby.components.*;
	import com.soueidan.games.lobby.components.popups.BanPopUpWindow;
	import com.soueidan.games.lobby.components.popups.ConnectionLostPopUpWindow;
	import com.soueidan.games.lobby.components.popups.KickPopUpWindow;
	import com.soueidan.games.lobby.components.popups.NoConnectionPopUpWindow;
	import com.soueidan.games.lobby.components.popups.PopUpWindow;
	import com.soueidan.games.lobby.events.*;
	import com.soueidan.games.lobby.managers.*;
	import com.soueidan.games.lobby.responses.CreateGameResponse;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.setInterval;
	
	import mx.managers.PopUpManager;
	
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
				resourceManager.localeChain = ['ar'];
			} else {
				resourceManager.localeChain = ['en_US'];
			}
			
			var path:String = "";
			if ( _parameters.debug != "true") {
				path = "/";
			}
			
			styleManager.loadStyleDeclarations(path + "assets/styles/" + ResourceManager.locale + ".swf", true, true);
			
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
		

		private function configurationFileReady(event:Event):void
		{
			trace("setup configuration");
			_server = ConnectManager.getInstance();
			_server.parameters = _parameters;
			_server.addEventListener(SFSEvent.LOGIN_ERROR, loginError);
			_server.addEventListener(SFSEvent.CONNECTION_LOST, lostConnection);
			_server.addEventListener(SFSEvent.CONNECTION, connection);
			_server.addEventListener(SFSEvent.ROOM_JOIN, roomJoined);
			_server.start(_urlLoader.data);
		}
		
		protected function connection(event:SFSEvent):void
		{
			if ( !event.params.success ) {
				var popup:PopUpWindow = new NoConnectionPopUpWindow();
				popup.show();
			}
			
		}
		
		protected function loginError(event:SFSEvent):void
		{
			var params:Object = event.params;
			var popup:PopUpWindow;
			if ( params.errorCode == 4 ) {
				popup = new BanPopUpWindow();
				popup.show();
			}
			
			shutDown();
		}
		
		private function shutDown():void
		{
			_server.removeEventListener(SFSEvent.CONNECTION_LOST, lostConnection);
			_server.disconnect();
		}
		
		private function lostConnection(event:SFSEvent=null):void {
			var params:Object = event.params;
			var popup:PopUpWindow;
			if ( params.reason == "kick") {
				popup = new KickPopUpWindow();
			} else if ( params.reason == "ban" ) {
				popup = new BanPopUpWindow();
			} else {
				popup = new ConnectionLostPopUpWindow();
			}
			
			popup.show();
			shutDown();
		}
		
		private function roomJoined(evt:SFSEvent):void
		{	
			addElement(_entrance);
			_server.removeEventListener(SFSEvent.ROOM_JOIN, roomJoined);
		}		
	}
}