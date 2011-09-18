package com.soueidan.games.lobby.core 
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.data.*;
	import com.soueidan.games.engine.components.popups.PopUpWindow;
	import com.soueidan.games.engine.core.EngineApplication;
	import com.soueidan.games.engine.managers.ServerManager;
	import com.soueidan.games.engine.net.Server;
	import com.soueidan.games.lobby.components.*;
	import com.soueidan.games.lobby.components.popups.*;
	import com.soueidan.games.lobby.events.*;
	import com.soueidan.games.lobby.managers.*;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import spark.components.*;
	import spark.events.*;

	[ResourceBundle("resources")] 
	public class App extends EngineApplication
	{
		private var _entrance:Entrance;
		
		private var _server:Server;
		
		private var _urlLoader:URLLoader;
		
		override protected function createChildren():void {
			super.createChildren();
				
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
			_server = ServerManager.getInstance();
			_server.parameters = _parameters;
			_server.addEventListener(SFSEvent.LOGIN_ERROR, loginError);
			_server.addEventListener(SFSEvent.CONNECTION_LOST, lostConnection);
			_server.addEventListener(SFSEvent.ROOM_JOIN, roomJoined);
			_server.start(_urlLoader.data);
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
			}
			
			if ( params.reason == "ban" ) {
				popup = new BanPopUpWindow();
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