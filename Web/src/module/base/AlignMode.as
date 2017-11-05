package module.base
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class AlignMode
	{
		public static const CENTER:String = "center";
		public static const BOTTOM:String = "bottom";
		public static const TOP:String = "top";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const TOP_LEFT:String = "top_left";
		public static const TOP_RIGHT:String = "top_right";
		public static const BOTTOM_LEFT:String = "bottom_left";
		public static const BOTTOM_RIGHT:String = "bottm_right";
		
		public function AlignMode()
		{
		}
		
		public static function align(mode:String, target:DisplayObject, parent:DisplayObjectContainer):void
		{
			switch(mode)
			{
				case CENTER:
					target.x = parent.width / 2 - target.width / 2;
					target.y = parent.height / 2 - target.height / 2;
					break;
				case BOTTOM:
					break;
				case TOP:
					break;
				case LEFT:
					break;
				case RIGHT:
					break;
				case TOP_LEFT:
					break;
				case TOP_RIGHT:
					break;
				case BOTTOM_LEFT:
					break;
				case BOTTOM_RIGHT:
					break;
			}
		}
	}
}