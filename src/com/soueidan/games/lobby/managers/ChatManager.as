package com.soueidan.games.lobby.managers
{
	import com.smartfoxserver.v2.entities.SFSUser;

	public class ChatManager
	{
		public static function convertSmilies(value:String, color:String):String {
			value = replace(value, ":D", '</span><img source="/images/smilies/035.png" width="16" height="16" alt="smilie" /><span  color="' + color + '">');
			value = replace(value, ":)", '</span><img source="/images/smilies/036.png" width="16" height="16" alt="smilie" /><span  color="' + color + '">');
			value = replace(value, ":|", '</span><img source="/images/smilies/037.png" width="16" height="16" alt="smilie" /><span  color="' + color + '">');
			value = replace(value, ":I", '</span><img source="/images/smilies/037.png" width="16" height="16" alt="smilie" /><span  color="' + color + '">');
			value = replace(value, ":(", '</span><img source="/images/smilies/038.png" width="16" height="16" alt="smilie" /><span  color="' + color + '">');
			value = replace(value, ":o", '</span><img source="/images/smilies/039.png" width="16" height="16" alt="smilie" /><span  color="' + color + '">');
			value = replace(value, ":O", '</span><img source="/images/smilies/039.png" width="16" height="16" alt="smilie" /><span  color="' + color + '">');
			value = replace(value, ":p", '</span><img source="/images/smilies/040.png" width="16" height="16" alt="smilie" /><span  color="' + color + '">');
			value = replace(value, ":P", '</span><img source="/images/smilies/040.png" width="16" height="16" alt="smilie" /><span  color="' + color + '">');
			value = replace(value, ":vip:", '</span><img source="/images/vip.png" width="10" height="10" alt="smilie" /><span  color="' + color + '">');
			return value;
		}
		
		private static function replace(str:String, fnd:String, rpl:String):String{
			return str.split(fnd).join(rpl);
		}
	}
}