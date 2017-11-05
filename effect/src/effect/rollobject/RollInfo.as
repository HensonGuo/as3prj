package effect.rollobject
{
	import flash.geom.Rectangle;

	public class RollInfo
	{
		public var objClass:Class;						//滚动对象类
		public var speed:Number;						//速度
		public var direction:String;						//方向
		public var rollRect:Rectangle;				//滚动区域
		public var pauseDisplayTime:int;			//滚动中间停留展示时间
		public var extraInfo:Object;					//额外信息
		
		public function RollInfo()
		{
		}
	}
}