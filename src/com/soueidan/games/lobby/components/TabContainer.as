package com.soueidan.games.lobby.components
{
	import skins.PanelSkin;
	
	import spark.components.Panel;
	import spark.layouts.VerticalLayout;
	
	public class TabContainer extends Panel
	{
		public function TabContainer()
		{
			super();
			
			setStyle("skinClass", Class(PanelSkin));
			setStyle("dropShadowVisible", false);
			
			height = 200;
			
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			graphics.clear();
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
}