package display.window
{
	import flash.events.Event;

	public class WindowEvent extends Event
	{
		public static const ON_SHOW:String = "WINDOW_ONSHOW";
		public static const ON_HIDE:String = "WINDOW_ONHIDE";
		public static const UPDATE:String = "WINDOW_UPDATE";
		public static const ON_POS_CHANGE:String = "ON_POS_CHANGE";
		
		public var window:Class;
		
		public function WindowEvent(type:String, window:Class, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.window = window;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new WindowEvent(type, window, bubbles, cancelable);
		}
		
	}
}