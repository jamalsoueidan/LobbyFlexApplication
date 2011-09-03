package com.soueidan.games.lobby.requests
{
	import com.smartfoxserver.v2.entities.Room;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.soueidan.games.lobby.managers.ConnectManager;
	
	public class StatusRequest extends ExtensionRequest
	{
		public static const UPDATE_STATUS:String = "update_status";
		
		public function StatusRequest(object:Object)
		{
			var params:ISFSObject = new SFSObject();
			params.putInt("status", object.id);
			super(UPDATE_STATUS, params, ConnectManager.getInstance().currentRoom, false);
		}
	}
}