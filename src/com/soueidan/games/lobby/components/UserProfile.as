package com.soueidan.games.lobby.components
{
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.soueidan.games.lobby.core.StatusProfile;
	import com.soueidan.games.lobby.managers.*;
	import com.soueidan.games.lobby.requests.StatusRequest;
	
	import spark.components.*;
	import spark.core.ContentCache;
	import spark.events.DropDownEvent;
	
	public class UserProfile extends HGroup
	{
		private var _cache:ContentCache = new ContentCache();
		private var _image:Image;
		
		private var _groupNicknameVIP:HGroup;
		private var _nickname:Label;
		
		[Embed(source="assets/032.png")] 
		private var _vipImageClass:Class;
		private var _vipImage:Image;
		
		private var _timesPlayed:Label;
		
		private var _groupWinLose:HGroup;
		private var _win:Label;
		private var _loss:Label;
		
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
			
				if (!_groupNicknameVIP ) {
					_groupNicknameVIP = new HGroup();
					_groupNicknameVIP.verticalAlign = "middle";
					_vGroup.addElement(_groupNicknameVIP);
				}
				
					if ( !_nickname ) {
						_nickname = new Label();
						_nickname.setStyle("fontWeight","bold");
						_groupNicknameVIP.addElement(_nickname);
					}
					
					if (!_vipImage ) {
						_vipImage = new Image();
						_vipImage.contentLoader = _cache;
						_groupNicknameVIP.addElement(_vipImage);
					}
			
				if (!_timesPlayed ) {
					_timesPlayed = new Label();
					_vGroup.addElement(_timesPlayed);
				}
				
				
				if (!_groupWinLose ) {
					_groupWinLose = new HGroup();
					_vGroup.addElement(_groupWinLose);
				}
			
					if ( !_win ) {
						_win = new Label()
						_groupWinLose.addElement(_win);
					}
					
					if ( !_loss ) {
						_loss = new Label();
						_groupWinLose.addElement(_loss);
					}
					
			if ( !_list ) {
				_list = new DropDownList();
				_list.dataProvider = StatusProfile.getList();
				_list.addEventListener(DropDownEvent.CLOSE, choosenFromList);
				_list.requireSelection = true;
				_list.setStyle("alternatingItemColors", [0xECECEC, 0xE6E6E6]);
				_list.setStyle("textAlign", ResourceManager.getString("left"));
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
				
				_nickname.text = _sfsUser.name;
				_timesPlayed.text = UserManager.privilege(_sfsUser);	
				_image.source = UserManager.avatar(_sfsUser);
				_vipImage.source = _vipImageClass;
				
				
				_win.text = ResourceManager.getString("user.win") + ": " + UserManager.win(_sfsUser).toString();
				_loss.text = ResourceManager.getString("user.loss") + ": " + UserManager.loss(_sfsUser).toString();
				_timesPlayed.text = ResourceManager.getString("user.times_played") + ": " + UserManager.timesPlayed(_sfsUser).toString();
			}
			
			super.commitProperties();
		}
	}
}