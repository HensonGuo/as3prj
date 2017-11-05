package effect
{
	import dot.DotFont;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import test.BaseTest;
	
	public class DotFontTest extends BaseTest
	{
		public function DotFontTest(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			var mc:DotFont;
			var child:DotFontTestMC = new DotFontTestMC();
			child.y = 300;
			this.addChild(child);
			
			child.submit.addEventListener(MouseEvent.CLICK,display);
			function display(event:MouseEvent):void{
				mc = new DotFont(child.fonttext.text,String(child.fonttype.value),Number(child.fontsize.value),Number(child.dot.value),Number(child.dotper.value),Number(child.mcsize.value));
				addChild(mc);
				mc.addChildChara(DotFont_mc);
				child.submit.visible=false;
				child.erase.visible=true;
			}
			
			child.erase.visible= false;
			child.erase.addEventListener(MouseEvent.CLICK,erase2);
			function erase2(event:MouseEvent):void{
				mc.removeChildChara();
				child.erase.visible=false;
				child.submit.visible=true;
			}
		}
		
		
	}
}