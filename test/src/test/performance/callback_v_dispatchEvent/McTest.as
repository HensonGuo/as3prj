package test.performance.callback_v_dispatchEvent
{
	import flash.display.MovieClip;
	
	public class McTest extends MovieClip
	{
		public var callback:Function;
		
		public function McTest()
		{
			super();
			
			this.addFrameScript(100, callback);
			
			trace("totalFrames:" + this.totalFrames)
		}
	}
}