package com.soueidan.games.lobby.components
{
	import com.smartfoxserver.v2.entities.data.SFSObject;
	
	import spark.components.HGroup;
	import spark.components.Label;
	
	public class RoomPlayerVersusPlayer extends HGroup
	{
		private var _sfsRoom:SFSObject;
		private var _sfsRoomChanged:Boolean;
		
		private var _inviter:UserVersus;
		private var _invitee:UserVersus;
		
		private var _label:Label;
		
		public function RoomPlayerVersusPlayer(value:SFSObject) {
			super();
			
			sfsRoom = value;
		}
		
		public function isEqual(value:SFSObject):Boolean {
			return ( value.getInt("id") == _sfsRoom.getInt("id") );
		}
		
		public function set sfsRoom(value:SFSObject):void {
			_sfsRoom = value;
			_sfsRoomChanged = true;
			invalidateProperties();
		}
		
		override protected function createChildren():void {
			if (!_label ) {
				_label = new Label(); 
				addElement(_label);
			}
			
			if ( !_inviter ) {
				_inviter = new UserVersus();
			}
			
			if ( !_invitee ) {
				_invitee = new UserVersus();
			}
			
			super.createChildren();
		}

		override protected function commitProperties():void {
			if ( _sfsRoomChanged ) {
				_sfsRoomChanged = false;
				
				_invitee.sfsObject = _sfsRoom.getSFSObject("invitee");
				addElement(_invitee);
				_inviter.sfsObject = _sfsRoom.getSFSObject("inviter");
				addElement(_inviter);
			}
			
			super.commitProperties();
		}
	}
}