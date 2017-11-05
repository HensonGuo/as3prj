package  utils.lib
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;

	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;

	public class FilterLib 
	{
		//经典1像素黑色描边
		public static var glow_classic : GlowFilter = new GlowFilter(0x071717, 1, 1.3, 1.3, 7, 1);
		//淡灰色轻柔化描边
		public static var glow_dust : GlowFilter = new GlowFilter(0x071717, 1, 1.1, 1.1, 1, 1);
		//淡灰色柔化描边
		public static var glow_soft : GlowFilter = new GlowFilter(0x071717, 1, 1.4, 1.4, 3, 2);
		//淡灰色柔化描边
		public static var glow_lite : GlowFilter = new GlowFilter(0x071717, 1, 1.4, 1.4, 2, 2);
		//深灰色柔化描边
		public static var glow_cloud : GlowFilter = new GlowFilter(0x071717, 1, 2, 2, 2.2, 5);
		//白色柔化描边
		public static var glow_white : GlowFilter = new GlowFilter(0xffffff, 1, 1.1, 1.1, 2, 2);
		//墨绿色粗描边
		public static var glow_green : GlowFilter = new GlowFilter(0x668833, 1, 3.5, 3.5, 4, 2);
		//红色发光
		public static var glow_Red : GlowFilter = new GlowFilter(0xffffff, 1, 1, 1, 3, 1);
		public static var glow_Green : GlowFilter = new GlowFilter(0x66ff66, 1, 1, 1, 3, 1);
		public static var glow_Blue : GlowFilter = new GlowFilter(0x66ffff, 1, 1, 1, 3, 1);

		//柔化测试
		public static var drop_soft : DropShadowFilter = new DropShadowFilter(1.5, 45, 0, 0.5, 2, 2, 1.8);

		//滤镜 - 阴影
		public static var drop_classic : DropShadowFilter = new DropShadowFilter(1, 45, 0x000000, 1, 1, 1, 3);
		public static var drop_dust : DropShadowFilter = new DropShadowFilter(1, 45, 0x000000, 0.8, 1, 1, 1);
		
		public static var drop_big : DropShadowFilter = new DropShadowFilter(2, 45, 0x008684, 1, 1, 1, 3);
		public static var drop_sun : DropShadowFilter = new DropShadowFilter(2, 225, 0xffffff, 0.8, 1, 1, 2);
		
		 //灰色滤镜
		private static var mat : Array = [0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0];
		private static var colorMat : ColorMatrixFilter = new ColorMatrixFilter(mat);
		//设置不可用(灰色滤镜)
		public static function setCantUse(object : Sprite = null , mouseEvt : Boolean = false) : void
		{
			if (object) {
				object.filters = [colorMat];
				object.mouseEnabled = mouseEvt;
			}
		}
		//设置可用(清除滤镜)
		public static function setUse(object : Sprite = null , mouseEvt : Boolean = false) : void
		{
			if (object) {
				object.filters = [];
				object.mouseEnabled = mouseEvt;
			}
		}
	}
}