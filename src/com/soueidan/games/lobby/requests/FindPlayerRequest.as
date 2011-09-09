package com.soueidan.games.lobby.requests
{
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.soueidan.games.lobby.managers.ConnectManager;

	public class FindPlayerRequest extends ExtensionRequest
	{
		public static const UPDATE_STATUS:String = "find_player";
		
		public function FindPlayerRequest(addToFindPlayer:Boolean) {
			var params:ISFSObject = new SFSObject();
			params.putBool("add", addToFindPlayer);

			super(UPDATE_STATUS, params, ConnectManager.getInstance().currentRoom, false);
		}
	}
}