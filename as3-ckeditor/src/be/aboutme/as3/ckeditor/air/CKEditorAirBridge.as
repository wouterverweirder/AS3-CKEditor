package be.aboutme.as3.ckeditor.air
{
	import be.aboutme.as3.ckeditor.core.ICKEditorBridge;
	import be.aboutme.as3.ckeditor.events.CKEditorEvent;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import mx.controls.HTML;
	import mx.core.UIComponent;

	public class CKEditorAirBridge extends UIComponent implements ICKEditorBridge
	{
		private var _data:String;
		
		private var html:HTML;
		private var jsEditor:*;
		private var checkDirtyTimer:Timer;
		
		public function CKEditorAirBridge()
		{
		}
		
		override protected function createChildren():void
		{
			var htmlClass:Class = getDefinitionByName("mx.controls.HTML") as Class;
			if(htmlClass != null)
			{
				html = new htmlClass();
				html.addEventListener(Event.COMPLETE, htmlCompleteHandler);
				addChild(html);
				html.htmlLoader.placeLoadStringContentInApplicationSandbox = true;
				html.htmlText = "<html>" + 
					"<head>" + 
					"<title>CKEditor</title>" + 
					"<script type=\"text/javascript\" src=\"js/ckeditor/ckeditor.js\"></script>" + 
					"</head>" + 
					"<body>" + 
					"<textarea id=\"editorArea\"></textarea>" +
					"<script type='text/javascript'>window.editor = CKEDITOR.replace(\"editorArea\");</script>" + 
					"</body>" + 
					"</html>";
			}
			
			super.createChildren();
		}
		
		private function htmlCompleteHandler(event:Event):void
		{
			jsEditor = html.domWindow.editor;
			if(jsEditor != null)
			{
				jsEditor.on('instanceReady', function(evt:Object):void {
					invalidateDisplayList();
					
					checkDirtyTimer = new Timer(100);
					checkDirtyTimer.addEventListener(TimerEvent.TIMER, checkDirtyHandler);
					checkDirtyTimer.start();
					
					dispatchEvent(new CKEditorEvent(CKEditorEvent.INSTANCE_READY));
				});
			}
		}
		
		private function checkDirtyHandler(event:Event):void
		{
			var data:String = getData();
			if(data != _data)
			{
				_data = data;
				dispatchEvent(new CKEditorEvent(CKEditorEvent.HTML_TEXT_CHANGED));
			}
		}
		
		public function setData(data:String):void
		{
			_data = data;
			if(jsEditor != null)
			{
				jsEditor.setData(data);
			}
		}
		
		public function getData():String
		{
			if(jsEditor != null)
			{
				return jsEditor.getData();
			}
			return null;
		}
		
		public function setSize(width:Number, height:Number):void
		{
			html.width = width;
			html.height = height;
			if(jsEditor != null)
			{
				jsEditor.resize('100%', height);
			}
		}
	}
}