package test.performance.bitwise_arithmetic
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import test.BaseTest;
	
	public class Modulo extends BaseTest
	{
		public function Modulo()
		{
		}
		
		override protected function onAdded(event:Event):void
		{
			// small benefit using bitwise operation vs modulo
			var p:int = 37;
			
			var i:int;
			var n:int = 10000000;
			var startTime:int;
			
			/*
			startTime = getTimer()
			// 556
			for(i=38;i<n;i++){
			if(i%p==0){
			}
			}
			trace("modulo duration",getTimer()-startTime);
			*/
			
			/*
			startTime = getTimer()
			//445
			var p_1:int = p-1;
			for(i=38;i<n;i++){
			if((i&(p_1))==0){
			}
			}
			trace("bitwise duration",getTimer()-startTime);
			*/
			
			///*
			//445
			for(i=38;i<n;i++){
				if((i&(p-1))==0){
				}
			}
			trace("bitwise duration",getTimer()-startTime);
			//*/

		}
	}
}