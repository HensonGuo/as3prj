package test
{
	import flash.display.Stage;
	import flash.events.Event;
	
	import starling.core.Starling;

	public class Test4Starling extends BaseTest
	{
		protected var _starling:Starling;
		protected var _mainClass:Class;
		
		public function Test4Starling(mainClass:Class, stage:Stage)
		{
			super(stage);
			_mainClass = mainClass;
			if (stage.stageWidth>0 && stage.stageHeight>0)
				start();
			else
				stage.addEventListener(Event.RESIZE,onResize);
		}
		
		private function onResize(e:Event):void
		{
			if (_stage.stageWidth>0 && _stage.stageHeight>0)
			{
				_stage.removeEventListener(Event.RESIZE,onResize);
				start();
			}
		}
		
		private function start():void
		{
			Starling.handleLostContext = false;
			_starling = new Starling(_mainClass, _stage);
			_starling.enableErrorChecking = false;
			_starling.antiAliasing = 1;
			if (!_starling.isStarted)
				_starling.start();
		}
	}
}