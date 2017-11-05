package effect.geckos
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import geckos.OilPaintingEffect;
	
	import test.BaseTest;
	
	public class OilPaintingEffectTest extends BaseTest
	{
		private var oilPaintingEffect:OilPaintingEffect;
		private var isDown:Boolean;
		
		public function OilPaintingEffectTest(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			this.oilPaintingEffect = new OilPaintingEffect(this.graphics, 0);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function mouseUpHandler(event:MouseEvent):void 
		{
			this.isDown = false;
		}
		
		private function mouseMoveHandler(event:MouseEvent):void 
		{
			if (this.isDown)
				this.oilPaintingEffect.paintMove(mouseX, mouseY);
		}
		
		private function mouseDownHandler(event:MouseEvent):void 
		{
			this.isDown = true;
			this.oilPaintingEffect.color = Math.random() * 0xFFFFFF;
			this.oilPaintingEffect.clear();
		}
	}
}