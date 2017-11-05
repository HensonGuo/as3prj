package test.performance.starling {
	
	import starling.display.Quad;
	import starling.display.Sprite;

	public class QuadSprite extends Sprite {

		public function QuadSprite(size:int,color:uint) {
			var q:Quad = new Quad(size,size);
			q.pivotX = size/2;
			q.pivotY = size/2;
			q.color = color;
			addChild( q );
		}
	}
}