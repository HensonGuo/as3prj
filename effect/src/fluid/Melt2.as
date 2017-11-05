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
package fluid
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import fluid.core.*;
	
	/**
	 * Melt
	 * addChild(new Melt(target));
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 * @link http://alumican.net/
	 */
	public class Melt2 extends Sprite
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//config param
		
		/**
		 * this is margin around fluid target, if width or height are 0 at Constructor.
		 * change before doing addChild(new Melt(target)).
		 */
		static public var FLUID_DEFAULT_MARGIN:Number = 100;
		
		
		
		
		
		/**
		 * zeros
		 */
		private const ZERO_POINT:Point = new Point(0,0);
		
		
		
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		
		/**
		 * whether it gradually returns it to shape in the origin or not
		 */
		public function get fluidUseDecay():Boolean { return _fluidUseDecay; }
		public function set fluidUseDecay(value:Boolean):void { _fluidUseDecay = value; }
		private var _fluidUseDecay:Boolean;
		
		/**
		 * whether it accept mouse motion as external force.
		 * if it is false, you can add external force to fluid by fluid.addOrientedForce(x, y, forceX, forceY, fluidFlowSize).
		 */
		public function get fluidUseMouse():Boolean { return _fluidUseMouse; }
		public function set fluidUseMouse(value:Boolean):void { _fluidUseMouse = value; }
		private var _fluidUseMouse:Boolean;
		
		/**
		 * ColorMatrixFilter for erasing overflowing fluid gradually
		 */
		public function get fluidCanvasTone():ColorMatrixFilter { return _fluidCanvasTone; }
		public function set fluidCanvasTone(value:ColorMatrixFilter):void { _fluidCanvasTone = value; }
		private var _fluidCanvasTone:ColorMatrixFilter;
		
		/**
		 * magnitude of mouse influence
		 */
		public function get fluidFlowSize():Number { return _fluidFlowSize; }
		public function set fluidFlowSize(value:Number):void { _fluidFlowSize = value; }
		private var _fluidFlowSize:Number;
		
		/**
		 * magnitude of flow
		 */
		public function get fluidMagnitude():Number { return _fluid.magnitude; }
		public function set fluidMagnitude(value:Number):void { _fluid.magnitude = value; }
		
		
		
		
		
		/**
		 * bounds of fluid target
		 */
		public function get clipRect():Rectangle { return _clipRect; }
		private var _clipRect:Rectangle;
		
		/**
		 * display BitmapData
		 */
		public function get canvas():BitmapData { return _canvas; }
		private var _canvas:BitmapData;
		
		/**
		 * fluid target
		 */
		public function get target():DisplayObject { return _target; }
		private var _target:DisplayObject;
		
		/**
		 * fluid core class
		 */
		public function get fluid():Fluid { return _fluid; }
		private var _fluid:Fluid;
		
		/**
		 * fluid width
		 */
		public function get fluidWidth():uint { return _fluid.width; }
		
		/**
		 * fluid height
		 */
		public function get fluidHeight():uint { return _fluid.height; }
		
		
		
		
		
		/**
		 * bitmap for add to stage
		 */
		private var _container:Bitmap;
		
		/**
		 * matrix for centering fluid target on container
		 */
		private var _centering:Matrix;
		
		/**
		 * fluid DisplacementMapFilter
		 */
		private var _mapFilter:DisplacementMapFilter;
		
		/**
		 * old mouse x
		 */
		private var _oldX:Number = 0;
		
		/**
		 * old mouse y
		 */
		private var _oldY:Number = 0;
		
		/**
		 * whether mouse is moving or not
		 */
		private var _isMouseMove:Boolean = false;
		
		
		
		
		
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 */
		public function Melt2(
			target:DisplayObject,
			magnitude:uint      = 150,
			transparent:Boolean = false,
			fluidUseDecay:Boolean    = true,
			fluidUseMouse:Boolean    = true,
			gridSize:uint       = 20,
			fluidWidth:uint     = 0,
			fluidHeight:uint    = 0,
			clipRect:Rectangle  = null
		):void
		{
			//fluid target
			_target = target;
			
			_fluidUseDecay = fluidUseDecay;
			_fluidUseMouse = fluidUseMouse;
			
			fluidWidth  = (fluidWidth  != 0) ? fluidWidth  : (_target.width  + FLUID_DEFAULT_MARGIN * 2);
			fluidHeight = (fluidHeight != 0) ? fluidHeight : (_target.height + FLUID_DEFAULT_MARGIN * 2);
			
			if (!clipRect)
			{
				var targetRect:Rectangle = _target.getRect(_target);
				
				_clipRect = new Rectangle(
					targetRect.x, // + (_targetRect.width  - _target.width ) / 2, 
					targetRect.y, // + (_targetRect.height - _target.height) / 2, 
					_target.width, 
					_target.height
				);
			}
			else
			{
				_clipRect = clipRect;
			}
			
			_initialize(magnitude, transparent, gridSize, fluidWidth, fluidHeight);
		}
		
		
		
		
		
		//--------------------------------------
		// METHODS
		//--------------------------------------
		
		/**
		 * initialize
		 */
		private function _initialize(magnitude:uint, transparent:Boolean, gridSize:uint, fluidWidth:uint, fluidHeight:uint):void
		{
			x = _target.x;
			y = _target.y;
			_target.visible = false;
			
			//create fluid system
			_fluid = new Fluid(
				fluidWidth, 
				fluidHeight, 
				gridSize, 
				magnitude
			);
			
			//get DisplacementMapFilter applied to canvas
			_mapFilter = _fluid.mapFilter;
			
			//ColorMatrixFilter for erasing overflowing fluid gradually
			_fluidCanvasTone = (transparent) ?
				new ColorMatrixFilter([
					1, 0, 0, 0  , 5,
					0, 1, 0, 0  , 5,
					0, 0, 1, 0  , 5,
					0, 0, 0, .98, -1
				])
				:
				new ColorMatrixFilter([
					1, 0, 0, 0, 5,
					0, 1, 0, 0, 5,
					0, 0, 1, 0, 5,
					0, 0, 0, 0, 0
				]);
			
			var targetRect:Rectangle = _target.getRect(_target);
			
			//centering target in fluid field
			_centering = new Matrix();
			_centering.scale(_target.width / targetRect.width, _target.height / targetRect.height);
			_centering.tx = uint((fluidWidth  - _clipRect.width ) / 2) - _clipRect.x;
			_centering.ty = uint((fluidHeight - _clipRect.height) / 2) - _clipRect.y;
			
			//bitmap for add to stage
			_container = new Bitmap();
			_container.x = -_centering.tx;
			_container.y = -_centering.ty;
			addChild(_container);
			
			_clipRect.x += _centering.tx;
			_clipRect.y += _centering.ty;
			
			/*
			var rect:Sprite = new Sprite();
			rect.graphics.lineStyle(1, 0x000000, 1);
			rect.graphics.drawRect(_clipRect.x, _clipRect.y, _clipRect.width, _clipRect.height);
			rect.x = -_centering.tx;
			rect.y = -_centering.ty;
			addChild(rect);
			*/
			
			//bitmap data for draw
			_canvas = new BitmapData(fluidWidth, fluidHeight, transparent, 0xffffff);
			_container.bitmapData = _canvas;
			
			//default flow size
			_fluidFlowSize = 2;
			
			//add event handler
			addEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveHandler);
			addEventListener(Event.ENTER_FRAME, _update);
		}
		
		/**
		 * kill events
		 */
		private function kill():void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveHandler);
			removeEventListener(Event.ENTER_FRAME, _update);
		}
		
		/**
		 * update canvas
		 * @param	e
		 */
		private function _update(e:Event):void
		{
			//apply mouse velocity to force
			if (_fluidUseMouse && _isMouseMove)
			{
				var speedX:Number = _container.mouseX - _oldX;
				var speedY:Number = _container.mouseY - _oldY;
				
				_fluid.addOrientedForce(_container.mouseX, _container.mouseY, speedX, speedY, _fluidFlowSize);
				
				_isMouseMove = false;
			}
			
			//update flow
			_fluid.updateFlow(_fluidUseDecay);
			
			//update displacement map
			_fluid.updateMap();
			
			//draw
			_canvas.lock();
			_canvas.applyFilter(_canvas, _canvas.rect, ZERO_POINT, _fluidCanvasTone);
			_canvas.draw(_target, _centering, null, null, _clipRect);
			_canvas.applyFilter(_canvas, _canvas.rect, ZERO_POINT, _mapFilter);
			_canvas.unlock();
			
			//save mouse position
			_oldX = _container.mouseX;
			_oldY = _container.mouseY;
		}
		
		/**
		 * event handler called when mouse move
		 * @param	e
		 */
		private function _mouseMoveHandler(e:MouseEvent):void
		{
			_isMouseMove = true;
		}
	}
}