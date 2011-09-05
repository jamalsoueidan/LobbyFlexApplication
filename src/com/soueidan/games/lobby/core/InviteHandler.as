package com.soueidan.games.lobby.core
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.entities.invitation.Invitation;
	import com.smartfoxserver.v2.entities.invitation.InvitationReply;
	import com.smartfoxserver.v2.requests.game.InvitationReplyRequest;
	import com.smartfoxserver.v2.requests.game.InviteUsersRequest;
	import com.soueidan.games.lobby.components.InviteRequest;
	import com.soueidan.games.lobby.components.UserList;
	import com.soueidan.games.lobby.components.users.UserPlayer;
	import com.soueidan.games.lobby.events.InviteEvent;
	import com.soueidan.games.lobby.managers.ApplicationManager;
	import com.soueidan.games.lobby.managers.ConnectManager;
	
	import mx.managers.PopUpManager;

	public class InviteHandler
	{
		private var _server:Connector = ConnectManager.getInstance();
		
		private var _inviteRequest:InviteRequest;
		
		private var _invitation:Invitation;
		
		private var _userList:UserList;
		
		public function InviteHandler(userList:UserList):void {
			if ( !_inviteRequest ) {
				_inviteRequest = new InviteRequest();
				_inviteRequest.addEventListener(InviteEvent.ACTION, inviteRequestHandler);
			}
			
			_userList = userList;
			_userList.addEventListener(InviteEvent.SENT, sentInvitation);
			
			addListener();	
		}
		
		private function addListener():void
		{	
			_server.addEventListener(SFSEvent.INVITATION, invitation);
			_server.addEventListener(SFSEvent.INVITATION_REPLY, invitationReply);
		}
		
		private function sentInvitation(event:InviteEvent):void {
			trace("sent invitation");
			var userOppount:UserPlayer = event.userPlayer;
			_server.send(new InviteUsersRequest([userOppount.user], 15, null));
			addPopUp(userOppount.user, ConnectManager.getInstance().mySelf as SFSUser);
		}

		/**
		 * When I recieve invitation from another user who want to battle me.
		 * Then show me window to accept or refuse the match.
		 *  
		 * @param evt
		 * 
		 */
		private function invitation(evt:SFSEvent):void {
			addPopUp(ConnectManager.getInstance().mySelf as SFSUser, evt.params.invitation.inviter);
			_invitation = evt.params.invitation;
			
		}
		
		/**
		 * When I have a answer to the inviter then response to him from the InviteRequest
		 * InviteEvent dispatcher.
		 * @param event
		 * 
		 */
		protected function inviteRequestHandler(event:InviteEvent):void{
			var response:int = InvitationReply.REFUSE;
			if ( event.action == InviteEvent.ACCEPT ) {
				response = InvitationReply.ACCEPT;
			}
			
			_server.send(new InvitationReplyRequest(_invitation, response));
		}
		
		private function addPopUp(invitee:SFSUser, inviter:SFSUser):void {
			_inviteRequest.invitee = invitee;
			_inviteRequest.inviter = inviter;
			
			PopUpManager.addPopUp(_inviteRequest, ApplicationManager.getInstance(), true);
			PopUpManager.centerPopUp(_inviteRequest);
		}
		
		private function invitationReply(evt:SFSEvent):void {
			PopUpManager.removePopUp(_inviteRequest);
			
			if ( evt.params.reply == InvitationReply.ACCEPT ) {
				//navigateToURL(new URLRequest(''),'_self')
			} else {
				//trace("REJECT GAME");
			}
		}
	}
}