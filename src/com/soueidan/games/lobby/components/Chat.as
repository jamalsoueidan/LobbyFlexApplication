package com.soueidan.games.lobby.components
{
	import com.soueidan.games.engine.components.chat.Chat;
	import com.soueidan.games.engine.managers.ResourceManager;
	import com.soueidan.games.lobby.core.*;
	import com.soueidan.games.lobby.managers.*;
	
	import spark.components.*;
	
	public class Chat extends com.soueidan.games.engine.components.chat.Chat
	{
		
		override protected function createChildren():void {
			super.createChildren();
			
			writeFromSystem(ResourceManager.getString("chat.welcome"));
		}

	}
}