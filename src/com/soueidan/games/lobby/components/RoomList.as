package com.soueidan.games.lobby.components
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.data.ISFSArray;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.soueidan.games.lobby.interfaces.ITab;
	import com.soueidan.games.lobby.core.*;
	import com.soueidan.games.lobby.managers.ConnectManager;
	
	import spark.components.Label;
	import spark.components.VGroup;
	
	public class RoomList extends VGroup implements ITab
	{
		private var _server:Connector;
		
		private var _rooms:Array = [];
		private var _newRooms:Array = [];
		private var _roomChanged:Boolean;
		
		private var _title:Label;
		private var _body:Label;
		
		public function RoomList()
		{
			super();
			
			percentWidth = 100;
			
			_server = ConnectManager.getInstance();
		
			_server.addEventListener(SFSEvent.EXTENSION_RESPONSE, extensionResponse);
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if (!_title) {
				_title = new Label();
				_title.text = "Room List";
				_title.setStyle("fontWeight", "bold");
				_title.setStyle("fontSize", 14);
				addElement(_title);
			}
			
			if (!_body) {
				_body = new Label();
				_body.text = "No games created yet!";
				addElement(_body);
			}
			
		}
		protected function extensionResponse(event:SFSEvent):void
		{
			var action:String = event.params.cmd;
			
			if ( ExtensionResponse.GAME_LIST_UPDATE != action ) {
				return;
			}
			
			var object:SFSObject = event.params.params as SFSObject;
			var list:ISFSArray = object.getSFSArray("list");
			
			var size:int = list.size();
			
			_newRooms = [];
			for(var i:int=0;i<size;i++){
				object = list.getElementAt(i);
				_newRooms.push(object);
			}
			
			_roomChanged = true;
			invalidateProperties();
		}
		
		override protected function commitProperties():void {
			if ( _roomChanged ) {
				_roomChanged = false;
				
				var remove:Boolean;
				
				for(var i:int=0;i<_rooms.length;i++) {
					remove = true;
					for(var n:int=0;n<_newRooms.length;n++) {
						if ( _rooms[i].isEqual(_newRooms[n]) ) {
							_newRooms.splice(n,1);
							remove = false;
							break;
						}
					}
					
					if ( remove ) {
						removeElement(_rooms[i]);
						_rooms.splice(i,1);
					}
				}
				 
				var create:RoomPlayerVersusPlayer;
				for each(var sfsObject:SFSObject in _newRooms ) {
					create = new RoomPlayerVersusPlayer(sfsObject);
					_rooms.push(create);
					addElement(create);
				}
				
				showNoRooms();
			}
			
			super.commitProperties();
		}
		
		private function showNoRooms():void
		{
			if ( !containsElement(_body) && _rooms.length == 0) {
				addElement(_body);
			}
			
			if ( _rooms.length > 0 && containsElement(_body) ) {
				removeElement(_body);
			}
		}
		
		public function hide():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function show():void
		{
			// TODO Auto Generated method stub
			
		}
		
		
	}
}