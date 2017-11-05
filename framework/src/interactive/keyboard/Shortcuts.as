package interactive.keyboard
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	import utils.trigger.Dispatcher;

	public class Shortcuts
	{
		private var _map:Dictionary = new Dictionary(true);
		public var enable:Boolean = true;
		
		public function Shortcuts(stage:Stage)
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if (!enable)
				return;
			var code:uint = event.keyCode;
			var isCtrl:Boolean = event.ctrlKey;
			var isShift:Boolean = event.shiftKey;
			if (!hasRegister(code))
				return;
			Dispatcher.dispatchEvent(new ShortCutsEvent(null, code, isCtrl, isShift));
		}
		
		/**
		 * register key code 
		 * @param args
		 * 
		 */		
		public function register(...args):void
		{
			for (var i:int = 0; i < args.length ; i++)
			{
				var code:uint = args[i];
				if (hasRegister(code))
					continue;
				_map[code] = code;
			}
		}
		
		public function unregister(...args):void
		{
			for (var i:int = 0; i < args.length ; i++)
			{
				var code:uint = args[i];
				args[code] = null;
				delete args[code];
			}
		}
		
		public function hasRegister(code:uint):Boolean
		{
			return _map[code] != null;
		}
		
		
	}
}