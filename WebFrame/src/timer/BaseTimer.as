package timer
{
	import flash.utils.getTimer;
	
	import resource.pools.Reuse;
	import resource.pools.ObjectPool;

	public class BaseTimer extends Reuse
	{
		protected var _timerID:int = -1;
		protected var _repeatCount:int;
		protected var _interval:int;
		protected var _lastUpdateTime:int = 0;
		protected var _isExactCount:Boolean = true;
		protected var _callback:Function;
		
		public function BaseTimer(interval:int, repeatCount:int = 1, callback:Function = null)
		{
			_interval = interval;
			_repeatCount = repeatCount;
			_callback = callback;
		}
		
		public function start():void
		{
			if (_repeatCount == -1)
				return;
			if (_timerID !=0)
				return;
			_lastUpdateTime = getTimer();
			_timerID = FrameWork.timerManager.register(this);
		}
		
		public function stop():void
		{
			if (_timerID == -1)
				return;
			_lastUpdateTime = 0;
			FrameWork.timerManager.unregister(_timerID);
			_timerID = -1;
		}
		
		internal function update():void
		{
			if (_lastUpdateTime == 0)
			{
				_lastUpdateTime = getTimer();
				return;
			}
			
			var currentTime:int = getTimer();
			var elapsed:int = currentTime - _lastUpdateTime;
			
			if (!_isExactCount)
			{
				if (elapsed > _interval)
				{
					excuteCallback();
					_lastUpdateTime = currentTime;
					return;
				}
			}
			while (isRuning && elapsed > _interval)
			{
				excuteCallback();
				elapsed -= _interval;
			}
			_lastUpdateTime = currentTime - elapsed;
		}
		
		private function excuteCallback():void
		{
			if (_callback != null)
				_callback.call(null);
			_repeatCount --;
			if (_repeatCount <= 0)
				stop();
		}
		
		/**
		 * 卡顿时,  是否追加触发, 以保证触发次数绝对正确
		 * */
		public function set isExactCount(value:Boolean):void
		{
			_isExactCount = value;
		}
		
		public function get timerID():int
		{
			return _timerID;
		}
		
		public function get isRuning():Boolean
		{
			return (_timerID != -1);
		}
		
		public function get leftCount():int
		{
			return _repeatCount;
		}
		
		override protected function reset():void
		{
			 _timerID = -1;
			_repeatCount = 0;
			_interval = 0;
			_lastUpdateTime = 0;
			_isExactCount = true;
			_callback = null;
		}
		
	}
}