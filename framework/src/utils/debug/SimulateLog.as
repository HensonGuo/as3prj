package utils.debug
{
	import flash.utils.setTimeout;

	/**
	 *日志的模拟 
	 * @author g7842
	 * 
	 */	
	public class SimulateLog
	{
		private static var _initOver:Boolean = false;
		private static var _valueableKey:String;
		private static var _simulateCallback:Function;
		private var _excuteQueue:Vector.<String> = new Vector.<String>();
		private var _excuteTimeQueue:Vector.<int> = new Vector.<int>();
		
		public function SimulateLog()
		{
		}
		
		public static function init(valueableKey:String, simulateCallback:Function):void
		{
			_valueableKey = valueableKey;
			_simulateCallback = simulateCallback;
			_initOver = true;
		}
		
		public function start(log:String):void
		{
			LogUtil.assert(_initOver = true, "请先初始化模拟器");
			var arr:Array = log.split("\r");
			for (var i:int = 0; i < arr.length; i++)
			{
				var logField:String = arr[i];
				
				var index:int = logField.indexOf(_valueableKey);
				if (index == -1)
					continue;
				
				var timeEndIndex:int = logField.indexOf("[");
				var timerStr:String = logField.substring(16, timeEndIndex);
				var time:int = int(timerStr);
				
				var valuableField:String = logField.substring(index + _valueableKey.length);
				_excuteQueue.push(valuableField);
				_excuteTimeQueue.push(time);
			}
			if (_excuteQueue.length > 0)
				simulate();
		}
		
		private function simulate():void
		{
			//小于20ms的一次执行完毕
			var startIndexTime:int = _excuteTimeQueue[0];
			var count:int = 0;
			for (var i:int = 0; i < _excuteTimeQueue.length; i++)
			{
				var time:int = _excuteTimeQueue[i];
				if (time - startIndexTime > 20)
					break;
				else
					count = i;
			}
			var lastIndexTime:int = _excuteTimeQueue[count];
			//excute
			for (i = 0; i <= count; i++)
			{
				var str:String = _excuteQueue.shift();
				_excuteTimeQueue.shift();
				_simulateCallback.call(null, str);
			}
			if (_excuteQueue.length > 0)
			{
				var interval:int = _excuteTimeQueue[0] - lastIndexTime;
				setTimeout(simulate, interval);
			}
		}
		
		public function get isActived():Boolean
		{
			return _excuteQueue.length != 0;
		}
		
		public function get isOver():Boolean
		{
			return _excuteQueue.length == 0;
		}
		
		
	}
}