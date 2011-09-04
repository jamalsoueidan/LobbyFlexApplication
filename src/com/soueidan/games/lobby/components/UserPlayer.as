package com.soueidan.games.lobby.components
{
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.entities.variables.UserVariable;
	import com.soueidan.games.lobby.core.StatusProfile;
	import com.soueidan.games.lobby.managers.UserManager;
	
	import flash.display.Graphics;
	
	import spark.components.Button;
	import spark.components.HGroup;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.VGroup;
	import spark.core.ContentCache;
	
	public class UserPlayer extends HGroup
	{
		private var _cache:ContentCache= new ContentCache();
		private var _image:Image;
		
		private var _userNicknameAndStatus:HGroup;
		
		private var _userNickname:Label;
		private var _userRank:Label;
		
		private var _vGroup:VGroup;
		
		private var _sfsUser:SFSUser;
		private var _sfsUserChanged:Boolean;
		
		private var _status:Button;
		private var _currentStatus:int = -1;
		private var _statusChanged:Boolean;
		
		private var _invite:Button;
		
		public function UserPlayer(value:SFSUser):void {
			_sfsUser = value;
			_sfsUserChanged = true;
			
			minHeight = 48;
			minWidth = 148;
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
			
			if ( !_userNicknameAndStatus) {
				_userNicknameAndStatus= new HGroup();
				_vGroup.addElement(_userNicknameAndStatus);
			}
			
			if ( !_userNickname ) {
				_userNickname = new Label();
				_userNicknameAndStatus.addElement(_userNickname);
			}

			if ( !_status ) {
				_status = new Button();
				_userNicknameAndStatus.addElement(_status);
			}
			
			if (!_userRank ) {
				_userRank = new Label();
				_userRank.text = "Rank: 0";
				_vGroup.addElement(_userRank);
			}
			
			if ( !_invite ) {
				_invite = new Button();
				_invite.id = "invite";
				_invite.label = "Invite";
			}
			
			update("status");
		}
		
		override protected function commitProperties():void {
			if ( _sfsUserChanged ) {
				_sfsUserChanged = false;
				
				_userNickname.text = _sfsUser.name;
				_userRank.text = UserManager.privilege(_sfsUser);	
				_image.source = UserManager.avatar(_sfsUser);
			}
			
			super.commitProperties();
		}
		
		private function updateInviteButton():void
		{
			if ( _currentStatus == StatusProfile.readyToPlay ) {
				_status.label = "Ready";	
			}
			
			if ( _currentStatus == StatusProfile.doNotDistrub) {
				_status.label = "Not";	
			}
			
			invalidateDisplayList();
		}
		
		public function get user():SFSUser {
			return _sfsUser;
		}
		
		public function update(variable:String):void
		{
			if ( variable == "status" ) {
				updateStatus(variable);
			}
		}
		
		private function updateStatus(variable:String):void
		{
			var userVar:UserVariable = _sfsUser.getVariable(variable);
			if ( _currentStatus == userVar.getIntValue() ) {
				return;
			}
			
			_currentStatus = userVar.getIntValue();
			_statusChanged = true;
			updateInviteButton();
		}
		
	}
}