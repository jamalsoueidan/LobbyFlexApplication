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
		
		private var _userNickname:Label;
		private var _userRegistered:Label;
		
		private var _vGroup:VGroup;
		
		private var _sfsUser:SFSUser;
		private var _sfsUserChanged:Boolean;
		
		private var _currentStatus:int = -1;
		private var _statusChanged:Boolean;
		
		public function UserPlayer(value:SFSUser):void {
			_sfsUser = value;
			_sfsUserChanged = true;
			
			// REMEMBER TO UPDATE THESE VARIABLES
			minHeight = 48;
			minWidth = 148;
			
			update("status");
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
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			if ( _statusChanged ) {
				_statusChanged = false;
				
				var g:Graphics = graphics;
				var color:int;
				switch(_currentStatus)
				{
					case StatusProfile.doNotDistrub:
					{
						color = 0xFF0040;
						break;
					}
						
					default:
					{
						color = 0x009966;
						break;
					}
				}
				
				g.beginFill(color);
				g.drawRect(0,0,getExplicitOrMeasuredWidth(),getExplicitOrMeasuredHeight());
				g.endFill();
			}
			super.updateDisplayList(unscaledWidth, unscaledHeight);
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
			invalidateDisplayList();
		}
		
	}
}