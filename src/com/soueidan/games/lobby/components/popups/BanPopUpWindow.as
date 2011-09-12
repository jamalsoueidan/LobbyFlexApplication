package com.soueidan.games.lobby.components.popups
{
	import com.soueidan.games.lobby.components.Text;
	import com.soueidan.games.lobby.managers.ResourceManager;
	
	public class BanPopUpWindow extends PopUpWindow
	{
		private var _description:Text;
		
		public function BanPopUpWindow() {
			super();
			
			title = ResourceManager.getString("ban.title");
			
			width = 400;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if ( !_description ) {
				_description = new Text();
				_description.percentWidth = 100;
				_description.text = ResourceManager.getString("ban.description");
				addElement(_description);
			}
			
			closeButton.visible = false;
		}
	}
}