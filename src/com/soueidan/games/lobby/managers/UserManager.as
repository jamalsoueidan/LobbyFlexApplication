package com.soueidan.games.lobby.managers
{	
	import com.smartfoxserver.v2.entities.SFSUser;
	
	import com.soueidan.games.lobby.core.PermissionProfile;

	public class UserManager
	{
		static public const GUEST_COLOR:int = 0x458B00;
		static public const REGISTERED_COLOR:int = 0x009ACD;
		
		static public function privilege(user:SFSUser):String {
			if ( user.privilegeId == PermissionProfile.ADMIN_ID ) {
				return PermissionProfile.ADMIN;
			} else if( user.privilegeId == PermissionProfile.MODERATOR_ID ) {
				return PermissionProfile.MODERATOR;
			} else if ( user.privilegeId == PermissionProfile.STANDARD_ID ) {
				return PermissionProfile.STANDARD;
			} else {
				return PermissionProfile.GUEST;
			}
		}
		
		static public function isRegistered(user:SFSUser):Boolean {
			return true;
		}
	
		static private var session:String;
		static public function setSession(value:String):void {
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