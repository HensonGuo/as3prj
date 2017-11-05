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
	
	import canlender.model.holidays.HolidayDateSetter;
	import canlender.model.holidays.IHolydayList;
	import canlender.model.holidays.NullHolidayList;
	import canlender.model.vo.CalenderDateObject;
	import canlender.model.vo.HolidayObject;
	import canlender.utils.CalenderUtil;
	
	/**
	 * カレンダーを作成し、保持するモデルクラスです。
	 * @author Hiiragi
	 */
	public class CalenderModel extends CalenderModelBase
	{
		/**
		 * 生成したカレンダーを保存する内部オブジェクトです。
		 */
		protected var _calendars:Object;
		
		
		/**
		 * 祝日を保持するリストです。
		 */
		protected var _holidayList:IHolydayList;
		
		/**
		 * 祝日・祭日のリストを設定します。初期値は何の値も持っていないリストとなっています。
		 */
		public function get holidayList():IHolydayList { return _holidayList; }
		
		public function set holidayList(value:IHolydayList):void 
		{
			_holidayList = value;
		}
		
		/**
		 * 現在、内部で位置づけられている年を保持する内部オブジェクトです。
		 */
		protected var _currentYear:uint;
		/**
		 * 現在、内部で位置づけられている年を取得します.
		 * 
		 * <p>getNextMonthCalender()やgetLastMonthCalender()を使用する際に、この値と_currentMonthで次に取得する月を設定します。</p>
		 * 
		 * <p>指定の方法は、コンストラクタかgetCalender()のみとなります。</p>
		 */
		public function get currentYear():uint { return _currentYear; }
		
		
		/**
		 * 現在、内部で位置づけられている月を保持する内部オブジェクトです。
		 */
		protected var _currentMonth:uint;
		/**
		 * 現在、内部で位置づけられている月を取得します.
		 * 
		 * <p>getNextMonthCalender()やgetLastMonthCalender()を使用する際に、この値と_currentYearで次に取得する月を設定します。</p>
		 * 
		 * <p>指定の方法は、コンストラクタかgetCalender()のみとなります。</p>
		 */
		public function get currentMonth():uint { return _currentMonth; }
		
		
		/**
		 * コンストラクタです。引数で、内部に利用する年月を指定できます。指定しない場合、現在の年月を自動的に格納します。
		 * 
		 * @param	year	年の値です。
		 * @param	month	月の値です。
		 */
		public function CalenderModel(year:int = -1, month:int = -1) 
		{
			_calendars = { };
			_holidayList = new NullHolidayList();
			
			if (year == -1)
			{
				var currentDate:Date = new Date();
				year = currentDate.fullYear;
				month = currentDate.month + 1;
			}
			
			_currentYear = year;
			_currentMonth = month;
		}
		
		/**
		 * 指定した年月のカレンダーを配列として返します.
		 * 
		 * <p>引数を指定しなかった場合、内部で設定されている年月のカレンダーを返します。</p>
		 * 
		 * @param	year	取得したいカレンダーの年の値です。
		 * @param	month	取得したいカレンダーの月の値です。
		 * @return	カレンダーの配列です。
		 */
		override public function getCalender(year:uint = 0, month:uint = 0):Array
		{
			if (month == 0)
			{
				if (year == 0)
				{
					year = _currentYear;
					month = _currentMonth;
				}
				else
				{
					month = 1;
				}
			}

			var co:CalenderDateObject = CalenderUtil.reformatYMD(year, month);
			_currentYear = co.year
			_currentMonth = co.month;
			
			var key:String = CalenderUtil.createKey(_currentYear, _currentMonth);
			
			if (_calendars[key] == null)
			{
				//月のカレンダーを作る
				_calendars[key] = createCalender(_currentYear, _currentMonth);
			}
			
			return _calendars[key].concat();
		}
		
		/**
		 * 現在内部に保存している年月の翌月のカレンダーを取得します。
		 * 
		 * @return	翌月のカレンダーの配列です。
		 */
		public function getNextMonthCalender():Array
		{
			var co:CalenderDateObject = CalenderUtil.reformatYMD(_currentYear, _currentMonth + 1);
			_currentYear = co.year;
			_currentMonth = co.month;
			
			return getCalender(_currentYear, _currentMonth);
		}
		
		/**
		 * 現在内部に保存している年月の前月のカレンダーを取得します。
		 * 
		 * @return	先月のカレンダーの配列です。
		 */
		public function getLastMonthCalender():Array
		{
			var co:CalenderDateObject = CalenderUtil.reformatYMD(_currentYear, _currentMonth - 1);
			
			_currentYear = co.year;
			_currentMonth = co.month;
			return getCalender(_currentYear, _currentMonth);
		}
		
		/**
		 * 指定した年月のカレンダーを生成済みかを取得します。
		 * 
		 * @param	year	チェックしたい年の値です。
		 * @param	month	チェックしたい月の値です。
		 * @return	生成済みであればtrueを、なければfalseを返します。
		 */
		public function isExistCalender(year:uint, month:uint):Boolean
		{
			var co:CalenderDateObject = CalenderUtil.reformatYMD(year, month);
			var key:String = CalenderUtil.createKey(co.year, co.month);
			return (_calendars[key]) ? true : false;
		}
		
		
		/**
		 * カレンダーの配列を生成します。
		 * 
		 * @param	year	生成したいカレンダーの年の値です。
		 * @param	month	生成したいカレンダーの月の値です。
		 * @return	指定した年月のカレンダーの配列です。
		 */
		protected function createCalender(year:uint, month:uint):Array 
		{
			var co:CalenderDateObject = CalenderUtil.reformatYMD(year, month);
			year = co.year;
			month = co.month;
			
			var maxDate:uint;
			var calender:Array = [];
			var week:uint = 1;
			var day:uint;
			var lastWeekFlag:Boolean = false;
			
			
			if (month == 2)
			{
				//二月の場合はうるう年の計算
				if (CalenderUtil.isLeepYear(year)) maxDate = 29;
				else maxDate = 28;
			}
			else
			{
				maxDate = CalenderUtil.daysOfMonthList[month - 1];
			}
			
			for (var i:int = 1; i <= maxDate; i++)
			{
				if (i > maxDate - 7 && !lastWeekFlag) lastWeekFlag = true;
				
				day = CalenderUtil.calcurateDay(year, month, i);
				week = Math.ceil(i / 7);
				
				calender.push(new CalenderDateObject(year, month, i, day, checkHoliday(year, month, i, week, lastWeekFlag, day)));
			}
			
			
			return calender;
		}
		
		
		/**
		 * 引数で渡された情報と、保持している祝日・祭日のデータを元に、その年月日が祝日・祭日に当たるかを判断し、該当する祝日のデータを配列として返します。
		 * 
		 * @param	year	チェックしたい年の値です。
		 * @param	month	チェックしたい月の値です。
		 * @param	date	チェックしたい日の値です。
		 * @param	week	チェックしたい日が、その月の第何週であるかを指定します。
		 * @param	lastWeekFlag	チェックしたい日が、その月の最終週であるかを指定します。
		 * @param	day		チェックしたい曜日の値です。
		 * @return	祝日リストと照合し、その日の情報を埋め込んだ配列です。
		 */
		protected function checkHoliday(year:uint, month:uint, date:uint, week:uint, lastWeekFlag:Boolean, day:uint):Array
		{
			var datas:Array = _holidayList.getDatas();
			var resultArray:Array = [];
			
			if (datas.length > 0)
			{
				var dateStr:String;
				
				var len:int = datas.length;
				var item:HolidayObject
				var dateSetter:HolidayDateSetter
				var i:int;
				var j:int;
				var dayFlag:String
				var weekFlag:String
				
				var dateCountFromADZero:uint = CalenderUtil.calcurateDateCountFromZeroAD(year, month, date);
				
				for (i = 0; i < len; i++)
				{
					item = datas[i];
					
					//適用年月日の範囲内か調べる
					if (dateCountFromADZero >= item.startDateFromADZero && (item.endDateFromADZero == 0 || dateCountFromADZero <= item.endDateFromADZero))
					{
						
						for (j = 0; j < item.dates.length; j++) 
						{
							
							//登録されている月が同じか調べる
							dateSetter = item.dates[j];
							
							if (month == dateSetter.month)
							{
								
								//日付が一致するか調べる
								if (dateSetter.date is String)
								{
									//String型の場合は文字列を解析して調べる。
									dateStr = dateSetter.date;
									
									//曜日と週が該当するかを調べるための材料を抽出
									dayFlag = dateStr.replace(/.*(sun|mon|tue|wed|thu|fri|sat).*/, "$1");
									weekFlag = dateStr.replace(/.*(\d|last).*/, "$1");
									
									
									//曜日があってるか確認する
									if ((dayFlag == "sun" && day == 0) ||
										(dayFlag == "mon" && day == 1) ||
										(dayFlag == "tue" && day == 2) ||
										(dayFlag == "wed" && day == 3) ||
										(dayFlag == "thu" && day == 4) ||
										(dayFlag == "fri" && day == 5) ||
										(dayFlag == "sat" && day == 6))
									{
									
										//週の情報があってるかを調べる
										if (weekFlag == dateStr)
										{
											//週の識別子がなかったということで、毎週と認識する。
											//曜日はあってるので、あとは、例外と一致しなければ無条件に格納。
											if (!checkException(year, month, date, item.includeDates, item.excludeDates))
											{
												resultArray.push(item.data);
												break;
											}
										}
										else if ((weekFlag == "last" && lastWeekFlag) || (uint(weekFlag) == week))
										{
											//週があっていた場合にも格納。
											if (!checkException(year, month, date, item.includeDates, item.excludeDates))
											{
												resultArray.push(item.data);
												break;
											}
										}
									}
								}
								else if (dateSetter.date as uint && uint(dateSetter.date) == date)
								{
									//一致してればresultArrayに加える
									if (!checkException(year, month, date, item.includeDates, item.excludeDates))
									{
										resultArray.push(item.data);
										break;
									}
								}
							}
						}
						
					}
					
				}
			}
			
			return resultArray;
		}
		
		/**
		 * 指定した年月日がincludeDatesやexcludeDatesの例外範囲に入っているかの真偽値を返します。
		 * 
		 * @param	year	チェックしたい年の値です。
		 * @param	month	チェックしたい月の値です。
		 * @param	date	チェックしたい日の値です。
		 * @param	includeDates	「祝日に適合する日」を明示的に指定した配列です。
		 * @param	excludeDates	「祝日に適合しない日」を明示的に指定した配列です。
		 * @return	適合しない「例外な日」であればtrueを、適合する日であればfalseを返します。
		 */
		protected function checkException(year:uint, month:uint, date:uint, includeDates:Array, excludeDates:Array):Boolean
		{
			var resultBool:Boolean = true;
			var incLen:int = includeDates.length;
			var excLen:int = excludeDates.length;
			var holidaySetter:HolidayDateSetter;
			
			var i:int;
			
			//includeDatesがあった場合、一致する条件があるか調べる。
			if (incLen > 0)
			{
				//includeDates内に指定年月日が存在するか調べる。
				for (i = 0; i < incLen; i++)
				{
					holidaySetter = includeDates[i];
					if (year == holidaySetter.year && month == holidaySetter.month && date == holidaySetter.date)
					{
						//一致したものがあった場合、格納すべき情報なのでfalseを設定する（例外ではない）
						resultBool = false;
						break;
					}
				}
			}
			else
			{
				//includeDatesがない場合には、無条件でfalseを設定する。（すべてのデータが例外ではないため）
				resultBool = false;
			}
			
			//resultBoolがfalse（例外ではない）場合で、excludeDatesがあった場合、一致する条件があれば例外とする
			if (!resultBool && excLen > 0)
			{
				for (i = 0; i < excLen; i++)
				{
					holidaySetter = excludeDates[i];
					if (year == holidaySetter.year && month == holidaySetter.month && date == holidaySetter.date)
					{
						//一致したものがあった場合、例外のデータとなるので、trueに設定する。
						resultBool = true;
						break;
					}
				}
			}
			
			return resultBool;
		}
	}

}