package com.soueidan.games.lobby.managers
{	
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.entities.User;
	import com.soueidan.games.lobby.core.PermissionProfile;
	import com.soueidan.games.lobby.core.StatusProfile;

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
		
		public static function avatar(user:SFSUser):String
		{
			return user.getVariable("avatar_url").getStringValue();
		}
		
		public static function win(user:SFSUser):Number
		{
			return user.getVariable("win").getIntValue(); 
		}
		
		public static function loss(user:SFSUser):Number
		{
			return user.getVariable("loss").getIntValue();
		}
		
		public static function points(user:SFSUser):Number
		{
			return user.getVariable("points").getIntValue();
		}
		
		public static function timesPlayed(user:SFSUser):Number
		{
			return UserManager.win(user) + UserManager.loss(user);
		}
		
		public static function isReady(user:User):Boolean
		{
			return ( user.getVariable("status").getIntValue() == StatusProfile.isPlay );
		}
		
		public static function isVip(user:SFSUser):Boolean {
			return user.getVariable("vip").getBoolValue();
		}
	}
}