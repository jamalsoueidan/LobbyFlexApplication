package lobby.core
{
	import com.smartfoxserver.v2.entities.*;
	
	public class User extends SFSUser implements com.smartfoxserver.v2.entities.User
	{		
		public function User(id:int, name:String, isItMe:Boolean):void {
			super(id, name, isItMe);
		}
		
		public function get isRegistered():Boolean {
			return true;
		}
		
	}
}