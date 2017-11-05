package test.performance.arry_v_vector
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import test.BaseTest;
	
	public class ArrayVVectorMovieClips extends BaseTest
	{
		public function ArrayVVectorMovieClips()
		{
		}
		
		override protected function onAdded(event:Event):void
		{
			// small benefit of vectors over arrays confirmed
			import flash.display.MovieClip;
			
			var mc:MovieClip 
			var n:int = 100000;
			var i:int;
			var startTime:int;
			///*
			// array test
			startTime = getTimer();
			var a:Array = new Array(n);
			for(i=0;i<n;i++){
				a[i] = new MovieClip();
			}
			
			for(i=0;i<n;i++){
				mc = a.pop();
			}
			trace("array test duration:",getTimer()-startTime);
			// output: array test: 750
			//*/
			
			///*
			// vector test
			
			startTime = getTimer();
			var pool:Vector.<MovieClip> = new Vector.<MovieClip>(n);
			for(i=0;i<n;i++){
				pool[i] = new MovieClip();
			}
			
			for(i=0;i<n;i++){
				mc = pool.pop();
			}
			trace("vector test duration:",getTimer()-startTime);
			// output: vector test: 590
			//*/
		}
	}
}