package com.soueidan.games.lobby.components
{
	import com.soueidan.games.engine.components.chat.ChatMessage;
	import com.soueidan.games.engine.components.chat.ChatPanel;
	import com.soueidan.games.engine.managers.ResourceManager;
	import com.soueidan.games.lobby.core.*;
	import com.soueidan.games.lobby.managers.*;
	
	import spark.components.*;
	
	public class Chat extends ChatPanel
	{
		
		override protected function createChildren():void {
			super.createChildren();
			
			systemMessage(ResourceManager.getString("chat.welcome"));
		}

	}
}