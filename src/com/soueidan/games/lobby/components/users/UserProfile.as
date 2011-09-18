package com.soueidan.games.lobby.components.users
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.User;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.soueidan.games.engine.components.user.UserBase;
	import com.soueidan.games.engine.formats.UserStatus;
	import com.soueidan.games.engine.managers.ResourceManager;
	import com.soueidan.games.engine.managers.ServerManager;
	import com.soueidan.games.engine.net.Server;
	import com.soueidan.games.lobby.requests.StatusRequest;
	
	import spark.components.DropDownList;
	import spark.events.DropDownEvent;
	
	public class UserProfile extends com.soueidan.games.engine.components.user.UserBase
	{	
		private var _list:DropDownList;
		
		private var _server:Server = ServerManager.getInstance();
		
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
				_list.dataProvider = UserStatus.getList();
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
			ServerManager.getInstance().send(request);
		}
	}
}