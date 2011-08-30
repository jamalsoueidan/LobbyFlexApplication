package com.soueidan.games.lobby.components
{
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.entities.UserPrivileges;
	
	import flash.events.MouseEvent;
	
	import com.soueidan.games.lobby.events.InviteEvent;
	import com.soueidan.games.lobby.managers.UserManager;
	
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.HGroup;
	import spark.components.TitleWindow;
	import spark.layouts.VerticalLayout;
	
	public class InviteRequest extends TitleWindow
	{
		private var _profile:HGroup;
		
		private var _inviterProfile:UserProfile;
		private var _inviteeProfile:UserProfile;
		
		private var _inviter:SFSUser; //User object corresponding to the user who sent the invitation.
		private var _invitee:SFSUser; //User object corresponding to the user who received the invitation.
		
		private var _inviteChanged:Boolean;
		
		private var _buttons:HGroup;
		
		static private const ACCEPT:String = "accept";
		static private const REFUSE:String = "refuse";
		static private const CANCEL:String = "cancel";
		
		private var _accept:Button;
		private var _refuse:Button;
		private var _cancel:Button;
		
		public function InviteRequest()
		{
			super();
			
			title = "Invitation Request";
			
			var verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.paddingBottom = verticalLayout.paddingLeft = verticalLayout.paddingRight = verticalLayout.paddingTop = 10;
			
			layout = verticalLayout;
			
			setStyle("verticalCenter", 0);
			setStyle("horizontalCenter", 0);
			
			addEventListener(CloseEvent.CLOSE, closedWindow);
			addEventListener(MouseEvent.CLICK, clickedButton);
		}
		
		protected function clickedButton(event:MouseEvent):void
		{
			var clickedButton:Boolean = event.target is Button;
			if (!clickedButton) {
				return;
			}
			
			var responseEvent:InviteEvent = new InviteEvent(InviteEvent.ACTION);
			var button:Button = event.target as Button;
			if ( button.label == ACCEPT ) {
				responseEvent.action = InviteEvent.ACCEPT;
			}
			
			if ( button.label == REFUSE ) {
				responseEvent.action = InviteEvent.REFUSE;
			}
			
			if ( button.label == CANCEL ) {
				responseEvent.action = InviteEvent.CANCEL;
			}
			
			dispatchEvent(responseEvent);
			PopUpManager.removePopUp(this);
		}
		
		protected function closedWindow(event:CloseEvent):void
		{
			var responeEvent:InviteEvent = new InviteEvent(InviteEvent.ACTION);
			responeEvent.action = InviteEvent.CANCEL;
			dispatchEvent(responeEvent);
			PopUpManager.removePopUp(this);
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if ( !_profile ) {
				_profile = new HGroup();
				addElement(_profile);
			}
			
			if ( !_inviterProfile) {
				_inviterProfile = new UserProfile();
				_profile.addElement(_inviterProfile);
			}
			
			if ( !_inviteeProfile ){
				_inviteeProfile = new UserProfile();
				_profile.addElement(_inviteeProfile);
			}
			
			if ( !_buttons ) {
				_buttons = new HGroup();
				addElement(_buttons);
			}
		}
	
		override protected function commitProperties():void {
			if ( _inviteChanged ) {
				_inviteChanged = false;
				
				if ( _inviterProfile && _inviter ) {
					_inviterProfile.sfsUser = _inviter;
					
					if ( _inviter.isItMe ) {
						removeAcceptAndRejectButtons();	
						addCancelButton();
					} else {
						addAcceptAndRejectButtons();
						removeCancelButton();
					}
				}
				
				if ( _inviteeProfile && _invitee ) {
					_inviteeProfile.sfsUser = _invitee;
					
					if ( _invitee.isItMe ) {
						addAcceptAndRejectButtons();
						removeCancelButton();
					}
				}
			}
			
			super.commitProperties();
		}
		
		private function removeCancelButton():void
		{
			if (_cancel && contains(_cancel) ){
				_buttons.removeElement(_cancel);
			}
		}
		
		private function addCancelButton():void
		{
			if (!_cancel ) {
				_cancel = new Button();
				_cancel.label = CANCEL;
			}
			
			_buttons.addElement(_cancel);
		}
		
		private function addAcceptAndRejectButtons():void
		{
			if ( !_accept ) {
				_accept = new Button();
				_accept.label = ACCEPT;
			}
			
			if ( !contains(_accept) ) {
				_buttons.addElement(_accept);
			}
			
			if ( !_refuse ) {
				_refuse = new Button();
				_refuse.label = REFUSE;
			}
			
			if ( !contains(_refuse) ) {
				_buttons.addElement(_refuse);
			}
		}
		
		private function removeAcceptAndRejectButtons():void {
			if ( _accept && contains(_accept)) {
				_buttons.removeElement(_accept);
			}
			
			if ( _refuse && contains(_refuse)) {
				_buttons.removeElement(_refuse);
			}
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