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
	import flash.events.Event;
	import canlender.model.holidays.IHolydayList;
	import canlender.model.holidays.lists.HolidayListJP;
	import canlender.model.vo.CalenderDateObject;
	import canlender.utils.CalenderUtil;
	
	/**
	 * isCalcVEDandAEDプロパティ（春分の日と秋分の日を計算するかを指定するプロパティ）が変化し、カレンダーを再構築し終わったときに出力されるイベントです.
	 * 
	 * <p>このイベントには、次のプロパティがあります。</p>
	 * 
	 * <table class="innertable">
	 * <tr><th>プロパティ</th><th>値</th></tr>
	 * <tr><td><code>bubbles</code></td><td><code>true</code></td></tr>
	 * <tr><td><code>cancelable</code></td><td><code>false</code> は、キャンセルするデフォルトの動作がないことを示します。</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>イベントリスナーで Event オブジェクトをアクティブに処理しているオブジェクトです。</td></tr>
	 * <tr><td><code>target</code></td><td>値が変更されたオブジェクトです。</td></tr>
	 * </table>
	 * 
	 * @eventType flash.events.Event.CHANGE
	 * 
	 */
	[Event(name = "change", type = "flash.events.Event")]
	
	
	
	/**
	 * 日本の祝日設定用にカスタマイズしたモデルクラスです.
	 * 
	 * 2012年現在の「国民の祝日に関する法律」に完全準拠しており、また、プロパティを設定することにより、2013年以降の春分の日・秋分の日を計算により付与します。
	 * 
	 * @author Hiiragi
	 */
	public class CalenderModelJP extends CalenderModel 
	{
		
		private var _isCalcVEDandAED:Boolean;
		
		/**
		 * 春分の日と秋分の日を計算によって未来まで出力するか、手打ちのデータのみを参照するかを取得、設定します.
		 * 
		 * <p>計算による設定は、2012年現在より過去の数値に関しては相違ないことを確認しておりますが、
		 * そもそも、これらの日は毎年会議によって決定されるものであり、
		 * 今後、祝日法の改正の可能性や計算方法の変更の可能性、算出された数値に対しての閣議による修正の可能性等ありますので、
		 * 必ずしもこの計算結果の通りに日付が決定されるわけではないことに注意して下さい。</p>
		 * 
		 * <p>計算による設定を選択した場合、2012年現在までの春分の日・秋分の日は手打ちの情報を使い、
		 * 2013年から2099年までの春分の日・秋分の日は計算による情報を使用します。</p>
		 * 
		 * <p>このプロパティはできる限り早めに設定し、また、設定の変更を頻繁に行わないでください。
		 * カレンダーを既に大量にスタックした状態で変更した場合、
		 * スタックされている2013年以降のカレンダーを作り直します。多ければ多いほど処理に時間がかかり、パフォーマンスの低下を招きます。
		 * ベストプラクティスは、このクラスのインスタンスが生成された段階で設定します。</p>
		 * 
		 * @default false
		 */
		public function get isCalcVEDandAED():Boolean { return _isCalcVEDandAED; }
		
		public function set isCalcVEDandAED(value:Boolean):void 
		{
			if (_isCalcVEDandAED != value)
			{
				_isCalcVEDandAED = value;
				
				_setHolidayDatas = {};
				
				var key:String;
				var year:uint;
				var month:uint;
				
				for (key in _calendars)
				{

					year = uint(key.substr(0, 4));
					month = uint(key.substr( -2, 2));
					
					if (year >= VEDandAED_calcStartYear)
					{
						_calendars[key] = null;
						delete _calendars[key];
						getCalender(year, month);
					}
				}
				
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * 振替休日が施行された、西暦0年から数えた日数。
		 * 振替休日は1973年4月12日に施行。
		 */
		private var exchangeHolidayStartDate:uint = CalenderUtil.calcurateDateCountFromZeroAD(1973, 4, 12);
		
		/**
		 * 国民の休日が施行された、西暦0年から数えた日数。
		 * 国民の休日は1985年12月27日に施行
		 */
		private var citizenHolidayStartDate:uint = CalenderUtil.calcurateDateCountFromZeroAD(1985, 12, 27);
		
		/**
		 * 国民の休日が改正された、、西暦0年から数えた日数。
		 * 改正は2007(平成19)年1月1日施行
		 */
		private var citizenHoliday2StartDate:uint = CalenderUtil.calcurateDateCountFromZeroAD(2007, 1, 1);
		
		/**
		 * 春分の日・秋分の日を計算で算出する開始年。
		 */
		private var VEDandAED_calcStartYear:uint = 2012;
		
		/**
		 * 処理方法の都合上、祝日のセットは1回きりである必要があるため、祝日の設定を行ったかを保持するオブジェクト。
		 */
		private var _setHolidayDatas:Object = {};
		
		/**
		 * 祝日・祭日のリストを設定します。コンストラクタによって、自動的にHolidayListJPクラスのインスタンスが割り当てられます。
		 * 
		 * @see jp.melancholy.calendermodel.holidays.lists.HolidayListJP
		 * 
		 */
		override public function get holidayList():IHolydayList { return _holidayList; }
		
		/**
		 * コンストラクタです。引数で、内部に利用する年月を指定できます。指定しない場合、現在の年月を自動的に格納します。
		 * 
		 * @param	year	年の値です。
		 * @param	month	月の値です。
		 */
		public function CalenderModelJP(year:int = -1, month:int = -1)
		{
			super(year, month);
			_holidayList = new HolidayListJP();
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function getCalender(year:uint = 0, month:uint = 0):Array
		{
			var beforeYear:uint = year;
			var beforeMonth:int;
			var afterYear:uint = year;
			var afterMonth:int;
			
			//前の月、次の月の年月を算出
			if (month == 1)
			{
				beforeYear--;
				beforeMonth = 12;
				afterMonth = 2;
			}
			else if (month == 12)
			{
				beforeMonth = 11;
				afterYear++;
				afterMonth = 1;
			}
			else
			{
				beforeMonth = month - 1;
				afterMonth = month + 1;
			}
			
			var calender:Array = super.getCalender(year, month);
			var beforeMonthCalender:Array = super.getCalender(beforeYear, beforeMonth);
			var afterMonthCalender:Array = super.getCalender(afterYear, afterMonth);
			
			var key:String = CalenderUtil.createKey(year, month);
			
			if (!_setHolidayDatas[key])
			{
				
				//春分の日・秋分の日の計算による設定
				if (_isCalcVEDandAED && year >= VEDandAED_calcStartYear && year <= 2099 && (month == 3 || month == 9))
				{
					if (month == 3)
					{
						//春分の日
						setVernalEquinoxDay(year, calender);
					}
					else if (month == 9)
					{
						//秋分の日
						setAutumnalEquinoxDay(year, calender);
					}
				}
				
				//振替休日設定
				setExchangeHoliday(beforeMonthCalender, calender, afterMonthCalender);
				
				//国民の休日設定
				setCitizenHoliday(beforeMonthCalender, calender, afterMonthCalender);
				
				_setHolidayDatas[key] = true;
				
				
			}
			
			
			return calender;
		}
		
		/**
		 * 春分の日を設定します。
		 * 
		 * @param	calender
		 */
		private function setVernalEquinoxDay(year:uint, calender:Array):void 
		{
			var mod:int = year % 4;
			var date:uint = 0;
			
			if (mod == 0)
			{
				//1960年～2088年までは3月20日
				//2092年～2096年までは3月19日
				if (year >= 1960 && year <= 2088) date = 20;
				else if (year >= 2092 && year <= 2096) date = 19;
			}
			else if (mod == 1)
			{
				//1993年～2097年までは3月20日
				if (year >= 1993 && year <= 2097) date = 20;
			}
			else if (mod == 2)
			{
				//1902年～2022年までは3月21日
				//2026年～2098年までは3月20日
				if (year >= 1902 && year <= 2022) date = 21;
				else if (year >= 2026 && year <= 2098) date = 20;
			}
			else if (mod == 3)
			{
				//1927年～2055年までは3月21日
				//2059年～2099年までは3月20日
				if (year >= 1927 && year <= 2055) date = 21;
				else if (year >= 2059 && year <= 2099) date = 20;
			}
			var dateObj:CalenderDateObject = calender[date];
			var datas:Array = dateObj.dataList.concat();
			
			datas.push( { name:"春分の日", type:CalenderUtil.NATIONAL_HOLIDAY } );
			calender[date] = new CalenderDateObject(dateObj.year, dateObj.month, dateObj.date, dateObj.day, datas);
		}
		
		/**
		 * 秋分の日を設定します。
		 * 
		 * @param	calender
		 */
		private function setAutumnalEquinoxDay(year:uint, calender:Array):void 
		{
			var mod:int = year % 4;
			var date:uint = 0;
			
			if (mod == 0)
			{
				//2012年～2096年までは9月22日
				if (year >= 2012 && year <= 2096) date = 22;
			}
			else if (mod == 1)
			{
				//1921年～2041年までは9月23日
				//2045年～2097年までは9月22日
				if (year >= 1921 && year <= 2041) date = 23;
				else if (year >= 2045 && year <= 2097) date = 22;
			}
			else if (mod == 2)
			{
				//1950年～2074年までは9月23日
				//2078年～2098年までは9月22日
				if (year >= 1950 && year <= 2074) date = 23;
				else if (year >= 2078 && year <= 2098) date = 22;
			}
			else if (mod == 3)
			{
				//1983年～2099年までは9月23日
				if (year >= 1983 && year <= 2099) date = 23;
			}
			var dateObj:CalenderDateObject = calender[date];
			var datas:Array = dateObj.dataList.concat();
			
			datas.push( { name:"秋分の日", type:CalenderUtil.NATIONAL_HOLIDAY } );
			calender[date] = new CalenderDateObject(dateObj.year, dateObj.month, dateObj.date, dateObj.day, datas);
		}
		
		/**
		 * 国民の休日を設定します。
		 * 
		 * @param	beforeMonthCalender
		 * @param	calender
		 * @param	afterMonthCalender
		 */
		private function setCitizenHoliday(beforeMonthCalender:Array, calender:Array, afterMonthCalender:Array):void 
		{
			var len:int = calender.length;
			
			var calenderDate:CalenderDateObject;
			var beforeDate:CalenderDateObject;
			var afterDate:CalenderDateObject;
			
			var datas:Array;
			
			var calenderDateCount:uint;
			var i:int = 0;
			
			var addFlag:Boolean;
			
			for (i = 0; i < len; i++) 
			{
				calenderDate = calender[i];
				calenderDateCount = CalenderUtil.calcurateDateCountFromZeroAD(calenderDate.year, calenderDate.month, calenderDate.date);
				
				//祝日規定範囲内であれば処理する
				if (calenderDateCount >= citizenHolidayStartDate)
				{
					
					//前日と次の日のCalenderDateObjectを取得する。
					if (i == 0)
					{
						beforeDate = beforeMonthCalender[beforeMonthCalender.length - 1]
						afterDate = calender[i + 1]
					}
					else if (i == len - 1)
					{
						beforeDate = calender[i - 1]
						afterDate = afterMonthCalender[beforeMonthCalender.length - 1]
					}
					else
					{
						beforeDate = calender[i - 1]
						afterDate = calender[i + 1]
					}
					
					addFlag = false;
					
					if (calenderDateCount >= citizenHoliday2StartDate)
					{
						//改正後（2007(平成19)年1月1日施行）
						//両隣が祝日である場合で、当日が祝日でない場合、国民の休日となる
						//	原文：その前日及び翌日が「国民の祝日」である日（「国民の祝日」でない日に限る。）は、休日とする。
						if (isNationalHoliday(beforeDate) && isNationalHoliday(afterDate) && !isNationalHoliday(calenderDate))
						{
							addFlag = true;
						}
					}
					else
					{
						//改正前（1985年12月27日施行）
						//両隣の日が祝日であり、当日が祝日でなく、更に日曜ではない場合、国民の休日となる
						//	原文：その前日及び翌日が「国民の祝日」である日（日曜日にあたる日及び前項に規定する休日にあたる日を除く。）は、休日とする。
						if (isNationalHoliday(beforeDate) && isNationalHoliday(afterDate) && (!isAdditionalNationalHoliday(calenderDate) && calenderDate.day != 0))
						{
							addFlag = true;
						}
					}
					
					
					if (addFlag)
					{
						datas = calenderDate.dataList.concat();
						datas.push( { name:"国民の休日", type:CalenderUtil.ADDITIONAL_NATIONAL_HOLIDAY } );
						
						calender[i] = new CalenderDateObject(calenderDate.year, calenderDate.month, calenderDate.date, calenderDate.day, datas); 
					}
						
				}
			}
		}
		
		/**
		 * 振替休日を設定します。
		 * 
		 * @param	beforeMonthCalender
		 * @param	currentMonthCalender
		 * @param	afterMonthCalender
		 */
		private function setExchangeHoliday(beforeMonthCalender:Array, currentMonthCalender:Array, afterMonthCalender:Array):void 
		{
			/*
			 * 小改正が2007(平成19)年1月1日に施行されているが、
			 * 改正前との違いは、月曜以外にも振替休日が設定できるようにしたことのみ。
			 * つまり、改正前は連続する祝日というのがなかったので、日曜に祝日にあった場合は必ず月曜にのみ振り替え休日が設定された。
			 * 具体例を挙げれば、5月4日の「みどりの日」が制定されたことによって、連続する祝日が始めて見受けられることとなった。そのための小改正である。
			 * 改正後の考え方で計算をしておけば改正前の考え方でも同じ計算でいけるので、改正後の考え方を参考にしている。
			 */
			
			var len:int = currentMonthCalender.length;
			
			var nationalHolidayFlag:Boolean;
			var calenderDate:CalenderDateObject;
			var j:int;
			var datas:Array;
			var calenderDateCount:uint;
			
			for (var i:int = -1; i < len - 1; i++)
			{
				if (i == -1) calenderDate = beforeMonthCalender[beforeMonthCalender.length - 1];
				else calenderDate = currentMonthCalender[i];
				
				calenderDateCount = CalenderUtil.calcurateDateCountFromZeroAD(calenderDate.year, calenderDate.month, calenderDate.date);
				
				//祝日規定の範囲内かを調べる
				if (calenderDateCount >= exchangeHolidayStartDate)
				{
					//祝日だった場合
					if (isNationalHoliday(calenderDate) && calenderDate.day == 0)
					{
						//次の祝日を探す
						do
						{
							i++;
							//当月の日数を越えてしまった場合、終了する。
							if (i >= len) return;
							else calenderDate = currentMonthCalender[i];
							
						} while (isNationalHoliday(calenderDate))
						
						//祝日を設定する
						datas = calenderDate.dataList.concat();
						datas.push( { name:"振替休日", type:CalenderUtil.ADDITIONAL_NATIONAL_HOLIDAY } );
						currentMonthCalender[i] = new CalenderDateObject(calenderDate.year, calenderDate.month, calenderDate.date, -1, datas);
					}
				}

			}
		}
		
		/**
		 * 祝日かどうか調べる
		 * @param	calenderDate
		 * @return
		 */
		private function isNationalHoliday(calenderDate:CalenderDateObject):Boolean 
		{
			for (var i:int = 0; i < calenderDate.dataList.length; i++)
			{
				if (calenderDate.dataList[i].type == CalenderUtil.NATIONAL_HOLIDAY)
				{
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * 祝日に関連した休日かどうか調べる
		 * @param	calenderDate
		 * @return
		 */
		private function isAdditionalNationalHoliday(calenderDate:CalenderDateObject):Boolean 
		{
			for (var i:int = 0; i < calenderDate.dataList.length; i++)
			{
				if (calenderDate.dataList[i].type == CalenderUtil.ADDITIONAL_NATIONAL_HOLIDAY)
				{
					return true;
				}
			}
			
			return false;
		}
	}

}