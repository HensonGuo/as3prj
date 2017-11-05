package enterframe
{
	import flash.utils.getTimer;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class EnterFrameLearn extends Sprite
	{
		public function EnterFrameLearn()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded ( e:Event):void 
		{
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private var _prevTime:uint;
		private function onEnterFrame(event:Event):void
		{
			var curTime:int = getTimer();
			trace(curTime - _prevTime);
			_prevTime = curTime;
		}
		
	}
}