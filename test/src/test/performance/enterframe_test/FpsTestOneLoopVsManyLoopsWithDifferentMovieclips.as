package test.performance.enterframe_test
{
	import flash.display.Stage;
	import flash.events.Event;
	
	import test.ITest;
	
	import utils.debug.Profile;
	
	public class FpsTestOneLoopVsManyLoopsWithDifferentMovieclips implements ITest
	{
		private var _num:int=10000;
		//private var mcA:Array=[];
		private var _mcArray:Vector.<MCwithoutLoop> = new Vector.<MCwithoutLoop>(_num);
		// to use, comment-out one of the block comments in turn.  
		
		public function FpsTestOneLoopVsManyLoopsWithDifferentMovieclips()
		{
		}
		
		public function test(stage:Stage):void
		{
			// test 1.  each movieclip with its own enterframe loop
			// on my computer without cacheAsBitmap = true, the frame rate is between 9 and 10.
			// on my computer with cacheAsBitmap = true, the frame rate is between 12 and 13.
			for (var i:int=0; i<_num; i++) {
				var mc:MCwithLoop = new MCwithLoop();
				stage.addChild(mc);
				mc.mouseEnabled = false
				mc.mouseChildren = false
				mc.cacheAsBitmap = true;
			}
			
			// test 2.  use one enterframe loop and an array
			// on my computer without cacheAsBitmap = true, frame rate is about 17
			// on my computer with cacheAsBitmap = true, frame rate is about 26
			///*
			/*
			for (var i:int=0; i<_num; i++) {
				_mcArray[i] = new MCwithoutLoop();
				_mcArray[i].mouseEnabled = false;
				_mcArray[i].mouseChildren = false;
				stage.addChild(_mcArray[i]);
				_mcArray[i].cacheAsBitmap = true
			}
			startLoopF();
			*/
			//*/
			Profile.init(AnimeTest.rootContainer,3);
		}
		
		private function startLoopF():void{
			AnimeTest.rootContainer.stage.addEventListener(Event.ENTER_FRAME,moveFunction);
		}
		private function moveFunction(e:Event):void{
			var stage:Stage = AnimeTest.rootContainer.stage;
			for(var i:int=0; i<_mcArray.length; i++)
			{
				_mcArray[i].x+=_mcArray[i].speed*Math.cos(_mcArray[i].angle*Math.PI/180);
				_mcArray[i].y+=_mcArray[i].speed*Math.sin(_mcArray[i].angle*Math.PI/180);
				
				if(_mcArray[i].x>stage.stageWidth-_mcArray[i].width)
				{
					_mcArray[i].angle = 180-_mcArray[i].angle;
				}
				else if(_mcArray[i].x<0)
				{
					_mcArray[i].angle = 180-_mcArray[i].angle;
				} 
				else if(_mcArray[i].y>stage.stageHeight-_mcArray[i].height)
				{
					_mcArray[i].angle *= -1;
				} 
				else if(_mcArray[i].y<0)
				{
					_mcArray[i].angle *= -1;
				}
			}
		}
		
	}
}