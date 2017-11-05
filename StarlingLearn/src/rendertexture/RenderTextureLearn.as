package rendertexture
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	/**
	 * API允许开发者在Starling中实现无损绘画功能
	 * 可以把该API想成是原生Flash中的BitmapData对象
	 * 
	 * 当你在创建类似绘图工具的应用程序时该特性会十分有用，RenderTexture对象可以作为一张“画布”.
	 * 满足你在一个Texture纹理对象中进行绘画的愿望，而且每次绘画时不会抹除上一次绘画的结果
	 */	
	public class RenderTextureLearn extends Sprite
	{
		private var mRenderTexture:RenderTexture; 
		private var mBrush:Image;
		
		[Embed(source = "/../bin-debug/assets/yumao.png")] 
		private static const Egg:Class;
		
		public function RenderTextureLearn()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded (e:Event):void 
		{
			// create a Bitmap object out of the embedded image 
			var brush:Bitmap = new Egg(); 
			// create a Texture object to feed the Image object 
			var texture:Texture = Texture.fromBitmap(brush);
			// create the texture to draw into the texture 
			mBrush = new Image(texture);
			// set the registration point 
			mBrush.pivotX = mBrush.width >> 1; 
			mBrush.pivotY = mBrush.height >> 1;
			// scale it 
			mBrush.scaleX = mBrush.scaleY = 0.5; 
			// creates the canvas to draw into 
			mRenderTexture = new RenderTexture(stage.stageWidth, stage.stageHeight); 
			// we encapsulate it into an Image object 
			var canvas:Image = new Image(mRenderTexture); 
			// show it 
			addChild(canvas); 
			// listen to mouse interactions on the stage 
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
		}
	
		private function onTouch(event:TouchEvent):void 
		{
			// retrieves the entire set of touch points (in case of multiple fingers on a touch screen) 
			var touches:Vector.<Touch> = event.getTouches(this); 
			for each (var touch:Touch in touches) 
			{
				// if only hovering or click states, let's skip 
				if (touch.phase == TouchPhase.HOVER || touch.phase == TouchPhase.ENDED) 
					continue; 
				// grab the location of the mouse or each finger 
				var location:Point = touch.getLocation(this); 
				// positions the brush to draw 
				mBrush.x = location.x;
				mBrush.y = location.y; 
				// draw into the canvas
				mRenderTexture.draw(mBrush);
			} 
		}
		
	}
}