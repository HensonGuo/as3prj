package test
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import loader.type.LoadResType;
	
	import utils.DrawUtils;
	
	public class Stage3DLayer extends BaseTest
	{
		public function Stage3DLayer(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			var sprite:Sprite = new Sprite();
			DrawUtils.drawBg(sprite, 100, 100);
			this.addChild(sprite);
			FrameWork.start(false, stage);
			FrameWork.loaderManager.loadRes(LoadResType.SWFFile, "StarlingLearn.swf", loadStage3dSWFComplete);
			FrameWork.loaderManager.loadRes(LoadResType.SWFFile, "竹叶.swf", loadNormalSWFComplete);
		}
		
		private function loadStage3dSWFComplete(url:String, obj:DisplayObject):void
		{
			this.addChildAt(obj, 1);
		}
		
		private function loadNormalSWFComplete(url:String, obj:DisplayObject):void
		{
			obj.alpha = 0.5;
			this.addChildAt(obj, 0);
		}
	}
}