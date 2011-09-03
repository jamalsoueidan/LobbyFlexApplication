package com.soueidan.games.lobby.core
{
	import mx.collections.ArrayCollection;

	public class StatusProfile
	{
		public static function getList():ArrayCollection {
			var list:ArrayCollection = new ArrayCollection();
			list.addItem({id:0, label:"Ready to play"});
			list.addItem({id:1, label:"Do not distrub"});
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