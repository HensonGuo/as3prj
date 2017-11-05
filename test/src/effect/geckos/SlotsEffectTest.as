package effect.geckos
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import geckos.SlotsEffect;
	
	import test.BaseTest;
	
	public class SlotsEffectTest extends BaseTest
	{
		private var slotsEffect:SlotsEffect;
		private var mc:SlotMC;
		
		public function SlotsEffectTest(stage:Stage)
		{
			mc = new SlotMC();
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			this.addChild(mc);
			this.slotsEffect = new SlotsEffect(10, 15, 2, 50);
			this.slotsEffect.push(selectMc);
			this.stopAllMc();
			this.selectMc();
			
			mc.btn1.addEventListener(MouseEvent.CLICK, btn1ClickHandler);
			mc.btn2.addEventListener(MouseEvent.CLICK, btn2ClickHandler);
		}
		
		private function btn2ClickHandler(event:MouseEvent):void 
		{
			this.slotsEffect.splice(randomSelect);
			this.slotsEffect.push(selectMc);
			this.slotsEffect.show(int(Math.random() * 15 + 1), true);
		}
		
		private function btn1ClickHandler(event:MouseEvent):void 
		{
			this.slotsEffect.splice(selectMc);
			this.slotsEffect.push(randomSelect);
			this.slotsEffect.show(int(Math.random() * 15 + 1), true);
		}
		
		
		private function clickHandler(event:MouseEvent):void 
		{
			
		}
		
		/**
		 * 选中某个mc
		 * @param	mc
		 */
		private function selectMc():void
		{
			this.stopAllMc();
			var mc:MovieClip = mc.getChildByName("b" + this.slotsEffect.curIndex) as MovieClip;
			mc.nextFrame();
		}
		
		private function randomSelect():void
		{
			this.stopAllMc();
			var mc:MovieClip = mc.getChildByName("b" + this.slotsEffect.randomIndex) as MovieClip;
			mc.nextFrame();
		}
		
		private function stopAllMc():void
		{
			var ab:MovieClip;
			for (var i:int = 1; mc.getChildByName("b" + i); i++) 
			{
				ab = mc.getChildByName("b" + i) as MovieClip;
				ab.gotoAndStop(1);
			}
		}
		
		private function keyDownHandler(event:KeyboardEvent):void 
		{
			this.slotsEffect.destroy();
		}
	}
}