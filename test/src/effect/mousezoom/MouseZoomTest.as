package effect.mousezoom
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import mouseZoom.controls.MouseSmoothScaleControl;
	
	import test.BaseTest;
	
	public class MouseZoomTest extends BaseTest
	{
		private var _scaleControl:MouseSmoothScaleControl = null;
		
		public function MouseZoomTest(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			var scaleControl:MouseSmoothScaleControl = new MouseSmoothScaleControl();
			scaleControl.width = this.stage.stageWidth;
			scaleControl.height = this.stage.stageHeight;
			scaleControl.content =  new MouseZoomContent();
			//  MouseSmoothScaleControl のインスタンスをステージに配置します。
			this.addChild(scaleControl);
			
			this._scaleControl = scaleControl;
			// ステージの設定をします。
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			// ステージサイズが変更されたときのハンドラを設定します。
			this.stage.addEventListener(Event.RESIZE, this.onStageResize);
		}
		
		private function onStageResize(event:Event):void
		{
			this._scaleControl.width = this.stage.stageWidth;
			this._scaleControl.height = this.stage.stageHeight;
		}
	}
}