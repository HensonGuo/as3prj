package test.performance.one_timer_v_many_timer
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import test.ITest;
	
	import utils.debug.Profile;
	
	public class OneTimerVManyTimer implements ITest
	{
		public function OneTimerVManyTimer()
		{
		}
		
		public function test(stage:Stage):void
		{
			Profile.init(AnimeTest.rootContainer,1);
			
			var n:int = 10000;
			var i:int;
			/*
			for(i=0;i<n;i++){
			this["t_"+i] = new Timer(50,0);
			this["t_"+i].addEventListener(TimerEvent.TIMER,timerF);
			this["t_"+i].start();
			}
			*/
			for(i=0;i<n;i++){
				var mc:MovieClip = new MovieClip();
				mc.t = new Timer(50,0);
				mc.t.addEventListener(TimerEvent.TIMER,timerF);
				mc.t.start();
			}
		}
		
		private function timerF(e:TimerEvent):void{
			
		}
	}
}