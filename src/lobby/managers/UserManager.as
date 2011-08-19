package lobby.managers
{	
	import com.smartfoxserver.v2.entities.SFSUser;

	public class UserManager
	{
		static public const GUEST_COLOR:int = 0x458B00;
		static public const REGISTERED_COLOR:int = 0x009ACD;
		
		static public function isRegistered(user:SFSUser):Boolean {
			return (user.getVariable("isRegistered").getBoolValue());
		}
	
		static private var session:String;
		static public function setSession(value:String):void {
			trace(value);
			session = value;
		}
		
		static public function getSession():String {
			return session;
		}
		
		static public function getColor(user:SFSUser):int {
			if ( isRegistered(user) ) {
				return REGISTERED_COLOR;
			} 
			return GUEST_COLOR;
		}
	}
}