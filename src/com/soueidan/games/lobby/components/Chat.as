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
	
	import skins.HGroupSkin;
	import skins.VGroupSkin;
	
	import spark.components.*;
	import spark.layouts.VerticalLayout;
	import spark.utils.TextFlowUtil;
	
	public class Chat extends TabContainer implements ITab
	{
		private static const MAX_LINES:int = 30;
		
		private var _box:SkinnableContainer;
		private var _textArea:TextArea;
		
		private var _form:SkinnableContainer;
		
		private var _texts:Array = [];
		
		private var _say:Label;
		private var _textInput:TextInput;
		private var _submit:Button;
		
		private var _server:Connector = ConnectManager.getInstance();
		private var _app:App = ApplicationManager.getInstance();
		
		public function Chat()
		{
			super();
			
			title = ResourceManager.getString("entrance.chat");
			
			_server.addEventListener(SFSEvent.USER_ENTER_ROOM, userEnterRoom);
			_server.addEventListener(SFSEvent.PUBLIC_MESSAGE, publicMessage);
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if (!_box ) {
				_box = new SkinnableContainer();
				_box.setStyle("skinClass", Class(VGroupSkin));
				_box.percentWidth = _box.percentHeight = 100;
				addElement(_box);
			}
			
			if ( !_textArea ) {
				_textArea = new TextArea();
				_textArea.setStyle("borderVisible", false);
				_textArea.editable = _textArea.selectable = false;
				_textArea.percentWidth = 100;
				_textArea.percentHeight = 100;
				_box.addElement(_textArea);
			}
			
			if ( !_form ) {
				_form = new SkinnableContainer();
				_form.setStyle("skinClass", Class(HGroupSkin));
				_form.percentWidth = 100;
				addElement(_form);
			}
			
			if (!_say ) {
				_say = new Label();
				_say.text = ResourceManager.getString("chat.say");
				_form.addElement(_say);
			}
			
			if ( !_textInput ) {
				_textInput = new TextInput();
				if ( ResourceManager.getString("direction") == Direction.RTL ) {
					_textInput.setStyle("textAlign", "right");
				}
				_textInput.percentWidth = 100;
				_form.addElement(_textInput);
			}
			
			if ( !_submit ) {
				_submit = new Button();
				_submit.label = ResourceManager.getString("chat.send");
				_form.addElement(_submit);
			}
			
			(titleDisplay as Label).setStyle("textAlign", ResourceManager.getString("left"));
			
			show();
			writeFromSystem(ResourceManager.getString("chat.welcome"));
			updateTextArea();
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
		
		private function userEnterRoom(event:SFSEvent):void
		{
			var user:SFSUser = event.params.user;
			
			var name:String = user.name;
			if ( UserManager.isVip(user)) {
				name += ":vip:";
			}
			
			var msg:String = name + " " + ResourceManager.getString("chat.msg");
			if ( ResourceManager.isLocale("ar") ) {
				msg = ResourceManager.getString("chat.msg") + " " + name;
			}
			
			writeFromSystem(msg);
			
			updateTextArea();
		}
		
		private function writeFromSystem(msg:String):void {
			var color:String = "0x51d63c";
			_texts.push('<p fontWeight="normal" fontSize="16"><span fontWeight="bold" color="' + color + '">' + ResourceManager.getString("chat.system") + ': </span><span  color="' + color + '">' + ChatManager.convertSmilies(msg, color) + '</span></p>');
		}
		
		private function publicMessage(event:SFSEvent):void
		{
			var user:SFSUser = event.params.sender;
			var msg:String = event.params.message;
			
			var fontSize:String = "13";
			var color:String = "0x000000";
			if ( user.isAdmin() ) {
				color = "0xFF3504";
				fontSize = "15";
			}
			
			if ( user.isModerator() ) {
				color = "0xf9be0a";
				fontSize = "14";
			}
			
			var name:String = user.name + "";
			if ( UserManager.isVip(user)) {
				name += ChatManager.convertSmilies(":vip:", color) + ": </span>";
			} else {
				name += ":</span>";
			}
			
			
			_texts.push('<p fontWeight="normal" fontSize="' + fontSize + '"><span fontWeight="bold" color="' + color + '">' + name + '<span color="0xFFFFFF">ا</span><span  color="' + color + '">' + ChatManager.convertSmilies(msg, color) + '</span></p>');

			updateTextArea();
		}	
		
		private function updateTextArea():void
		{
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
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			//trace(getExplicitOrMeasuredWidth(), unscaledWidth, _box.getExplicitOrMeasuredWidth());
			
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
}