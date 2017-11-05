package effect.rollobject
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import resource.pools.Reuse;
	
	import utils.trigger.Dispatcher;
	
	public class RollManager
	{
		private static var _timer:Timer;
		private static var _cacheArr:Vector.<RollInfo> = new Vector.<RollInfo>();
		private static var _curRollObj:RollObject;
		
		private static var _rootContainer:DisplayObjectContainer;
		private static var _container:Sprite;
		
		public function RollManager()
		{
		}
		
		/**
		 * 初始化
		 * container容器
		 * excuteInterval执行间隔
		 */
		public static function init(container:DisplayObjectContainer, excuteInterval:int = 40, offsetX:Number = 0, offsetY:Number = 0):void
		{
			_rootContainer = container;
			_container = new Sprite();
			_container.x = offsetX;
			_container.y = offsetY;
			_rootContainer.addChild(_container);
			
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
			if (_curRollObj && _curRollObj.equal(info))
				return;
			_cacheArr.push(info);
		}
		
		public static function clearCache():void
		{
			_timer.stop();
			_cacheArr.length = 0;
			disposeCurRollObj();
		}
		
		private static function onTimer(event:TimerEvent):void
		{
			if (_curRollObj == null)
			{
				if (_cacheArr.length == 0)
				{
					_timer.stop();
					Dispatcher.dispatchEvent(new RollEvent(RollEvent.ROLL_END));
					return;
				}
				var info:RollInfo = _cacheArr.shift();
				_curRollObj = Reuse.create(info.objClass);
				_curRollObj.init(info);
				_curRollObj.show(_container);
				return;
			}
			if (_curRollObj.isFinishRoll)
			{
				disposeCurRollObj();
				return;
			}
			_curRollObj.update();
		}
		
		private static function disposeCurRollObj():void
		{
			_curRollObj.hide();
			_curRollObj.destory()
			_curRollObj = null;
		}
		
		public static function dispose():void
		{
			disposeCurRollObj();
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer = null;
			_rootContainer = null;
			_container = null;
			_cacheArr.length = 0;
		}
		
	}
}