package effect
{
	import flash.display.Stage;
	import flash.events.Event;
	
	import terafire.TeraFire;
	
	import test.BaseTest;
	
	public class TeraFireTest extends BaseTest
	{
		public function TeraFireTest(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			var fire:TeraFire = new TeraFire(300, 300, 200, 300);
			this.addChild(fire);
		}
	}
}