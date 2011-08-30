package com.soueidan.games.lobby.components
{
	import com.smartfoxserver.v2.entities.SFSUser;
	
	import com.soueidan.games.lobby.core.*;
	import com.soueidan.games.lobby.managers.*;
	
	import spark.components.*;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.VerticalLayout;

	public class Entrance extends TitleWindow
	{
		private var _top:HGroup;
		
		private var _userProfile:UserProfile;
		
		private var _bottom:HGroup;
		
		private var _userList:UserList;
		private var _roomList:RoomList;
		
		public function Entrance():void {
			super();
			
			title = "Lobby";
			
			var verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.paddingBottom = verticalLayout.paddingLeft = verticalLayout.paddingRight = verticalLayout.paddingTop = 10;
			
			layout = verticalLayout;
			
			setStyle("verticalCenter", 0);
			setStyle("horizontalCenter", 0);
			
			width = 400;
			height = 400;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if ( !_top ) {
				_top = new HGroup();
				addElement(_top);
			}
			
			if ( !_userProfile ) {
				_userProfile = new UserProfile();
				_userProfile.sfsUser = ConnectManager.getInstance().mySelf as SFSUser;
				_top.addElement(_userProfile);
			}
			
			if ( !_bottom ) {
				_bottom = new HGroup();
				addElement(_bottom);
			}
			
			if ( !_userList ) {
				_userList = new UserList();
				_bottom.addElement(_userList);
			}
			
			if ( !_roomList ) {
				_roomList = new RoomList();
				_bottom.addElement(_roomList);
			}
		}
	}
}