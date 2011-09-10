package com.soueidan.games.lobby.core
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.entities.data.ISFSArray;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.soueidan.games.lobby.components.popups.AutoPlayPopUpWindow;
	import com.soueidan.games.lobby.managers.ConnectManager;
	import com.soueidan.games.lobby.requests.FindPlayerRequest;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.utils.setInterval;
	
	import mx.events.CloseEvent;
	import mx.events.DragEvent;
	
	import spark.components.Button;

	public class AutoPlayHandler
	{
		private var _button:Button;
		private var _autoPlayWindow:AutoPlayPopUpWindow;
		private var _server:Connector = ConnectManager.getInstance();
		
		public function AutoPlayHandler(button:Button)
		{
			_button = button;
			
			_button.addEventListener(MouseEvent.CLICK, clicked);
			
			_autoPlayWindow = new AutoPlayPopUpWindow();
			_autoPlayWindow.addEventListener(CloseEvent.CLOSE, closedWindow);
			
			_server.addResponseHandler(FindPlayerRequest.UPDATE_STATUS, startGame);
		}
		
		private function closedWindow(event:CloseEvent):void
		{
			_autoPlayWindow.hide();
			
			var request:IRequest = new FindPlayerRequest(false);
			_server.send(request);
		}
		
		private function clicked(event:MouseEvent):void
		{			
			var request:IRequest = new FindPlayerRequest(true);
			_server.send(request);
			
			_autoPlayWindow.show();
		} 
		
		private function startGame(event:SFSEvent):void {
			var params:ISFSObject = event.params.params as SFSObject
			var room:String = params.getUtfString("room");
			_autoPlayWindow.playerFound();
			_autoPlayWindow.addEventListener(Event.COMPLETE, function():void {
				ExternalInterface.call("start_match", room);		
			});
		}
	}
}