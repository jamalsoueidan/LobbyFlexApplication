package lobby.managers
{
	import lobby.core.App;

	public class ApplicationManager
	{
		public static var _application:App;
		
		public static function setInstance(application:App):void {
			_application = application;
		}
		
		public static function getInstance():App {
			return _application;
		}
	}
}