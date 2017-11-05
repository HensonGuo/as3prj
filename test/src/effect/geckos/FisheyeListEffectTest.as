package effect.geckos
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	import geckos.FisheyeListEffect;
	
	import test.BaseTest;
	
	import utils.debug.Stats;
	
	public class FisheyeListEffectTest extends BaseTest
	{
		private var fisheyeListEffect:FisheyeListEffect;
		private var resources:Vector.<DisplayObject>;
		private var classArr:Array = [mc0, mc1, mc2, mc3, mc4, mc5, mc6, mc7, mc8, mc9, mc10, mc11, mc12, mc13, mc14, mc15, mc16, mc17, mc18, mc19];
		
		public function FisheyeListEffectTest(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			this.addChild(new Stats());
			this.resources = new Vector.<DisplayObject>();
			var mc:MovieClip;
			var MyClass:Class;
//			var mc:MovieClip = new mc0();
//			this.addChild(mc);
//			return;
			for (var i:int = 0; i < classArr.length; i += 1)
			{
//				MyClass = getDefinitionByName("mc" + i) as Class;
//				MyClass = ("mc" + i) as Class;
				mc = new classArr[i] as MovieClip;
				this.addChild(mc);
				this.resources.push(mc);
			}
			this.fisheyeListEffect = new FisheyeListEffect(stage, resources, 
				100, 300, 
				700, -80, 
				.3, 1, 
				FisheyeListEffect.HORIZONTAL);
			this.fisheyeListEffect.showBlur = true;
			this.fisheyeListEffect.showAlpha = true;
			this.fisheyeListEffect.addEventListener(FisheyeListEffect.SCROLL_COMPLETE, scrollCompleteHandler);
			
			this.fisheyeListEffect.autoScroll( -1);
			this.fisheyeListEffect.setPosByIndex(1);
			this.initEvent();
		}
		
		private function scrollCompleteHandler(event:Event):void 
		{
			trace("scrollComplete");
		}
		
		/**
		 * 初始化
		 */
		private function initEvent():void
		{
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDonwHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			this.stage.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function mouseUpHandler(event:MouseEvent):void 
		{
			//this.fisheyeListEffect.mouseUp();
		}
		
		private function mouseDonwHandler(event:MouseEvent):void 
		{
			if (event.target is Sprite)
			{	
				var mc:Sprite = event.target as Sprite;
				var index:int = this.resources.indexOf(mc);
				this.fisheyeListEffect.scrollByIndex(index);
			}
			//this.fisheyeListEffect.mouseDown();
		}
		
		private function loop(event:Event):void 
		{
			this.fisheyeListEffect.render();
		}
		
		private function onKeyDownHandler(event:KeyboardEvent):void 
		{
			this.fisheyeListEffect.setPosByIndex(1);
			trace(this.fisheyeListEffect.getCurPosIndex());
		}
	}
}