package effect.geckos
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import geckos.TextEffect;
	
	import test.BaseTest;
	
	public class TextEffectTest extends BaseTest
	{
		private var textEffect:TextEffect;
		private var text:TextField;
		
		public function TextEffectTest(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			this.text = this.getChildByName("txt") as TextField;
			this.textEffect = new TextEffect();
			this.textEffect.progressShow(this.text, "asdasdasdqe12sdqwasd啊吴涤清我的阿斯达阿斯顿请问阿斯达", 10);
			stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
		}
		
		private function stageClickHandler(event:MouseEvent):void 
		{
			this.textEffect.destroy();
		}
	}
}