package effect.mapchipx
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mapchipx.ChipInfo;
	import mapchipx.ChipInfoArray;
	import mapchipx.MapChipX;
	
	import test.BaseTest;
	
	public class MapChipX1 extends BaseTest
	{
		private var chipInfos:ChipInfoArray;
		private var map:Array = [];
		
		private var mapChipX:MapChipX;
		
		private var mapFrameWidth:int = 640;
		private var mapFrameHeight:int = 480;
		
		private var mapCenterX:Number = 0;
		private var mapCenterY:Number = 0;
		private var mapCenterRotation:Number = 0;
		
		private var fullscreen_btn:MovieClip;
		
		public function MapChipX1(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			setMapData();
			
			mapChipX = new MapChipX(map, chipInfos, mapFrameWidth, mapFrameHeight);
			addChild(mapChipX);
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler, false, 0, true);
			mapChipX.addEventListener(MouseEvent.CLICK, onMouseClickHandler, false, 0, true);
			buttonMode = true;
			
			setFullScreenBtn();
		}
		
		private function setMapData():void {
			var chipWidth:int = 320;
			var chipHeight:int = 240;
			var chipInfo:ChipInfo = new ChipInfo(new SampleMovie(), chipWidth, chipHeight);
			chipInfos = new ChipInfoArray(chipWidth, chipHeight);
			chipInfos.push(chipInfo);
			map[0] = [0];
		}
		
		private function onEnterFrameHandler(e:Event):void {
			update();
		}
		
		private function onMouseClickHandler(e:MouseEvent):void {
			switchRoll();
		}
		
		private function update():void {
			var frameCenterX:int = mapFrameWidth / 2;
			var frameCenterY:int = mapFrameHeight / 2;
			var ax:int = (mouseX - frameCenterX) / 5;
			var ay:int = (mouseY - frameCenterY) / 5;
			mapCenterX += ax;
			mapCenterY += ay;
			setMapCenterRotation();
			
			chipInfos[0].update();
			mapChipX.update(mapCenterX, mapCenterY, mapCenterRotation);
		}
		
		private var isRolling:Boolean = false;
		private var ar:Number = 1;
		
		private function switchRoll():void {
			if (isRolling) {
				isRolling = false;
				ar = 1;
			} else {
				isRolling = true;
			}
		}
		
		private function setMapCenterRotation():void {
			if (isRolling) {
				ar += 0.5;
				ar %= 360;
				mapCenterRotation += ar;
				mapCenterRotation %= 360;
				if (mapCenterRotation > 180) {
					mapCenterRotation -= 360;
				}
				return;
			}
			if (mapCenterRotation == 0) {
				return;
			}
			var dr:Number = (0 - mapCenterRotation) * 0.2;
			if (Math.abs(dr) < 0.1) {
				mapCenterRotation = 0;
				return;
			}
			mapCenterRotation += dr;
		}
		
		private function setFullScreenBtn():void {
			fullscreen_btn = new FullScreenBtn();
			fullscreen_btn.x = mapFrameWidth - 8 - fullscreen_btn.width;
			fullscreen_btn.y = mapFrameHeight - 8 - fullscreen_btn.height;
			fullscreen_btn.alpha = 1;
			fullscreen_btn.buttonMode = true;
			fullscreen_btn.mouseChildren = false;
			fullscreen_btn.addEventListener(MouseEvent.CLICK, onFullScreenBtnHandler, false, 0, true);
			this.addChild(this.fullscreen_btn);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenChangeHandler, false, 0, true);
		}
		
		private function onFullScreenBtnHandler(event:MouseEvent):void {
			if (stage.displayState == StageDisplayState.NORMAL) {
				stage.fullScreenSourceRect = new Rectangle(0,0,mapFrameWidth,mapFrameHeight);
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}else {
				stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		private function onFullScreenChangeHandler(event:FullScreenEvent):void {
			if (stage.displayState == StageDisplayState.NORMAL) {
				fullscreen_btn.gotoAndStop('fullscreen');
			}else {
				fullscreen_btn.gotoAndStop('window');
			}
		}
	}
}