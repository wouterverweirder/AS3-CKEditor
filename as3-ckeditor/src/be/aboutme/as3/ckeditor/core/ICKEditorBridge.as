package be.aboutme.as3.ckeditor.core
{
	import flash.events.IEventDispatcher;
	
	public interface ICKEditorBridge extends IEventDispatcher
	{
		function setData(data:String):void;
		function getData():String;
		function setSize(width:Number, height:Number):void;
	}
}