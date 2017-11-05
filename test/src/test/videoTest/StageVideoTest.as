package test.videoTest
{
	import flash.display.Stage;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	
	import media.MediaEvent;
	import media.StreamMedia;
	
	import test.ITest;
	
	import utils.debug.LogUtil;
	import utils.trigger.Dispatcher;

	public class StageVideoTest implements ITest
	{
		private var _streamMedia:StreamMedia;
		private var _video:StageVideo;
		private var _stage:Stage;
		
		public function StageVideoTest()
		{
		}
		
		public function test(stage:Stage):void
		{
			_stage = stage;
			//清晰
			_streamMedia = new StreamMedia("空口言.flv", 2000);
			//普通
//			_streamMedia = new StreamMedia("如果这都不算爱.flv", 2000);
			
			stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoState); 
		}
		
		private function onStageVideoState(event:StageVideoAvailabilityEvent):void 
		{     
			// Detect if StageVideo is available and decide what to do in toggleStageVideo 
			toggleStageVideo(event.availability == StageVideoAvailability.AVAILABLE); 
		}
		
		private function toggleStageVideo(on:Boolean):void 
		{ 
			if (!on)
				return;
			_video = _stage.stageVideos[0];
			_video.addEventListener(StageVideoEvent.RENDER_STATE, stageVideoStateChange); 
			_streamMedia.beAttatchedByStageVideo(_video);
			_streamMedia.play();
		}
		
		private function stageVideoStateChange(e:StageVideoEvent):void
		{
			switch(e.status)
			{
				case "accelerated":
					LogUtil.info("StageVideo将使用硬件加速渲染视频");
					break;
				case "software":
					LogUtil.info("StageVideo通过软件模拟渲染视频,这个使用Video播放视频差不多,性能没有太大的提升");
					break;
				case "unavailable":
					LogUtil.info("StageVideo又不可用了");
					break;
			}
			resize();
		}
		
		private function resize ():void       
		{          
			var rc:Rectangle = new Rectangle(0, 0, _video.videoWidth, _video.videoHeight);       
			_video.viewPort = rc;       
		}
		
	}
}