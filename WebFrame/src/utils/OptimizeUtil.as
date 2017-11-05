package utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;

	public class OptimizeUtil
	{
		public function OptimizeUtil()
		{
		}
		
		/**
		 *优化渲染 
		 * @param obj
		 */		
		public static function optimizeRender(obj:DisplayObject):void
		{
			obj.cacheAsBitmap = true;
			if (obj is InteractiveObject)
				(obj as InteractiveObject).mouseEnabled = false;
			if (obj is DisplayObjectContainer)
				(obj as DisplayObjectContainer).mouseChildren = false;
		}
	}
}