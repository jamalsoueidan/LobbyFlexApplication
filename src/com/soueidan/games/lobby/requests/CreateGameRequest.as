package com.soueidan.games.lobby.requests
{
	import com.smartfoxserver.v2.entities.Room;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.soueidan.games.lobby.managers.ConnectManager;
	
	public class CreateGameRequest extends ExtensionRequest
	{
		public static const CREATE_GAME:String = "create_game";
		
		public function CreateGameRequest(params:ISFSObject=null) {
			super(CREATE_GAME, params, ConnectManager.getInstance().currentRoom, false);
		}
	}
}