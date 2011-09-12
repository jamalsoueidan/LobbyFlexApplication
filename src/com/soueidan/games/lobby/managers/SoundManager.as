package com.soueidan.games.lobby.managers
{
	import flash.media.Sound;
	
	import mx.core.FlexGlobals;
	import mx.styles.CSSStyleDeclaration;

	public class SoundManager
	{
		[Embed(source="./assets/sounds/received_invitation.mp3")] 
		public static var soundClass:Class;
		
		public static function playRecievedInvitation():void {
			var myEmbeddedSound:Sound = new soundClass() as Sound;			
			myEmbeddedSound.play();		
		}
	}
}