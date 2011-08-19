package lobby.components
{
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	
	import lobby.core.User;
	import lobby.managers.UserManager;
	
	import spark.components.Label;
	import spark.components.VGroup;
	
	public class UserProfile extends VGroup
	{
		private var _userNickname:Label;
		private var _userRegistered:Label;
		
		private var _sfsUser:SFSUser;
		private var _sfsUserChanged:Boolean;
		
		private var _sfsObject:ISFSObject;
		private var _sfsObjectChanged:Boolean;
		
		
		public function set sfsObject(value:ISFSObject):void {
			_sfsObject = value;
			_sfsObjectChanged = true;
			invalidateProperties();
		}

		public function set sfsUser(value:SFSUser):void {
			_sfsUser = value;
			_sfsUserChanged = true;
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
			if ( _sfsUserChanged ) {
				_sfsUserChanged = false;
				
				_userNickname.text = _sfsUser.name;
				
				if ( UserManager.isRegistered(_sfsUser) ) {
					_userRegistered.text = "Registered";	
				} else {
					_userRegistered.text = "Guest";
				}
			}
			
			if ( _sfsObjectChanged ) {
				_sfsObjectChanged = false;
				
				_userNickname.text = _sfsObject.getUtfString("name");
				
				trace(_userNickname.text, _sfsObject.getBool("isRegistered"));
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