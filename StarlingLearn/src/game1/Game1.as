package game1
{
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game1 extends Sprite
	{
		private var q:Quad;
		
		public function Game1()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded ( e:Event ):void 
		{ 
			stage.color = 0x000000;
			
			q = new Quad(200, 200);
			q.color = 0x00FF00;
//			q.setVertexColor(0, 0x000000); 
//			q.setVertexColor(1, 0xAA0000); 
//			q.setVertexColor(2, 0x00FF00); 
//			q.setVertexColor(3, 0x0000FF); 
			addChild( q ); 
			
			q.x = stage.stageWidth - q.width >> 1; 
			q.y = stage.stageHeight - q.height >> 1;
		}
		
	}
}