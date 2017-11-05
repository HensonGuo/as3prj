package effect
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import loader.type.LoadResType;
	
	import ripples.WarterRipples;
	
	import test.BaseTest;
	
	public class WarterRipplesTest extends BaseTest
	{
		public function WarterRipplesTest(stage:Stage)
		{
			FrameWork.start(false, stage);
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			_stage = stage
			
			FrameWork.loaderManager.loadRes(LoadResType.ImageFile, "assets/jiehunzhao.png", completeCallback);
		}
		
		private function completeCallback(url:String, child:DisplayObject):void {
			var  bitmap:BitmapData = new BitmapData(642, 477,true);
			bitmap.draw(child,null,null,null,null,true);
			var waterripples:WarterRipples = new WarterRipples(bitmap);
			this.addChild(waterripples);
		}
		
	}
}