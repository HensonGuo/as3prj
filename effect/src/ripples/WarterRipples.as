package ripples
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
	
	public class WarterRipples extends Sprite
	{
		private var mouseDown:Boolean = false;
		//
		private var _result1:BitmapData;
		private var _result2:BitmapData;
		private var _source:BitmapData;
		private var _buffer:BitmapData;
		private var _output:BitmapData;
		private var _surface:BitmapData;
		private var _bounds:Rectangle;
		private var _origin:Point;
		private var _matrix1:Matrix;
		private var _matrix2:Matrix;
		private var _wave:ConvolutionFilter;
		private var _damp:ColorTransform;
		private var _water:DisplacementMapFilter;
		
		private var _applyBounds:Rectangle;
		
		public function WarterRipples(bitMapData:BitmapData)
		{
			_surface = bitMapData;
			_applyBounds = new Rectangle(0, 0, _surface.width *2, _surface.height * 2);
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(event:Event):void
		{
			waterWave();
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseEvent);
			stage.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		public function waterWave():void{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_result1 = new BitmapData(_surface.width, _surface.height, false, 128);
			_result2 = new BitmapData(_surface.width*2, _surface.height*2, false, 128);
			_source = new BitmapData(_surface.width, _surface.height, false, 128);
			_buffer = new BitmapData(_surface.width, _surface.height, false, 128);
			_output = new BitmapData(_surface.width*2, _surface.height*2, true, 128);
			_bounds = new Rectangle(0, 0, _surface.width, _surface.height);
			_origin = new Point();
			_matrix1 = new Matrix();
			_matrix2 = new Matrix();
			_matrix2.a = _matrix2.d=2;
			_wave = new ConvolutionFilter(3, 3, [1, 1, 1, 1, 1, 1, 1, 1, 1], 9, 0);
			_damp = new ColorTransform(0, 0, 9.960937E-001, 1, 0, 0, 2, 0);
			_water = new DisplacementMapFilter(_result2, _origin, 4, 4, 48, 48, "ignore");
			var _bg:Sprite = new Sprite();
			stage.addChild(_bg);
			_bg.graphics.beginFill(0xFF0000,0);
			_bg.graphics.drawRect(0,0,_surface.width, _surface.height);
			_bg.graphics.endFill();
			stage.addChild(new Bitmap(_output));
		}
		
		private function onMouseEvent(e:MouseEvent):void
		{
			mouseDown = e.type == MouseEvent.MOUSE_DOWN;
		}
		
		private function onEnterFrame(_e:Event):void{
			if (mouseDown)
			{
				var _x:Number = stage.mouseX/2;
				var _y:Number = stage.mouseY/2;
				_source.setPixel(_x+1, _y, 16777215);
				_source.setPixel(_x-1, _y, 16777215);
				_source.setPixel(_x, _y+1, 16777215);
				_source.setPixel(_x, _y-1, 16777215);
				_source.setPixel(_x, _y, 16777215);
			}
			// end if          
			_result1.applyFilter(_source, _bounds, _origin, _wave);
			_result1.draw(_result1, _matrix1, null, BlendMode.ADD);
			_result1.draw(_buffer, _matrix1, null, BlendMode.DIFFERENCE);
			_result1.draw(_result1, _matrix1, _damp);
			_result2.draw(_result1, _matrix2, null, null, null, true);
			_output.applyFilter(_surface, _applyBounds, _origin, _water);
			_buffer = _source;
			_source = _result1.clone();
		}
		
		
	}
}