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


package canlender.utils 
{
	import canlender.model.vo.CalenderDateObject;

	/**
	 * カレンダーの日付などを扱うためのユーティリティクラスです。
	 * 
	 * @author Hiiragi
	 */
	public final class CalenderUtil extends Object 
	{
		/**
		 * 国で定められた祝日・祭日を表す文字列です。
		 */
		public static const NATIONAL_HOLIDAY:String = "nationalHoliday";
		
		/**
		 * 祝日・祭日としては設定されていないが、それに関連して設定される法的な休日を表す文字列です.
		 * 
		 * <p>例：日本国憲法内、国民の祝日に関する法律の第三条第二項（振替休日）、第三項（国民の休日）。</p>
		 */
		public static const ADDITIONAL_NATIONAL_HOLIDAY:String = "additionalNationalHoliday";
		
		
		
		private static var _daysOfMonthList:Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		/**
		 * 月ごとの日数の配列です.
		 * 
		 * <p>インデックス0は1月、インデックス1は2月です。2月は28固定となっており、閏年は考慮されてません。必要に応じて、自身で演算を構築してください。</p>
		 */
		public static function get daysOfMonthList():Array { return _daysOfMonthList; }
		
		
		/**
		 * コンストラクタです。
		 * 
		 * @private
		 */
		public function CalenderUtil() 
		{
			throw new Error("このクラスはインスタンス化できません。静的メソッド、静的プロパティを使用してください。");
		}
		
		/**
		 * 月日が不正な値（大きすぎたり、0以下だったり）の場合、正常な年月日表示に修正します.
		 * 
		 * <p>この関数はcalcurateDay関数でも使用されており、この関数内でcalcurateDay関数を使用するとスタックオーバーフローが起きるため、曜日の計算は行っておりません。</p>
		 * 
		 * <listing>var co:CalenderDateObject = reformatYMD(2000, -1, -1);	//1999,10,29</listing>
		 * 
		 * @param	year	年の値です。
		 * @param	month	月の値です。
		 * @param	date	日の値です。
		 * @return	整理された年月日を格納したCalenderDateObjectです。
		 */
		public static function reformatYMD(year:uint, month:int, date:int = 1):CalenderDateObject 
		{
			
			//月がオーバーしていた際の処理
			if (month <= 0) month -= 1;
			if (month > 12 || month < 0)
			{
				year += Math.floor(month / 12);
				if (month > 12) month = Math.abs(month % 12);
				else month = 13 - Math.abs(month % 12);
			}
			
			//日の補正(日付が大きすぎる、或いは0以下の場合、閏年をまたいでしまう可能性があるため、この時点で年月日を作る必要がある)
			if (date > 0)
			{
				//多すぎたら年月を調整する
				while (date > _daysOfMonthList[month - 1])
				{
					//日の調整
					if (month == 2 && isLeepYear(year)) date -= 29; //閏年
					else date -= _daysOfMonthList[month - 1];
					
					//年月の調整
					if (month == 12)
					{
						year++;
						month = 1;
					}
					else
					{
						month++;
					}
				}
			}
			else
			{
				//年月を調整する
				while (date <= 0)
				{
					
					//年月の調整
					if (month == 1)
					{
						year--;
						month = 12;
					}
					else
					{
						month--;
					}
					
					//日の調整
					if (month == 2 && isLeepYear(year)) date += 29;	//閏年
					else date += _daysOfMonthList[month - 1];
				}
			}
			
			//return calcurateDateFromZeroAD(calcurateDateCountFromZeroAD(year, month, date));	//calcurateDateFromZeroADとcalcurateDateCountFromZeroADの確認用
			return new CalenderDateObject(year, month, date);
		}
		
		/**
		 * 年月日から曜日を計算します。
		 * 
		 * @param	year	年の値です。
		 * @param	month	月の値です。
		 * @param	date	日の値です。
		 * @return	計算された曜日の数値です。0が日曜日、1が月曜日・・・、6が土曜日となります。
		 */
		public static function calcurateDay(year:uint, month:int, date:int):uint
		{
			var co:CalenderDateObject = reformatYMD(year, month, date);
			year = co.year;
			month = co.month;
			date = co.date;
			
			//参考 ： http://www.h2.dion.ne.jp/~p_soul/jchieyoubi.htm
			
			if (month < 3)
			{
				year--;
				month += 13;
			}
			else
			{
				month++;
			}
			
			var day:uint = int(365.25 * year) + int(30.6 * month) + int(year / 400) + date - int(year / 100) - 429;
			
			day = day - int(day / 7) * 7;
			
			//月曜が0になってるので、ASの定義と一緒にするために、日曜を0にする
			day = (day + 1 == 7) ? 0 : day + 1;
			
			return day;
		}
		
		
		/**
		 * 保存用のキーを生成します。キーは[YYYYMM]形式です。
		 * 
		 * @param	year	年の値です。
		 * @param	month	月の値です。
		 * @return	生成されたキーです。
		 */
		public static function createKey(year:uint, month:int):String
		{
			var co:CalenderDateObject = reformatYMD(year, month);
			year = co.year;
			month = co.month;
			
			return year.toString() + StringUtil.fillZero(month, 2);
		}
		
		
		
		/**
		 * 西暦0年からの日数を返します。西暦0年を下回るものは0を返します。
		 * 
		 * @param	year	年の値です。
		 * @param	month	月の値です。
		 * @param	date	日の値です。
		 * @return	西暦0年からの日数です。
		 */
		public static function calcurateDateCountFromZeroAD(year:uint, month:int = 1, date:int = 1):uint
		{
			
			var co:CalenderDateObject = reformatYMD(year, month, date);
			year = co.year;
			month = co.month;
			date = co.date;
			
			//年と日と閏年の回数を合計する
			var resultDateCount:int = year * 365 + date + calcurateLeepYearCount((month <= 2) ? year - 1 : year);
			
			
			//上記の合計に月の日数を足し合わせる
			for (var i:int = 0; i < month - 1; i++)
			{
				resultDateCount += _daysOfMonthList[i];
			}
			
			//リミッター
			if (resultDateCount < 0) resultDateCount = 0;
			
			return uint(resultDateCount);
		}
		
		/**
		 * 西暦0年からの日数から、年月日を算出します。
		 * 
		 * @param	dateCount	西暦0年からの日数です。
		 * @return	算出された年月日を格納したCalenderDateObjectです。
		 */
		public static function calcurateDateFromZeroAD(dateCount:uint):CalenderDateObject
		{
			var remainingDays:uint = 0;
			
			//////////年数の計算
			
			//4年分の日数
			var fourYearUnit:uint = 365 * 3 + 366;
			
			//100年分の日数（100年で割り切れる年は閏年が平年になるのに注意）
			var oneHundredYearUnit:uint = fourYearUnit * 25 - 1;
			
			//400年分の日数（400年で割り切れる年は閏年になるのに注意）
			var fourHundredYearUnit:uint = oneHundredYearUnit * 4 + 1
			
			var fourHundredYearCount:uint = Math.floor(dateCount / fourHundredYearUnit);
			remainingDays = dateCount - fourHundredYearUnit * fourHundredYearCount;
			
			var oneHundredYearCount:uint = Math.floor(remainingDays / oneHundredYearUnit);
			if (oneHundredYearCount == 4) oneHundredYearCount = 3;
			remainingDays = remainingDays - oneHundredYearUnit * oneHundredYearCount;
			
			var fourYearCount:uint = Math.floor(remainingDays  / fourYearUnit);
			remainingDays = remainingDays - fourYearUnit * fourYearCount;
			
			var year:uint = Math.floor(remainingDays / 365);
			if (year == 4) year = 3;
			remainingDays = remainingDays - 365 * year;
			
			year += (fourHundredYearCount * 400) + (oneHundredYearCount * 100) + (fourYearCount * 4);
			
			//////////月数・日数の計算
			if (remainingDays <= 59) remainingDays += 1;
			
			var month:int = 1;
			
			while (remainingDays > _daysOfMonthList[month - 1])
			{
				remainingDays -= _daysOfMonthList[month - 1];
				month++;
			}
			
			
			return new CalenderDateObject(year, month, remainingDays);
		}
		
		/**
		 * 西暦0年からの閏年の回数を返します。
		 * 
		 * @param	year	現在の西暦年の値です。
		 */
		public static function calcurateLeepYearCount(year:uint):uint
		{
			return Math.floor(year / 4) - Math.floor(year / 100) + Math.floor(year / 400);
		}
		
		/**
		 * 指定の年が閏年か判断します。
		 * 
		 * @param	year	判定したい年の値です。
		 * @return	閏年であればtrue、そうでない場合はfalseを返します。
		 */
		public static function isLeepYear(year:uint):Boolean
		{
			return (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
		}
	}

}