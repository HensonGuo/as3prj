package reflection{
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	
	public class Reflection extends Sprite {
		//publics:
		public var reflectedClip      :DisplayObjectContainer;
		public var reflectionHeight   :Number;
		public var reflectionStrength :Number;
		public var reflectionOffsetY  :Number;
		
		//privates:
		private var reflectionHolder  :Sprite;
		private var bm_reflection     :Bitmap;
		private var refMask           :Sprite;
		
		//////////////////////////////////////////////
		//               CONSTRUCTOR:
		//////////////////////////////////////////////
		public function Reflection( reflectedClip:DisplayObjectContainer, height:Number = 255, strength:Number = 1, reflectionOffsetY:Number = 1 ) {
			this.reflectedClip       = reflectedClip;
			this.reflectionHeight    = height;
			this.reflectionStrength  = strength;
			this.reflectionOffsetY   = reflectionOffsetY;
			this.addEventListener(Event.ENTER_FRAME, render);
			build();
		}
		
		//////////////////////////////////////////////
		//               RENDER FUNCTIONS:
		//////////////////////////////////////////////
		private function render(l_loader:Event) : void
		{
			bm_reflection.bitmapData.fillRect(bm_reflection.getRect(bm_reflection), 16777215);
			bm_reflection.bitmapData.draw(reflectedClip);
			return;
		}// end function
		
		//////////////////////////////////////////////
		//               BUILDER FUNCTIONS:
		//////////////////////////////////////////////
		private function build():void {
			buildReflection();
			attachItems();
			positionElements();
		}
		
		private function buildReflection():void {
			reflectionHolder = new Sprite();
			
			var bmd:BitmapData = new BitmapData( reflectedClip.width, reflectedClip.height, true, 0xc61916 );
			bmd.draw( reflectedClip );
			
			bm_reflection             = new Bitmap( bmd );
			bm_reflection.y           = bm_reflection.height;
			bm_reflection.x           = 0;
			bm_reflection.rotation    = 180;
			bm_reflection.scaleX      = -1;
			bm_reflection.alpha       = reflectionStrength;
			
			refMask                   = new Sprite();
			var fillType      :String = GradientType.LINEAR;
			var colors        :Array  = [0xFFFFFF, 0x0000FF];
			var alphas        :Array  = [100, 0];
			var ratios        :Array  = [0, reflectionHeight];
			var matr          :Matrix = new Matrix();
			var spreadMethod  :String = SpreadMethod.PAD;
			
			matr.createGradientBox(reflectedClip.height * .9, reflectedClip.width, 0,0, 0);
			refMask.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			refMask.graphics.drawRect(0, 0, reflectedClip.height, reflectedClip.width);
			
			refMask.y                        = 0;
			refMask.x                        = bm_reflection.width;
			refMask.rotation                 = 90;
			
			bm_reflection.cacheAsBitmap      = true;
			refMask.cacheAsBitmap            = true;
			bm_reflection.mask               = refMask;
		}
		
		//////////////////////////////////////////////
		//        ATTACHER & POSITION FUNCTIONS:
		//////////////////////////////////////////////
		private function attachItems():void {
			this.addChild( reflectionHolder );
			reflectionHolder.addChild( bm_reflection );
			reflectionHolder.addChild( refMask );
		}
		
		private function positionElements():void {
			this.x = reflectedClip.x;
			this.y = reflectedClip.y + reflectedClip.height + reflectionOffsetY;
		}
		
		//////////////////////////////////////////////
		//               KILL FUNCTION:
		//////////////////////////////////////////////
		public function kill():void {
			reflectionHolder.removeChild( refMask );
			reflectionHolder.removeChild( bm_reflection );
			this.removeChild( reflectionHolder );
			this.removeEventListener(Event.ENTER_FRAME, render);
		}
	}
}