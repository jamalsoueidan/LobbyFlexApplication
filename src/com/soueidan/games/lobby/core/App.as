package com.soueidan.games.lobby.core 
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.entities.invitation.InvitationReply;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.soueidan.games.lobby.components.*;
	import com.soueidan.games.lobby.components.popups.ConnectionLostPopUpWindow;
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
			_server.addEventListener(SFSEvent.CONNECTION_LOST, lostConnection);
			_server.addEventListener(SFSEvent.ROOM_JOIN, roomJoined);
			_server.start(_urlLoader.data);
			
			//private var _timer:Timer;
			/*_timer = new Timer(1000,1000);
			_timer.start();*/
			
		}
		
		private function lostConnection(event:SFSEvent=null):void {
			var popup:ConnectionLostPopUpWindow = new ConnectionLostPopUpWindow();
			popup.show();
		}
		
		private function roomJoined(evt:SFSEvent):void
		{	
			addElement(_entrance);
			_server.removeEventListener(SFSEvent.ROOM_JOIN, roomJoined);
		}		
	}
}