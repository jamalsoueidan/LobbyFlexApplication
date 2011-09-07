package com.soueidan.games.lobby.components.users
{
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.entities.variables.UserVariable;
	import com.soueidan.games.lobby.core.StatusProfile;
	import com.soueidan.games.lobby.managers.ResourceManager;
	import com.soueidan.games.lobby.managers.UserManager;
	
	import spark.components.HGroup;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.VGroup;
	import spark.core.ContentCache;
	
	public class UserBase extends HGroup
	{
		/*[Embed(source="assets/status/151.png")] 
		private var _statusDisturb:Class;*/
		
		/*[Embed(source="assets/status/152.png")] 
		private var _statusReady:Class;*/
		
		private var _status:Image;
		private var _statusChanged:Boolean;
		private var _currentStatus:int = 0;
		
		private var _cache:ContentCache = new ContentCache();
		private var _image:Image;
		
		protected var _nicknameGroup:HGroup;
		private var _nickname:Label;
		
		/*[Embed(source="assets/032.png")] 
		private var _vipImageClass:Class;*/
		private var _vipImage:Image;
		
		private var _timesPlayed:Label;
		
		private var _groupWinLose:HGroup;
		private var _win:Label;
		private var _loss:Label;
		
		protected var _textGroup:VGroup;
		
		protected var _sfsUser:SFSUser;
		protected var _sfsUserChanged:Boolean;
		
		public function set user(value:SFSUser):void {
			_sfsUser = value;
			_sfsUserChanged = true;
			invalidateProperties();
		}
		
		public function get user():SFSUser {
			return _sfsUser;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if ( !_image ) {
				_image = new Image();
				_image.width = _image.height = 48;
				_image.contentLoader = _cache;
				addElement(_image);
			}
			
			if ( !_textGroup ) {
				_textGroup = new VGroup();
				_textGroup.percentWidth = 100;
				addElement(_textGroup);
			}
			
			if (!_nicknameGroup ) {
				_nicknameGroup = new HGroup();
				_nicknameGroup.verticalAlign = "middle";
				_textGroup.addElement(_nicknameGroup);
			}
			
			if ( !_nickname ) {
				_nickname = new Label();
				_nickname.setStyle("fontWeight","bold");
				_nicknameGroup.addElement(_nickname);
			}
			
			if (!_vipImage ) {
				_vipImage = new Image();
				_vipImage.toolTip = ResourceManager.getString("user.vip");	
				_vipImage.contentLoader = _cache;
			}
			
			if ( !_status ) {
				_status = new Image();
				_status.toolTip = ResourceManager.getString("status.ready");
				_status.source = '/images/status/152.png';
				_nicknameGroup.addElement(_status);
			}
			
			if (!_timesPlayed ) {
				_timesPlayed = new Label();
				_textGroup.addElement(_timesPlayed);
			}
			
			
			if (!_groupWinLose ) {
				_groupWinLose = new HGroup();
				_textGroup.addElement(_groupWinLose);
			}
			
			if ( !_win ) {
				_win = new Label()
				_groupWinLose.addElement(_win);
			}
			
			if ( !_loss ) {
				_loss = new Label();
				_groupWinLose.addElement(_loss);
			}
		}
		
		override protected function commitProperties():void {
			if ( _sfsUserChanged ) {
				_sfsUserChanged = false;
				
				_nickname.text = _sfsUser.name;
				_timesPlayed.text = UserManager.privilege(_sfsUser);	
				_image.source = UserManager.avatar(_sfsUser);
				
				if ( UserManager.isVip(_sfsUser)) {
					_vipImage.source = "/images/vip.png";
					_nicknameGroup.addElement(_vipImage);
				}
				
				_win.text = ResourceManager.getString("user.win") + ": " + UserManager.win(_sfsUser).toString();
				_loss.text = ResourceManager.getString("user.loss") + ": " + UserManager.loss(_sfsUser).toString();
				_timesPlayed.text = ResourceManager.getString("user.times_played") + ": " + UserManager.timesPlayed(_sfsUser).toString();
			}
			
			if ( _statusChanged ) {
				_statusChanged = false;
				updateStatus();
			}
			
			super.commitProperties();
		}
		
		private function updateStatus():void
		{
			var status:int = _sfsUser.getVariable("status").getIntValue();
			if ( _currentStatus == status ) {
				return;
			}
			
			_currentStatus = status;
			
			if ( _currentStatus == StatusProfile.readyToPlay ) {
				_status.toolTip = ResourceManager.getString("status.ready");
				_status.source = '/images/status/152.png';	
			}
			
			if ( _currentStatus == StatusProfile.doNotDistrub) {
				_status.toolTip = ResourceManager.getString("status.disturb");
				_status.source = '/images/status/151.png';
			}
		}
		
		public function update():void {
			_statusChanged = true;
			invalidateProperties();
		}
	}
}