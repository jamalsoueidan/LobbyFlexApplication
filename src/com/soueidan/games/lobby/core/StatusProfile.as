package com.soueidan.games.lobby.core
{
	import com.soueidan.games.lobby.managers.ResourceManager;
	
	import mx.collections.ArrayCollection;

	public class StatusProfile
	{
		public static function getList():ArrayCollection {
			var list:ArrayCollection = new ArrayCollection();
			list.addItem({id:0, label:ResourceManager.getString("status.ready")});
			list.addItem({id:1, label:ResourceManager.getString("status.disturb")});
			return list;
		}
		
		public static function get readyToPlay():int {
			return 0;
		}
		public static function get doNotDistrub():int {
			return 1;
		}
		
		
		
	}
}