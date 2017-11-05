package frame
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import utils.trigger.Dispatcher;

	/**
	 * 执行有间隔
	 * 显示对象移除了显示列表将移除帧听
	 * 动态帧控制
	 * 默认24帧
	 * 不做动画处理18帧即可
	 * @author g7842
	 */	
	public class FrameManager
	{
		private var _renderframeLib:Dictionary = new Dictionary(true);
		private var _logicFrameLib:Dictionary = new Dictionary(true);
		private var _nextID:int;
		private var _curFrameCount:int;
		
		public function FrameManager()
		{
			Dispatcher.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			_curFrameCount ++;
			if (_curFrameCount % 2 == 0)
			{
				for (var key:String in _logicFrameLib)
				{
					var fr:Frame = _logicFrameLib[key];
					fr.update();
				}
			}
			for ( key in _renderframeLib)
			{
				fr = _renderframeLib[key];
			}
			fr.update();
		}
		
		internal function register(fr:Frame):int
		{
			_nextID ++;
			if (fr.type == FrameType.Logic)
				_logicFrameLib[_nextID] = fr;
			else
				_renderframeLib[_nextID] = fr;
			return _nextID;
		}
		
		internal function unregister(fr:Frame):void
		{
			if (fr.type == FrameType.Logic)
			{
				_logicFrameLib[fr.id] = null;
				delete _logicFrameLib[fr.id];
			}
			else
			{
				_renderframeLib[fr.id] = null;
				delete _renderframeLib[fr.id]
			}
		}
		
		public function excuteCount():int
		{
			return _curFrameCount;
		}
	}
}