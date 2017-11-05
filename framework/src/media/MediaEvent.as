package media
{
	import flash.events.Event;
	
	public class MediaEvent extends Event
	{
		public static const DATA_SYNC:String = "DATA_SYNC";
		public static const PLAYING:String = "PLAYING";
		public static const BUFFERING:String = "BUFFERING";
		public static const PLAY_COMPLETE:String = "PLAY_COMPLETE";
		public static const LOADING:String = "LOADING";
		public static const LOAD_COMPLETE:String = "LOAD_COMPLETE";
		
		public function MediaEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}