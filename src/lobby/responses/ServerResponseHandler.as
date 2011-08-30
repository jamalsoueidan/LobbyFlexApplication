package lobby.responses
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	
	import lobby.core.Connector;
	import lobby.managers.ConnectManager;
	
	public class ServerResponseHandler
	{
		protected var _server:Connector = ConnectManager.getInstance();
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