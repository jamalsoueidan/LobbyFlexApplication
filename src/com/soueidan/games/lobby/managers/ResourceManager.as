package com.soueidan.games.lobby.managers
{
	import mx.resources.ResourceManager;

	public class ResourceManager
	{
		public static function getString(value:String):String
		{
			return mx.resources.ResourceManager.getInstance().getString("resources", value);
		}
	}
}