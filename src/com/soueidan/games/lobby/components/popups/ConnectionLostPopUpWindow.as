package com.soueidan.games.lobby.components.popups
{
	import com.soueidan.games.lobby.components.Text;
	import com.soueidan.games.lobby.managers.ApplicationManager;
	import com.soueidan.games.lobby.managers.ResourceManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.engine.TextLine;
	
	import mx.managers.PopUpManager;
	
	import spark.components.Application;
	import spark.components.Button;
	import spark.components.TextArea;
	import spark.utils.TextFlowUtil;
	
	public class ConnectionLostPopUpWindow extends PopUpWindow
	{
		private var _text:Text;
		
		private var _join:Button;
		
		public function ConnectionLostPopUpWindow() {
			super();
			
			title = ResourceManager.getString("connection_lost.title");
			
			width = 400;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if (!_text ) {
				_text = new Text();
				_text.height = 50;
				_text.percentWidth = 100;
				_text.text = ResourceManager.getString("connection_lost.text");
				addElement(_text);
			}
			
			/*if (!_join ) {
				_join = new Button();
				_join.label = "Join";
				_join.addEventListener(MouseEvent.CLICK, joinLobby, false, 0, true);
				addElement(_join);
			}*/
		}
		
		/*protected function joinLobby(event:MouseEvent):void
		{
			_join.removeEventListener(MouseEvent.CLICK, joinLobby);
			PopUpManager.removePopUp(this);
			dispatchEvent(new Event("join"));
		}*/
	}
}