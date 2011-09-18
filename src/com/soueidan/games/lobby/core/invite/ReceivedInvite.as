package com.soueidan.games.lobby.core.invite
{
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.entities.invitation.Invitation;
	import com.smartfoxserver.v2.entities.invitation.InvitationReply;
	import com.smartfoxserver.v2.requests.game.InvitationReplyRequest;
	import com.soueidan.games.lobby.events.InviteEvent;
	
	import mx.managers.PopUpManager;

	public class ReceivedInvite extends InviteBase
	{
		private var _invitation:Invitation;
		private var _handler:InviteHandler;
		
		public function ReceivedInvite(invitation:Invitation, handler:InviteHandler)
		{
			_invitation = invitation;
			_handler = handler;
			
			_invitee = _server.mySelf as SFSUser;
			_inviter = invitation.inviter as SFSUser;
		}
		
		public function show():void {
			popup.show();
		}
		
		public function hide():void {
			popup.hide();
		}
		
		override protected function closedInvitationPopupWindow(event:InviteEvent):void {
			var response:int = InvitationReply.REFUSE;
			
			_handler.receivedInvite = null;
			
			if ( event.action == InviteEvent.ACCEPT ) {
				response = InvitationReply.ACCEPT;
			} else {
				PopUpManager.removePopUp(popup);
			}
			
			_server.send(new InvitationReplyRequest(_invitation, response));
		}
	}
}