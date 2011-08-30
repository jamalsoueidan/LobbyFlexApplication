package com.soueidan.games.lobby.components
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.entities.User;
	import com.smartfoxserver.v2.entities.invitation.Invitation;
	import com.smartfoxserver.v2.entities.invitation.InvitationReply;
	import com.smartfoxserver.v2.entities.invitation.SFSInvitation;
	import com.smartfoxserver.v2.exceptions.SFSError;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.smartfoxserver.v2.requests.game.InvitationReplyRequest;
	import com.smartfoxserver.v2.requests.game.InviteUsersRequest;
	
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import com.soueidan.games.lobby.core.*;
	import com.soueidan.games.lobby.events.InviteEvent;
	import com.soueidan.games.lobby.managers.*;
	
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.*;
	
	public class UserList extends VGroup
	{
		private var _title:Label;
		private var _body:Label;
		
		private var _server:Connector = ConnectManager.getInstance();
		
		private var _list:Array = [];
		private var _inviteRequest:InviteRequest;
		
		public function UserList()
		{
			super();
			
			_server.addEventListener(SFSEvent.USER_ENTER_ROOM, userEnterRoom);
			_server.addEventListener(SFSEvent.USER_EXIT_ROOM, userExitRoom);
			_server.addEventListener(SFSEvent.USER_COUNT_CHANGE, showNoUsers);
			
			addEventListener(MouseEvent.CLICK, clickedUser);
		}
		
		private function showNoUsers(evt:SFSEvent):void
		{
			if ( !containsElement(_body) && _list.length == 0 ) {
				addElement(_body);
			}
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if (!_title) {
				_title = new Label();
				_title.text = "Player List";
				_title.setStyle("fontWeight", "bold");
				_title.setStyle("fontSize", 14);
				addElement(_title);
			}
			
			if (!_body) {
				_body = new Label();
				_body.text = "No players on this lobby";
				addElement(_body);
			}
			
			if ( !_inviteRequest ) {
				_inviteRequest = new InviteRequest();
				_inviteRequest.addEventListener(InviteEvent.ACTION, inviteRequestHandler);
			}
			
			addListener();
			initializeUserList();
		}
		
		private function addListener():void
		{
			_server.addEventListener(SFSEvent.INVITATION, invitation);
			_server.addEventListener(SFSEvent.INVITATION_REPLY, invitationReply);
		}
		
		private function initializeUserList():void {
			var addedAnything:Boolean;
			
			for each( var user:SFSUser in _server.userManager.getUserList() ) {
				if ( !user.isItMe ) {
					var userOpponent:UserButton = new UserButton(user);
					_list.push(userOpponent);
					addElement(userOpponent);
					addedAnything = true;
				}
			}
			
			if ( addedAnything ) {
				removeEmptyLabel();
			}
		}
		
		private function userEnterRoom(evt:SFSEvent):void
		{
			removeEmptyLabel();
						
			var userOpponent:UserButton = new UserButton(evt.params.user);
			_list.push(userOpponent);
			addElement(userOpponent);
		}
		
		private function userExitRoom(evt:SFSEvent):void {
			var userOpponent:UserButton;

			for(var i:int=0;i<_list.length;i++) {
				userOpponent = _list[i];
				if ( userOpponent.user.id == evt.params.user.id ) {
					_list.splice(i,1);
					removeElement(userOpponent);
				}
			}

			showNoUsers(evt);
		}
		
		private function clickedUser(evt:MouseEvent):void {
			var isUserOppount:Boolean = evt.target is UserButton;
			if ( !isUserOppount ) {
				return;
			}
			
			var userOppount:UserButton = evt.target as UserButton;
			_server.send(new InviteUsersRequest([userOppount.user], 15, null));
		
			addPopUp(userOppount.user, ConnectManager.getInstance().mySelf as SFSUser);
		}
		
		private function invitationReply(evt:SFSEvent):void {
			PopUpManager.removePopUp(_inviteRequest);
			
			if ( evt.params.reply == InvitationReply.ACCEPT ) {
				navigateToURL(new URLRequest(''),'_self')
			} else {
				trace("REJECT GAME");
			}
		}
		
		private var _invitation:Invitation;
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
			
			PopUpManager.addPopUp(_inviteRequest, this, true);
			PopUpManager.centerPopUp(_inviteRequest);
		}
		
		private function removeEmptyLabel():void {
			if ( containsElement(_body) ) {
				removeElement(_body);
			}
		}
	}
}