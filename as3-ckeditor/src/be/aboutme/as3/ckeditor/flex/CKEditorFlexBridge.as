package be.aboutme.as3.ckeditor.flex
{
	import be.aboutme.as3.ckeditor.core.ICKEditorBridge;
	import be.aboutme.as3.ckeditor.events.CKEditorEvent;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;
	import uk.co.netthreads.IFrame;
	
	public class CKEditorFlexBridge extends IFrame implements ICKEditorBridge
	{
		
		private var _data:String;
		
		private var readyToReplaceEditor:Boolean;
		private var jsLoaded:Boolean;
		private var instanceReady:Boolean;
		private var checkDirtyTimer:Timer;
		
		public function CKEditorFlexBridge()
		{
			super();
			//force an id, otherwise onload callback won't work
			this.id = "ck";
			this.debug = false;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			//CKEDITOR library injection
			ExternalInterface.call("document.insertScript = function ()" +
			"{ " +
				"if (document.ckEditorInjectScript==null)" +
				"{" +
					"ckEditorInjectScript = function (frameId)" +
					"{" +
						"if(!window.AS3CKEDITOR) window.AS3CKEDITOR = {};" +
						"if(!window.AS3CKEDITOR.frameIds) window.AS3CKEDITOR.frameIds = [];" +
						"window.AS3CKEDITOR.frameIds.push(frameId);" +
						"if(!window.AS3CKEDITOR.checkApiStatus) window.AS3CKEDITOR.checkApiStatus = function()" +
						"{" +
							"if(window.CKEDITOR && window.CKEDITOR.status && window.CKEDITOR.status != 'unloaded')" +
							"{" +
								"clearInterval(window.AS3CKEDITOR.apiPollingId);" +
								"var swf = document.getElementById(\""+FlexGlobals.topLevelApplication.id + "\");" +
								"for(var i = 0; i < window.AS3CKEDITOR.frameIds.length; i++)" +
								"{" +
									"swf[\"editor\" + window.AS3CKEDITOR.frameIds[i] + \"OnJSLoaded\"]();" +
								"}" +
							"}" +
						"};" +
						"if(!window.CKEDITOR && !window.AS3CKEDITOR.hasInjectedScript)" +
						"{" +
							"window.AS3CKEDITOR.hasInjectedScript = true;" +
							"var headTag = document.getElementsByTagName('head').item(0);" +
							"var scriptTag = document.createElement('script');" +
							"scriptTag.type = 'text/javascript';" +
							"scriptTag.src = 'js/ckeditor/ckeditor.js';" +
							"headTag.appendChild(scriptTag);" +
						"}" +
						"if(!window.AS3CKEDITOR.apiPollingId)" +
						"{" +
							"window.AS3CKEDITOR.apiPollingId = setInterval(window.AS3CKEDITOR.checkApiStatus, 200);" +
						"}" +
					"};" +
				"}" +
			"}");
			
			ExternalInterface.call("document.insertScript = function ()" +
        	"{ " +
	            "if (document.ckEditorReplace==null)" +
	            "{" +
	                "ckEditorReplace = function (frameId)" +
                    "{" +
						"document[\"editorInstance\" + frameId] = CKEDITOR.replace(\"editor\" + frameId);" + 
                    	"document[\"editorInstance\" + frameId].on(\"instanceReady\"," + 
                    	"function(evt)" + 
                    	"{" + 
                    		"document.getElementById(\"cke_\" + evt.editor.name).style.padding = 0;" + 
                    		"var swf = document.getElementById(\""+FlexGlobals.topLevelApplication.id + "\");" + 
                    		"swf[\"editor\" + frameId + \"OnInstanceReady\"]();" +  
                    	"});" +
                    "};" +
                "}" +
            "}");
            
            ExternalInterface.call("document.insertScript = function ()" +
        	"{ " +
	            "if (document.ckEditorChangeSize==null)" +
	            "{" +
	                "ckEditorChangeSize = function (frameId, width, height)" +
                    "{" + 
                    	"document[\"editorInstance\" + frameId].resize(width, height);" + 
                    "}" +
                "}" +
            "}");
            
            ExternalInterface.call("document.insertScript = function ()" +
        	"{ " +
	            "if (document.ckEditorSetData==null)" +
	            "{" +
	                "ckEditorSetData = function (frameId, data)" +
                    "{" + 
                    	"document[\"editorInstance\" + frameId].setData(data);" + 
                    "}" +
                "}" +
            "}");
            
            ExternalInterface.call("document.insertScript = function ()" +
        	"{ " +
	            "if (document.ckEditorGetData==null)" +
	            "{" +
	                "ckEditorGetData = function (frameId)" +
                    "{" + 
                    	"return document[\"editorInstance\" + frameId].getData();" + 
                    "}" +
                "}" +
            "}");
            
            content = "<textarea id=\"editor" + frameId + "\"></textarea>";
            
            //add callbacks
			ExternalInterface.addCallback('editor' + frameId + "OnJSLoaded", onJSLoaded);
            ExternalInterface.addCallback('editor' + frameId + "OnInstanceReady", onInstanceReady);
			
			//inject required js file into DOM
			ExternalInterface.call("ckEditorInjectScript", frameId);
			readyToReplaceEditor = true;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(jsLoaded && readyToReplaceEditor)
			{
				readyToReplaceEditor = false;
				ExternalInterface.call("ckEditorReplace", frameId);
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(instanceReady)
			{
				ExternalInterface.call("ckEditorChangeSize", frameId, unscaledWidth, unscaledHeight);
			}
		}
		
		private function onJSLoaded():void
		{
			jsLoaded = true;
			invalidateProperties();
		}
		
		private function onInstanceReady():void
		{
			instanceReady = true;
			invalidateDisplayList();
			
			checkDirtyTimer = new Timer(100);
			checkDirtyTimer.addEventListener(TimerEvent.TIMER, checkDirtyHandler);
			checkDirtyTimer.start();
			
			dispatchEvent(new CKEditorEvent(CKEditorEvent.INSTANCE_READY));
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
			ExternalInterface.call("ckEditorSetData", frameId, data);
		}
		
		public function getData():String
		{
			return ExternalInterface.call("ckEditorGetData", frameId);
		}
		
		public function setSize(width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;
		}
	}
}