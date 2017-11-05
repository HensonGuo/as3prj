package textfield
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * ，Starling使用CPU创建了一个原生的Flash TextField对象，在为其设置完文字及格式后，为其拍了个快照或是截了个屏神马的，
	 * 之后将此图像传至GPU进行渲染。
	 * 注：
	 * Staring只会创建一个原生TextField对象作为文字源，该文字源将为多个starling.text.TextField对象提供文字纹理。
	 * Starling不会为每个starling.text.TextField都创建一个原生TextField对象，以避免浪费
	 * 
	 * API:
	 * alpha : 文本透明度
	 * autoScale : 是否让文本自动缩放以适应TextField的区域
	 * bold : 指定文本是否以粗体显示
	 * border : 允许显示textfield的边框。在对textfield进行显式调试时此属性很有用
	 * bounds : textfield所占区域
	 * color : 文本颜色
	 * fontName : 文本字体名
	 * fontSize : 文本大小
	 * hAlign : 文本水平排列方式
	 * italic : 指定文本是否以斜体显示
	 * kerning : 当你在使用位图字体时（前提是存在可用的位图字体），允许你设置字符间距。此属性默认值为YES
	 * text : 显示的文本
	 * textBounds : textfield中实际文本所占区域
	 * underline : 指定文本是否显示下划线
	 * vAlign : 文本垂直排列方式
	 */	
	public class TextFieldLearn extends Sprite
	{
		public function TextFieldLearn()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded (e:Event):void 
		{
			// create the TextField object 
			var legend:TextField = new TextField(300, 300, "大家好才是真的好!", "Verdana", 38, 0xFFFFFF);
			// change the color, set bold and enable a border 
			legend.color = 0x990000; 
			legend.bold = true; 
			legend.border = true;
			legend.autoScale = true;
			// centers the text on stage 
			legend.x = stage.stageWidth - legend.width >> 1; 
			legend.y = stage.stageHeight - legend.height >> 1;
			// show it 
			addChild(legend); 
		}
	}
}