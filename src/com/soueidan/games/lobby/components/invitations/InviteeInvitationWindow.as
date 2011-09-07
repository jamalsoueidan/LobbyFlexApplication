package com.soueidan.games.lobby.components.invitations
{
	import com.soueidan.games.lobby.events.InviteEvent;
	import com.soueidan.games.lobby.managers.ResourceManager;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import spark.components.Button;

	public class InviteeInvitationWindow extends InvitationPopupWindow
	{
		private var _accept:Button;
		private var _refuse:Button;
		
		private var _timer:Timer;
		
		public function InviteeInvitationWindow() {
			super();
			
			title = ResourceManager.getString("invite.popup.invitee");
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if ( !_accept ) {
				_accept = new Button();
				_accept.id = ACCEPT;
				_accept.label = ResourceManager.getString("invite.accept");
			}
			
			if ( !contains(_accept) ) {
				_buttons.addElement(_accept);
			}
			
			if ( !_refuse ) {
				_refuse = new Button();
				_refuse.id = REFUSE;
				_refuse.label = ResourceManager.getString("invite.refuse") + " (10)";
			}
			
			if ( !contains(_refuse) ) {
				_buttons.addElement(_refuse);
			}
			
			_timer = new Timer(1000, 10);
			_timer.addEventListener(TimerEvent.TIMER, timerDelay, false, 0, true);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete, false, 0, true);
			_timer.start();
		}
		
		
		private function timerDelay(event:TimerEvent):void {
			_refuse.label = ResourceManager.getString("invite.refuse") + " (" + (10-_timer.currentCount) + ")";
		}
		
		private function timerComplete(event:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER, timerDelay);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
			
			var responseEvent:InviteEvent = new InviteEvent(InviteEvent.ACTION);
			responseEvent.action = InviteEvent.REFUSE;
			dispatchEvent(responseEvent);
		}		
	}
}