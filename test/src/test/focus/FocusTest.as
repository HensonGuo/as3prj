package test.focus
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	
	import test.BaseTest;
	
	public class FocusTest extends BaseTest
	{
		public function FocusTest(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			var text1:TextField = new TextField();
			text1.type = "input";
			text1.border = true;
			this.addChild(text1);
			
			var text2:TextField = new TextField();
			text2.type = "input";
			text2.border = true;
			text2.x = 200;
			this.addChild(text2);
		}
	}
}