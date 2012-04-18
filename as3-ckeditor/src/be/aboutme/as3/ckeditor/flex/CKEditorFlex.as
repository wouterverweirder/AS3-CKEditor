package be.aboutme.as3.ckeditor.flex
{
	import be.aboutme.as3.ckeditor.core.CKEditorBase;

	public class CKEditorFlex extends CKEditorBase
	{
		
		public function CKEditorFlex()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			bridge = new CKEditorFlexBridge();
			super.createChildren();
		}
		
	}
}