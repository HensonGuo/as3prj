package test.motionbase
{
	import fl.motion.AnimatorFactory;
	import fl.motion.MotionBase;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	
	import test.BaseTest;
	
	public class MotionTest extends BaseTest
	{
		private var motionBase:MotionBase;
		private var animFactory:AnimatorFactory;
		private var size:uint    = 100;
		private var bgColor:uint = 0xFFCC00;
		
		public function MotionTest(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			var boxObj:Sprite = new Sprite();
			boxObj.graphics.beginFill(bgColor);
			boxObj.graphics.drawRect(0, 0, size, size);
			boxObj.graphics.endFill();
			_stage.addChild(boxObj);
			
			motionBase = new MotionBase();
			motionBase.duration = 20;
			motionBase.addPropertyArray("x",[0,50,95,134,169,199,225,247,265,280]);
			motionBase.addPropertyArray("y",[0,1,0,4,12,21,32,44,52,38]);
			animFactory = new AnimatorFactory(motionBase);
			animFactory.transformationPoint = new Point(2, 2);
			animFactory.addTarget(boxObj, 10);
		}
		
	}
}