package test
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	public class BaseTest extends Sprite
	{
		protected var _stage:Stage;
		
		public function BaseTest(stage:Stage)
		{
			_stage = stage;
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(event:Event):void
		{
		}
		
		override public function get stage():Stage
		{
			return _stage;
		}
	}
}