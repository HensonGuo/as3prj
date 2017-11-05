package effect.pageflip
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	
	import pageflip.book.Page;
	import pageflip.book.PageEvent;
	
	import test.BaseTest;
	
	public class PageFlipTest extends BaseTest
	{
		private var prevPage:DisplayObject;
		
		public function PageFlipTest(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			var page5:Page = new Page(stage, 200, 200, 250, 50, new Page1(), new Page1(), "Pages 5 and 6");
			page5.addEventListener(PageEvent.FLIP_START, onFlipStartHandler);
			page5.addEventListener(PageEvent.FLIP_COMPLETE, onFlipCompleteHandler);
			
			var page3:Page = new Page(stage, 200, 200, 250, 50, new Page1(), new Page1(), "Pages 3 and 4");
			page3.addEventListener(PageEvent.FLIP_START, onFlipStartHandler);
			page3.addEventListener(PageEvent.FLIP_COMPLETE, onFlipCompleteHandler);
			
			var page1:Page = new Page(stage, 200, 200, 250, 50, new Page1(), new Page1(), "Pages 1 and 2");
			page1.addEventListener(PageEvent.FLIP_START, onFlipStartHandler);
			page1.addEventListener(PageEvent.FLIP_COMPLETE, onFlipCompleteHandler);
		}
		
		private function onFlipStartHandler(event:PageEvent):void{
//			trace("Flip Started! " + event.page.getName() + " - " + event.targ);
			if(prevPage != null) 
				_stage.setChildIndex(event.targ,  _stage.numChildren - 1)
		}
		
		private function onFlipCompleteHandler(event:PageEvent):void{
//			trace("Flip Completed! " + event.page.getName() + " - " + event.targ);
			prevPage = event.targ;
		}
		
	}
}