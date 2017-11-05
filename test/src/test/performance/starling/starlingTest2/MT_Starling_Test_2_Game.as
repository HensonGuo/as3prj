package test.performance.starling.starlingTest2{

	import starling.display.BlendMode;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.deg2rad;
	
	import test.performance.starling.QuadSprite;

	public class MT_Starling_Test_2_Game extends Sprite{
		private var quad:QuadSprite;
		private var pSprite:Sprite;
		private var num:int = 10000;
		private var i:int;
		private var rectSize:int = 2;
		private var rotationRate:Number = deg2rad(1);
		private var quadA:Vector.<QuadSprite> = new Vector.<QuadSprite>(num);
		private var stageW:int;
		private var stageH:int;
		private var rectHalf:Number = rectSize/2;
		private var speed:Number;
		private var quadVector:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>(num);
  	  
	  	public function MT_Starling_Test_2_Game(){
        	this.addEventListener(Event.ADDED_TO_STAGE,createQuadsF);
    	}
		
		private function createQuadsF(e:Event):void{
			stageW = stage.stageWidth;
			stageH = stage.stageHeight;
			// create a parent starling sprite in case I want to add TouchEvents.  Instead of adding many TouchEvents (one to each child), I'll just add one to the parent and, in the event listener, detect which child was touched.
			parentF();
			for(i=num-1;i>=0;i--){
				// A starling spirte that contains a quad.
				quad = new QuadSprite(rectSize,0xffffff*Math.random());
				quadA[i] = quad;
				// quad rotation, speed, vectorX, vectorY
				// Starling DisplayObjects have rotations in radians, not degrees
				// Because QuadSprites look the same when rotated pi/2 and pi etc, I may as well use a rotation that requires the least computation.
				quad.rotation = randomF(0,Math.PI);
				speed = randomF(1,3);
				//quad.vectorX = speed*randomF(-1,1);
				//quad.vectorY = speed*randomF(-1,1);
				quadVector[i] = new <Number>[speed*randomF(-1,1),speed*randomF(-1,1)];
				//quad.blendMode = BlendMode.NONE;
				//quad.flatten();
				//quad.touchable = false
				pSprite.addChild(quad);
				quad.x = int(randomF(rectHalf,stageW-rectSize));
				quad.y = int(randomF(rectHalf,stageH-rectSize));
			}
			//pSprite.flatten();
			addEventListener(Event.ENTER_FRAME,animateQuadsF);
		}
		private function animateQuadsF(e:Event):void{
			//pSprite.unflatten();
			for(i=num-1;i>=0;i--){
				quadA[i].rotation += rotationRate;
				//quadA[i].x += quadA[i].vectorX;
				//quadA[i].y += quadA[i].vectorY;
				quadA[i].x += quadVector[i][0];
				quadA[i].y += quadVector[i][1];
				boundaryF(quadA[i],i);
			}
			//pSprite.flatten();
		}
		private function boundaryF(q:QuadSprite,i:int):void{
			if (q.x>stageW-rectHalf || q.x<rectHalf) {
				quadVector[i][0] *= -1;
			} 
			if (q.y>stageH-rectHalf || q.y<rectHalf) {
				quadVector[i][1] *= -1;
			}
		}
		private function parentF():void{
			pSprite = new Sprite();
			var pQuad:Quad = new Quad(stageW,stageH,0x000000);
			//pQuad.blendMode = BlendMode.NONE;
			//pQuad.touchable = false;
			pSprite.blendMode = BlendMode.NONE;
			pSprite.touchable = false;
			addChild(pSprite);
			pSprite.addChild(pQuad);
		}
	
		private function randomF(int1:int,int2:int):Number{
			return int1+(int2-int1)*Math.random();
		}
		
	}
}

