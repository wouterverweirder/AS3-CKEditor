package be.aboutme.as3.ckeditor.air
{
	import be.aboutme.as3.ckeditor.core.CKEditorBase;

	public class CKEditorAir extends CKEditorBase
	{
		
		public function CKEditorAir()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			bridge = new CKEditorAirBridge();
			super.createChildren();
		}
		
	}
}