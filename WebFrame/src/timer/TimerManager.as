package timer
{
	import utils.debug.LogUtil;

	public class TimerManager
	{
		private var timers:Vector.<BaseTimer> = null;
		private var freeIndexs:Vector.<int> = null;
		private var currentLength:int = 0;
		
		public function TimerManager()
		{
			timers = new Vector.<BaseTimer>();
			freeIndexs = new Vector.<int>();
		}
		
		public function activate():void
		{
			var i:int = 0;
			while(i < currentLength)
			{
				var ntimer:BaseTimer = timers[i];
				if (ntimer != null)
					ntimer.update();
				i++;
			}
		}
		
		public function register(baseTimer:BaseTimer):int
		{
			var index:int = 0;
			if (freeIndexs.length == 0)
			{
				index = timers.push(baseTimer);
				currentLength = index;
				index -= 1;
			}
			else
			{
				index = freeIndexs.pop();
				LogUtil.assert(timers[index] == null);
				timers[index] = baseTimer;
			}
			return index;
		}
		
		public function unregister(timerID:int):Boolean
		{
			if (timerID >= timers.length || timers[timerID] == null)
				return false;
			
			freeIndexs.push(timerID);
			timers[timerID] = null;
			return true;
		}
	}
}