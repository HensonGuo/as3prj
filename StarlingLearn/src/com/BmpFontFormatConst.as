package com
{
	import feathers.text.BitmapFontTextFormat;

	public class BmpFontFormatConst
	{
		public static const FONT_SIZE:int = 24;
		
		public function BmpFontFormatConst()
		{
		}
		
		private static var _formatWhite:BitmapFontTextFormat;
		public static function get formatWhite():BitmapFontTextFormat
		{
			if(!_formatWhite)
				_formatWhite=new BitmapFontTextFormat(FontManager.Font_MircosoftYaHeiBold, FONT_SIZE, 0xffffff);
			return clone(_formatWhite);
		}
		
		private static var _formatYellow:BitmapFontTextFormat;
		public static function get formatYellow():BitmapFontTextFormat
		{
			if(!_formatYellow)
				_formatYellow=new BitmapFontTextFormat(FontManager.Font_MircosoftYaHeiBold, FONT_SIZE, 0xffff00);
			return clone(_formatYellow);
		}
		
		private static var _formatGreen:BitmapFontTextFormat;
		public static function get formatGreen():BitmapFontTextFormat
		{
			if(!_formatGreen)
				_formatGreen=new BitmapFontTextFormat(FontManager.Font_MircosoftYaHeiBold, FONT_SIZE, 0x00ff00);
			return clone(_formatGreen);
		}
		
		private static function clone(fmt:BitmapFontTextFormat):BitmapFontTextFormat
		{
			return new BitmapFontTextFormat(fmt.font, fmt.size, fmt.color, fmt.align);
		}
	}
}