package com.soueidan.games.lobby.components.users
{
	import com.soueidan.games.lobby.managers.ResourceManager;
	import com.soueidan.games.lobby.managers.UserManager;
	
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.VGroup;
	
	public class UserPlayer extends UserBase
	{	
		private var _invite:Button;
		private var _stats:Button;
		
		private var _lastGroup:VGroup;
		
		private var _backgroundChanged:Boolean;
		private var _backgroundColor:int;
		private static const BACKGROUND_COLOR:int = 0xFF0040;
		
		public function UserPlayer() {
			super();
			
			percentWidth = 100;
			
			addEventListener(MouseEvent.ROLL_OVER, rollOver);
			addEventListener(MouseEvent.ROLL_OUT, rollOut);
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if (!_lastGroup ) {
				_textGroup.percentWidth = 80;
				
				_lastGroup = new VGroup();
				_lastGroup.horizontalAlign = "right";
				_lastGroup.verticalAlign = "bottom";
				_lastGroup.percentWidth = 20;
				addElement(_lastGroup);
			}
			
			addButtons();
		}
		
		private function addButtons():void
		{
			if (!_stats ) {
				_stats = new Button();
				_stats.id = "stats";
				_stats.label = "Stats";
				//_lastGroup.addElement(_stats);
			}
			
			if ( !_invite ) {
				_invite = new Button();
				_invite.id = "invite";
				_invite.label = "Invite";
				_lastGroup.addElement(_invite);
			}
			
			update();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			graphics.clear();
			
			if ( _backgroundChanged ) {
				_backgroundChanged = false;
				graphics.beginFill(_backgroundColor);
				graphics.drawRect(0,0,unscaledWidth, unscaledHeight);
				graphics.endFill();
			}
			
			graphics.lineStyle(1,0x000);
			graphics.moveTo(0,unscaledHeight);
			graphics.lineTo(unscaledWidth,unscaledHeight);
		}
		
		override public function update():void {
			super.update();
			
			if ( UserManager.isReady(_sfsUser) ) {
				if (!_lastGroup.containsElement(_invite)) _lastGroup.addElement(_invite);
			} else {
				if (_lastGroup.containsElement(_invite)) _lastGroup.removeElement(_invite);
			}
			
			invalidateProperties();
		}
		
		private function rollOver(event:MouseEvent):void {
			_backgroundColor = BACKGROUND_COLOR;
			_backgroundChanged = true;
			invalidateDisplayList();
		}
		
		private function rollOut(event:MouseEvent):void {
			_backgroundColor = 0xFFFFFF;
			_backgroundChanged = true;
			invalidateDisplayList();
		}
	}
}