package com.soueidan.games.lobby.components
{
	import com.smartfoxserver.v2.entities.SFSUser;
	
	import com.soueidan.games.lobby.managers.UserManager;
	
	import spark.components.Button;
	
	public class UserButton extends Button
	{
		private var _info:SFSUser;
		
		public function UserButton(info:SFSUser)
		{
			super();
			
			_info = info;
			
			label = _info.name;
		}
		
		public function get user():SFSUser {
			return _info;
		}
	}
}