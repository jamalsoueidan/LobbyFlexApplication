package com.soueidan.games.lobby.components.users
{
	import com.soueidan.games.lobby.managers.ResourceManager;
	
	import spark.components.Button;
	import spark.components.VGroup;
	
	public class UserPlayer extends UserBase
	{	
		private var _invite:Button;
		private var _stats:Button;
		
		protected var _lastGroup:VGroup;
		
		public function UserPlayer() {
			super();
			
			percentWidth = 100;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if (!_lastGroup ) {
				_lastGroup = new VGroup();
				_lastGroup.horizontalAlign = (ResourceManager.isLocale("ar") ? "left" : "right");
				_lastGroup.verticalAlign = "bottom";
				_textGroup.percentWidth = 80;
				_lastGroup.percentWidth = 20;
				addElement(_lastGroup);
			}
			
			if (!_stats ) {
				_stats = new Button();
				_stats.id = "stats";
				_stats.label = "Stats";
				_lastGroup.addElement(_stats);
			}
			
			if ( !_invite ) {
				_invite = new Button();
				_invite.id = "invite";
				_invite.label = "Invite";
				_lastGroup.addElement(_invite);
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