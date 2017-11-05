package extend.gravity2d
{
	import flash.display.Stage;
	import flash.events.Event;
	
	import gravity2d.Gravity2D;
	import gravity2d.GravityObject2D;
	
	import test.BaseTest;
	
	public class Gravity2DTest1 extends BaseTest
	{
		public function Gravity2DTest1(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			var mc1:mcSquare = new mcSquare();
			var mc2:mcSquare = new mcSquare();
			var mc3:mcCircle = new mcCircle();
			
			mc1.x = mc1.y = 50;
			mc2.x = mc2.y = 100;
			mc3.x = mc3.y = 150;
			
			addChild(mc1);
			addChild(mc2);
			addChild(mc3);
			
			var gv:Gravity2D = new Gravity2D();
			
			var go1:GravityObject2D = new GravityObject2D(mc1, gv);
			var go2:GravityObject2D = new GravityObject2D(mc2, gv);
			var go3:GravityObject2D = new GravityObject2D(mc3, gv);
			
			gv.start();
		}
	}
}