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


package canlender.model.vo 
{
	/**
	 * CalenderModelで取得したカレンダー配列に使用される値オブジェクトです。 
	 * このクラスの各プロパティは、コンストラクタに渡された引数からのみ設定できます。
	 * 
	 * @author Hiiragi
	 */
	public final class CalenderDateObject extends Object
	{
		
		private var _year:uint;
		/**
		 * インスタンスに設定されている年を取得します。
		 */
		public function get year():uint { return _year; }
		
		
		
		private var _month:uint;
		/**
		 * インスタンスに設定されている月を取得します。
		 */
		public function get month():uint { return _month; }
		
		
		
		private var _date:uint;
		/**
		 * インスタンスに設定されている日を取得します。
		 */
		public function get date():uint { return _date; }
		
		
		
		private var _day:int;
		/**
		 * インスタンスに設定されている曜日を取得します。
		 */
		public function get day():int { return _day; }
		
		
		private var _dataList:Array;
		/**
		 * インスタンスに設定されている情報を取得します.
		 * 
		 * <p>Arrayの中はその日付に関する情報の数だけObjectが入っています。詳しくはHolidayObjectクラスを参照してください。</p>
		 * 
		 * @see HolidayObject
		 */
		public function get dataList():Array { return _dataList; }
		
		
		/**
		 * コンストラクタです。
		 * 
		 * @param	year	格納したい年の値です。
		 * @param	month	格納したい月の値です。
		 * @param	date	格納したい日の値です。
		 * @param	day		格納したい曜日の値です。
		 * @param	dataList	この年月日に付与される休日・祝日・祭日・その他の情報です。
		 */
		public function CalenderDateObject(year:uint, month:uint, date:uint, day:int = -1, dataList:Array = null) 
		{
			_year = year;
			_month = month;
			_date = date;
			_day = day;
			
			if (dataList) _dataList = dataList;
			else _dataList = [];
		}
		
		/**
		 * 設定されている情報の一覧を取得できます.
		 * 
		 * <p>情報は以下のように出力されます。</p>
		 * 
		 * <listing>[year = 2000, month = 12, date = 23, day = 6, data = 天皇誕生日]</listing>
		 * 
		 * @return	情報一覧を記述した文字列です。
		 */
		public function toString():String
		{
			var resultStr:String = "[year = " + _year + " , month = " + _month + " , date = " + _date + " , day = " + _day
			var len:int = _dataList.length;
			
			if (len)
			{
				resultStr += ", data = ";
				
				for (var i:int = 0; i < len; i++)
				{
					resultStr += _dataList[i].name;
					if (i != len - 1) resultStr += " , ";
				}
			}

			
			resultStr += "]";
			
			return resultStr;
		}
	}

}