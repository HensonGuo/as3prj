package tweens
{
	import flash.display.Bitmap;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 *API:
	 *animate : 缓动一个对象的某个属性至指定目标值. 你可以在一个Tween对象中多次调用此方法
	 *target : 缓动目标对象
	 *transition : 指定补间动画所用缓动方程
	 *currentTime : 补间动画当前播放到的时间
	 *totalTime : 补间动画所要消耗的总时间（单位为秒）.
	 *delay : 补间动画开始前需要等待的延迟时间
	 *fadeTo : 缓动一个对象的透明度至指定目标值. 你可以在一个Tween对象中多次调用此方法
	 *moveTo : 同时缓动一个对象的x、y属性至指定目标值
	 *scaleTo : 同时将scaleX及scaleY属性值缓动至指定目标值.
	 *isComplete : 此标记用以判断一个补间动画是否播放完毕
	 *onComplete : 补间动画播放完毕回调函数
	 *onCompleteArgs : 补间动画播放完毕回调函数参数
	 *onStart : 补间动画开始播放回调函数
	 *onStartArgs : 补间动画开始播放回调函数参数
	 *onUpdate : 补间动画每帧更新时都会调用此方法
	 *onUpdateArgs : 需要传入补间动画每帧更新时都会调用的方法的参数
	 *roundToInt :若该标记为true，则所有带小数的属性值都会去掉小数变为整数
	 */	
	public class TweenLearn extends Sprite
	{
		[Embed(source = "/../bin-debug/assets/yumao.png")] 
		private static const Yumao:Class;
		
		public function TweenLearn()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded (e:Event):void 
		{
//			var yumao:Bitmap = new Yumao();
			var txture:Texture = Texture.fromEmbeddedAsset(Yumao);
			var img:Image = new Image(txture);
			// centers the text on stage 
			img.x = stage.stageWidth - img.width >> 1; 
			img.y = stage.stageHeight - img.height >> 1; 
			// create a Tween object 
			var t:Tween = new Tween(img, 2, Transitions.EASE_IN_BOUNCE);
			t.delay = 3;
			// move the object position 
			t.moveTo(img.x+500, img.y); 
			// add it to the Juggler 
			Starling.juggler.add(t); 
			// listen to the start 
			t.onStart = onStart; 
			// listen to the progress 
			t.onUpdate = onProgress; 
			// listen to the end 
			t.onComplete = onComplete; 
			// show it 
			addChild(img); 
		}
		
		private function onStart():void 
		{ 
			trace ("tweening complete"); 
		}
		
		private function onProgress():void 
		{ 
			trace ("tweening in progress"); 
		}
		
		private function onComplete():void 
		{
			trace ("tweening complete") 
		}
		
	}
}