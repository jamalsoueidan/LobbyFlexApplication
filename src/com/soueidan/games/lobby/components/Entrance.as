package com.soueidan.games.lobby.components
{
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.soueidan.games.lobby.core.*;
	import com.soueidan.games.lobby.interfaces.ITab;
	import com.soueidan.games.lobby.managers.*;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Spacer;
	import mx.events.FlexEvent;
	
	import spark.components.*;
	import spark.events.IndexChangeEvent;
	import spark.layouts.VerticalLayout;
	import com.soueidan.games.lobby.components.users.UserProfile;

	public class Entrance extends VGroup
	{
		
		private static const FIRST_COLUMN_WIDTH:int = 300;
		private static const SECOND_COLUMN_WIDTH:int = 100;
		
		private var _top:HGroup;
		private var _userProfile:UserProfile;
		
		private var _bottom:HGroup;
		
		private var _userList:UserList;
		
		private var _roomList:ITab;
		private var _chatList:ITab;
		
		private var _inviteHandler:InviteHandler;
		
		public function Entrance():void {
			super();
			
			percentWidth = percentHeight = 100;
			addEventListener(FlexEvent.CREATION_COMPLETE, creationDone);	
		}
		
		private function creationDone(event:FlexEvent):void
		{
			_inviteHandler = new InviteHandler(_userList);
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if ( !_top ) {
				_top = new HGroup();
				_top.percentWidth = 100;
				_top.paddingLeft = FIRST_COLUMN_WIDTH + 8;
				addElement(_top);
			}
			
			if ( !_userProfile ) {
				_userProfile = new UserProfile();
				_userProfile.percentWidth = FIRST_COLUMN_WIDTH;
				_userProfile.user = ConnectManager.getInstance().mySelf as SFSUser;
				_top.addElement(_userProfile);
			}
			
			if ( !_bottom ) {
				_bottom = new HGroup();
				_bottom.percentWidth = _bottom.percentHeight = 100;
				addElement(_bottom);
			}
			
			if ( !_chatList ) {
				_chatList = new Chat();
				_chatList.width = FIRST_COLUMN_WIDTH;
				_chatList.percentHeight = 100;
				_bottom.addElement(_chatList);
			}
			
			if ( !_userList ) {
				_userList = new UserList();
				_userList.percentWidth = _userList.percentHeight = 100;
				_bottom.addElement(_userList);
			}	
		}
	}
}