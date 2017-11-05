package effect.flyobject
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import utils.OptimizeUtil;
	

	public class FlyManager
	{
		private static var _cacheArr:Vector.<FlyObject> = new Vector.<FlyObject>();
		private static var _flyArr:Vector.<FlyObject> = new Vector.<FlyObject>();
		
		private static var _container:Sprite;
		private static var _rootContainer:DisplayObjectContainer;
		
		private static var _addInterval:int = 500;
		private static var _timer:Timer;
		private static var _prevAddTime:int;
		
		public static var isInited:Boolean;
		
		public function FlyManager()
		{
		}
		
		public static function init(rootContainer:DisplayObjectContainer, addInterval:int = 500, excuteInterval:int = 40):void
		{
			_rootContainer = rootContainer;
			_container = new Sprite();
			OptimizeUtil.optimizeRender(_container);
			_rootContainer.addChild(_container);
			
			_addInterval = addInterval;
			
			_timer = new Timer(excuteInterval);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			isInited = true;
		}
		
		public static function addChars(chars:FlyObject):void
		{
			if (!_timer.running)
				_timer.start();
			
			_cacheArr.push(chars);
		}
		
		private static function onTimer(event:TimerEvent):void
		{
			if (_cacheArr.length != 0)
			{
				var curTime:int = getTimer();
				if (curTime - _prevAddTime >= _addInterval)
				{
					var chars:FlyObject = _cacheArr.shift();
					_flyArr.push(chars);
					chars.show(_container, true);
					_prevAddTime = curTime;
				}
			}
			if (_flyArr.length == 0)
			{
				_timer.stop();
				return;
			}
			for (var i:int = 0; i < _flyArr.length; i++)
			{
				chars = _flyArr[i];
				if (chars.isArried && chars.isDisappeared)
				{
					_flyArr.shift();
					chars.hide();
					chars.destory();
					chars  = null;
				}
				else
				{
					chars.update();
				}
			}
		}
		
		public static function dispose():void
		{
			_rootContainer = null;
			_flyArr = null;
			if (_timer)
			{
				_timer.stop();
				_timer = null;
			}
		}
		
	}
}