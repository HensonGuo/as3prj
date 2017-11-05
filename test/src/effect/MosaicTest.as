package effect
{
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.events.Event;
	
	import mosaic.Mosaic;
	
	import test.BaseTest;
	
	public class MosaicTest extends BaseTest
	{
		[Embed(source = "/../bin-debug/assets/yumao.png")] 
		private static const BG:Class;
		
		public function MosaicTest(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			var srcBitmap:Bitmap = new BG();
			this.addChild(srcBitmap);
			
			
			var myMoz:Mosaic = new Mosaic(srcBitmap);
			myMoz.x = srcBitmap.width / 2;
			myMoz.y = srcBitmap.height / 2;
			myMoz.pixelSize = 10;
			myMoz.render();
			addChild(myMoz);
		}
	}
}