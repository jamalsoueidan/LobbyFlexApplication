package com.soueidan.games.lobby.components.users
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.User;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.soueidan.games.lobby.core.Connector;
	import com.soueidan.games.lobby.core.StatusProfile;
	import com.soueidan.games.lobby.managers.ConnectManager;
	import com.soueidan.games.lobby.managers.ResourceManager;
	import com.soueidan.games.lobby.requests.StatusRequest;
	
	import spark.components.DropDownList;
	import spark.events.DropDownEvent;
	
	public class UserProfile extends UserBase
	{	
		private var _list:DropDownList;
		
		private var _server:Connector = ConnectManager.getInstance();
		
		public function UserProfile() {
			super();
			
			_server.addEventListener(SFSEvent.USER_VARIABLES_UPDATE, updateStatus);
			
			
		}
		
		private function updateStatus(event:SFSEvent):void {
			var user:User = event.params.user;
			if ( !user.isItMe ) {
				return;
			}
			
			update();
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if ( !_list ) {
				_list = new DropDownList();
				_list.percentWidth = 100;
				_list.dataProvider = StatusProfile.getList();
				_list.addEventListener(DropDownEvent.CLOSE, choosenFromList);
				_list.requireSelection = true;
				_list.setStyle("alternatingItemColors", [0xECECEC, 0xE6E6E6]);
				_list.setStyle("textAlign", ResourceManager.getString("left"));
				_textGroup.addElement(_list);
			}
		}
		
		private function choosenFromList(event:DropDownEvent):void
		{
			var request:IRequest = new StatusRequest(_list.selectedItem);
			ConnectManager.getInstance().send(request);
		}
	}
}