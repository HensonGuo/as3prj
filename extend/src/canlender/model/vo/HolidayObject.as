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
	import canlender.model.holidays.HolidayDateSetter;
	import canlender.utils.CalenderUtil;
	
	/**
	 * HolidayListで祝日や特別な日を設定するために必要なクラスです。
	 * 
	 * @author Hiiragi
	 */
	public final class HolidayObject extends Object 
	{
		
		private var _holidayName:String;
		/**
		 * 祝日の名前を取得、設定します。
		 */
		public function get holidayName():String { return _holidayName; }
		
		public function set holidayName(value:String):void 
		{
			_holidayName = value;
		}
		
		
		private var _data:Object;
		/**
		 * 祝日のデータを取得、設定します.
		 * 
		 * <p>holidayNameプロパティを設定した場合、このObjectのnameキーにholidayNameが設定されます。
		 * 祝日名以外に必要なデータ（URL、説明等）がある場合には、任意のキーで設定してください。</p>
		 * 
		 * <p>また、祝日を設定したい場合には、CalenderUtilクラスのNATIONAL_HOLIDAY定数を、このObjectのtypeキーに設定する必要があります。
		 * 祝日ではなく、それに付随する休日や特別な日であった場合は、CalenderUtilクラスのADDITIONAL_NATIONAL_HOLIDAY定数をこのObjectのtypeキーに設定してください。</p>
		 * 
		 * @see jp.melancholy.utils.CalenderUtil
		 */
		public function get data():Object { return _data; }
		
		public function set data(value:Object):void 
		{
			_data = value;
		}
		
		
		private var _dates:Array;
		/**
		 * 祝日の日付を設定したHolidayDateSetterオブジェクトを格納するプロパティです。
		 * 
		 * 配列の中身はHolidayDateSetterオブジェクトのみが格納されている必要があります。
		 */
		public function get dates():Array { return _dates; }
		
		public function set dates(value:Array):void 
		{
			_dates = value;
		}
		
		
		private var _startYear:uint;
		/**
		 * 祝日の制定が施行された年を設定します。
		 */
		public function get startYear():uint { return _startYear; }
		
		public function set startYear(value:uint):void 
		{
			_startYear = value;
			_startDateFromADZero = CalenderUtil.calcurateDateCountFromZeroAD(_startYear, _startMonth, _startDate);
		}
		
		
		private var _startMonth:uint;
		/**
		 * 祝日の制定が施行された月を設定します。
		 */
		public function get startMonth():uint { return _startMonth; }
		
		public function set startMonth(value:uint):void 
		{
			_startMonth = value;
			_startDateFromADZero = CalenderUtil.calcurateDateCountFromZeroAD(_startYear, _startMonth, _startDate);
		}
		
		
		private var _startDate:uint;
		/**
		 * 祝日の制定が施行された日を設定します。
		 */
		public function get startDate():uint { return _startDate; }
		
		public function set startDate(value:uint):void 
		{
			_startDate = value;
			_startDateFromADZero = CalenderUtil.calcurateDateCountFromZeroAD(_startYear, _startMonth, _startDate);
		}
		
		
		
		private var _endYear:int;
		/**
		 * 祝日の制定が廃止された年を設定します。
		 */
		public function get endYear():int { return _endYear; }
		
		public function set endYear(value:int):void 
		{
			_endYear = value;
			_endDateFromADZero = CalenderUtil.calcurateDateCountFromZeroAD(_endYear, _endMonth, _endDate);
		}
		
		
		private var _endMonth:int;
		/**
		 * 祝日の制定が廃止された月を設定します。
		 */
		public function get endMonth():int { return _endMonth; }
		
		public function set endMonth(value:int):void 
		{
			_endMonth = value;
			_endDateFromADZero = CalenderUtil.calcurateDateCountFromZeroAD(_endYear, _endMonth, _endDate);
		}
		
		
		private var _endDate:int;
		/**
		 * 祝日の制定が廃止された日を設定します。
		 */
		public function get endDate():int { return _endDate; }
		
		public function set endDate(value:int):void 
		{
			_endDate = value;
			_endDateFromADZero = CalenderUtil.calcurateDateCountFromZeroAD(_endYear, _endMonth, _endDate);
		}
		
		
		private var _startDateFromADZero:uint;
		/**
		 * 祝日の制定が施行された日を、西暦0年からの日数を取得・設定します。設定すると、startYear, startMonth, startDateも再計算されて設定されます。
		 */
		public function get startDateFromADZero():uint { return _startDateFromADZero; }
		
		public function set startDateFromADZero(value:uint):void 
		{
			_startDateFromADZero = value;
			var co:CalenderDateObject = CalenderUtil.calcurateDateFromZeroAD(value);
			_startYear = co.year;
			_startMonth = co.month;
			_startDate = co.date;
		}
		
		
		
		private var _endDateFromADZero:uint;
		/**
		 * 祝日の制定が廃止された日を、西暦0年からの日数を取得・設定します。設定すると、endYear, endMonth, endDateも再計算されて設定されます。
		 */
		public function get endDateFromADZero():uint { return _endDateFromADZero; }
		
		public function set endDateFromADZero(value:uint):void 
		{
			_endDateFromADZero = value;
			var co:CalenderDateObject = CalenderUtil.calcurateDateFromZeroAD(value);
			_endYear = co.year;
			_endMonth = co.month;
			_endDate = co.date;
		}
		
		
		private var _includeDates:Array;
		/**
		 * 指定した日のみ祝日として当てはめます。
		 * 
		 * 例えば、1980年に施行され、1985年に廃止された「12月12日に設定された祝日」があるとした場合、そして、そのうちの1982年と1984年にしか適用されない祝日の場合、
		 * この配列に1982年12月12日と1984年12月12日をそれぞれ設定したHolidayDateSetterオブジェクト群を格納すると、その設定した年のみ祝日として設定されます。
		 * 
		 * 配列の中身はHolidayDateSetterオブジェクトのみが格納されている必要があります。
		 */
		public function get includeDates():Array { return _includeDates; }
		
		public function set includeDates(value:Array):void 
		{
			_includeDates = value;
		}
		
		
		
		private var _excludeDates:Array;
		
		/**
		 * 指定した日は祝日としては当てはめずに除外します。優先度は一番高いです。
		 * 
		 * 例えば、1980年に施行され、1985年に廃止された「12月12日に設定された祝日」があるとした場合、そして、そのうちの1983年のみ特別な理由で祝日とならない場合、
		 * この配列に1983年12月12日を設定したHolidayDateSetterオブジェクトを格納すると、その日は祝日から除外されます。
		 * 
		 * 配列の中身はHolidayDateSetterオブジェクトのみが格納されている必要があります。
		 */
		public function get excludeDates():Array { return _excludeDates; }
		
		public function set excludeDates(value:Array):void 
		{
			_excludeDates = value;
		}
		
		
		/**
		 * コンストラクタです。
		 * 
		 * dates、includeDates、excludeDatesの配列の中身はHolidayDateSetterオブジェクトのみが格納されている必要があります。
		 * 
		 * @param	holidayName
		 * @param	dates
		 * @param	includeDates
		 * @param	excludeDates
		 * @param	data
		 * @param	startYear
		 * @param	startMonth
		 * @param	startDate
		 * @param	endYear
		 * @param	endMonth
		 * @param	endDate
		 */
		public function HolidayObject(holidayName:String,
										dates:Array,
										data:Object = null,
										includeDates:Array = null,
										excludeDates:Array = null,
										startYear:uint = 0, startMonth:uint = 1, startDate:uint = 1,
										endYear:int = -1, endMonth:int = -1, endDate:int = -1
										)
		{
			_holidayName = holidayName;
			
			if (!data) _data = {};
			else _data = data;
			
			_data.name = _holidayName;
			
			_dates = dates;
			_includeDates = (!includeDates) ? [] : includeDates;
			_excludeDates = (!excludeDates) ? [] : excludeDates;
			
			var date:*;
			
			for each (date in dates)
			{
				if (!date is HolidayDateSetter)
				{
					throw new Error("HolydayObject.datesの中に規定外の型が存在します。格納される型はHolidayDateSetter型のみです。");
				}
			}

			for each (date in _includeDates)
			{
				if (!date is HolidayDateSetter)
				{
					throw new Error("HolydayObject.includeDateの中に規定外の型が存在します。格納される型はHolidayDateSetter型のみです。");
				}
			}
			
			for each (date in _excludeDates)
			{
				if (!date is HolidayDateSetter)
				{
					throw new Error("HolydayObject.excludeDateの中に規定外の型が存在します。格納される型はHolidayDateSetter型のみです。");
				}
			}
			
			_startYear = startYear;
			_startMonth = startMonth;
			_startDate = startDate;
			_startDateFromADZero = CalenderUtil.calcurateDateCountFromZeroAD(_startYear, _startMonth, _startDate);
			
			_endYear = endYear;
			_endMonth = endMonth;
			_endDate = endDate;
			
			
			if (_endYear == -1 && _endMonth == -1 && _endDate == -1)
			{
				_endDateFromADZero = 0;
			}
			else if (_endYear > -1)
			{
				if (_endMonth == -1) _endMonth = 1;
				if (_endDate == -1) _endDate = 1;
				_endDateFromADZero = CalenderUtil.calcurateDateCountFromZeroAD(_endYear, _endMonth, _endDate);
			}
		}
		
	}

}