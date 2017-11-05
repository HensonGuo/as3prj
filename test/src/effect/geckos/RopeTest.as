package effect.geckos
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import geckos.Rope;
	
	import test.BaseTest;
	
	import utils.DrawUtils;
	
	public class RopeTest extends BaseTest
	{
		private var rope:Rope;
		private var sp:Point;
		private var ep:Point;
		private var curMc:Sprite;
		
		private var mc1:Sprite;
		private var mc2:Sprite;
		
		public function RopeTest(stage:Stage)
		{
			mc1 = new Sprite();
			mc2 = new Sprite();
			DrawUtils.drawBg(mc1, 100, 100);
			DrawUtils.drawBg(mc2, 100, 100);
			mc1.x = 100; mc1.y = 100;
			mc2.x = 400; mc2.y = 100;
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			this.addChild(mc1);
			this.addChild(mc2);
			this.sp = new Point(mc1.x, mc1.y);
			this.ep = new Point(mc2.x, mc2.y);
			this.rope = new Rope(this.sp, this.ep);
			this.addEventListener(Event.ENTER_FRAME, loop);
			mc1.addEventListener(MouseEvent.MOUSE_DOWN, mcMouseDown);
			mc2.addEventListener(MouseEvent.MOUSE_DOWN, mcMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, mcMouseUp);
		}
		
		private function mcMouseUp(event:MouseEvent):void 
		{
			this.curMc.stopDrag();
		}
		
		private function mcMouseDown(event:MouseEvent):void 
		{
			var mc:Sprite = event.currentTarget as Sprite;
			mc.startDrag();
			this.curMc = mc;
		}
		
		private function loop(event:Event):void 
		{
			this.sp.x = mc1.x;
			this.sp.y = mc1.y;
			this.ep.x = mc2.x;
			this.ep.y = mc2.y;
			this.rope.update();
			this.rope.render(this.graphics, 3, 0x00F0FF);
		}
	}
}