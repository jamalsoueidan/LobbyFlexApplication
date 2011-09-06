package com.soueidan.games.lobby.managers
{
	import mx.resources.ResourceManager;

	public class ResourceManager
	{
		public static function getString(value:String):String
		{
			return mx.resources.ResourceManager.getInstance().getString("resources", value);
		}
		
		public static function isLocale(value:String):Boolean {
			return (mx.resources.ResourceManager.getInstance().localeChain[0] == value);
		}
	}
}