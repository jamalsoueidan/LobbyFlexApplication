package com.soueidan.games.lobby.components
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.entities.User;
	import com.smartfoxserver.v2.entities.invitation.Invitation;
	import com.smartfoxserver.v2.entities.invitation.InvitationReply;
	import com.smartfoxserver.v2.entities.variables.UserVariable;
	import com.smartfoxserver.v2.requests.game.InvitationReplyRequest;
	import com.smartfoxserver.v2.requests.game.InviteUsersRequest;
	import com.soueidan.games.lobby.core.*;
	import com.soueidan.games.lobby.events.InviteEvent;
	import com.soueidan.games.lobby.managers.*;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.IVisualElement;
	import mx.graphics.codec.PNGEncoder;
	import mx.managers.PopUpManager;
	
	import spark.components.*;
	import spark.layouts.VerticalLayout;
	
	public class UserList extends Panel
	{
		private var _body:Label;
		
		private var _server:Connector = ConnectManager.getInstance();
		
		private var _list:Array = [];
		private var _inviteRequest:InviteRequest;

		
		public function UserList()
		{
			super();
			
			setStyle("paddingTop", 0);
			setStyle("paddingLeft", 0);
			setStyle("paddingBottom", 0);
			setStyle("paddingRight", 0);
			
			setStyle("dropShadowVisible", false);
			
			title = ResourceManager.getString("userList.title");
			
			var vertial:VerticalLayout = new VerticalLayout();
			vertial.gap = 0;			
			layout = vertial;
			
			_server.addEventListener(SFSEvent.USER_ENTER_ROOM, userEnterRoom);
			_server.addEventListener(SFSEvent.USER_EXIT_ROOM, userExitRoom);
			_server.addEventListener(SFSEvent.USER_COUNT_CHANGE, showNoUsers);
			
			_server.addEventListener(SFSEvent.USER_VARIABLES_UPDATE, userUpdateVariable);
			
			addEventListener(MouseEvent.CLICK, clickedUser);
		}
		
		private function userUpdateVariable(event:SFSEvent):void
		{
			var user:User = event.params.user;
			if ( user.isItMe ) {
				return;
			}
			
			var variable:UserVariable = user.getVariable("status");
			if (variable) {
				for each(var current:UserPlayer in _list ) {
					trace(current.user.id, user.id);
					if ( current.user.id == user.id ) {
						current.update("status");
					}
				}
			}
			
		}
		
		private function showNoUsers(evt:SFSEvent):void
		{
			if ( !contains(_body) && _list.length == 0 ) {
				addElement(_body);
			}
		}
		
		override protected function createChildren():void {
			super.createChildren();

			if (!_body) {
				_body = new Label();
				_body.setStyle("paddingTop", 10);
				_body.setStyle("paddingLeft", 10);
				_body.setStyle("paddingRight", 10);
				_body.setStyle("paddingBottom", 10);
				_body.text = ResourceManager.getString("userList.empty");
				addElement(_body);
			}
			
			if ( !_inviteRequest ) {
				_inviteRequest = new InviteRequest();
				_inviteRequest.addEventListener(InviteEvent.ACTION, inviteRequestHandler);
			}
			
			addListener();
			initializeUserList();
			
			(titleDisplay as Label).setStyle("textAlign", ResourceManager.getString("left"));
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
					var userOpponent:UserPlayer = new UserPlayer(user);
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
						
			var userOpponent:UserPlayer = new UserPlayer(evt.params.user);
			_list.push(userOpponent);
			addElement(userOpponent);
		}
		
		private function userExitRoom(evt:SFSEvent):void {
			var userOpponent:UserPlayer;

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
			var isUserOppount:Boolean = evt.target is Button;
			if ( !isUserOppount ) {
				return;
			}
			
			var btn:Button = evt.target as Button;
			if ( btn.id == "invite" ) {
				var userOppount:UserPlayer = (evt.target).parent.parent as UserPlayer;
				_server.send(new InviteUsersRequest([userOppount.user], 15, null));
				addPopUp(userOppount.user, ConnectManager.getInstance().mySelf as SFSUser);
			}
		}
		
		private function invitationReply(evt:SFSEvent):void {
			PopUpManager.removePopUp(_inviteRequest);
			
			if ( evt.params.reply == InvitationReply.ACCEPT ) {
				//navigateToURL(new URLRequest(''),'_self')
			} else {
				//trace("REJECT GAME");
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
			if ( contains(_body) ) {
				removeElement(_body);
			}
		}
	}
}