package com.soueidan.games.lobby.components
{
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.soueidan.games.lobby.components.users.UserProfile;
	import com.soueidan.games.lobby.core.*;
	import com.soueidan.games.lobby.core.invite.InviteHandler;
	import com.soueidan.games.lobby.interfaces.ITab;
	import com.soueidan.games.lobby.managers.*;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Spacer;
	import mx.events.FlexEvent;
	
	import spark.components.*;
	import spark.events.IndexChangeEvent;
	import spark.layouts.VerticalLayout;

	public class Entrance extends VGroup
	{
		
		private static const FIRST_COLUMN_WIDTH:int = 300;
		private static const SECOND_COLUMN_WIDTH:int = 100;
		
		private var _top:HGroup;
		private var _userProfile:UserProfile;
		private var _autoPlayButton:Button;
		
		private var _bottom:HGroup;
		
		private var _userList:UserList;
		
		private var _roomList:ITab;
		private var _chatList:ITab;
		
		private var _inviteHandler:InviteHandler;
		private var _autoPlayHandler:AutoPlayHandler;
		
		public function Entrance():void {
			super();
			
			percentWidth = percentHeight = 100;
			addEventListener(FlexEvent.CREATION_COMPLETE, creationDone);	
		}
		
		private function creationDone(event:FlexEvent):void
		{
			_inviteHandler = new InviteHandler(_userList);
			_autoPlayHandler = new AutoPlayHandler(_autoPlayButton);
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if ( !_top ) {
				_top = new HGroup();
				_top.percentWidth = 100;
				_top.verticalAlign = "middle";
				addElement(_top);
			}
			
			if ( !_userProfile ) {
				_userProfile = new UserProfile();
				_userProfile.user = ConnectManager.getInstance().mySelf as SFSUser;
				_top.addElement(_userProfile);
			}
			
			if (!_autoPlayButton ) {
				_autoPlayButton = new Button();
				_autoPlayButton.label = ResourceManager.getString("entrance.auto_play");
				_autoPlayButton.setStyle("fontSize", 50);
				_top.addElement(_autoPlayButton);
			}
			
			if ( !_bottom ) {
				_bottom = new HGroup();
				_bottom.percentWidth = _bottom.percentHeight = 100;
				addElement(_bottom);
			}
			
			if ( !_chatList ) {
				_chatList = new Chat();
				_chatList.percentWidth = 30;
				_chatList.percentHeight = 100;
				_bottom.addElement(_chatList);
			}
			
			if ( !_userList ) {
				_userList = new UserList();
				_userList.percentWidth = 70;
				_userList.percentHeight = 100;
				_bottom.addElement(_userList);
			}	
		}
	}
}