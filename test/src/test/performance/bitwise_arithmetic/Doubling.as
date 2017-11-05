package test.performance.bitwise_arithmetic
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import test.BaseTest;
	
	
	public class Doubling extends BaseTest
	{
		public function Doubling()
		{
		}
		
		override protected function onAdded(event:Event):void
		{
			var xx:int;
			
			var n:int = 10000000;
			var i:int;
			var startTime:int;
			
			///*
			startTime =  getTimer();
			// 414
			for(i=0;i<n;i++){
				xx = i*2;
			}
			trace("arithmetic duration",getTimer()-startTime);
			//*/
			
			///*
			startTime = getTimer();
			// 413
			for(i=0;i<n;i++){
				xx = i<<1;
			}
			trace("bitwise duration",getTimer()-startTime);
		}
	}
}