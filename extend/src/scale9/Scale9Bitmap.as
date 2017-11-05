/**
 *
 *	ScaleBitmap
 *	
 * 	@version	1.1
 * 	@author 	Didier BRUN	-  http://www.bytearray.org
 * 	
 * 	@version	1.2.1
 * 	@author		Alexandre LEGOUT - http://blog.lalex.com
 *
 * 	@version	1.2.2
 * 	@author		Pleh
 * 	
 * 	Project page : http://www.bytearray.org/?p=118
 *
 */

package scale9{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Scale9Bitmap extends Bitmap {
		
		protected var _isCleared:Boolean = true;
		protected var _isOnStage:Boolean = false;
		/**
		 * 临时性清除，以节省内存 
		 * 
		 */		
		public function clear():void
		{
			if(_createBitmap)
			{
//				Dbg.send("restore mem :" + (_createBitmap.width*_createBitmap.height*8));
				_isCleared = true;
				_createBitmap.dispose();
				_createBitmap = null;
			}
		}
		
		/**
		 * 恢复显示 
		 * 
		 */		
		public function restore():void
		{
//			Dbg.send("restore");
			if(_isCleared)
			{
				var tempScaleX:Number = this.scaleX;
				var tempScaleY:Number = this.scaleY;
				this.scaleX = 1;
				this.scaleY = 1;
				setSize(_width,_height);
				this.scaleX = tempScaleX;
				this.scaleY = tempScaleY;
			}
		}
		
		// ------------------------------------------------
		//
		// ---o properties
		//
		// ------------------------------------------------
		
		protected var _originalBitmap : BitmapData;
		protected var _createBitmap:BitmapData;
		protected var _scale9Grid : Rectangle = null;
		protected var _keepTexture:Boolean;//拉伸后保持花纹
		protected var _isDisposed:Boolean = true;
		
		// ------------------------------------------------
		//
		// ---o constructor
		//
		// ------------------------------------------------
		//keepTexture保持花纹，使用bitmapfill的方式拉伸，但效果还不够完美，纯色的最好使用非保持花纹的方式 
		
		function Scale9Bitmap(bmpData : BitmapData = null, pixelSnapping : String = "auto", smoothing : Boolean = false,keepTexture:Boolean = false) {
			
			_originalBitmap = bmpData;
			// super constructor
			super(_originalBitmap, pixelSnapping, smoothing);
			
			_keepTexture = keepTexture;
			// original bitmap
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			
		}
		
		public function createDisposeChildren():void
		{
			if(_isDisposed)
			{
//				// original bitmap
//				if( super.bitmapData )
//				{
//					_originalBitmap = super.bitmapData.clone();
//				}
				_isDisposed = false;
			}
		}
		
		private function onAddedToStage(e:Event):void
		{
			_isOnStage = true;
			this.restore();
		}
		
		private function onRemoveFromStage(e:Event):void
		{
			_isOnStage = false;
			this.clear();
		}
		
		// ------------------------------------------------
		//
		// ---o public methods
		//
		// ------------------------------------------------
		
		/**
		 * setter bitmapData
		 */
		override public function set bitmapData(bmpData : BitmapData) : void {
			_originalBitmap = bmpData;
			_width = bmpData.width;
			_height = bmpData.height;
			if (_scale9Grid != null) {
				if (!validGrid(_scale9Grid)) {
					_scale9Grid = null;
				}
				setSize(bmpData.width, bmpData.height);
			} else {
				assignBitmapData(_originalBitmap);
			}
		} 
		
		/**
		 * setter width
		 */
		override public function set width(w : Number) : void {
			if (w != width) {
				setSize(w, height);
			}
		}
		
		/**
		 * setter height
		 */
		override public function set height(h : Number) : void {
			if (h != height) {
				setSize(width, h);
			}
		}
		
		/**
		 * set scale9Grid
		 */
		override public function set scale9Grid(r : Rectangle) : void {
			// Check if the given grid is different from the current one
			if ((_scale9Grid == null && r != null) || (_scale9Grid != null && !_scale9Grid.equals(r))) {
				if (r == null) {
					// If deleting scalee9Grid, restore the original bitmap
					// then resize it (streched) to the previously set dimensions
					var currentWidth : Number = width;
					var currentHeight : Number = height;
					_scale9Grid = null;
					assignBitmapData(_originalBitmap);
					setSize(currentWidth, currentHeight);
				} else {
					if (!validGrid(r)) {
						throw (new Error("#001 - The _scale9Grid does not match the original BitmapData"));
						return;
					}
					
					_scale9Grid = r.clone();
					resizeBitmap(width, height);
					scaleX = 1;
					scaleY = 1;
				}
			}
		}
		
		/**
		 * assignBitmapData
		 * Update the effective bitmapData
		 */
		protected function assignBitmapData(bmp : BitmapData) : void {
			//			super.bitmapData.dispose();
			super.bitmapData = bmp;
		}
		
		private function validGrid(r : Rectangle) : Boolean {
			return r.right <= _originalBitmap.width && r.bottom <= _originalBitmap.height;
		}
		
		/**
		 * get scale9Grid
		 */
		override public function get scale9Grid() : Rectangle {
			return _scale9Grid;
		}
		
		
		/**
		 * setSize
		 */
		protected var _width:Number = -1;
		protected var _height:Number = -1;
		public function setSize(w : Number, h : Number) : void {

			if (_scale9Grid == null) {
				super.width = w;
				super.height = h;
			} else {
				if(_originalBitmap)
				{
					w = Math.max(w, _originalBitmap.width - _scale9Grid.width);
					h = Math.max(h, _originalBitmap.height - _scale9Grid.height);
				}
				resizeBitmap(w, h);
			}
			_width = w;
			_height = h;
		}
		
		/**
		 * get original bitmap
		 */
		public function getOriginalBitmapData() : BitmapData {
			return _originalBitmap;
		}
		
		// ------------------------------------------------
		//
		// ---o protected methods
		//
		// ------------------------------------------------
		
		/**
		 * resize bitmap
		 */
		private static var defaultBitmapData:BitmapData;
		protected function resizeBitmap(w : Number, h : Number) : void {
			//无效的宽度或高度时，不做拉伸处理
			if(!(w > 0 && h > 0)){
				return;
			}
			if(!_isOnStage)
			{
				if(!defaultBitmapData)
				{
					defaultBitmapData = new BitmapData(1,1);
				}
				assignBitmapData(defaultBitmapData);
			}
			if(_createBitmap)
			{
				_createBitmap.dispose();
			}
			_createBitmap = new BitmapData(w, h, true, 0x00000000);
			_isCleared = false;
			
			var rows : Array = [0, _scale9Grid.top, _scale9Grid.bottom, _originalBitmap.height];
			var cols : Array = [0, _scale9Grid.left, _scale9Grid.right, _originalBitmap.width];
			
			var dRows : Array = [0, _scale9Grid.top, h - (_originalBitmap.height - _scale9Grid.bottom), h];
			var dCols : Array = [0, _scale9Grid.left, w - (_originalBitmap.width - _scale9Grid.right), w];
			
			var origin : Rectangle;
			var draw : Rectangle;
			var mat : Matrix = new Matrix();
			var cx : int;
			var cy : int
			
			if(!_keepTexture)
			{
				for (cx = 0;cx < 3; cx++) {
					for (cy = 0;cy < 3; cy++) {
						origin = new Rectangle(cols[cx], rows[cy], cols[cx + 1] - cols[cx], rows[cy + 1] - rows[cy]);
						draw = new Rectangle(dCols[cx], dRows[cy], dCols[cx + 1] - dCols[cx], dRows[cy + 1] - dRows[cy]);
						mat.identity();
						mat.a = draw.width / origin.width;
						mat.d = draw.height / origin.height;
						mat.tx = draw.x - origin.x * mat.a;
						mat.ty = draw.y - origin.y * mat.d;
						_createBitmap.draw(_originalBitmap, mat, null, null, draw, smoothing);
					}
				}
				assignBitmapData(_createBitmap);
			}
			else
			{
				var shape:Shape = new Shape();
				var drawBitmapData:BitmapData;
				for (cx = 0; cx < 3; cx++) {
					
					for (cy = 0;cy <3; cy++) {
						draw = new Rectangle(cols[cx], rows[cy], cols[cx + 1] - cols[cx], rows[cy + 1] - rows[cy]);
						drawBitmapData = new BitmapData(cols[cx + 1] - cols[cx],rows[cy + 1] - rows[cy],true,0x00000000);
						drawBitmapData.copyPixels(_originalBitmap, draw, new Point(0,0));
						shape.graphics.clear();
						shape.graphics.beginBitmapFill(drawBitmapData);
						shape.graphics.drawRect(0, 0, dCols[cx + 1] - dCols[cx], dRows[cy + 1] - dRows[cy]);					
						var drawBitmapDataResized:BitmapData = new BitmapData(dCols[cx + 1] - dCols[cx], dRows[cy + 1] - dRows[cy], true, 0x00000000);
						draw = new Rectangle(0, 0, dCols[cx + 1] - dCols[cx], dRows[cy + 1] - dRows[cy]);
						drawBitmapDataResized.draw(shape);
						_createBitmap.copyPixels(drawBitmapDataResized, draw, new Point(dCols[cx], dRows[cy]));
						drawBitmapData.dispose();
						drawBitmapData = null;
						drawBitmapDataResized.dispose();
					}
				}
				assignBitmapData(_createBitmap);
			}
		}
		
//		protected function disposeBitmap():void
//		{
//			if(super.bitmapData)
//			{
//				super.bitmapData.dispose();
//				super.bitmapData = null;
//			}
//		}
		
		public function destory(isReuse:Boolean=true):void
		{
			if(_isDisposed)
			{
				return;
			}
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			clear();
			super.bitmapData = null;
//			disposeBitmap();
//			if(_originalBitmap)
//			{
//				_originalBitmap.dispose();
//				_originalBitmap = null;
//			}
			_isDisposed = true;
			_scale9Grid = null;
			_isCleared = true;
			_isOnStage = false;
			super.x = 0;
			super.y = 0;
		}
	}
}