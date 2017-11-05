/**
 * CalenderModel
 * 
 * @author Copyright (C) 2011 Hiiragi, All Rights Reserved.
 * @version 1.0.0
 * @see http://www.libspark.org/wiki/CalenderModel
 * 
 * 
 * The MIT License
 * 
 * Copyright (c) 2011 Hiiragi
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


package canlender.model 
{
	
	/**
	 * CalenderModelのインターフェイスクラスです。
	 * 
	 * @author Hiiragi
	 */
	public interface ICalenderModel 
	{
		
		/**
		 * 指定した年月のカレンダーを配列として返します。
		 * 
		 * @param	year	取得したいカレンダーの年の値です。
		 * @param	month	取得したいカレンダーの月の値です。
		 * @return	カレンダーの配列です。
		 */
		function getCalender(year:uint = 0, month:uint = 0):Array;
	}
	
}