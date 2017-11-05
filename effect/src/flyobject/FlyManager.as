package flyobject
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import flyobject.type.BaseFlyObject;
	
	public class FlyManager
	{
		private static var _cacheArr:Vector.<BaseFlyObject> = new Vector.<BaseFlyObject>();
		private static var _flyArr:Vector.<BaseFlyObject> = new Vector.<BaseFlyObject>();
		
		private static var _container:Sprite;
		private static var _stage:Stage;
		
		private static var _addInterval:int = 500;
		private static var _timer:Timer;
		private static var _prevAddTime:int;
		
		public function FlyManager()
		{
		}
		
		public static function init(stage:Stage, addInterval:int = 500, excuteInterval:int = 40):void
		{
			_stage = stage;
			_container = new Sprite();
			_stage.addChild(_container);
			
			_addInterval = addInterval;
			
			_timer = new Timer(excuteInterval);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		public static function addChars(chars:BaseFlyObject):void
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
					var chars:BaseFlyObject = _cacheArr.shift();
					_flyArr.push(chars);
					_container.addChildAt(chars, 0);
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
					_container.removeChild(chars);
					chars.dispose();
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
			_stage = null;
			_flyArr = null;
			if (_timer)
			{
				_timer.stop();
				_timer = null;
			}
		}
		
	}
}