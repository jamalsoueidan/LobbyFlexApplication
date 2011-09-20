package com.soueidan.games.lobby.responses
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.soueidan.games.engine.net.responses.ServerResponseHandler;
	
	import flash.external.ExternalInterface;

	public class CreateGameResponse extends ServerResponseHandler
	{
		public static const CREATE_GAME:String = "create_game";
		
		override public function handleServerResponse(event:SFSEvent):void {
			trace("create game");
			
			var object:SFSObject = event.params.params as SFSObject;
			
			ExternalInterface.call("start_match", object.getUtfString("room"));
		}
	}
}