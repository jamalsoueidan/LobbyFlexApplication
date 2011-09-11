package com.soueidan.games.lobby.managers
{
	import com.soueidan.games.lobby.core.Connector;

	public class ConnectManager
	{
		static private var _server:Connector;
		
		static public function getInstance():Connector {
			if ( !_server ) {
				_server = new Connector(false);
			}
			
			return _server;
		}
	}
}