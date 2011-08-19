package lobby.events
{
	import flash.events.Event;
	
	public class SubmitEvent extends Event
	{
		static public const CLICK:String = "submitclicked";
	
		private var _parameters:Object;
		
		private var _path:String;
		
		public function SubmitEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, path:String=null, parameters:Object=null)
		{
			super(type, bubbles, cancelable);
			
			_parameters = parameters;
			_path = path;
		}

		public function get path():String
		{
			return _path;
		}

		public function get parameters():Object
		{
			return _parameters;
		}

	}
}