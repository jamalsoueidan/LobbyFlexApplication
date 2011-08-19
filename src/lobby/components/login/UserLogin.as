package lobby.components.login
{
	import com.adobe.crypto.SHA1;
	import com.adobe.utils.StringUtil;
	
	import flash.events.MouseEvent;
	
	import lobby.events.SubmitEvent;
	
	import spark.components.*;

	public class UserLogin extends VGroup
	{
		private var _email:TextInput
		private var _password:TextInput
		private var _submit:Button;
		
		override protected function createChildren():void {
			super.createChildren();
			
			if ( !_email ) {
				_email = new TextInput();
				_email.prompt = "Enter your email";
				_email.text = "js@mmlink.dk";
				addElement(_email);
			}
			
			if ( !_password ) {
				_password = new TextInput();
				_password.displayAsPassword = true;
				_password.prompt = "Enter your password";
				_password.text = "nicenice";
				addElement(_password);
			}
			
			if ( !_submit ) {
				_submit = new Button();
				_submit.label = "Login";
				_submit.addEventListener(MouseEvent.CLICK, submitNow, false, 0, true);
				addElement(_submit);
			}
		}
		
		protected function submitNow(event:MouseEvent):void
		{
			trace(SHA1.hash(_password.text));
			var parameters:Object = {email: StringUtil.trim(_email.text), password: SHA1.hash(_password.text)};
			var evt:SubmitEvent = new SubmitEvent(SubmitEvent.CLICK, false, false, "login", parameters);
			dispatchEvent(evt);
		}
	}
}