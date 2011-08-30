package lobby.managers
{
	import lobby.core.Connector;

	public class ConnectManager
	{
		static private var _server:Connector;
		
		static public function getInstance():Connector {
			if ( !_server ) {
				_server = new Connector();
			}
			
			return _server;
		}
	}
}