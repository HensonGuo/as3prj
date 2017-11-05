package effect
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	
	import loader.type.LoadResType;
	
	import ripples.Rippler;
	
	import test.BaseTest;
	
	public class RipplerTest extends BaseTest
	{
		public function RipplerTest(stage:Stage)
		{
			FrameWork.start(false, stage);
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			FrameWork.loaderManager.loadRes(LoadResType.ImageFile, "image1.jpg", completeCallback);
		}
		
		private function completeCallback(url:String, child:DisplayObject):void {
			this.addChild(child);
			var rippler:Rippler = new Rippler(this, 10, 5);
		}
		
	}
}