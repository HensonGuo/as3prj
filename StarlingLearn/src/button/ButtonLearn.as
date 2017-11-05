package button
{
	import flash.display.Bitmap;
	import flash.utils.setTimeout;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class ButtonLearn extends Sprite
	{
		[Embed(source = "/../bin-debug/assets/blueBtn_upSkin.png")] 
		private static const buttonTexture:Class;
		
		[Embed(source = "/../bin-debug/assets/shuye.jpg")] 
		private static const BackgroundImage:Class; 
		private var backgroundContainer:Sprite; 
		private var background1:Image; 
		private var background2:Image;
		
		private var _sections:Vector.<String> = Vector.<String>(["Play", "Options", "Rules", "Sign in"]);
		
		public function ButtonLearn()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		/**
		 *fromBitmap方法直接向GPU上传了一个Texture对象作为按钮的唯一皮肤。
		 * 如果你准备为全部按钮都用同一个皮肤的话这么做当然没什么问题。不过一个更加好的习惯是将一个按钮的全部状态素材都放在一个SpriteSheet中，
		 * 就像之前我们在创建男孩及屠夫的movieClip例子中做的那样。 
		 * 
		 * 
		 * API:
		 * alphaWhenDisabled : 当按钮处于不可用状态时的透明度
		 * downState : 当按钮被按下时的皮肤纹理
		 * enabled : 此属性决定按钮是否可用、可交互
		 * fontBold : 按钮文本是否为粗体
		 * fontColor : 按钮文本的颜色
		 * fontName : 按钮文本所用字体。可以是一个系统字体也可以是一个已经注册了的位图字体
		 * fontSize : 按钮文本大小
		 * scaleWhenDown : 按钮按下时将被缩放到的值。如果你设置了downState，那么按钮在按下后将不会被缩放
		 * text : 按钮显示的文本
		 * textBounds : 按钮文本所在区域
		 * upState : 当按钮未产生交互时的皮肤纹理
		 */		
		private function onAdded (e:Event):void {
			// create a Bitmap object out of the embedded image 
			var buttonSkin:Bitmap = new buttonTexture();
			// create a Texture object to feed the Button object 
			var texture:Texture = Texture.fromBitmap(buttonSkin);
			// create a Bitmap object out of the embedded image 
			var background:Bitmap = new BackgroundImage(); 
			// create a Texture object to feed the Image object 
			var textureBackground:Texture = Texture.fromBitmap(background); 
			// container for the background textures 
			backgroundContainer = new Sprite(); 
			// create the images for the background 
			background1 = new Image(textureBackground); 
			background2 = new Image(textureBackground); 
			// positions the second part 
			background2.x = background1.width; 
			// nest them 
			backgroundContainer.addChild(background1); 
			backgroundContainer.addChild(background2); 
			// show the background 
			addChild(backgroundContainer);
			// createa container for the menu (buttons) 
			var menuContainer:Sprite = new Sprite();
			var numSections:uint = _sections.length;
			for (var i:uint = 0; i< 4; i++) 
			{ 
				// create a button using this skin as up state 
				var myButton:Button = new Button(texture, _sections[i], texture);
				// bold labels 
				myButton.fontBold = true; 
				// position the buttons 
				myButton.y = myButton.height * i; 
				// add the button to our container 
				menuContainer.addChild(myButton);
			}
			// catch the Event.TRIGGERED event
			menuContainer.addEventListener(Event.TRIGGERED, onTriggered);
			// on each frame
			var callback:Function = function():void
			{
				stage.addEventListener(Event.ENTER_FRAME, onFrame);
			};
			setTimeout(callback, 5000);
			// centers the menu 
			menuContainer.x = stage.stageWidth - menuContainer.width >> 1; 
			menuContainer.y = stage.stageHeight - menuContainer.height >> 1; 
			// show the button 
			addChild(menuContainer);
		}
		
		
		/**
		 *注意，一个Button对象将会在你点击它的时候派发一个特殊的事件：Event.TRIGGERED
		 */
		
		private function onTriggered(e:Event):void 
		{
			// outputs : [object Sprite] [object Button] 
			trace ( e.currentTarget, e.target ); 
			// outputs : triggered!
			trace ("triggered!"); 
		}
		
		private function onFrame (e:Event):void 
		{
			// scroll it 
			backgroundContainer.x -= 10; 
			// reset 
			if ( backgroundContainer.x <= -background1.width ) 
				backgroundContainer.x = 0; 
		}
	}
}