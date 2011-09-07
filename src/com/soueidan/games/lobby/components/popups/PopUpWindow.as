package com.soueidan.games.lobby.components.popups
{
	import com.soueidan.games.lobby.core.App;
	import com.soueidan.games.lobby.managers.ApplicationManager;
	import com.soueidan.games.lobby.managers.ResourceManager;
	
	import mx.managers.PopUpManager;
	
	import spark.components.Label;
	import spark.components.TitleWindow;
	import spark.layouts.VerticalLayout;
	
	public class PopUpWindow extends TitleWindow
	{
		private var _visible:Boolean = false;
		
		public function PopUpWindow()
		{
			super();
			
			var verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.paddingBottom = verticalLayout.paddingLeft = verticalLayout.paddingRight = verticalLayout.paddingTop = 10;
			verticalLayout.horizontalAlign = "center";
			
			layout = verticalLayout;			
		}
		
		override protected function createChildren():void {
			super.createChildren();
		
			if ( titleDisplay ) {
				(titleDisplay as Label).setStyle("textAlign", ResourceManager.getString("left"));
			}
		}
		
		public function show():void {
			var app:App = ApplicationManager.getInstance();
			_visible = true;
			x = -1000;
			app.addElement(this);
			app.removeElement(this);
			_visible = false;
			invalidateDisplayList();
			
			PopUpManager.addPopUp(this, app, true);
		}
		
		public function hide():void {
			PopUpManager.removePopUp(this);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			if ( !_visible ) {
				x = ApplicationManager.getInstance().width/2 - getExplicitOrMeasuredWidth()/2;
				y = ApplicationManager.getInstance().height/2 - getExplicitOrMeasuredHeight()/2;
				
				_visible = true;
			}
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
}