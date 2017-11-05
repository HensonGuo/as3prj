package test.videoTest
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.media.Video;
	
	import media.MediaEvent;
	import media.StreamMedia;
	
	import test.BaseTest;
	
	import utils.debug.LogUtil;
	import utils.trigger.Dispatcher;
	
	public class GerneralVideoTest extends BaseTest
	{
		private var _streamMedia:StreamMedia;
		private var _video:Video;
		
		public function GerneralVideoTest(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			Dispatcher.addEventListener(MediaEvent.DATA_SYNC, onDataSync);
			
			_video = new Video();
			stage.addChild(_video);
			
			//清晰
			_streamMedia = new StreamMedia("空口言.flv", 2000);
			//普通
//			_streamMedia = new StreamMedia("如果这都不算爱.flv", 2000);
			_streamMedia.beAttatchedByVideo(_video);
			_streamMedia.play();
			
		}
		
		private function onDataSync(e:MediaEvent):void
		{
			_video.width = _streamMedia.data["width"];
			_video.height = _streamMedia.data["height"];
		}
	}
}