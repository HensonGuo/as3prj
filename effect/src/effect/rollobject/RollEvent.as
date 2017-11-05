package effect.rollobject
{
	import flash.events.Event;
	
	public class RollEvent extends Event
	{
		public static const ROLL_START:String = "ROLL_START";
		public static const ROLL_END:String = "ROLL_END";
		
		public function RollEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}