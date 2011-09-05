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
		
		private static const FIRST_COLUMN_WIDTH:int = 220;
		private static const SECOND_COLUMN_WIDTH:int = 100;
		
		private var _top:HGroup;
		private var _userProfile:UserProfile;
		
		private var _bottom:HGroup;
		
		private var _userList:UserList;
		
		private var _tabs:ButtonBar;
		private var _tabsContainer:VGroup;
		
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
				_bottom.percentWidth = 100;
				addElement(_bottom);
			}
			
			if ( !_userList ) {
				_userList = new UserList();
				_userList.width = FIRST_COLUMN_WIDTH;
				_bottom.addElement(_userList);
			}
			
			if (!_tabsContainer ) {
				_tabsContainer = new VGroup();
				_tabsContainer.gap = 0;
				_tabsContainer.percentWidth = SECOND_COLUMN_WIDTH;
				_bottom.addElement(_tabsContainer);
			}
			
			if ( !_tabs ) {
				_tabs = new ButtonBar();
				_tabs.addEventListener(IndexChangeEvent.CHANGING, tabIndexChanged);
				_tabs.dataProvider = new ArrayCollection();
				_tabs.dataProvider.addItem(ResourceManager.getString("entrance.rooms"));
				_tabs.dataProvider.addItem(ResourceManager.getString("entrance.chat"));
				_tabs.requireSelection = true;
				_tabsContainer.addElement(_tabs);
			}
			
			if ( !_roomList ) {
				_roomList = new RoomList();
				_tabsContainer.addElement(_roomList);	
			}
			
			if ( !_chatList ) {
				_chatList = new Chat();
			}
		}
		
		private function tabIndexChanged(event:IndexChangeEvent):void
		{
			if ( _tabs.selectedIndex == 0 ) {
				if ( !_tabsContainer.containsElement(_roomList) ) {
					_roomList.show();
					_tabsContainer.addElement(_roomList);	
				}
			} else {
				if ( _tabsContainer.containsElement(_roomList) ) {
					_tabsContainer.removeElement(_roomList);
					_roomList.hide();
				}
			}
			
			if ( _tabs.selectedIndex == 1 ) {
				if ( !_tabsContainer.containsElement(_chatList) ) {
					_chatList.show();
					_tabsContainer.addElement(_chatList);	
				}
			} else {
				if ( _tabsContainer.containsElement(_chatList) ) {
					_tabsContainer.removeElement(_chatList);	
					_chatList.hide();
				}
			}
		}
	}
}