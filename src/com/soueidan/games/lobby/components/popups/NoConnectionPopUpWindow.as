package com.soueidan.games.lobby.components.popups
{
	import com.soueidan.games.lobby.components.Text;
	import com.soueidan.games.lobby.managers.ResourceManager;
	
	import mx.controls.Button;

	public class NoConnectionPopUpWindow extends PopUpWindow
	{
		private var _text:Text;
		
		private var _join:Button;
		
		public function NoConnectionPopUpWindow() {
			super();
			
			title = ResourceManager.getString("no_connection.title");
			
			width = 400;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if (!_text ) {
				_text = new Text();
				_text.percentWidth = 100;
				_text.text = ResourceManager.getString("no_connection.description");
				addElement(_text);
			}
		}
	}
}