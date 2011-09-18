package com.soueidan.games.lobby.core.invite
{
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.soueidan.games.engine.managers.ServerManager;
	import com.soueidan.games.engine.net.Server;
	import com.soueidan.games.lobby.components.invitations.InvitationPopupWindow;
	import com.soueidan.games.lobby.components.invitations.InviteeInvitationWindow;
	import com.soueidan.games.lobby.components.invitations.InviterInvitationWindow;
	import com.soueidan.games.lobby.events.InviteEvent;

	public class InviteBase
	{
		protected var _inviter:SFSUser;
		protected var _invitee:SFSUser;
		
		protected var _server:Server = ServerManager.getInstance();
		
		protected var _popup:InvitationPopupWindow;
		
		
		public function get invitee():SFSUser
		{
			return _invitee;
		}

		public function get inviter():SFSUser
		{
			return _inviter;
		}

		protected function get popup():InvitationPopupWindow {
			if ( !_popup ) {
				
				if ( inviter.isItMe ) {
					_popup = new InviterInvitationWindow();	 
				} else {
					_popup = new InviteeInvitationWindow();
				}
				
				_popup.addEventListener(InviteEvent.ACTION, closedInvitationPopupWindow, false,0, true);
				_popup.invitee = _invitee;
				_popup.inviter = _inviter;
			}
			
			return _popup;
		}
		
		protected function closedInvitationPopupWindow(event:InviteEvent):void { } 
	}
}