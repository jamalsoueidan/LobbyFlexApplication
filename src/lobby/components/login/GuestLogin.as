package lobby.components.login
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import lobby.events.SubmitEvent;
	
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.StringUtil;
	
	import spark.components.*;
	
	public class GuestLogin extends VGroup
	{
	
		private var _nickname:TextInput
		private var _submit:Button;
		
		override protected function createChildren():void {
			super.createChildren();
			
			if ( !_nickname ) {
				_nickname = new TextInput();
				_nickname.prompt = "Enter your nickname";
				_nickname.text = "testerne";
				addElement(_nickname);
			}
			
			if ( !_submit ) {
				_submit = new Button();
				_submit.label = "Login as guest";
				_submit.addEventListener(MouseEvent.CLICK, submitNow, false, 0, true);
				addElement(_submit);
			}
		}
		
		protected function submitNow(event:MouseEvent):void
		{
			var parameters:Object = {nickname: StringUtil.trim(_nickname.text)};
			var evt:SubmitEvent = new SubmitEvent(SubmitEvent.CLICK, false, false, "login_as_guest", parameters);
			dispatchEvent(evt);
		}
	}
}