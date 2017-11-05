package test.performance.starling.starlingTest1
{
	import flash.display.Stage;
	import flash.system.ApplicationDomain;
	
	import starling.core.Starling;
	
	import test.ITest;
	
	public class MT_Starling_Test_1 implements ITest
	{
		private var starlingInst:Starling;
		
		public function MT_Starling_Test_1()
		{
		}
		
		public function test(stage:Stage):void
		{
			// Check for Flash Player 11
			if (ApplicationDomain.currentDomain.hasDefinition("flash.display.Stage3D")){
				// It's present so we can use Stage3D and Starling
				startF(stage);
				// I created a stop/start button to stop and start the game
				//stopstartButtonF();
			} else {
				// start fallback code
			}
		}
		
		private function startF(stage:Stage):void{
			// I ran into this problem while trying to profile this test
			Starling.handleLostContext = true;
			// Create Starling instance
			starlingInst = new Starling(MT_Starling_Test_1_Game, stage);
			// Startling has a built-in frame rate display.
			starlingInst.showStats = true;
			// set anti-aliasing (higher is better quality but slower performance)
			starlingInst.antiAliasing=0;
			//starlingInst.enableErrorChecking = true;
			// Start the Starling instance
			starlingInst.start();
		}
	}
}