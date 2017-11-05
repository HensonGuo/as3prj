/*
* Anime Class in ActionScript3
* Copyright (c) 2009 Takaaki Morita [tmdf.net]
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

package anime {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	public class Anime extends MovieClip {
		
		private var cels:Array;
		private var _centering:Boolean;
		private var _smoothing:Boolean;
		private var _bytesLoaded:Array;
		private var _bytesTotal:Array;
		private var _currentFrame:int;
		private var _totalFrames:int;
		
		/** Anime
		 * @param _head   head(ex:"image/")
		 * @param _num    middle(sequence number)
		 * @param _tail   tail(ex:".png")
		 * @param _begin  begining number
		 * @param _figure if 0 is not 
		 * @param _center true=centering on
		 * @param _smooth true=smoothing on
		 * @return void
		*/
		public function Anime(_head:String = "", _num:int = 1, _tail:String = ".png", _begin:int = 0, _figure:int = 0, _center:Boolean = false, _smooth:Boolean = false):void {
			
			cels = new Array();
			_centering = _center;
			_smoothing = _smooth;
			_bytesLoaded = new Array();
			_bytesTotal = new Array();
			_currentFrame = 1;
			_totalFrames = _num;
			
			var l:int = _begin + _num - 1;
			var loader:Loader;
			var file:String;
			var url:String;
			
			for (var i:int = _begin; i <= l; i ++) {
				
				file = String(i);
				if (_figure != 0) {
					file = ("0000000000" + file).substr(-_figure);
				}
				url = _head + file + _tail;
				loader = new Loader();
				loader.load(new URLRequest(url));
				
				addChild(loader);
				loader.visible = false;
				cels.push(loader);
				
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, Progress(i));
				if (i == l) {
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, Complete);
				}
			}
		}
		
		
		/** Progress
		 * @param _loader
		 * @return void
		*/
		private function Progress(_loader:int):Function {
			return function(e:ProgressEvent):void {
				_bytesLoaded[_loader] = e.bytesLoaded;
				_bytesTotal[_loader] = e.bytesTotal;
				dispatchEvent(new AnimeEvent("progress"));
			}
		}
		
		
		/** Completed
		 * @param e Eventt
		 * @return void
		*/
		private function Complete(e:Event):void {
			if (_centering) {
				this.centering = _centering;
			}
			if (_smoothing) {
				this.smoothing = _smoothing;
			}
			Show(_currentFrame);
			dispatchEvent(new AnimeEvent("complete"));
		}
		
		
		/** Show
		 * @return void
		*/
		private function Show(_frame:int):void {
			if (_frame < 1) {
				_frame = _totalFrames;
			}
			else if (_frame > _totalFrames) {
				_frame = 1;
			}
			cels[(_currentFrame - 1)].visible = false;
			cels[(_frame - 1)].visible = true;
			_currentFrame = _frame;
		}
		
		
		/** EnterFrame
		 * @param e Event
		 * @return 無し
		*/
		private function EnterFrame(e:Event):void {
			Show((currentFrame + 1));
		}
		
		
		/** gotoAndPlay
		 * @param _frame playhead to the specified frame
		 * @return void
		*/
		override public function gotoAndPlay(_frame:Object, _scene:String=null):void {
			Show(int(_frame));
			play();
		}
		
		
		/** gotoAndStop
		 * @param _frame playhead to the specified frame
		 * @return void
		*/
		override public function gotoAndStop(_frame:Object, _scene:String=null):void {
			Show(int(_frame));
			stop();
		}
		
		
		/** nextFrame
		 * @return void
		*/
		override public function nextFrame():void {
			Show((_currentFrame + 1));
			stop();
		}
		
		
		/** play
		 * @return void
		*/
		override public function play():void {
			addEventListener(Event.ENTER_FRAME, EnterFrame);
		}
		
		
		/** prevFrame
		 * @return void
		*/
		override public function prevFrame():void {
			Show((_currentFrame - 1));
			stop();
		}
		
		
		/** stop
		 * @return void
		*/
		override public function stop():void {
			removeEventListener(Event.ENTER_FRAME, EnterFrame);
		}
		
		
		/** centering
		 * @param _center true=on false=off
		 * @return void
		*/
		public function set centering(_center:Boolean):void {
			for (var i:int = 0; i < _totalFrames; i ++) {
				try {
					if (_center) {
						cels[i].x = -cels[i].width / 2;
						cels[i].y = -cels[i].height / 2;
					}
					else {
						cels[i].x = cels[i].y = 0;
					}
				}
				catch (e:Error) {
					
				}
			}
			_centering = _center;
		}
		
		/** centering
		 * @return true=on false=off
		*/
		public function get centering():Boolean {
			return _centering;
		}
		
		/** smoothing
		 * @param _smooth true=on false=off
		 * @return void
		*/
		public function set smoothing(_smooth:Boolean):void {
			for (var i:int = 0; i < _totalFrames; i ++) {
				try {
					var bmp:Bitmap = Bitmap(cels[i].content);
					bmp.smoothing = _smooth;
				}
				catch (e:Error) {
					
				}
			}
			_smoothing = _smooth;
		}
		
		/** smoothing
		 * @return true=on false=off
		*/
		public function get smoothing():Boolean {
			return _smoothing;
		}
		
		/** bytesLoaded
		 * @return bytes
		*/
		public function get bytesLoaded():uint {
			var data:uint = 0;
			for (var i:int = 0; i < _bytesLoaded.length; i ++) {
				try {
					data += _bytesLoaded[i];
				}
				catch (e:Error) {
					
				}
			}
			return data;
		}
		
		/** bytesTotal
		 * @return bytes
		*/
		public function get bytesTotal():uint {
			var data:uint = 0;
			for (var i:int = 0; i < _bytesTotal.length; i ++) {
				try {
					data += _bytesTotal[i];
				}
				catch (e:Error) {
					
				}
			}
			return data;
		}
		
		/** currentFrame
		 * @return current frame number
		*/
		override public function get currentFrame():int {
			return _currentFrame;
		}
		
		/** totalFrames
		 * @return total frame number
		*/
		override public function get totalFrames():int {
			return _totalFrames;
		}
	}
}