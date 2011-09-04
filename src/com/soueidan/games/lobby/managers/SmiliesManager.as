package com.soueidan.games.lobby.managers
{
	public class SmiliesManager
	{
		public static function convert(value:String):String {
			value = replace(value, ":D", "<img source='/images/smilies/035.png' width='16' height='16' alt='smilie' />");
			value = replace(value, ":)", "<img source='/images/smilies/036.png' width='16' height='16' alt='smilie' />");
			value = replace(value, ":|", "<img source='/images/smilies/037.png' width='16' height='16' alt='smilie' />");
			value = replace(value, ":I", "<img source='/images/smilies/037.png' width='16' height='16' alt='smilie' />");
			value = replace(value, ":(", "<img source='/images/smilies/038.png' width='16' height='16' alt='smilie' />");
			value = replace(value, ":o", "<img source='/images/smilies/039.png' width='16' height='16' alt='smilie' />");
			value = replace(value, ":O", "<img source='/images/smilies/039.png' width='16' height='16' alt='smilie' />");
			value = replace(value, ":p", "<img source='/images/smilies/040.png' width='16' height='16' alt='smilie' />");
			value = replace(value, ":P", "<img source='/images/smilies/040.png' width='16' height='16' alt='smilie' />");
			return value;
		}
		
		private static function replace(str:String, fnd:String, rpl:String):String{
			return str.split(fnd).join(rpl);
		}
	}
}