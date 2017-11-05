package effect.geckos
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import geckos.BeeBehavior;
	
	import test.BaseTest;
	
	public class BeenBehaviorTest extends BaseTest
	{
		private var beeBehavior:BeeBehavior;
		private var isPause:Boolean;
		
		public function BeenBehaviorTest(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			this.beeBehavior = new BeeBehavior(2, 1);
			for (var i:int = 0; i < 20; i++) 
			{
				var bee:Bee = new Bee();
				bee.x = Math.random() * (stage.stageWidth - 100) + 100;
				bee.y = Math.random() * (stage.stageHeight - 100) + 100;
				this.beeBehavior.addBee(bee);
				this.addChild(bee);
			}
			this.beeBehavior.start();
			
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(event:MouseEvent):void 
		{
			isPause = !isPause;
			if (isPause)
				this.beeBehavior.pause();
			else
				this.beeBehavior.start();
		}
	}
}