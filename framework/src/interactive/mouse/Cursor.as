package interactive.mouse
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	
	import utils.debug.LogUtil;

	public class Cursor
	{
		public function Cursor()
		{
		}
		
		public static function setCursor(name:String, frameList:Vector.<BitmapData>):void
		{
			if (!Mouse.supportsNativeCursor)
			{
				LogUtil.info("不支持本机光标");
				return;
			}
			var cursorData:MouseCursorData = new MouseCursorData();
			cursorData.data
			cursorData.frameRate = 24;
			Mouse.registerCursor(name, cursorData);
		}
		
		public static function removeCursor(name:String):void
		{
			Mouse.unregisterCursor(name);
		}
		
		public static function show():void
		{
			Mouse.show();
		}
		
		public static function hide():void
		{
			Mouse.hide();
		}
		
	}
}