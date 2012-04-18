package be.aboutme.as3.ckeditor
{
	import be.aboutme.as3.ckeditor.air.CKEditorAir;
	import be.aboutme.as3.ckeditor.core.CKEditorBase;
	import be.aboutme.as3.ckeditor.core.CKEditorDesignMode;
	import be.aboutme.as3.ckeditor.events.CKEditorEvent;
	import be.aboutme.as3.ckeditor.flex.CKEditorFlex;
	
	import flash.system.Capabilities;
	
	import mx.core.UIComponent;
	import mx.core.UIComponentGlobals;

	public class CKEditor extends UIComponent
	{
		
		private var htmlTextChanged:Boolean;
		private var _htmlText:String;
		[Bindable(event="htmlTextChanged")]
		public function get htmlText():String
		{
			return _htmlText;
		}
		public function set htmlText(value:String):void
		{
			_htmlText = value;
			htmlTextChanged = true;
			invalidateProperties();
		}
		
		private var editorImplementation:CKEditorBase;
		
		public function CKEditor()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			if(UIComponentGlobals.designMode)
			{
				editorImplementation = new CKEditorDesignMode();
			}
			else
			{
				if(Capabilities.playerType == "Desktop")
				{
					editorImplementation = new CKEditorAir();
				}
				else
				{
					editorImplementation = new CKEditorFlex();
				}
			}
			editorImplementation.addEventListener(CKEditorEvent.HTML_TEXT_CHANGED, htmlTextChangedHandler);
			addChild(editorImplementation);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(editorImplementation != null)
			{
				if(htmlTextChanged)
				{
					htmlTextChanged = false;
					editorImplementation.htmlText = _htmlText;
				}
			}
		}
		
		private function htmlTextChangedHandler(event:CKEditorEvent):void
		{
			_htmlText = editorImplementation.htmlText;
			dispatchEvent(new CKEditorEvent(CKEditorEvent.HTML_TEXT_CHANGED)); 
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			editorImplementation.width = unscaledWidth;
			editorImplementation.height = unscaledHeight;
		}
		
	}
}