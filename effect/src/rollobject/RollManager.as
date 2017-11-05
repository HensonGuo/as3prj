package rollobject
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import rollobject.object.RollObject;
	
	import resource.pools.ObjectPool;
	import utils.trigger.Dispatcher;
	

	public class RollManager
	{
		private static var _timer:Timer;
		private static var _cacheArr:Vector.<RollInfo> = new Vector.<RollInfo>();
		private static var _curRollObj:RollObject;
		
		private static var _container:DisplayObjectContainer;
		
		public function RollManager()
		{
		}
		
		/**
		 * 初始化
		 * container容器
		 * excuteInterval执行间隔
		 */
		public static function init(container:DisplayObjectContainer, excuteInterval:int = 40):void
		{
			_container = container;
			
			_timer = new Timer(excuteInterval);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		/**
		 * 添加滚动对象
		 */	
		public static function addRollTarget(info:RollInfo):void
		{
			if (!_timer.running)
				_timer.start();
			_cacheArr.push(info);
		}
		
		private static function onTimer(event:TimerEvent):void
		{
			if (_curRollObj == null)
			{
				if (_cacheArr.length == 0)
				{
					_timer.stop();
					Dispatcher.dispatchEvent(new RollEvent(RollEvent.FINISH));
					return;
				}
				var info:RollInfo = _cacheArr.shift();
				_curRollObj = ObjectPool.getObject(info.objClass);
				_curRollObj.init(info);
				_container.addChild(_curRollObj);
				return;
			}
			if (_curRollObj.isFinishRoll)
			{
				_container.removeChild(_curRollObj);
				_curRollObj.dispose();
				ObjectPool.disposeObject(_curRollObj);
				_curRollObj = null;
				return;
			}
			_curRollObj.update();
		}
		
		public static function dispose():void
		{
			
		}
		
	}
}