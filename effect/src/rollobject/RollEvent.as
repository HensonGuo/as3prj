package rollobject
{
	import flash.events.Event;
	
	public class RollEvent extends Event
	{
		public static const FINISH:String = "FINISH";
		public static const START:String = "START";
		
		public function RollEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}