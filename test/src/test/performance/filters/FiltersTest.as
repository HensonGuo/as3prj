package test.performance.filters
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.utils.Timer;
	
	import test.ITest;
	
	import utils.debug.Profile;
	
	public class FiltersTest implements ITest
	{
		public function FiltersTest()
		{
		}
		
		public function test(stage:Stage):void
		{
			Profile.init(AnimeTest.rootContainer,1);
			
			// fps 60, memory 12mb without filters (~8mb sprites)
			// fps 60, memory 14mb with filters
			
			var side:int = 10;
			var n:int = 2000;
			var i:int = 0;
			var sp:Sprite;
			var spV:Vector.<Sprite> = new Vector.<Sprite>(n);
			var bf:BlurFilter = new BlurFilter();
			
			// about 8mb of sprites.
			for(i=0;i<n;i++){
				sp = new Sprite();
				sp.mouseEnabled = false;
				sp.mouseChildren = false;
				// without filters,  8mb if cacheAsBitamp=false
				// with filters,11mb if cacheAsBitamp=false
				sp.cacheAsBitmap = true;
				with(sp.graphics){
					beginFill(0xffffff*Math.random());
					drawRect(0,0,side,side)
					endFill();
				}
				sp.x = i*(sp.width+side/2)%stage.stageWidth;
				sp.y = (sp.height+side/2)*int(i*(sp.width+side/2)/stage.stageWidth);
				stage.addChild(sp);
				spV[i] = sp;
			}
			
			var t:Timer = new Timer(500,0);
			t.addEventListener(TimerEvent.TIMER,f);
			t.start();
			
			function f(e:TimerEvent):void{
			if(e.currentTarget.currentCount%2==1){
			for(i=0;i<spV.length;i++){
			spV[i].filters = [bf];
			}
			} else {
			for(i=0;i<spV.length;i++){
			spV[i].filters = [];
			}
			}
			}
		}
		
	}
}