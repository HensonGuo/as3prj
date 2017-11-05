package framework
{
	import display.menu.Menu;
	
	import extend.AnimeTest;
	
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.data.ListCollection;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class MenuTest extends Sprite
	{
		public function MenuTest()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded ( e:Event ):void 
		{
//			FrameWork.start(AnimeTest.stage, true, true, this.stage);
			var menu:Menu = new Menu();
			menu.intialize(["项目一", "项目二"], 60, 50);
			this.addChild(menu);
		}
		
	}
}