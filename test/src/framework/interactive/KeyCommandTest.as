package framework.interactive
{
	import flash.display.Stage;
	import flash.events.Event;
	
	import interactive.keyboard.KeyCommand;
	
	import test.BaseTest;
	
	public class KeyCommandTest extends BaseTest
	{
		public function KeyCommandTest(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			var k1:KeyCommand = new KeyCommand(KeyCommand.KONAMI_COMMAND, stage, 2000);
			k1.addEventListener(Event.COMPLETE, function(e:Event):void {
				trace("コナミコマンド!!!");
			});
			
			// 任意のコマンド
			var k2:KeyCommand = new KeyCommand(
				[{code:38}, {code:40}, {code:66, shift:true}, {code:65, shift:true}],
				stage, 5000);
			
			k2.addEventListener(Event.COMPLETE, function(e:Event):void {
				trace("command!!!")
			})
		}
	}
}