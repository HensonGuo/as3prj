package effect
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import paintglow.PantsGlow;
	
	import test.BaseTest;
	
	public class PaintsGlowTest extends BaseTest
	{
		private var mOffscreenData:BitmapData;
		private var mOffscreenBitmap:Bitmap;
		
		public function PaintsGlowTest(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			stage.color = 0;
				
			mOffscreenData = new BitmapData(200, 80, true, 0);
			mOffscreenBitmap = new Bitmap(mOffscreenData);
			
			var t:TextField = new TextField();
			var fmt:TextFormat = new TextFormat();
			t.width = 220;
			fmt.size = 20;
			fmt.bold = true;
			fmt.font = "Arial Black";
			t.textColor = 0xffffff;
			t.defaultTextFormat = fmt;
			
			t.text = "Effect Test";
			
			mOffscreenData.draw(t);
			addChild(mOffscreenBitmap);
			
			mOffscreenBitmap.x = 85;
			mOffscreenBitmap.y = 70;
			
			var pg:PantsGlow = new PantsGlow(mOffscreenData);
			addChild(pg);
			pg.x = mOffscreenBitmap.x;
			pg.y = mOffscreenBitmap.y;
			
			pg.setTargetRect(0, 0, 200, 30);
			pg.setEffectCenter(87, 15);
			pg.effectWidth = 120;
			pg.sampling = 0.06;	
			pg.loopEnd = 90;
			
			pg.prepare();
		}
	}
}