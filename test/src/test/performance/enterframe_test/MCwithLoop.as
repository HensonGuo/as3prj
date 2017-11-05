package  test.performance.enterframe_test{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class MCwithLoop extends MovieClip {
		
		private var speed:int;
		private var angle:int;
		
		public function MCwithLoop() {
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
			this.addEventListener(Event.ENTER_FRAME,moveF);
		}
		private function moveF(e:Event):void{
			this.x+=speed*Math.cos(angle*Math.PI/180);
			this.y+=speed*Math.sin(angle*Math.PI/180);
			if(this.x>stage.stageWidth-this.width){
				angle = 180-angle;
			} else if(this.x<0){
				angle = 180-angle;
			} else if(this.y>stage.stageHeight-this.height){
				angle *= -1;
			} else if(this.y<0){
				angle *= -1;
			}
		}
	}
	
}
