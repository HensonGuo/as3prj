package test.performance.starling.starlingTest2
{
	import flash.display.Stage;
	
	import starling.core.Starling;
	
	import test.ITest;
	
	public class MT_Starling_Test_2 implements ITest
	{
		private var _starling:Starling;
		
		public function MT_Starling_Test_2()
		{
		}
		
		public function test(stage:Stage):void
		{
			Starling.handleLostContext = true;
			// Create Starling instance
			_starling = new Starling(MT_Starling_Test_2_Game, stage);
			// Startling has a built-in frame rate display.
			_starling.showStats = true;
			_starling.start();
			_starling.enableErrorChecking = true;
		}
	}
}