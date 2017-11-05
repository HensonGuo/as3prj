package bitmapfont
{
	import flash.display.Bitmap;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	/**
	 *为了获得最佳的视觉体验，降低资源加载量和垃圾回收量，我们可以在TextField对象中用上位图字体 
	 *位图字体的制作原理很简单，而且我们对其也已经非常熟悉了，就是把所有字体素材都集成在一个SpriteSheet中，之后我们每个字的外观都将从该SpriteSheet中采样。
	 *把所有字体素材都集成在一个SpriteSheet中，之后我们每个字的外观都将从该SpriteSheet中采样
	 */	
	public class BitmapFontLearn extends Sprite
	{
		[Embed(source = "/../bin-debug/assets/bmpFont_0.png")] 
		private static const BitmapChars:Class; 
		
		[Embed(source="/../bin-debug/assets/bmpFont.fnt", mimeType="application/octet-stream")] 
		private static const BritannicXML:Class;
		
		public function BitmapFontLearn()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded (e:Event):void {
			// creates the embedded bitmap (spritesheet file) 
			var bitmap:Bitmap = new BitmapChars(); 
			// creates a texture out of it 
			var texture:Texture = Texture.fromBitmap(bitmap); 
			// create the XML file describing the glyphes position on the spritesheet 
			var xml:XML = XML(new BritannicXML()); 
			// register the bitmap font to make it available to TextField 
			TextField.registerBitmapFont(new BitmapFont(texture, xml)); 
			// create the TextField object 
			var bmpFontTF:TextField = new TextField(400, 400, "点击", "微软雅黑", 100, 0x00ff00);
			// the native bitmap font size, no scaling 
//			bmpFontTF.fontSize = BitmapFont.NATIVE_SIZE; 
			// use white to use the texture as it is (no tinting) 
//			bmpFontTF.color = Color.WHITE; 
			// centers the text on stage 
			bmpFontTF.x = stage.stageWidth - bmpFontTF.width >> 1; 
			bmpFontTF.y = stage.stageHeight - bmpFontTF.height >> 1; 
			// show it 
			addChild(bmpFontTF); 
		}
	}
}