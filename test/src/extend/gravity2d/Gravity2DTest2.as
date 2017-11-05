package extend.gravity2d
{
	import flash.display.Stage;
	import flash.events.Event;
	
	import gravity2d.Gravity2D;
	import gravity2d.GravityGroup2D;
	
	import test.BaseTest;
	
	public class Gravity2DTest2 extends BaseTest
	{
		public function Gravity2DTest2(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			var mc:mcGroup = new mcGroup();
			addChild(mc);
			
			var gv:Gravity2D = new Gravity2D();
			var gg:GravityGroup2D = new GravityGroup2D(mc, gv);
		}
	}
}