package com.soueidan.games.lobby.components
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.smartfoxserver.v2.requests.PublicMessageRequest;
	import com.soueidan.games.lobby.core.*;
	import com.soueidan.games.lobby.interfaces.ITab;
	import com.soueidan.games.lobby.managers.*;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import flashx.textLayout.formats.Direction;
	
	import mx.utils.StringUtil;
	
	import spark.components.*;
	import spark.layouts.VerticalLayout;
	import spark.utils.TextFlowUtil;
	
	public class Chat extends Panel implements ITab
	{
		private static const MAX_LINES:int = 30;
		
		private var _textArea:TextArea;
		
		private var _form:HGroup;
		
		private var _texts:Array = [];
		
		private var _textInput:TextInput;
		private var _submit:Button;
		
		private var _server:Connector = ConnectManager.getInstance();
		private var _app:App = ApplicationManager.getInstance();
		
		public function Chat()
		{
			super();
			
			setStyle("paddingTop", 0);
			setStyle("paddingLeft", 0);
			setStyle("paddingBottom", 0);
			setStyle("paddingRight", 0);
			
			setStyle("dropShadowVisible", false);
			
			title = ResourceManager.getString("entrance.chat");
			
			var vertial:VerticalLayout = new VerticalLayout();
			vertial.gap = 0;			
			layout = vertial;
			
			_server.addEventListener(SFSEvent.PUBLIC_MESSAGE, publicMessage);
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if ( !_textArea ) {
				_textArea = new TextArea();
				_textArea.setStyle("borderVisible", false);
				_textArea.selectable = false;
				_textArea.percentWidth = 100;
				_textArea.percentHeight = 100;
				addElement(_textArea);
			}
			
			if ( !_form ) {
				_form = new HGroup();
				_form.percentWidth = 100;
				_form.paddingLeft = _form.paddingRight = _form.paddingBottom = 5;
				addElement(_form);
			}
			
			if ( !_textInput ) {
				_textInput = new TextInput();
				if ( ResourceManager.getString("direction") == Direction.RTL ) {
					_textInput.setStyle("textAlign", "right");
				}
				_textInput.percentWidth = 75;
				_form.addElement(_textInput);
			}
			
			if ( !_submit ) {
				_submit = new Button();
				_submit.percentWidth = 25;
				_submit.label = ResourceManager.getString("chat.send");
				_form.addElement(_submit);
			}
			
			(titleDisplay as Label).setStyle("textAlign", ResourceManager.getString("left"));
			
			show();
		}
		
		public function show():void {
			_textInput.setFocus();
			_submit.addEventListener(MouseEvent.CLICK, submitForm);
			_textInput.addEventListener(KeyboardEvent.KEY_DOWN, keyboardDown);
		}
		
		public function hide():void {
			_submit.removeEventListener(MouseEvent.CLICK, submitForm);
			_textInput.removeEventListener(KeyboardEvent.KEY_DOWN, keyboardDown);
		}
		
		private function publicMessage(event:SFSEvent):void
		{
			var user:SFSUser = event.params.sender;
			var msg:String = event.params.message;
			
			_texts.push('<p fontWeight="bold"><span fontWeight="normal">' + user.name.toString() + ':</span><span color="0xFFFFFF">ا</span>' + SmiliesManager.convert(msg) + '</p>');
			
			if (_texts.length > MAX_LINES ) {
				_texts.shift();
			}
			
			var text:String = '';
			for(var i:int=0;i<_texts.length;i++) {
				text += _texts[i];
			}
			
			_textArea.textFlow = TextFlowUtil.importFromString(text);
			_textArea.textFlow.direction = ResourceManager.getString("direction");
			_textArea.textFlow.flowComposer.updateAllControllers();
		}
		
		private function submitForm(event:MouseEvent=null):void
		{
			var msg:String = StringUtil.trim(_textInput.text);
			if ( msg.length > 0 ) {
				var request:IRequest = new PublicMessageRequest(msg);
				_server.send(request);
			}
			_textInput.text = "";
		}
		
		private function keyboardDown(event:KeyboardEvent):void
		{
			if ( event.keyCode == Keyboard.ENTER ) {
				submitForm();
			}
		}
	}
}