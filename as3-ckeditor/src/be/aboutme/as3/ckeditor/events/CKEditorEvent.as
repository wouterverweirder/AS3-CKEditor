package be.aboutme.as3.ckeditor.events
{
	import flash.events.Event;

	public class CKEditorEvent extends Event
	{
		
		public static const INSTANCE_READY:String = "instanceReady";
		public static const HTML_TEXT_CHANGED:String = "htmlTextChanged";
		
		public function CKEditorEvent(type:String)
		{
			super(type);
		}
		
	}
}