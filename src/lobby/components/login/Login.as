package lobby.components.login
{
	import com.adobe.serialization.json.JSON;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.User;
	import com.smartfoxserver.v2.exceptions.SFSError;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.smartfoxserver.v2.requests.LoginRequest;
	
	import flash.events.Event;
	
	import lobby.core.*;
	import lobby.events.SubmitEvent;
	import lobby.managers.*;
	
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import spark.components.*;
	import spark.layouts.HorizontalLayout;
	
	public class Login extends TitleWindow
	{
		private var _guest:GuestLogin;
		private var _user:UserLogin;
		
		private var _server:Connector = ConnectManager.server;
		
		public function Login():void {
			super();
			
			title = "Login";
			
			var horizontalLayout:HorizontalLayout = new HorizontalLayout();
			horizontalLayout.paddingBottom = horizontalLayout.paddingLeft = horizontalLayout.paddingRight = horizontalLayout.paddingTop = 10;
			
			layout = horizontalLayout;
				
			setStyle("verticalCenter", 0);
			setStyle("horizontalCenter", 0);
		}
		
		protected function submit(event:SubmitEvent):void
		{
			var loginRequest:IRequest;
			var parameters:Object = event.parameters; 
			if ( !parameters.nickname) {
				loginRequest = new LoginRequest(parameters.email, parameters.password);
			} else {
				loginRequest = new LoginRequest(parameters.nickname);
			}
			
			_server.addEventListener(SFSEvent.LOGIN_ERROR, loginError);
			_server.send(loginRequest);
			
			enabled = false;
		}
		
		private function loginError(evt:SFSEvent):void
		{
			enabled = true;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if ( !_user ) {
				_user = new UserLogin();
				_user.addEventListener(SubmitEvent.CLICK, submit, false, 0, true);
				addElement(_user);
			}
			
			if (!_guest) {
				_guest = new GuestLogin();
				_guest.addEventListener(SubmitEvent.CLICK, submit, false, 0, true);
				addElement(_guest);
			}
		}
		
		private function removeListener():void {
			_user.removeEventListener(SubmitEvent.CLICK, submit);
			_guest.addEventListener(SubmitEvent.CLICK, submit);
		}
	}
}