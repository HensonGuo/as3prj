package movieclip
{
	import flash.display.Bitmap;
	import flash.ui.Keyboard;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * 有不少开发人员使用BitmapData来重现了MovieClip的功能
	 * PS：这样可以大大提升大量动画同屏渲染的呈现效率
	 * 
	 * 通过每帧更换纹理，我们可以重建出一个MovieClip的概念，GPU每帧都会重新采样并在屏幕上显示出来。
	 * 
	 * Flash Professional工具是我们制作素材的好搭档，它可以将一个动画的每帧导出为一组图片序列，之后，我们把这一些图片扔到一些工具，如TexturePacker
	 * 
	 * 如果你要对你的sprite atlas纹理使用Mip映射，那么你最好确保其中各帧之间的间隔起码保持2像素以上，否则在使用时将会出现像素重叠。
	 * 意思就是GPU在对每帧进行采样时，会采样到相邻帧的一部分颜色。
	 * 
	 * 在制作纹理素材时我们需要记住Stage3D（Molehill）对其尺寸的限制条件（必须为2的整数倍），这一点其实是手机应用开发时的一个条件
	 * 。这个条件事实上是由OpenGL、ES2这些显卡驱动所规定的，然而Stage3D为了去驱动它们就必须得遵循这个限制
	 * 
	 * TexturePacker这个工具提供了一个称为AutoSize（自动调整尺寸）的功能，它不仅能帮助我们很好地遵循此限制条件
	 * 
	 * 使用纹理序列来组成动画的好处在于，我们得到了动画各帧的掌控权，甚至可以动态调整动画的帧频，这样就允许我们为每个动画设置独立的帧频。
	 * public function MovieClip(textures:Vector.<Texture>, fps:Number=12)
	 * 
	 * 首先，这样做很方便，所有素材都集成在一个单独的纹理文件中。仅用一张纹理文件，可以最小化FlashPlayer向GPU上传的图片次数。
	 * 记住，向GPU上传图片的工作是很耗费性能的，尤其是对于手机设备来说。所以，向GPU上传图片的次数越少越好。
	 * 最后，切换纹理也是一个比较耗费性能的工作，使用一个单独纹理可以让你避免频繁地切换纹理。
	 */	
	public class MCLearn extends Sprite
	{
		private var mMovie:MovieClip;
		
		[Embed(source="/../bin-debug/assets/icons.xml", mimeType="application/octet-stream")] 
		public static const SpriteSheetXML:Class; 
		[Embed(source = "/../bin-debug/assets/icons.png")] 
		private static const SpriteSheet:Class;
		
		public function MCLearn()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		/**
		 * 调用pause后，播放头会停止在当前播放到的帧处，但是调用stop后，播放头会被重置回第一帧的位置。
		 * 
		 * currentFrame : 指示当前帧序号∗
		 *  fps : 默认情况下的帧频，即每秒播放的帧数∗ 
		 * isPlaying : 判断当前影片剪辑是否正在播放∗ 
		 * loop : 判断当前影片剪辑是否会循环播放∗ 
		 * numFrames : 当前影片剪辑包含的总帧数∗ 
		 * totalTime : 播完一次影片所需时间，单位为秒
		 * addFrame : 为影片剪辑增加一帧至时间轴末尾处，你可以设置该帧的持续时间及播放到该帧时需要发出的声音
		 * addFrameAt : 添加一帧到指定位置
		 * getFrameDuration : 获取某一帧的持续时间（单位为秒）
		 * getFrameDuration : 获取某一帧的持续时间（单位为秒）
		 * getFrameSound : 获取某一帧播放的声音
		 * getFrameTexture : 获取某一帧所用纹理
		 * pause : 暂停影片播放
		 * play : 开始播放影片. 不过在此之前你需要确保影片对象被添加到了一个Juggler对象中
		 * removeFrameAt : 移出指定位置处的帧
		 * setFrameDuration : 设置某一帧的持续时间（单位为秒）
		 * setFrameSound : 设置某一帧播放的声音
		 * setFrameTexture : 设置某一帧所用纹理
		 */		
		private function onAdded (e:Event):void { 
			// creates the embedded bitmap (spritesheet file) 
			var bitmap:Bitmap = new SpriteSheet(); 
			// creates a texture out of it 
			var texture:Texture = Texture.fromBitmap(bitmap); 
			// creates the XML file detailing the frames in the spritesheet 
			var xml:XML = XML(new SpriteSheetXML());
			// creates a texture atlas (binds the spritesheet and XML description) 
			var sTextureAtlas:TextureAtlas = new TextureAtlas(texture, xml); 
			// retrieve the frames the running boy frames 
			var frames:Vector.<Texture> = sTextureAtlas.getTextures("40");
			// creates a MovieClip playing at 40fps 
			mMovie = new MovieClip(frames, 40); 
			mMovie.setFrameDuration(10, 3);
			// centers the MovieClip 
			mMovie.x = stage.stageWidth - mMovie.width >> 1; 
			mMovie.y = stage.stageHeight - mMovie.height >> 1; 
			// show it 
			addChild ( mMovie ); 
			//play
			mMovie.play();
			Starling.juggler.add(mMovie);
			
			// on key down 
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if ( e.keyCode == Keyboard.RIGHT ) 
				mMovie.x = mMovie.x + 10; 
			else if ( e.keyCode == Keyboard.LEFT ) 
				mMovie.x = mMovie.x - 10; 
		}
	}
}