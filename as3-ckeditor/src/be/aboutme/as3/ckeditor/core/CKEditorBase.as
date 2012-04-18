package be.aboutme.as3.ckeditor.core
{
	import be.aboutme.as3.ckeditor.events.CKEditorEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.UIComponent;

	public class CKEditorBase extends UIComponent
	{
		
		//bridge implementation
		protected var bridge:ICKEditorBridge;
		
		protected var _htmlText:String;
		public function get htmlText():String
		{
			return _htmlText;
		}
		public function set htmlText(value:String):void
		{
			_htmlText = value;
			if(bridge != null) bridge.setData(value);
			dispatchEvent(new CKEditorEvent(CKEditorEvent.HTML_TEXT_CHANGED));
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			if(bridge)
			{
				bridge.addEventListener(CKEditorEvent.HTML_TEXT_CHANGED, htmlTextChangedHandler);
				bridge.addEventListener(CKEditorEvent.INSTANCE_READY, instanceReadyHandler);
				addChild(bridge as DisplayObject);
			}
		}
		
		private function htmlTextChangedHandler(event:Event):void
		{
			_htmlText = bridge.getData();
			dispatchEvent(new CKEditorEvent(CKEditorEvent.HTML_TEXT_CHANGED));
		}
		
		private function instanceReadyHandler(event:CKEditorEvent):void
		{
			bridge.setData(_htmlText);
			dispatchEvent(new CKEditorEvent(CKEditorEvent.INSTANCE_READY));
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(bridge)
			{
				bridge.setSize(unscaledWidth, unscaledHeight);
			}
		}
		
	}
}