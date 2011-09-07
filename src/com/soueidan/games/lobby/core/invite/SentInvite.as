package com.soueidan.games.lobby.core.invite
{
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.smartfoxserver.v2.requests.game.InviteUsersRequest;
	import com.soueidan.games.lobby.components.invitations.InvitationPopupWindow;
	import com.soueidan.games.lobby.events.InviteEvent;
	import com.soueidan.games.lobby.managers.ApplicationManager;
	import com.soueidan.games.lobby.managers.ConnectManager;
	
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import mx.managers.PopUpManager;

	public class SentInvite extends InviteBase
	{		
		private var _id:Number;
		
		public function SentInvite(inviter:SFSUser, invitee:SFSUser) {
			super();
			
			_inviter = inviter;
			_invitee = invitee;
		}
		
		override protected function closedInvitationPopupWindow(event:InviteEvent):void {
			PopUpManager.removePopUp(popup);
			
			var params:ISFSObject = new SFSObject();
			params.putInt("invitee_id", invitee.id);
			
			_server.send(new ExtensionRequest("cancel_invite", params, _server.currentRoom, false));
		}
		
		public function get id():Number {
			return _id;
		}
		
		public function send():void {				
			_server.send(new InviteUsersRequest([invitee], 12, null));
		
			PopUpManager.addPopUp(popup, ApplicationManager.getInstance(), true);			
		}
		
		public function close():void {
			_popup.removeEventListener(InviteEvent.ACTION, closedInvitationPopupWindow);
			PopUpManager.removePopUp(popup);
		}
	}
}