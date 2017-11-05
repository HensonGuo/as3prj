package display.window
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import utils.debug.LogUtil;

	public class WindowLocate
	{
		public static const TYPE_ABS:int = 0;
		public static const TYPE_TOP:int = 1;
		public static const TYPE_TOP_LEFT:int = 2;
		public static const TYPE_TOP_RIGHT:int = 3;
		public static const TYPE_CENTER:int = 4;
		public static const TYPE_LEFT:int = 5;
		public static const TYPE_RIGHT:int = 6;
		public static const TYPE_BOTTOM:int = 7;
		public static const TYPE_BOTTOM_LEFT:int = 8;
		public static const TYPE_BOTTOM_RIGHT:int = 9;
		protected static const TYPE_TOTAL:int = 10;
		
		private var _type:int = TYPE_TOP_LEFT;
		private var _level:String = WindowLayer.MIDDLE;
		private var _offsetX:int = 0;
		private var _offsetY:int = 0;
		
		public function WindowLocate()
		{
		}
		
		public function locate(window:BaseWindow):void
		{
			if (window == null || !window.isLoadComplete)
			{
				throw new Error("window is not exist or not load complete!");
			}
			var targetInfo:Rectangle = getTargetInfo();
			var baseWindow:BaseWindow = window as BaseWindow;
			adjust(window, targetInfo);
		}
		
		private function adjust(window:BaseWindow, targetInfo:Rectangle):void
		{
			var srcX:int = window.x;
			var srcY:int = window.y;
			var curX:int = 0;
			var curY:int = 0;
			switch (_type)
			{
				case TYPE_ABS:
					curX = _offsetX;
					curY = _offsetY;
					break;
				case TYPE_TOP_LEFT:
					curX = targetInfo.x + _offsetX;
					curY = targetInfo.y + _offsetY;
					break;
				case TYPE_TOP:
					curX = (targetInfo.width - window.width) / 2 + targetInfo.x + _offsetX;
					curY = targetInfo.y + _offsetY;
					break;
				case TYPE_TOP_RIGHT:
					curX = (targetInfo.width - window.width) + targetInfo.x + _offsetX;
					curY = targetInfo.y + _offsetY;
					break;
				case TYPE_LEFT:
					curX = targetInfo.x + _offsetX;
					curY = (targetInfo.height - window.height) / 2 + targetInfo.y + _offsetY;
					break;
				case TYPE_CENTER:
					curX = (targetInfo.width - window.width) / 2 + targetInfo.x + _offsetX;
					curY = (targetInfo.height - window.height) / 2 + targetInfo.y + _offsetY;
					break;
				case TYPE_RIGHT:
					curX = (targetInfo.width - window.width) + targetInfo.x + _offsetX;
					curY = (targetInfo.height - window.height) / 2 + targetInfo.y + _offsetY;
					break;
				case TYPE_BOTTOM_LEFT:
					curX = targetInfo.x + _offsetX;
					curY = (targetInfo.height - window.height) + targetInfo.y + _offsetY;
					break;
				case TYPE_BOTTOM:
					curX = (targetInfo.width - window.width) / 2 + targetInfo.x + _offsetX;
					curY = (targetInfo.height - window.height) + targetInfo.y + _offsetY;
					break;
				case TYPE_BOTTOM_RIGHT:
					curX = (targetInfo.width - window.width) + targetInfo.x + _offsetX;
					curY = (targetInfo.height - window.height) + targetInfo.y + _offsetY;
					break;
			}
			
			window.x = curX;
			window.y = curY;
			LogUtil.debug(window.windowName + " relocation to " + window.locationInfo + " type=" + _type  
				 + " target=" + targetInfo);
		}
		
		public function setting(type:int, level:String = WindowLayer.MIDDLE, offsetX:int = 0, offsetY:int = 0):void
		{
			if (type <= TYPE_ABS || type >= TYPE_TOTAL)
			{
				throw new Error("type > TYPE_ABS && type < TYPE_TOTAL");
			}
			
			_type = type;
			_level = level;
			_offsetX = offsetX;
			_offsetY = offsetY;
		}
		
		private function getTargetInfo():Rectangle
		{
			var targetInfo:Rectangle = new Rectangle();
			targetInfo.x = -FrameWork.windowManager.renderRect.x;
			targetInfo.y = -FrameWork.windowManager.renderRect.y;
			targetInfo.width = FrameWork.windowManager.renderRect.width;
			targetInfo.height = FrameWork.windowManager.renderRect.height;
			return targetInfo;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function get level():String
		{
			return _level;
		}

		public function get offsetX():int
		{
			return _offsetX;
		}

		public function get offsetY():int
		{
			return _offsetY;
		}


	}
}