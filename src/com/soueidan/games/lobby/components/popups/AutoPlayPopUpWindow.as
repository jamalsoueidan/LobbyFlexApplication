package com.soueidan.games.lobby.components.popups
{
	import com.soueidan.games.engine.components.Text;
	import com.soueidan.games.engine.components.popups.PopUpWindow;
	import com.soueidan.games.engine.managers.ResourceManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.ProgressBar;
	
	import spark.components.Button;

	public class AutoPlayPopUpWindow extends PopUpWindow
	{
		private static const COUNT:int = 5;
		
		private var _text:Text;
		
		private var _cancel:Button;
		
		private var _progress:ProgressBar;;
		
		private var _count:Text;
		
		public function AutoPlayPopUpWindow() {
			super();
			
			title = ResourceManager.getString("auto_play.searching");
			
			width = 400;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if (!_text ) {
				_text = new Text();
				_text.height = 50;
				_text.percentWidth = 100;
				_text.text = ResourceManager.getString("auto_play.please_wait");
				addElement(_text);
			}
			
			if ( !_progress ){
				_progress = new ProgressBar();
				_progress.indeterminate = true;
				_progress.minimum = 0;
				_progress.maximum = 100;
				_progress.label = "";
				_progress.percentWidth = 80;
				addElement(_progress);	
			}
			
			if (!_cancel ) {
				_cancel = new Button();
				_cancel.label = ResourceManager.getString("cancel");;
				_cancel.addEventListener(MouseEvent.CLICK, cancelFindPlayer);
				controlBarGroup.addElement(_cancel);
			}
		}
		
		private function cancelFindPlayer(event:MouseEvent):void {
			super.closeButton_clickHandler(event)
		}
		
		override protected function closeButton_clickHandler(event:MouseEvent):void {
			super.closeButton_clickHandler(event);
		}
		
		public function playerFound():void
		{
			removeElement(_progress);
			controlBarGroup.removeElement(_cancel);
			
			closeButton.visible = false;
			
			title = ResourceManager.getString("auto_play.title");
			
			_text.text = ResourceManager.getString("auto_play.player_found");
			_text.height = 30;
			
			_count = new Text();
			_count.height = 40;
			_count.percentWidth = 100;
			_count.setStyle("fontSize", 30);
			_count.setStyle("textAlign", "center");
			_count.text = String(COUNT);
			addElement(_count);
			
			var timer:Timer = new Timer(1000, COUNT);
			timer.addEventListener(TimerEvent.TIMER, timerSequence);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
			timer.start();
		}
		
		protected function timerComplete(event:TimerEvent):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function timerSequence(event:TimerEvent):void
		{
			_count.text = String(COUNT - Timer(event.target).currentCount);
		}
		
	}
}