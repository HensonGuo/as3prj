package mapchipx {
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author KAZUMiX
	 */
	public class ChipInfo {
		
		private var src:DisplayObjectContainer;
		private var srcBmd:BitmapData;
		private var rect:Rectangle;
		private var isTransparent:Boolean;
		
		public function ChipInfo(src:DisplayObjectContainer, chipWidth:uint, chipHeight:uint, isTransparent:Boolean = false) {
			this.src = src;
			this.isTransparent = isTransparent;
			srcBmd = new BitmapData(chipWidth, chipHeight, isTransparent);
			rect = new Rectangle(0, 0, srcBmd.width, srcBmd.height);
			update();
		}
		
		public function update():void {
			srcBmd.fillRect(rect, 0x00000000);
			srcBmd.draw(src, null, null, null, rect, false);
		}
		
		public function pasteTo(targetBmd:BitmapData, targetPoint:Point):void {
			targetBmd.copyPixels(srcBmd, rect, targetPoint);
		}
	}
	
}