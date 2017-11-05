package effect.geckos
{
	import com.bit101.components.PushButton;
	
	import flash.display.Stage;
	import flash.events.Event;
	
	import geckos.Tree;
	
	import test.BaseTest;
	
	public class TreeTest extends BaseTest
	{
		public function TreeTest(stage:Stage)
		{
			super(stage);
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		override protected function onAdded(event:Event):void
		{
			var btn:com.bit101.components.PushButton = new PushButton(this, this.stage.stageWidth - 100, this.stage.stageHeight - 100, "random", recenter);
			Tree.draw(this.graphics, this.stage.stageWidth/ 2, this.stage.stageHeight - 100, 60, -Math.PI / 2, 12, 12);
		}
		
		private function onResize(event:Event):void
		{
			if (stage.stageHeight == 0 || stage.stageWidth == 0)
				return;
		}
		
		private function recenter(e:Event = null):void {
			this.graphics.clear();
			Tree.draw(this.graphics, this.stage.stageWidth/ 2, this.stage.stageHeight - 100, 60, -Math.PI / 2, 12, 12);
		}
		
	}
}