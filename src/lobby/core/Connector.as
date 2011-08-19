package lobby.core
{
	import com.adobe.crypto.SHA1;
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.exceptions.SFSError;
	import com.smartfoxserver.v2.logging.Logger;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.smartfoxserver.v2.requests.JoinRoomRequest;
	import com.smartfoxserver.v2.requests.LoginRequest;
	import com.smartfoxserver.v2.requests.PublicMessageRequest;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import lobby.events.*;
	import lobby.managers.UserManager;
	
	import mx.events.FlexEvent;
	
	import spark.components.Application;
	
	public class Connector extends SmartFox
	{
		
		public function Connector(debug:Boolean=false):void {
			super(false);
			
			addEventListener(SFSEvent.CONNECTION, connection);

			loadConfig("config.xml");

		}
		
		private function connection(event:SFSEvent):void
		{
			Logger.getInstance().info("Connection made");
		}	
	}
}