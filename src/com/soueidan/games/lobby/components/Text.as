package com.soueidan.games.lobby.components
{
	import spark.components.TextArea;
	import spark.utils.TextFlowUtil;
	
	public class Text extends TextArea
	{
		public function Text()
		{
			super();
			
			selectable = editable = false;
			
			setStyle("borderVisible", false);
		}
	}
}