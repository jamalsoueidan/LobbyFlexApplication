package com.soueidan.games.lobby.components.invitations
{
	import com.soueidan.games.lobby.events.InviteEvent;
	import com.soueidan.games.lobby.managers.ResourceManager;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import spark.components.Button;

	public class InviterInvitationWindow extends InvitationPopupWindow
	{
		private var _cancel:Button;
		
		private var _timer:Timer;
		
		public function InviterInvitationWindow() {
			super();
			
			title = ResourceManager.getString("invite.popup.inviter");
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if (!_cancel ) {
				_cancel = new Button();
				_cancel.width = 80;
				_cancel.id = CANCEL;
				_cancel.label = ResourceManager.getString("invite.cancel") + " (10)";
			}
			
			controlBarGroup.addElement(_cancel);
			
			_timer = new Timer(1000, TIMER_COUNT);
			_timer.addEventListener(TimerEvent.TIMER, timerDelay, false, 0, true);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete, false, 0, true);
			_timer.start();
		}
		
		private function timerDelay(event:TimerEvent):void
		{
			_cancel.label = ResourceManager.getString("invite.cancel") + " (" + (10-_timer.currentCount) + ")";
		}
		
		private function timerComplete(event:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER, timerDelay);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
			
			var responseEvent:InviteEvent = new InviteEvent(InviteEvent.ACTION);
			responseEvent.action = InviteEvent.CANCEL;
			dispatchEvent(responseEvent);
		}
		
	}
}