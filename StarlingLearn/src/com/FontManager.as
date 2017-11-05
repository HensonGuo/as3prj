package com
{
	import flash.display.Bitmap;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	import utils.debug.LogUtil;

	public class FontManager
	{
		public static var Font_MircosoftYaHeiBold:BitmapFont;
		public static const FontName_MircosoftYaHeiBold:String = "微软雅黑";
		
		[Embed(source = "/../bin-debug/assets/bmpFont_0.png")] 
		private static const MircosoftYaHeiBoldChars:Class; 
		
		[Embed(source="/../bin-debug/assets/bmpFont.fnt", mimeType="application/octet-stream")] 
		private static const MircosoftYaHeiBoldXML:Class;
		
		public function FontManager()
		{
		}
		
		public static function init():void
		{
			// creates the embedded bitmap (spritesheet file) 
			var bitmap:Bitmap = new MircosoftYaHeiBoldChars(); 
			// creates a texture out of it 
			var texture:Texture = Texture.fromBitmap(bitmap); 
			// create the XML file describing the glyphes position on the spritesheet 
			var xml:XML = XML(new MircosoftYaHeiBoldXML()); 
			LogUtil.debug("[Load Font] " + xml.info.@face)
			// register the bitmap font to make it available to TextField 
			Font_MircosoftYaHeiBold = new BitmapFont(texture, xml);
			TextField.registerBitmapFont(Font_MircosoftYaHeiBold); 
		}
	}
}