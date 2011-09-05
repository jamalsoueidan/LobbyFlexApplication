package com.soueidan.games.lobby.components
{
	import com.soueidan.games.lobby.managers.ResourceManager;
	
	import flash.display.Graphics;
	
	import flashx.textLayout.formats.Direction;
	
	import spark.components.VGroup;
	
	public class TabContainer extends VGroup
	{
		public function TabContainer()
		{
			super();
			
			percentWidth = 100;
			
			paddingTop = 10;
			paddingLeft = 10;
			paddingRight = 10;
			paddingBottom = 10;			
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			var g:Graphics = graphics;
			g.lineStyle(0, 0x000);
			if ( ResourceManager.getString("direction") == Direction.LTR ) {
				g.lineTo(0,0);
				g.lineTo(0,unscaledHeight);
				g.lineTo(unscaledWidth-1,unscaledHeight);
				g.lineTo(unscaledWidth-1,-1);
				g.lineTo(0,-1);
			} else {
				g.lineStyle(1,0x000);
				g.lineTo(1,-1);
				g.lineTo(1,unscaledHeight);
				g.lineTo(unscaledWidth,unscaledHeight);
				g.lineTo(unscaledWidth,-1);
				g.lineTo(1,-1);
			}
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
}