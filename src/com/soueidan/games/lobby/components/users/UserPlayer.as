package com.soueidan.games.lobby.components.users
{
	import com.smartfoxserver.v2.requests.*;
	import com.soueidan.games.engine.components.user.UserBase;
	import com.soueidan.games.engine.managers.ServerManager;
	import com.soueidan.games.engine.managers.UserManager;
	import com.soueidan.games.engine.net.Server;
	import com.soueidan.games.lobby.events.InviteEvent;
	
	import flash.events.MouseEvent;
	
	import skins.ButtonImageSkin;
	
	import spark.components.Button;
	import spark.components.HGroup;
	
	public class UserPlayer extends UserBase
	{	
		private var _invite:Button;
		private var _kick:Button;
		private var _ban:Button;
		private var _stats:Button;
		
		private var _actions:HGroup;
		
		private var _backgroundChanged:Boolean;
		private var _backgroundColor:int;
		private var _server:Server;
		
		public function UserPlayer() {
			super();
			
			percentWidth = 100;
			
			addEventListener(MouseEvent.ROLL_OVER, rollOver);
			addEventListener(MouseEvent.ROLL_OUT, rollOut);
			
			_server = ServerManager.getInstance();
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if (!_actions ) {
				_textGroup.percentWidth = 80;
				
				_actions = new HGroup();
				_actions.horizontalAlign = "right";
				_actions.verticalAlign = "bottom";
				_actions.percentHeight = 100;
				_actions.percentWidth = 20;
				addElement(_actions);
			}
			
			addButtons();
		}
		
		private function addButtons():void
		{
			if ( UserManager.isAtLeastModerator(_server.mySelf) ) {
				if ( !_kick) {
					_kick = new Button();
					_kick.setStyle("skinClass", Class(ButtonImageSkin));
					_kick.styleName = "kick";
					_kick.toolTip = "Kick";
					_actions.addElement(_kick);
				}
			}
			
			if ( _server.mySelf.isAdmin() ) {
				if ( !_ban) {
					_ban = new Button();
					_ban.setStyle("skinClass", Class(ButtonImageSkin));
					_ban.styleName = "ban";
					_ban.toolTip = "Ban";
					_actions.addElement(_ban);
				}
			}
			
			if (!_stats ) {
				_stats = new Button();
				_stats.label = "Stats";
				//_lastGroup.addElement(_stats);
			}
			
			if ( !_invite ) {
				_invite = new Button();
				_invite.setStyle("skinClass", Class(ButtonImageSkin));
				_invite.styleName = "invite";
				_actions.addElement(_invite);
			}
			
			update();
		}
		
		override public function update():void {
			super.update();
			
			if ( UserManager.isReady(_sfsUser) ) {
				if (!_actions.containsElement(_invite)) _actions.addElement(_invite);
			} else {
				if (_actions.containsElement(_invite)) _actions.removeElement(_invite);
			}
			
			invalidateProperties();
		}
		
		private function rollOver(event:MouseEvent):void {
			wakeUp();
			setStyle("backgroundColor", "#efefef");
			invalidateSkinState();
		}
		
		private function wakeUp():void
		{
			if ( _kick ) {
				_kick.addEventListener(MouseEvent.CLICK, clicked, false, 0, true);
			}
			
			if ( _ban ) {
				_ban.addEventListener(MouseEvent.CLICK, clicked, false, 0, true);
			}
			
			if ( _invite ) {
				_invite.addEventListener(MouseEvent.CLICK, clicked, false, 0, true);
			}
		}
		
		private function clicked(event:MouseEvent):void
		{
			var btn:Button = event.target as Button;
			var request:IRequest;
			if ( _kick && btn.styleName == _kick.styleName ) {
				request = new KickUserRequest(_sfsUser.id, "Kicked", 2);
				_server.send(request);
			} 

			if ( _ban && btn.styleName == _ban.styleName ) {
				request = new BanUserRequest(_sfsUser.id, "Banned", BanMode.BY_NAME, 2);
				_server.send(request);
			} 

			if ( _invite && btn.styleName == _invite.styleName ) {
				dispatchEvent(new InviteEvent(InviteEvent.SENT, true, false, this));
			}
			
		}
		
		private function rollOut(event:MouseEvent):void {
			kill();
			setStyle("backgroundColor", "#FFFFFF");
			invalidateSkinState();
		}
		
		private function kill():void
		{
			if ( _ban ) {
				_ban.removeEventListener(MouseEvent.CLICK, clicked);
			}
			
			if ( _kick ) {
				_kick.removeEventListener(MouseEvent.CLICK, clicked);
			}
			
			if ( _invite ) {
				_invite.removeEventListener(MouseEvent.CLICK, clicked);
			}
			
		}
	}
}