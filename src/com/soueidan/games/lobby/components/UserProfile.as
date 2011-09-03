package com.soueidan.games.lobby.components
{
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.soueidan.games.lobby.core.StatusProfile;
	import com.soueidan.games.lobby.managers.ConnectManager;
	import com.soueidan.games.lobby.managers.UserManager;
	import com.soueidan.games.lobby.requests.StatusRequest;
	
	import spark.components.DropDownList;
	import spark.components.HGroup;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.VGroup;
	import spark.core.ContentCache;
	import spark.events.DropDownEvent;
	
	public class UserProfile extends HGroup
	{
		private var _cache:ContentCache = new ContentCache();
		private var _image:Image;
		
		private var _userNickname:Label;
		private var _userRegistered:Label;
		
		private var _vGroup:VGroup;
		
		private var _sfsUser:SFSUser;
		private var _sfsUserChanged:Boolean;
		
		private var _list:DropDownList;

		public function set sfsUser(value:SFSUser):void {
			_sfsUser = value;
			_sfsUserChanged = true;
			invalidateProperties();
		}
		
		override protected function childrenCreated():void {
			super.createChildren();
			
			if ( !_image ) {
				_image = new Image();
				_image.contentLoader = _cache;
				addElement(_image);
			}
			
			if ( !_vGroup ) {
				_vGroup = new VGroup();
				addElement(_vGroup);
			}
			
			if ( !_userNickname ) {
				_userNickname = new Label();
				_vGroup.addElement(_userNickname);
			}
			
			if (!_userRegistered ) {
				_userRegistered = new Label();
				_vGroup.addElement(_userRegistered);
			}
			
			if ( !_list ) {
				_list = new DropDownList();
				_list.dataProvider = StatusProfile.getList();
				_list.addEventListener(DropDownEvent.CLOSE, choosenFromList);
				_list.selectedIndex = 0;
				_vGroup.addElement(_list);
			}
		}
		
		private function choosenFromList(event:DropDownEvent):void
		{
			var request:IRequest = new StatusRequest(_list.selectedItem);
			ConnectManager.getInstance().send(request);
		}
		
		override protected function commitProperties():void {
			if ( _sfsUserChanged ) {
				_sfsUserChanged = false;
				
				_userNickname.text = _sfsUser.name;
				_userRegistered.text = UserManager.privilege(_sfsUser);	
				_image.source = UserManager.avatar(_sfsUser);
			}
			
			super.commitProperties();
		}
	}
}