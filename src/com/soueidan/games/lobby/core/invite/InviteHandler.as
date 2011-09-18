package com.soueidan.games.lobby.core.invite
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.entities.invitation.InvitationReply;
	import com.soueidan.games.engine.managers.ServerManager;
	import com.soueidan.games.engine.managers.UserManager;
	import com.soueidan.games.engine.net.Server;
	import com.soueidan.games.lobby.components.*;
	import com.soueidan.games.lobby.components.users.*;
	import com.soueidan.games.lobby.events.*;
	import com.soueidan.games.lobby.managers.*;
	import com.soueidan.games.lobby.requests.CreateGameRequest;
	import com.soueidan.games.lobby.responses.*;

	public class InviteHandler
	{
		private var _server:Server = ServerManager.getInstance();
		
		private var _userList:UserList;
		
		private var _receivedInvite:ReceivedInvite;
		private var _sentInvitations:Array = [];
		
		public function InviteHandler(userList:UserList):void {
			_userList = userList;
			_userList.addEventListener(InviteEvent.SENT, sendInvitation);
			
			_server.addEventListener(SFSEvent.EXTENSION_RESPONSE, extensionResponse);
			_server.addEventListener(SFSEvent.INVITATION, receivedInvitation);
			_server.addEventListener(SFSEvent.INVITATION_REPLY, invitationReplied);
			
			_server.addResponseHandler(CreateGameResponse.CREATE_GAME, CreateGameResponse);
		}
		
		public function set receivedInvite(value:ReceivedInvite):void
		{
			_receivedInvite = value;
		}

		private function sendInvitation(event:InviteEvent):void {
			trace("sent invitation");
			event.stopImmediatePropagation();
			event.stopPropagation();
			
			var sendInvite:SentInvite;
			var found:Boolean;
			for each( sendInvite in _sentInvitations ){
				if ( sendInvite.invitee == event.userPlayer.user ) {
					found = true;
					break;
				}
			}
			
			if ( !found ) {
				sendInvite = new SentInvite(_server.mySelf as SFSUser, event.userPlayer.user);
				sendInvite.send();
			
				_sentInvitations.push(sendInvite);
			}
		}

		/**
		 * When I recieve invitation from another user who want to battle me.
		 * Then show me window to accept or refuse the match.
		 *  
		 * @param evt
		 * 
		 */
		private function receivedInvitation(evt:SFSEvent):void {
			trace("received invitation");
			
			var params:ISFSObject = evt.params.invitation.params;
			
			if ( !UserManager.isReady(_server.mySelf)) {
				return;
			}
			
			if ( _receivedInvite ) {
				return;
			}
			
			_receivedInvite = new ReceivedInvite(evt.params.invitation, this);
			_receivedInvite.show();
			
			SoundManager.playRecievedInvitation();
		}
		
		protected function invitationReplied(event:SFSEvent):void
		{
			trace("invitation replied");
			for(var i:int=0;i<_sentInvitations.length;i++){
				if ( event.params.invitee.id == _sentInvitations[i].invitee.id ) {
					_sentInvitations[i].close();
					_sentInvitations.splice(i,1);
				}
			}
			
			if ( event.params.reply == InvitationReply.ACCEPT ) {
				invitationReplyAccepted(event);
			}
		}
		
		private function invitationReplyAccepted(event:SFSEvent):void {
			// set all players
			var users:ISFSArray = new SFSArray();
			users.addInt(event.params.invitee.id);
			
			var params:ISFSObject = new SFSObject();
			params.putSFSArray("users", users);
			
			_server.send(new CreateGameRequest(params));
		}
		
		private function extensionResponse(event:SFSEvent):void
		{
			var action:String = event.params.cmd;
			
			if ( action != "cancel_invite" ) {
				return;
			}
			
			if ( _receivedInvite ) {
				_receivedInvite.hide();
				_receivedInvite = null;
			}	
		}
	}
}