package test.performance.bitwise_arithmetic
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import test.BaseTest;
	
	public class Halving extends BaseTest
	{
		public function Halving()
		{
		}
		
		override protected function onAdded(event:Event):void
		{
			// no significant benefit using bitwise operation vs division
			var xx:Number;
			
			var n:int = 10000000;
			var i:int;
			var startTime:int;
			
			///*
			startTime = getTimer()
			// 425
			for(i=0;i<n;i++){
				xx = i/2;
			}
			trace("division duration",getTimer()-startTime);
			//*/
			
			///*
			startTime = getTimer()
			// 422
			for(i=0;i<n;i++){
				xx = i*.5;
			}
			trace("multiplication duration",getTimer()-startTime);
			//*/
			
			///*
			startTime = getTimer()
			// 420
			for(i=0;i<n;i++){
				xx = i>>1;
			}
			trace("bitwise duration",getTimer()-startTime);
			//*/
		}
	}
}