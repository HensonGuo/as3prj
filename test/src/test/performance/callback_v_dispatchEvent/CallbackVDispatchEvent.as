package test.performance.callback_v_dispatchEvent
{
	import flash.display.Stage;
	import flash.events.Event;
	
	import test.ITest;
	
	import utils.debug.Profile;
	
	public class CallbackVDispatchEvent implements ITest
	{
		public function CallbackVDispatchEvent()
		{
		}
		
		public function test(stage:Stage):void
		{
			Profile.init(AnimeTest.rootContainer,2);
			
			// check the last frame of the library symbol mc.
			
			// fps 24, memory 106.5mb with dispatchEvent, one event per mc but not able to be gc'd
			// fps 26, memory 102.5mb with dispatchEvent, many events but all available for gc
			// fps 35, memory 93.75mb with callback
			
			var num:int = 100000;
			var i:int;
			var mc:McTest;
			var a:Array = [];
			
			for(i=0;i<num;i++){
				mc = new McTest();
				mc.addEventListener("testE",completeF);
				// prevent mc from being gc'd
				a[i] = mc;
				/*
				mc.callback=function():void{
				}
				*/
			}
			
			function completeF(e:Event):void{
			}
			
		}
	}
}