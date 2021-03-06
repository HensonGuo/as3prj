package effect.geckos
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import geckos.ChainEffect;
	
	import test.BaseTest;
	
	public class ChainEffectTest extends BaseTest
	{
		private var chainEffect:ChainEffect;
		private var angle:Number;
		private var targetPoint:Point;
		private var r:Number;
		
		public function ChainEffectTest(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			var scene:Sprite = new Sprite();
			scene.filters = [new GlowFilter(0x00CCFF, 1, 10, 10, 2, 1, false, false)];
			this.addChild(scene)
			this.chainEffect = new ChainEffect(scene);
			this.chainEffect.move(mouseX, mouseY);
			//this.chainEffect.lineColor = 0xFF00FF;
			//this.chainEffect.lineSize = 20;
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		private function keyDownHandler(event:KeyboardEvent):void 
		{
			this.chainEffect.clear();
		}
		
		private function enterFrameHandler(event:Event):void 
		{
			this.chainEffect.update(mouseX, mouseY);
		}
	}
}