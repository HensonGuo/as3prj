package embedfonts
{
	import flash.text.Font;
	import flash.text.TextFieldType;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class EmbedFontLearn extends Sprite
	{
		[Embed(source='/../bin-debug/assets/fonts/童年的记忆.ttf', embedAsCFF='false', fontName='Abduction')] 
		public static var Abduction:Class;
		
		public function EmbedFontLearn()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded (e:Event):void 
		{ 
			// create the font 
			var font:Font = new Abduction(); 
			// create the TextField object 
			var legend:TextField = new TextField(300, 300, "Here is some text, using an embedded font!", font.fontName, 38, 0xFFFFFF); 
			// centers the text on stage 
			legend.x = stage.stageWidth - legend.width >> 1; 
			legend.y = stage.stageHeight - legend.height >> 1; 
			// show it
			addChild(legend);
			
			createTextInput();
		}
		
		/**
		 * 开始我们设置Stage3D运行环境的时候，若是wmode不正确，Starling就会在屏幕上显示wmode不正确的错误提示。这其实就用到了native overlay的特性。
		 * 在Starling对象中访问原生Flash显示列表，并可以向其中添加你以前常用的原生Flash显示对象，如视频播放器（vedio）、文本输入框（textinput）等，它们将会覆盖于Stage3D舞台之上。
		 */
		
		private function createTextInput():void
		{
			var textInput:flash.text.TextField = new flash.text.TextField(); 
			textInput.type = TextFieldType.INPUT; 
			Starling.current.nativeOverlay.addChild(textInput);
		}
		
	}
}