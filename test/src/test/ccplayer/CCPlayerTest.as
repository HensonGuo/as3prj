package test.ccplayer
{
	import com.bit101.components.Slider;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.setTimeout;
	
	import loader.type.LoadResType;
	
	import test.BaseTest;
	
	public class CCPlayerTest extends BaseTest
	{
		private var _videoContent:DisplayObject;
		private var _videoOrgWidth:Number;
		private var _videoOrgHeight:Number;
		
		public function CCPlayerTest(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			var context:LoaderContext = new LoaderContext();
			var lder:Loader = new Loader();
//			lder.load(new URLRequest("http://service.hi.163.com/static/v/CCMediaPlayer.swf?v=0.3.9&/34092923&maxjitter=3000&geturl=1&minjitter=1200&delaymode=low&provider=rhttp&fwdexttime=1.2&buffertime=60&defaultip=114.113.200.201&file=34092923&maskinterval=30&debug=true&groupcgihost=group.v.cc.163.com&autoplay=true&src=cc&secret=fbe3babac0&localplayer=1&ctrbarvisible=false&nofullscreen=true"), context);
			lder.load(new URLRequest("http://static.youku.com/v1.0.0423/v/swf/loader.swf?VideoIDS=XNzg0MTI3NDIw&embedid=MjE4LjEwNy41NS4yNTMCMTk2MDMxODU1AgI%3D&wd=&vext=pid%3D%26emb%3DMjE4LjEwNy41NS4yNTMCMTk2MDMxODU1AgI%3D%26bc%3D%26type%3D03"), context);
			lder.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadCompelte);
		}
		
		private function onLoadCompelte(event:Event):void
		{
			var swf:LoaderInfo = event.target as LoaderInfo;
			 _videoContent = swf.content;
			this.addChild(_videoContent);
			
			setTimeout(onVideoResize, 2000);
			 
			 var silder:Slider = new Slider(Slider.VERTICAL, this, 200, 50);
		}
		
		private function onVideoResize():void
		{
			var boo:Boolean = stage.hasEventListener(Event.RESIZE);
			var obj:Object = _videoContent["player"]["exProxy"]["viewManager"];
			
			var setSizeFunc:Function = obj["setSize"];
			setSizeFunc(500, 400);
			
			
			 _videoOrgWidth = _videoContent.width;
			 _videoOrgHeight = _videoContent.height;
		}
		
	}
}