package interactive.keyboard
{
	import flash.events.Event;
	
	public class ShortCutsEvent extends Event
	{
		public var code:uint;
		public var isCtrl:Boolean;
		public var isShift:Boolean;
		
		public function ShortCutsEvent(type:String, code:uint, isCtrl:Boolean, isShift:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.code = code;
			this.isCtrl = isCtrl;
			this.isShift = isShift;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new ShortCutsEvent(type, code, isCtrl, isShift);
		}
	}
}