/**
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
package effect.fluid
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import fluid.Melt;
	
	import test.BaseTest;
	
	import utils.debug.Stats;
	
	/**
	 * LiquidVideo
	 * This is ALFluid sample.
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 * @link http://alumican.net/
	 */
	
	public class LiquidVideo extends BaseTest
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		private const FLUID_WIDTH:Number  = 500;
		private const FLUID_HEIGHT:Number = 500;
		
		
		
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		
		private var _melt:Melt;
		private var _source:BitmapData;
		private var _stats:Stats
		
		
		
		
		
		private var _container:Sprite;
		
		private var _ns:NetStream;
		private var _nc:NetConnection;
		private var _video:Video;
		
		private var _credit:Credit;
		private var _usage:Usage;
		private var _background:Sprite;
		
		
		
		
		
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
		public function LiquidVideo(stage:Stage):void
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			_initialize();
		}
		
		/**
		 * initialize
		 */
		private function _initialize():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _initialize);
			addEventListener(Event.REMOVED_FROM_STAGE, _finalize);
			
			//stage setting
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//background
			_background = new Sprite();
			addChild(_background);
			
			//sprite for adding to stage
			_container = new Sprite();
			addChild(_container);
			
			//credit
			_credit = new Credit();
			_credit.blendMode = BlendMode.INVERT;
			
			//move mouse on movie
			_usage = new Usage();
			_usage.blendMode = BlendMode.INVERT;
			
			//check status
			_stats = new Stats( {
				bg:0xffffff,
				fps:0x333333,
				ms:0x333333,
				mem:0x333333,
				memmax:0x333333
			});
			_stats.blendMode = BlendMode.DARKEN;
			addChild(_stats);
			
			//add event handler
			stage.addEventListener(Event.RESIZE, _resizeHandler);
			stage.addEventListener(MouseEvent.CLICK, _clickHandler);
			
			//centering
			_resizeHandler();
			
			//load video
			_loadVideo("如果这都不算爱.flv");
		}
		
		/**
		 * finalize
		 */
		private function _finalize(e:Event):void
		{
			_ns.close();
			removeEventListener(Event.REMOVED_FROM_STAGE, _finalize);
			_ns.removeEventListener(NetStatusEvent.NET_STATUS, _videoNetStatusHandler);
			stage.removeEventListener(Event.RESIZE, _resizeHandler);
		}
		
		
		
		
		
		//--------------------------------------
		// METHODS
		//--------------------------------------
		
		/**
		 * load video
		 * @param	url
		 */
		private function _loadVideo(url:String):void
		{
			_nc = new NetConnection();
			_nc.connect(null);
			
			_ns = new NetStream(_nc);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, _videoNetStatusHandler);
			_ns.client = { onMetaData:function(param:Object):void { } };
			_ns.play(url);
			
			_video = new Video();
			_video.attachNetStream(_ns);
		}
		
		/**
		 * draw background
		 */
		private function _refillBackground():void
		{
			var sw:int = stage.stageWidth;
			var sh:int = stage.stageHeight;
			
			var g:Graphics = _background.graphics;
			g.clear();
			g.beginFill(0xffffff);
			g.moveTo(0 , 0 );
			g.lineTo(sw, 0 );
			g.lineTo(sw, sh);
			g.lineTo(0 , sh);
			g.lineTo(0 , 0 );
			g.endFill();
		}
		
		
		
		
		
		//--------------------------------------
		// EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * event handler called when net status is changed 
		 * @param	e
		 */
		private function _videoNetStatusHandler(e:NetStatusEvent):void 
		{
			switch(e.info.code)
			{
				case "NetStream.Buffer.Full":
					
					_video.width  = 300;
					_video.height = 225;
					_video.x      = uint((FLUID_WIDTH  - _video.width ) / 2);
					_video.y      = uint((FLUID_HEIGHT - _video.height) / 2);
					
					_source = new BitmapData(_video.width, _video.height, false);
					
					//melt target
					_melt = new Melt(_source, false, 20, FLUID_WIDTH, FLUID_HEIGHT);
					_melt.x = _video.x;
					_melt.y = _video.y;
					_container.addChild(_melt);
					
				//	_melt.fluid.addOrientedForce(256, 256, 100, 100, 2);
					
					//add other objects
					_credit.x = _video.x - 5;
					_credit.y = _video.y + _video.height + 40;
					_container.addChild(_credit);
					
					_usage.x = _video.x + _video.width + 25;
					_usage.y = _video.y - 25;
					_container.addChild(_usage);
					
					//default volume is too large
					var st:SoundTransform = _ns.soundTransform;
					st.volume = 0.3;
					_ns.soundTransform = st;
					
					_ns.removeEventListener(NetStatusEvent.NET_STATUS, _videoNetStatusHandler);
					addEventListener(Event.ENTER_FRAME, _update);
					break;
			}
		}
		
		/**
		 * update source bitmapdata
		 * @param	e
		 */
		private function _update(e:Event):void
		{
			_source.draw(_video);
		}
		
		/**
		 * event handler called when click on stage
		 * @param	e
		 */
		private function _clickHandler(e:MouseEvent):void {
			
			//switch using decay
			_melt.fluidUseDecay = !_melt.fluidUseDecay;
		}
		
		/**
		 * event handler called when stage is resized
		 * @param	e
		 */
		private function _resizeHandler(e:Event = null):void
		{
			_refillBackground();
			
			_container.x = uint((stage.stageWidth  - FLUID_WIDTH ) / 2);
			_container.y = uint((stage.stageHeight - FLUID_HEIGHT) / 2);
			
			_stats.x = 2;
			_stats.y = stage.stageHeight - 45;
		}
	}
}