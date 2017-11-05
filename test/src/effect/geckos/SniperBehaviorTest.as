package effect.geckos
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import geckos.SniperBehavior;
	
	import test.BaseTest;
	
	public class SniperBehaviorTest extends BaseTest
	{
		private var sniperBehavior:SniperBehavior;
		private var sniperMC:SniperMC;
		
		public function SniperBehaviorTest(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			sniperMC = new SniperMC();
			this.addChild(sniperMC);
			this.sniperBehavior = new SniperBehavior(.03, .04, .3);
			this.sniperBehavior.addWaveView(sniperMC.mc);
			this.sniperBehavior.startWave();
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(event:MouseEvent):void 
		{
			this.sniperBehavior.shake(20, 20);
			//this.sniperBehavior.destroy();
			//this.sniperBehavior.removeWaveView(mc);
		}
		
	}
}