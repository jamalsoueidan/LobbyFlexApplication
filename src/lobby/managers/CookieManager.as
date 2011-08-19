package lobby.managers
{
	import com.smartfoxserver.v2.entities.SFSUser;
	
	import flash.net.SharedObject;

	public class CookieManager
	{
		static private var so:SharedObject = SharedObject.getLocal("userData");
		
		static public function getSession():String {
			return so.data.session;
		}
		
		static public function setSession(value:String):void {
			so.data.session = value;
			so.flush();
		}
		
		static public function getKey(name:String):String {
			return so.data[so];
		}
		
		static public function setKey(name:String, value:String):void {
			so.data[name] = value;
			so.flush();
		}
	}
}