package test.performance.arry_v_vector
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import test.BaseTest;
	
	public class ArrayVVectorArithmetic  extends BaseTest
	{
		public function ArrayVVectorArithmetic()
		{
		}
		
		override protected function onAdded(event:Event):void
		{
			// small benefit of vectors over arrays confirmed.
			var n:int = 1000000;
			var i:int;
			var startTime:int;
			var sum:Number;
			///*
			// array test
			startTime = getTimer();
			var a:Array = new Array(n);
			for(i=0;i<n;i++){
				a[i] = int(Math.random()*n);
			}
			sum = 0;
			for(i=0;i<n;i++){
				sum+=a[i];
			}
			trace("array test duration:",getTimer()-startTime,"|| ave = ",int(sum/n),": ave predicted = ",n/2);
			// output: array test: 366 || ave =  500049 : ave predicted =  500000
			
			//*/
			
			///*
			// vector test
			
			startTime = getTimer();
			var pool:Vector.<int> = new Vector.<int>(n);
			for(i=0;i<n;i++){
				pool[i] = int(Math.random()*n);
			}
			sum = 0
			for(i=0;i<n;i++){
				sum+=pool[i];
			}
			trace("vector test duration:",getTimer()-startTime,"|| ave = ",int(sum/n),": ave predicted = ",n/2);
			// output: vector test: 168 || ave =  499695 : ave predicted =  500000
			//*/
		}
	}
}