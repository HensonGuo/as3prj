package test.error
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLVariables;
	
	import test.BaseTest;
	
	import utils.StringUtil;
	
	public class ThrowIOErrorTest extends BaseTest
	{
		public function ThrowIOErrorTest(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
//			try
//			{
//				throw new IOErrorEvent("test");
//			}
//			catch(e:IOErrorEvent)
//			{
//				trace(e)
//			}
			var str:String = StringUtil.trim("http://192.168.10.201:8300/draw/state/?uid=20068527");
			
			var loaderBox:UrlLoaderBox = new UrlLoaderBox();
			var variables:URLVariables = new URLVariables();
			variables.begin = 0;
			variables.end = 30;
			loaderBox.load("http://192.168.10.201:8300/draw/winner_list", test, variables);
		}
		
		private function test(url:String, dataStr:String):void
		{
			trace(dataStr);
		}
	}
}