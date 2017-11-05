package loader
{
	import flash.events.Event;
	
	public class LoadEvent extends Event
	{
		public static const LoadComplete:String = "LoadComplete";
		public static const AtOnceLoading:String = "AtOnceLoading";
		public static const AtOnceLoadEnd:String = "AtOnceLoadEnd";
		private var _data:Object;
		
		public function LoadEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_data = data;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new LoadEvent(type, _data, bubbles, cancelable);
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
	}
}