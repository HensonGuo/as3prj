﻿/**
 * Licensed under the MIT License
 * 
 * Copyright (c) 2009 alumican.net (www.alumican.net) and 
 *               Spark project (www.libspark.org)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package fluid.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.filters.BlurFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Fluid
	 * Class for express fluid
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 * @link http://alumican.net/
	 */
	public class Fluid2
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		private static const ZERO_POINT:Point = new Point(0, 0);
		
		
		
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		
		/**
		 * flow intensity
		 */
		public function get intensity():Number { return _intensity; }
		public function set intensity(value:Number):void { _colorAdjust = -128 * (_intensity = value); }
		private var _intensity:Number = 0.25;
		
		/**
		 * DisplacementMapFilter scale
		 */
		public function get magnitude():Number { return _mapFilter.scaleX; }
		public function set magnitude(value:Number):void { _mapFilter.scaleX = _mapFilter.scaleY = value; }
		
		/**
		 * DisplacementMapFilterMode
		 */
		public function get mapMode():String { return _mapFilter.mode; }
		public function set mapMode(value:String):void { _mapFilter.mode = value; }
		
		/**
		 * BlurFilter intensity applied to map of DisplacementMapFilter
		 */
		public function get blurIntensity():uint { return _blurFilter.blurX; }
		public function set blurIntensity(value:uint):void { _blurFilter.blurX = _blurFilter.blurY = value; }
		
		/**
		 * BlurFilter quality applied to map of DisplacementMapFilter
		 */
		public function get blurQuality():uint { return _blurFilter.quality; }
		public function set blurQuality(value:uint):void { _blurFilter.quality = value; }
		
		/**
		 * (0 to 1) number which controll the easiness of flow to extend
		 */
		public function get extendEasiness():Number { return _extendEasiness; }
		public function set extendEasiness(value:Number):void {
			_extendEasiness = (value <= 0) ? 0.01 : (value >= 1) ? 0.99 : value;
		}
		private var _extendEasiness:Number = 0.7;
		
		/**
		 * speed of decay when decay is used
		 */
		public function get decaySpeed():Number { return _decaySpeed; }
		public function set decaySpeed(value:Number):void { _decaySpeed = value; }
		private var _decaySpeed:uint = 1;
		
		
		
		
		
		/**
		 * grid cells (all cells). The cell on the edge is NOT participating in flow.
		 */
		public function cell(x:uint, y:uint):FluidData { return _cells[_heightCount * x + y]; }
		private var _cells:Array;
		
		/**
		 * all cell count
		 */
		public function get cellCount():uint { return _cellCount; }
		private var _cellCount:uint;
		
		/**
		 * map image width
		 */
		public function get width():uint { return _width; }
		private var _width:uint;
		
		/**
		 * map image height
		 */
		public function get height():uint { return _height; }
		private var _height:uint;
		
		/**
		 * division number of grid 
		 */
		public function get widthCount():uint { return _widthCount; }
		private var _widthCount:uint;
		
		/**
		 * division number of grid 
		 */
		public function get heightCount():uint { return _heightCount; }
		private var _heightCount:uint;
		
		/**
		 * cell(grid) size
		 */
		public function get gridSize():uint { return _gridSize; }
		private var _gridSize:uint;
		
		/**
		 * DisplacementMapFilter
		 */
		public function get mapFilter():DisplacementMapFilter { return _mapFilter; }
		private var _mapFilter:DisplacementMapFilter;
		
		
		
		
		
		/**
		 * BlurFilter applied to map of DisplacementMapFilter
		 */
		private var _blurFilter:BlurFilter;
		
		/**
		 * grid cells (exclude edge)
		 */
		private var _loops:Array;
		
		/**
		 * loops cell count
		 */
		private var _loopCount:uint;
		
		/**
		 * BitmapData for DisplacementMapFilter
		 */
		private var _mapBmd:BitmapData;
		
		/**
		 * flow size of external force
		 */
		private var _fluidFlowSize:Number;
		
		/**
		 * calculator of velocity and pressure value of each cell
		 */
		private var _calculator:FluidCalculator;
		
		/**
		 * some constants are calced on ahead for optimization
		 */
		private var _colorAdjust:Number;
		private var _distMin2:Number;
		private var _fluidFlowSize2:Number;
		
		
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 */
		public function Fluid2(
			width:uint,
			height:uint,
			gridSize:uint    = 20,
			magnitude:Number = 150
		):void
		{
			if (width < gridSize || height < gridSize)
			{
				throw new Error("Width or height must be larger than the gridSize.");
				return;
			}
			
			_width     = width;
			_height    = height;
			_gridSize  = gridSize;
			
			_initialize(magnitude);
		}
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// METHODS
		//--------------------------------------
		
		/**
		 * initialize
		 */
		private function _initialize(magnitude:Number):void
		{
			var i:uint;
			var j:uint;
			var data:FluidData;
			
			//division number of grid
			_widthCount  = uint( Math.ceil(width  / _gridSize) );
			_heightCount = uint( Math.ceil(height / _gridSize) );
			
			_cellCount = _widthCount * _heightCount;
			_cells = new Array(_cellCount);
			var p:uint = 0;
			
			//create temporary array to express 2-dimension grid 
			var cells2d:Array= new Array(_widthCount);
			for (i = 0; i < _widthCount; ++i)
			{
				cells2d[i] = new Array(_heightCount);
				for (j = 0; j < _heightCount; ++j)
				{
					data = new FluidData(i, j);
					cells2d[i][j] = data;
					_cells[p] = data;
					
					++p;
				}
			}
			
			//create 1-dimension array to put 2-dimension grid into linear
			_loops = new Array();
			
			//create linked list of each cell
			var w:uint = _widthCount  - 1;
			var h:uint = _heightCount - 1;
			var pi:uint = 0;
			var pj:uint = 0;
			for (i = 1; i < w; ++i)
			{
				for (j = 1; j < h; ++j)
				{
					//center
					data = cells2d[i][j] as FluidData;
					
					//around
					data.n00 = cells2d[i - 1][j - 1] as FluidData;
					data.n10 = cells2d[i    ][j - 1] as FluidData;
					data.n20 = cells2d[i + 1][j - 1] as FluidData;
					
					data.n01 = cells2d[i - 1][j    ] as FluidData;
					data.n21 = cells2d[i + 1][j    ] as FluidData;
					
					data.n02 = cells2d[i - 1][j + 1] as FluidData;
					data.n12 = cells2d[i    ][j + 1] as FluidData;
					data.n22 = cells2d[i + 1][j + 1] as FluidData;
					
					//prev and next to loop cells
					if (pi != 0)
					{
						data.prev = cells2d[pi][pj] as FluidData;
						data.prev.next = data;
					}
					
					_loops.push(data);
					
					pi = i;
					pj = j;
				}
			}
			_loopCount = _loops.length;
			
			//create BitmapData for DisplacementMapFilter
			_mapBmd = new BitmapData(_width, _height, false, 0x008080);
			
			//create DisplacementMapFilter
			_mapFilter = new DisplacementMapFilter();
			_mapFilter.mapBitmap  = _mapBmd;
			_mapFilter.mapPoint   = ZERO_POINT;
			_mapFilter.componentX = BitmapDataChannel.GREEN;
			_mapFilter.componentY = BitmapDataChannel.BLUE;
			_mapFilter.mode       = DisplacementMapFilterMode.CLAMP;
			_mapFilter.scaleX     = magnitude;
			_mapFilter.scaleY     = magnitude;
			
			//create BlurFilter 
			_blurFilter = new BlurFilter(32, 32, 2);
			
			//some constants are calced on ahead for optimization
			intensity = 0.25;
			_distMin2 = 4 * _gridSize * _gridSize;
			
			//create calculator of velocity and pressure value of each cell
			_calculator = new FluidCalculator();
		}
		
		/**
		 * add directional force to fluid map
		 * @param	x
		 * @param	y
		 * @param	forceX
		 * @param	forceY
		 */
		public function addOrientedForce(x:uint, y:uint, forceX:Number, forceY:Number, fluidFlowSize:Number = 2):void
		{
			var s:uint = _gridSize;
			var n:uint = _loopCount;
			var cell:FluidData = _loops[0] as FluidData;
			
			_fluidFlowSize2 = fluidFlowSize * fluidFlowSize;
			
			for (var i:uint = 0; i < n; ++i)
			{
				_calcOrientedForce(cell, x / s, y / s, forceX, forceY);
				cell = cell.next;
			}
		}
		
		/**
		 * add no-directional force to fluid map
		 * 
		 * TODO This method is under construction
		 * 
		 * @param	x
		 * @param	y
		 * @param	force
		 */
		public function addPointForce(x:uint, y:uint, force:Number = 0):void
		{
			var s:uint = _gridSize;
			var n:uint = _loopCount;
			var cell:FluidData = _loops[0] as FluidData;
			
			for (var i:uint = 0; i < n; ++i)
			{
				_calcPointForce(cell, x / s, y / s, force);
				cell = cell.next;
			}
		}
		
		/**
		 * update flow
		 * @param	useDecay
		 */
		public function updateFlow(useDecay:Boolean = true):void
		{
			if (useDecay) _decay();
			
			_updatePressure();
			_updateVelocity();
		}
		
		/**
		 * update map
		 * @return
		 */
		public function updateMap():BitmapData
		{
			var s:uint            = _gridSize;
			var n:uint            = _loopCount;
			var cell:FluidData = _loops[0] as FluidData;
			var map:BitmapData    = _mapBmd;
			
			map.lock();
			map.fillRect(map.rect, 0x008080);
			for (var i:uint = 0; i < n; ++i)
			{
				map.fillRect(
					new Rectangle(cell.x * s, cell.y * s, s, s),
					_calcMapColor(cell)
				);
				cell = cell.next;
			}
			map.applyFilter(map, map.rect, ZERO_POINT, _blurFilter);
			map.unlock();
			
			return map;
		}
		
		/**
		 * decay velocity field
		 */
		private function _decay():void
		{
			var n:uint = _cellCount;
			var cell:FluidData = _cells[0] as FluidData;
			
			for (var i:uint = 0; i < n; ++i)
			{
				_calcDecay(_cells[i]);
			}
		}
		
		/**
		 * update pressure value field
		 */
		private function _updatePressure():void
		{
			var n:uint = _loopCount;
			var cell:FluidData = _loops[0] as FluidData;
			
			for (var i:uint = 0; i < n; ++i)
			{
				_calcPressure(cell);
				cell = cell.next;
			}
		}
		
		/**
		 * update velocity field
		 */
		private function _updateVelocity():void
		{
			var n:uint = _loopCount;
			var cell:FluidData = _loops[0] as FluidData;
			
			for (var i:uint = 0; i < n; ++i)
			{
				_calcVelocity(cell);
				cell = cell.next;
			}
		}
		
		/**
		 * calc decay of velocity of each cell
		 * @param	data
		 */
		private function _calcDecay(data:FluidData):void
		{
			var g:Number = data.colorX;
			var b:Number = data.colorY;
			
			if (g != 128) data.colorX += (g < 128) ? _decaySpeed : -_decaySpeed;
			if (b != 128) data.colorY += (b < 128) ? _decaySpeed : -_decaySpeed;
		}
		
		/**
		 * calc pressure value of each cell
		 * @param	data
		 */
		private function _calcPressure(data:FluidData):void
		{ 
			data.pressure += _calculator.calcPressure(data);
			data.pressure *= _extendEasiness;
		}
		
		
		/**
		 * calc velocity of each cell
		 * @param	data
		 */
		private function _calcVelocity(data:FluidData):void
		{
			data.vx += _calculator.calcVelocityX(data);
			data.vy += _calculator.calcVelocityY(data);
			data.vx *= _extendEasiness;
			data.vy *= _extendEasiness;
		}
		
		/**
		 * calc directional external force of each cell
		 * @param	data
		 * @param	x
		 * @param	y
		 * @param	speedX
		 * @param	speedY
		 */
		private function _calcOrientedForce(data:FluidData, x:uint, y:uint, forceX:Number, forceY:Number):void
		{
			var dx:int       = data.x - x;
			var dy:int       = data.y - y;
			var dist2:Number = dx * dx + dy * dy;
			
			if (dist2 < _fluidFlowSize2)
			{
				var f:Number = (dist2 < _distMin2) ? 1.0 : (_fluidFlowSize / Math.sqrt(dist2));
				
				data.vx += forceX * f;
				data.vy += forceY * f;
			}
		}
		
		/**
		 * calc no-directional external force of each cell
		 * @param	data
		 * @param	x
		 * @param	y
		 * @param	power
		 */
		private function _calcPointForce(data:FluidData, x:uint, y:uint, force:Number = 0):void
		{
			/* under construction */
		}
		
		/**
		 * calc map color of each cell
		 * @param	data
		 */
		private function _calcMapColor(data:FluidData):uint
		{
			var g:int = Math.round( _colorAdjust * data.vx + data.colorX );
			var b:int = Math.round( _colorAdjust * data.vy + data.colorY );
			
			g = (g < 0) ? 0 : (g > 255) ? 255 : g;
			b = (b < 0) ? 0 : (b > 255) ? 255 : b;
			
			data.colorX = g;
			data.colorY = b;
			
			return data.color = g << 8 | b;
		}
		
		
		
		
		
		//--------------------------------------
		// EVENT HANDLERS
		//--------------------------------------
	}
}
