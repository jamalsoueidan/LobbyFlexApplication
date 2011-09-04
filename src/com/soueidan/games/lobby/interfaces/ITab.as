package com.soueidan.games.lobby.interfaces
{
	import flash.display.IBitmapDrawable;
	
	import mx.core.IUIComponent;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;

	public interface ITab extends IVisualElement 
	{
		function show():void;
		function hide():void;
	}
}