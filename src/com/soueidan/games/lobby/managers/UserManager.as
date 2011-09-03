package com.soueidan.games.lobby.managers
{	
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.soueidan.games.lobby.core.PermissionProfile;

	public class UserManager
	{		
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
		
		public static function avatar(_sfsUser:SFSUser):String
		{
			return _sfsUser.getVariable("avatar_url").getStringValue();
		}
	}
}