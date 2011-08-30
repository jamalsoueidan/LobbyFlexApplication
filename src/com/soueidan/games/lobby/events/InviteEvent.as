package com.soueidan.games.lobby.events
{
	import flash.events.Event;
	
	public class InviteEvent extends Event
	{
		static public const ACTION:String = "action";
		
		static public const REFUSE:String = "refuse"; // when the invitee reject
		static public const ACCEPT:String = "accept"; // when the invitee accept
		
		static public const CANCEL:String = "cancel"; // when the inviter cancel the game invitation, notice the other player about that
		
		public function set action(value:String):void
		{
			_action = value;
		}

		public function get action():String {
			return _action;
		}
		
		private var _action:String;
		
		public function InviteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}