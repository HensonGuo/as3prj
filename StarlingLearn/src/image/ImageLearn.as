package image
{
	import flash.display.Bitmap;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	
	public class ImageLearn extends Sprite
	{
		private const NUM_SAUSAGES:uint = 50;
		private var sausagesVector:Vector.<CustomImage> = new Vector.<CustomImage>(NUM_SAUSAGES, true);
		
		[Embed(source = "/../bin-debug/assets/yumao.png")] 
		private static const Sausage:Class;
		
		public function ImageLearn()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		/**
		 *Texture对象是可以重用的。【PS：这一点跟BitmapData一样】 
		 * 正因为如此，我们不建议你为具有同样外观的Image对象创建多个Texture：
		 * @param e
		 */		
		private function onAdded (e:Event):void 
		{
			// create a Bitmap object out of the embedded image 
			var sausageBitmap:Bitmap = new Sausage(); 
			// create a Texture object to feed the Image object 
			var texture:Texture = Texture.fromBitmap(sausageBitmap); 
			for (var i:int = 0; i < NUM_SAUSAGES; i++) 
			{
				// create a Image object with our one texture 
				var img:CustomImage = new CustomImage(texture); 
				// set a random alpha, position, rotation 
				img.alpha = Math.random(); 
				// define a random initial position 
				img.x = Math.random()*stage.stageWidth 
				img.y = Math.random()*stage.stageHeight 
				img.rotation = deg2rad(Math.random()*360); 
				// show it 
				addChild(img); 
				// store references for later 
				sausagesVector[i] = img; 
			}
			// main loop 
			stage.addEventListener(Event.ENTER_FRAME, onFrame);
			stage.addEventListener(TouchEvent.TOUCH, onClick);
		}
		
		private function onFrame (e:Event):void
		{ 
			var lng:uint = sausagesVector.length; 
			for (var i:int = 0; i < lng; i++) 
			{
				// move the sausages around 
				var sausage:CustomImage = sausagesVector[i]; 
				sausage.x -= ( sausage.x - sausage.destX ) * .1; 
				sausage.y -= ( sausage.y - sausage.destY ) * .1;
				// when reached destination 
				if ( Math.abs ( sausage.x - sausage.destX ) < 1 && Math.abs ( sausage.y - sausage.destY ) < 1) 
				{ 
					sausage.destX = Math.random()*stage.stageWidth; 
					sausage.destY = Math.random()*stage.stageWidth; 
					sausage.rotation = deg2rad(Math.random()*360);
				} 
			}
		}
		
		/**
		 *之前提到过的事件冒泡机制，可以让我们在主应用中不必为每个移动着的图片侦听Touch事件，
		 * 让代码更加简洁。取而代之的是，我们只需要对舞台对象侦听Touch事件就够了：
		 * 如果我们测试一下事件的target及currentTarget属性，
		 * 我们会发现currentTarget对象始终是Stage对象，
		 * 而target属性则是所点击到的Image对象： 
		 * 
		 */	
		private function onClick(e:TouchEvent):void { 
			// get the touch points (can be mulitple because of multitouch) 
			var touches:Vector.<Touch> = e.getTouches(this);
			var clicked:DisplayObject = e.currentTarget as DisplayObject; 
			// if one finger only or the mouse 
			if ( touches.length == 1 ) 
			{
				// grab the touch point 
				var touch:Touch = touches[0]; 
				// detect the click/release phase 
				if ( touch.phase == TouchPhase.ENDED ) 
				{
					// outputs : [object Stage] [object CustomImage] 
					trace ( e.currentTarget, e.target ); 
				}
			}
		}
		
		/**
		 *。Image对象除了继承了DisplayObject的一系列API之外还提供了一个特殊的属性smoothing来提供对图像的平滑处理功能。
		 * 该属性的可能值均存放于TextureSmoothing类定义的静态常量中： ∗
		 *  BILINEAR : 当纹理被缩放时对其应用双线性滤镜(默认值) ∗
		 *  NONE : 当纹理被缩放时不使用任何滤镜∗ 
		 * TRILINEAR : 当纹理被缩放时对其应用三线性滤镜 
		 * 
		 * 在Image对象中存在一个color属性值得大家记住，该属性允许你为一个图片指定一个颜色值。
		 * 在Image对象中，每个像素的颜色值都是由其纹理的颜色值和你指定的color颜色值混合的结果。
		 * PS：所以此color属性其实就是让你设置一个背景底色
		 */		
	}
}