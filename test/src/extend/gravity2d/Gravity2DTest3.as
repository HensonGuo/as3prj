package extend.gravity2d
{
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import gravity2d.Gravity2D;
	import gravity2d.GravityGroup2D;
	
	import test.BaseTest;
	
	public class Gravity2DTest3 extends BaseTest
	{
		public var gg1:GravityGroup2D;
		
		public function Gravity2DTest3(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			stage.quality = StageQuality.MEDIUM;
			
			var mc:mcMan = new mcMan();
			mc.x = 300;
			mc.y = 250;
			addChild(mc);
			
			var gv:Gravity2D = new Gravity2D();
			
			gg1 = new GravityGroup2D(mc, gv);
			
			gg1.createAllJoints();
			
			gg1.setJointLimit("body", "head", -10, 10);
			gg1.setJointLimit("body", "armL0",  -70,  70);
			gg1.setJointLimit("body", "armR0",  -70,  70);
			gg1.setJointLimit("armL1", "armL0",  -50,  50);
			gg1.setJointLimit("armR1", "armR0",  -50,  50);
			gg1.setJointLimit("body", "legL0",   20, 60);
			gg1.setJointLimit("body", "legR0", -60,  -20);
			gg1.setJointLimit("legL1", "legL0",  -50,  0);
			gg1.setJointLimit("legR1", "legR0",    0, 50);
			
			var t:Timer = new Timer(1000);
			t.addEventListener(TimerEvent.TIMER, eTimer);
			t.start();
		}
		
		public var direct:int = 1;
		public function eTimer(e:TimerEvent):void {
			
			gg1.wakeupAll();
			
			direct *= -1;
			gg1.setJointMotor("legR0", "body", -1 * direct, 1000, false);
			gg1.setJointMotor("legL0", "body",  1 * direct, 1000, false);
			gg1.setJointMotor("armR0", "body", -2 * direct, 1000, false);
			gg1.setJointMotor("armL0", "body",  2 * direct, 1000, false);
			gg1.setJointMotor("armR0", "armR1", 1 * direct, 1000, false);
			gg1.setJointMotor("armL0", "armL1", 1 * direct, 1000, false);
			gg1.setJointMotor("legR0", "legR1",  1 * direct, 1000, false);
			gg1.setJointMotor("legL0", "legL1", -1 * direct, 1000, false);
			
		}
	}
}