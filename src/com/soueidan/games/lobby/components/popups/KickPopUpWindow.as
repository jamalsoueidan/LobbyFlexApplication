package com.soueidan.games.lobby.components.popups
{
	import com.soueidan.games.engine.components.Text;
	import com.soueidan.games.engine.components.popups.PopUpWindow;
	import com.soueidan.games.engine.managers.ResourceManager;

	public class KickPopUpWindow extends PopUpWindow
	{
		private var _description:Text;
		
		public function KickPopUpWindow() {
			super();
			
			title = ResourceManager.getString("kick.title");
			
			width = 400;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if ( !_description ) {
				_description = new Text();
				_description.percentWidth = 100;
				_description.text = ResourceManager.getString("kick.description");
				addElement(_description);
			}
			
			closeButton.visible = false;
		}
	}
}