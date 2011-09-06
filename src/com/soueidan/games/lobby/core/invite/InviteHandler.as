package com.soueidan.games.lobby.core.invite
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.entities.invitation.Invitation;
	import com.smartfoxserver.v2.entities.invitation.InvitationReply;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.smartfoxserver.v2.requests.game.InvitationReplyRequest;
	import com.soueidan.games.lobby.components.*;
	import com.soueidan.games.lobby.components.users.*;
	import com.soueidan.games.lobby.core.Connector;
	import com.soueidan.games.lobby.events.*;
	import com.soueidan.games.lobby.managers.*;
	import com.soueidan.games.lobby.responses.*;
	
	import mx.managers.PopUpManager;
	
	import spark.components.Button;

	public class InviteHandler
	{
		private var _server:Connector = ConnectManager.getInstance();
		
		private var _userList:UserList;
		
		private var _receivedInvite:ReceivedInvite;
		private var _sentInvitations:Array = [];
		
		public function InviteHandler(userList:UserList):void {
			_userList = userList;
			_userList.addEventListener(InviteEvent.SENT, sendInvitation);
			
			_server.addEventListener(SFSEvent.EXTENSION_RESPONSE, extensionResponse);
			_server.addEventListener(SFSEvent.INVITATION, receivedInvitation);
			_server.addEventListener(SFSEvent.INVITATION_REPLY, invitationReplied);	
		}
		
		public function set receivedInvite(value:ReceivedInvite):void
		{
			_receivedInvite = value;
		}

		private function sendInvitation(event:InviteEvent):void {
			trace("sent invitation");

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
		
		private function invitationReplyAccepted(event:SFSEvent):void
		{
			var params:ISFSObject = new SFSObject();
			
			// set all players
			var users:ISFSArray = new SFSArray();
			users.addInt(event.params.invitee.id);
			params.putSFSArray("users", users);
			
			// set game id
			params.putInt("game_id", _server.gameId);
			
			var extensionRequest:IRequest = new ExtensionRequest(CreateRoomResponse.CREATE_ROOM, params);
			_server.send(extensionRequest);
		}
		
		private function extensionResponse(event:SFSEvent):void
		{
			var action:String = event.params.cmd;
			
			if ( action != "cancel_invite" ) {
				return;
			}
			
			if ( _receivedInvite ) {
				_receivedInvite.kill();
				_receivedInvite = null;
			}
			
		}
	}
}