package com.soueidan.games.lobby.components.users
{
	import spark.components.Button;
	
	public class UserPlayer extends UserBase
	{	
		private var _invite:Button;
		private var _stats:Button;
		
		public function UserPlayer() {
			super();
			
			percentWidth = 100;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if ( !_invite ) {
				_invite = new Button();
				_invite.id = "invite";
				_invite.label = "Invite";
				_textGroup.addElement(_invite);
			}
			
			if (!_stats ) {
				_stats = new Button();
				_stats.id = "stats";
				_stats.label = "Stats";
				_textGroup.addElement(_stats);
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			graphics.clear();
			graphics.lineStyle(1,0x000);
			graphics.moveTo(0,unscaledHeight);
			graphics.lineTo(unscaledWidth,unscaledHeight);
		}
	}
}