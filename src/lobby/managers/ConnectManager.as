package lobby.managers
{
	import lobby.core.Connector;

	public class ConnectManager
	{
		static private var _server:Connector;
		
		static public function get server():Connector {
			if ( !_server ) {
				_server = new Connector(true);
			}
			
			return _server;
		}
	}
}