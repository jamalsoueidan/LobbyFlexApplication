package com.soueidan.games.lobby.components.popups
{
	import com.soueidan.games.lobby.managers.ApplicationManager;
	import com.soueidan.games.lobby.managers.ResourceManager;
	
	import spark.components.Label;
	import spark.components.TitleWindow;
	import spark.layouts.VerticalLayout;
	
	public class PopUpWindow extends TitleWindow
	{
		public function PopUpWindow()
		{
			super();
			
			var verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.paddingBottom = verticalLayout.paddingLeft = verticalLayout.paddingRight = verticalLayout.paddingTop = 10;
			
			layout = verticalLayout;
			
			visible = false;
			
		}
		
		override protected function createChildren():void {
			super.createChildren();
		
			if ( titleDisplay ) {
				(titleDisplay as Label).setStyle("textAlign", ResourceManager.getString("left"));
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			if ( !visible ) {
				x = ApplicationManager.getInstance().width/2 - getExplicitOrMeasuredWidth()/2;
				y = ApplicationManager.getInstance().height/2 - getExplicitOrMeasuredHeight()/2;
				
				visible = true;
			}
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
}