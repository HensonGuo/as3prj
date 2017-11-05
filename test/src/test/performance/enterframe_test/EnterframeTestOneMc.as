package test.performance.enterframe_test
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	
	import test.ITest;
	
	import utils.debug.Profile;
	
	public class EnterframeTestOneMc implements ITest
	{
		public function EnterframeTestOneMc()
		{
		}
		
		public function test(stage:Stage):void
		{
			Profile.init(AnimeTest.rootContainer.stage,2, true);
			
			var mc:MovieClip = new MovieClip();
			var n:int = 100000;
			var functionA:Array = [];
			var i:int;
			
			for(i=n-1;i>=0;i--){
				mc["f_"+i] = function():void{
				}
				functionA[i] = 	mc["f_"+i];
			}
			
			// test 1: one enterframe loop, array of function references.
			// FPS: 54 || Memory Use: 31.18  MB
			mc.addEventListener(Event.ENTER_FRAME,masterF);
			function masterF(e:Event):void{
				for(i=n-1;i>=0;i--){
					functionA[i]();
				}
			}
			
			/*
			// test 2: many enterframe loops, array of function references.
			// FPS: 33 || Memory Use: 36.3  MB
			for(i=n-1;i>=0;i--){
			mc.addEventListener(Event.ENTER_FRAME,functionA[i]);
			}
			*/
			
			/*
			// test 3: one enterframe loop.
			// FPS: 7 || Memory Use: 31.27  MB
			mc.addEventListener(Event.ENTER_FRAME,masterF);
			function masterF(e:Event):void{
			for(i=n-1;i>=0;i--){
			this["f_"+i]();
			}
			}
			*/
			
			/*
			// test 4: many enterframe loops.
			// FPS: 33 || Memory Use: 36.3  MB
			for(i=n-1;i>=0;i--){
			mc.addEventListener(Event.ENTER_FRAME,this["f_"+i]);
			}
			*/
		}
	}
}