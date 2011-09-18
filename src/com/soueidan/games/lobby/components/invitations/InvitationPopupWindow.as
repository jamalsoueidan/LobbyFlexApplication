package com.soueidan.games.lobby.components.invitations
{
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.soueidan.games.engine.components.popups.PopUpWindow;
	import com.soueidan.games.lobby.components.users.UserVersus;
	import com.soueidan.games.lobby.events.InviteEvent;
	
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	
	import spark.components.Button;
	import spark.components.HGroup;
	
	public class InvitationPopupWindow extends PopUpWindow
	{
		public static const TIMER_COUNT:int = 10;
		
		private var _profile:HGroup;
		
		private var _inviterProfile:UserVersus;
		private var _inviteeProfile:UserVersus;
		
		private var _inviter:SFSUser; //User object corresponding to the user who sent the invitation.
		private var _invitee:SFSUser; //User object corresponding to the user who received the invitation.
		
		private var _inviteChanged:Boolean;
		
		private var _timer:Timer;
		
		static protected const ACCEPT:String = "accept";
		static protected const REFUSE:String = "refuse";
		static protected const CANCEL:String = "cancel";
		
		public function InvitationPopupWindow()
		{
			super();
			
			addEventListener(MouseEvent.CLICK, clickedButton);
		}
		
		protected function clickedButton(event:MouseEvent):void
		{
			var clickedButton:Boolean = event.target is Button;
			if (!clickedButton) {
				return;
			}
			
			var responseEvent:InviteEvent = new InviteEvent(InviteEvent.ACTION);
			responseEvent.action = InviteEvent.CANCEL
				
			var button:Button = event.target as Button;
			
			if ( button.id == ACCEPT ) {
				responseEvent.action = InviteEvent.ACCEPT;
			}
			
			if ( button.id == REFUSE ) {
				responseEvent.action = InviteEvent.REFUSE;
			}
			
			dispatchEvent(responseEvent);
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if ( !_profile ) {
				_profile = new HGroup();
				addElement(_profile);
			}
			
			if ( !_inviterProfile) {
				_inviterProfile = new UserVersus();
				_profile.addElement(_inviterProfile);
			}
			
			if ( !_inviteeProfile ){
				_inviteeProfile = new UserVersus();
				_profile.addElement(_inviteeProfile);
			}
		}
	
		override protected function commitProperties():void {
			if ( _inviteChanged ) {
				_inviteChanged = false;
				
				_inviterProfile.user = _inviter;
				_inviteeProfile.user = _invitee;
			}
			
			super.commitProperties();
		}
		
		public function set inviter(user:SFSUser):void {
			_inviter = user;
			_inviteChanged = true;
			invalidateProperties();
		}
		
		public function set invitee(user:SFSUser):void {
			_invitee = user;
			_inviteChanged = true;
			invalidateProperties();
		}
	}
}