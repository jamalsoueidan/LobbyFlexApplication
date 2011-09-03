package com.soueidan.games.lobby.components
{
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	
	import spark.components.Label;
	import spark.components.VGroup;
	
	public class UserVersus extends VGroup
	{
		private var _userNickname:Label;
		private var _userRegistered:Label;
		
		private var _sfsObject:ISFSObject;
		private var _sfsObjectChanged:Boolean;
		
		
		public function set sfsObject(value:ISFSObject):void {
			_sfsObject = value;
			_sfsObjectChanged = true;
			invalidateProperties();
		}
		
		override protected function childrenCreated():void {
			super.createChildren();
			
			if ( !_userNickname ) {
				_userNickname = new Label();
				addElement(_userNickname);
			}
			
			if (!_userRegistered ) {
				_userRegistered = new Label();
				addElement(_userRegistered);
			}
		}
		
		override protected function commitProperties():void {

			if ( _sfsObjectChanged ) {
				_sfsObjectChanged = false;
				
				_userNickname.text = _sfsObject.getUtfString("name");
				
				if ( _sfsObject.getBool("isRegistered") ) {
					_userRegistered.text = "Registered";	
				} else {
					_userRegistered.text = "Guest";
				}
			}
			super.commitProperties();
		}
	}
}