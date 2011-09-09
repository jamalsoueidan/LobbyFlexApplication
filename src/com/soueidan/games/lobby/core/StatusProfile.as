package com.soueidan.games.lobby.core
{
	import com.soueidan.games.lobby.managers.ResourceManager;
	
	import mx.collections.ArrayCollection;

	public class StatusProfile
	{
		public static function getList():ArrayCollection {
			var list:ArrayCollection = new ArrayCollection();
			list.addItem({id:0, label:ResourceManager.getString("status.play")});
			list.addItem({id:1, label:ResourceManager.getString("status.chat")});
			list.addItem({id:2, label:ResourceManager.getString("status.away")});
			return list;
		}

		public static function get isAway():int {
			return 2;
		}
		
		public static function get isChat():int {
			return 1;
		}
		
		public static function get isPlay():int {
			return 0;
		}
		
	}
}