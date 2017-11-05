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


package canlender.model.holidays 
{
	/**
	 * 祝日・祭日の日付をセットするための値オブジェクトです。
	 * 
	 * @author Hiiragi
	 */
	public class HolidayDateSetter extends Object 
	{
		/**
		 * 最終の週を定義する定数です。
		 */
		public static const LAST:String = "last";
		
		/**
		 * 日曜日を定義する定数です。
		 */
		public static const SUN:String = "sun";
		
		/**
		 * 月曜日を定義する定数です。
		 */
		public static const MON:String = "mon";
		
		/**
		 * 火曜日を定義する定数です。
		 */
		public static const TUE:String = "tue";
		
		/**
		 * 水曜日を定義する定数です。
		 */
		public static const WED:String = "wed";
		
		/**
		 * 木曜日を定義する定数です。
		 */
		public static const THU:String = "thu";
		
		/**
		 * 金曜日を定義する定数です。
		 */
		public static const FRI:String = "fri";
		
		/**
		 * 土曜日を定義する定数です。
		 */
		public static const SAT:String = "sat";
		
		
		private var _year:uint;
		/**
		 * 祝日・祭日の年を取得・設定します。
		 */
		public function get year():uint { return _year; }
		
		public function set year(value:uint):void 
		{
			_year = value;
		}
		
		
		private var _month:uint;
		/**
		 * 祝日・祭日の月を取得・設定します。
		 */
		public function get month():uint { return _month; }
		
		public function set month(value:uint):void 
		{
			_month = value;
		}
		
		
		
		private var _date:*;
		/**
		 * 祝日・祭日の日を取得・設定します。String型かuint型である必要があります.
		 * 
		 * <p>例えば、第2木曜日を指定する際には文字列で
		 * 
		 * <listing>HolidayDateSetter.THU + 2</listing>
		 * 
		 * とする必要があります。</p>
		 * 
		 * <p>「順序」は関係なく、「数字の型」は文字列型、数値型、どちらでも構いません。また、最終月曜日を指定する場合には、
		 * 
		 * <listing>HolidayDateSetter.LAST + HolidayDateSetter.MON</listing>
		 * 
		 * と設定します。これも順序は関係ありません。</p>
		 */
		public function get date():* { return _date; }
		
		public function set date(value:*):void 
		{
			if (value is String || value as uint) _date = value;
			else throw new Error("HolidayDateSetterに設定するdateは既定のString型か、日付のuint型である必要があります。");
		}
		
		
		/**
		 * コンストラクタです.
		 * 
		 * <p>dateの指定はObject型となっており、String型、uint型を渡すことができます。詳細はdateプロパティを参照してください。</p>
		 * 
		 * @see #date
		 * 
		 * @param	year	年の値です。
		 * @param	month	月の値です。
		 * @param	date	日の値です。
		 */
		public function HolidayDateSetter(year:uint, month:uint, date:*) 
		{
			_year = year;
			_month = month;
			this.date = date;
		}
		
	}

}