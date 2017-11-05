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
	import flash.events.Event;
	
	public class AnimeEvent extends Event {
		
		/**
		* Defines the value of the type property of a progress event object.
		*/
		public static const PROGRESS:String = "progress";
		
		/**
		* The Event.COMPLETE constant defines the value of the type property of a complete event object.
		*/
		public static const COMPLETE:String = "complete";
		
		public function AnimeEvent(_type:String):void {
			super(_type, false, false);
		}
		
		public override function clone():Event {
			return new AnimeEvent(type);
		}
		
		public function get bytesLoaded():uint {
			return target.bytesLoaded;
		}
		
		public function get bytesTotal():uint {
			return target.bytesTotal;
		}
	}
}