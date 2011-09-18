package com.soueidan.games.lobby.responses
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.soueidan.games.engine.managers.ServerManager;
	import com.soueidan.games.engine.net.Server;
	
	public class ServerResponseHandler
	{
		protected var _server:Server = ServerManager.getInstance();
		private var _action:String;
		
		public function get action():String
		{
			return _action;
		}
		
		public function set action(value:String):void
		{
			_action = value;
		}
		
		public function handleServerResponse(event:SFSEvent):void {
			
		}
	}
}