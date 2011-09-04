package com.soueidan.games.lobby.managers
{
	public class SmiliesManager
	{
		public static function convert(value:String):String {
			value = replace(value, ":D", "<img source='assets/smilies/035.png' width='16' height='16' alt='smilie' />");
			value = replace(value, ":)", "<img source='assets/smilies/036.png' width='16' height='16' alt='smilie' />");
			value = replace(value, ":|", "<img source='assets/smilies/037.png' width='16' height='16' alt='smilie' />");
			value = replace(value, ":I", "<img source='assets/smilies/037.png' width='16' height='16' alt='smilie' />");
			value = replace(value, ":(", "<img source='assets/smilies/038.png' width='16' height='16' alt='smilie' />");
			value = replace(value, ":o", "<img source='assets/smilies/039.png' width='16' height='16' alt='smilie' />");
			value = replace(value, ":O", "<img source='assets/smilies/039.png' width='16' height='16' alt='smilie' />");
			value = replace(value, ":p", "<img source='assets/smilies/040.png' width='16' height='16' alt='smilie' />");
			value = replace(value, ":P", "<img source='assets/smilies/040.png' width='16' height='16' alt='smilie' />");
			return value;
		}
		
		private static function replace(str:String, fnd:String, rpl:String):String{
			return str.split(fnd).join(rpl);
		}
	}
}