package  test.performance.enterframe_test{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class MCwithoutLoop extends MovieClip {
		
		public var speed:int;
		public var angle:int;
		
		public function MCwithoutLoop() {
			with (this.graphics) {
				beginFill(0xffffff*Math.random());
				drawCircle(0,0,2);
				endFill();
			}
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(e:Event):void{
			speed = 1+int(10*Math.random());
			angle = int(360*Math.random());
			this.x = int(Math.random()*(stage.stageWidth-this.width));
			this.y = int(Math.random()*(stage.stageHeight-this.height));
		}
	}
	
}
