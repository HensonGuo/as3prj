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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	import fluid.Melt;
	
	import test.BaseTest;
	
	/**
	 * MariFace
	 * This is ALFluid sample.
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 * @link http://alumican.net/
	 */
	
	public class MariFace extends BaseTest
	{
		[Embed(source = "/../bin-debug/assets/jiehunzhao.png")] 
		private static const Nishimura:Class;
		public var target:Bitmap = new Nishimura();
		
		public function MariFace(stage:Stage):void
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			var source:BitmapData = new BitmapData(target.width, target.height, false);
			source.draw(target);
			
			//create instance
			var melt:Melt = new Melt(source, false, 10, target.width, target.height);
			
			//config
			melt.fluidMagnitude = 50.0;  //default 150
			melt.fluidFlowSize  = 1.5;   //default 2
		//	melt.fluidUseDecay = false;  //default true
		//	melt.fluidUseMouse = false;  //default true
		//	melt.fluidCanvasTone = new ColorMatrixFilter();
			
			//set mouse event
			melt.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				melt.fluidUseDecay = !melt.fluidUseDecay;
			});
			
			melt.x = target.x;
			melt.y = target.y;
			
			addChild(melt);
		}
		
		
	}
}