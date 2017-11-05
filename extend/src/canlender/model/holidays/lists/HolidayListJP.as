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


package canlender.model.holidays.lists 
{
	import canlender.model.holidays.HolidayListBase;
	import canlender.model.vo.HolidayObject;
	import canlender.model.holidays.HolidayDateSetter;
	import canlender.utils.CalenderUtil;
	
	/**
	 * 日本の祝日法で決定された祝日を設定するクラスです.
	 * 
	 * <p>1948年7月20日に施行された「国民の祝日に関する法律」、及び、その後の法改正情報を参考にしています。</p>
	 * 
	 * <p>春分の日、秋分の日に関しては、手入力による情報登録を行っています。
	 * これは、これらの日は固定の日ではなく、毎年閣議決定により日付が法的に決定されるものだからです。
	 * 計算による情報登録も可能ですが、リスト上では行っておりません。</p>
	 * 
	 * <p>春分の日、秋分の日の算出を扱いたい場合、CalenderModelJPクラスを使用してください。詳しくはCalenderModelJPクラスを参照してください。</p>
	 * 
	 * @see jp.melancholy.calendermodel.CalenderModelJP
	 * 
	 * @author Hiiragi
	 */
	public class HolidayListJP extends HolidayListBase
	{
		
		/**
		 * コンストラクタです。
		 */
		public function HolidayListJP() 
		{
			_version = "1.0.0";
			_lastUpdate = new Date(2011, 2, 1);
			
			_datas.push(new HolidayObject("元日", [new HolidayDateSetter(0, 1, 1)], { type:CalenderUtil.NATIONAL_HOLIDAY }, null, null, 1948, 7, 20));
			_datas.push(new HolidayObject("成人の日", [new HolidayDateSetter(0, 1, 15)], { type:CalenderUtil.NATIONAL_HOLIDAY }, null, null, 1948, 7, 20, 1999, 12, 31));
			_datas.push(new HolidayObject("成人の日", [new HolidayDateSetter(0, 1, HolidayDateSetter.MON + "2")], { type:CalenderUtil.NATIONAL_HOLIDAY }, null, null, 2000, 1, 1));
			_datas.push(new HolidayObject("建国記念の日", [new HolidayDateSetter(0, 2, 11)], { type:CalenderUtil.NATIONAL_HOLIDAY }, null, null, 1966, 6, 25));
			_datas.push(new HolidayObject("天皇誕生日", [new HolidayDateSetter(0, 4, 29)], { type:CalenderUtil.NATIONAL_HOLIDAY }, null, null, 1948, 7, 20, 1989, 2, 16));
			_datas.push(new HolidayObject("みどりの日", [new HolidayDateSetter(0, 4, 29)], { type:CalenderUtil.NATIONAL_HOLIDAY }, null, null, 1989, 2, 17, 2006, 12, 31));
			_datas.push(new HolidayObject("昭和の日", [new HolidayDateSetter(0, 4, 29)], { type:CalenderUtil.NATIONAL_HOLIDAY }, null, null, 2007, 1, 1));
			_datas.push(new HolidayObject("憲法記念日", [new HolidayDateSetter(0, 5, 3)], { type:CalenderUtil.NATIONAL_HOLIDAY }, null, null, 1948, 7, 20));
			_datas.push(new HolidayObject("みどりの日", [new HolidayDateSetter(0, 5, 4)], { type:CalenderUtil.NATIONAL_HOLIDAY }, null, null, 2007, 1, 1));
			_datas.push(new HolidayObject("こどもの日", [new HolidayDateSetter(0, 5, 5)], { type:CalenderUtil.NATIONAL_HOLIDAY }, null, null, 1948, 7, 20));
			_datas.push(new HolidayObject("海の日", [new HolidayDateSetter(0, 7, 20)], { type:CalenderUtil.NATIONAL_HOLIDAY }, null, null, 1996, 1, 1, 2002, 12, 31));
			_datas.push(new HolidayObject("海の日", [new HolidayDateSetter(0, 7, HolidayDateSetter.MON + "3")], { type:CalenderUtil.NATIONAL_HOLIDAY }, null, null, 2003, 1, 1));
			_datas.push(new HolidayObject("敬老の日", [new HolidayDateSetter(0, 9, 15)], { type:CalenderUtil.NATIONAL_HOLIDAY }, null, null, 1966, 6, 25, 2002, 12, 31));
			_datas.push(new HolidayObject("敬老の日", [new HolidayDateSetter(0, 9, HolidayDateSetter.MON + "3")], { type:CalenderUtil.NATIONAL_HOLIDAY }, null, null, 2003, 1, 1));
			_datas.push(new HolidayObject("体育の日", [new HolidayDateSetter(0, 10, 10)], { type:CalenderUtil.NATIONAL_HOLIDAY }, null, null, 1966, 6, 25, 1999, 12, 31));
			_datas.push(new HolidayObject("体育の日", [new HolidayDateSetter(0, 10, HolidayDateSetter.MON + "2")], { type:CalenderUtil.NATIONAL_HOLIDAY }, null, null, 2000, 1, 1));
			_datas.push(new HolidayObject("文化の日", [new HolidayDateSetter(0, 11, 3)], { type:CalenderUtil.NATIONAL_HOLIDAY }, null, null, 1948, 7, 20));
			_datas.push(new HolidayObject("勤労感謝の日", [new HolidayDateSetter(0, 11, 23)], { type:CalenderUtil.NATIONAL_HOLIDAY }, null, null, 1948, 7, 20));
			_datas.push(new HolidayObject("天皇誕生日", [new HolidayDateSetter(0, 12, 23)], { type:CalenderUtil.NATIONAL_HOLIDAY }, null, null, 1989, 2, 17));
			
			
			
			_datas.push(new HolidayObject("皇太子・明仁親王の結婚の儀", [new HolidayDateSetter(0, 4, 10)], { type:CalenderUtil.NATIONAL_HOLIDAY }, 
																								[new HolidayDateSetter(1959, 4, 10)],
																								null, 1959, 3, 17, 1982, 7, 23));
																						
			_datas.push(new HolidayObject("昭和天皇の大喪の礼", [new HolidayDateSetter(0, 2, 24)], { type:CalenderUtil.NATIONAL_HOLIDAY }, 
																						[new HolidayDateSetter(1989, 2, 24)],
																						null, 1989, 2, 17));
																						
			_datas.push(new HolidayObject("即位の礼正殿の儀", [new HolidayDateSetter(0, 11, 12)], { type:CalenderUtil.NATIONAL_HOLIDAY }, 
																					[new HolidayDateSetter(1990, 11, 12)],
																					null, 1990, 6, 1));
																						
			_datas.push(new HolidayObject("皇太子・徳仁親王の結婚の儀", [new HolidayDateSetter(0, 6, 9)], { type:CalenderUtil.NATIONAL_HOLIDAY }, 
																							[new HolidayDateSetter(1993, 6, 9)],
																							null, 1993, 4, 30));
																	
																	
																	
			_datas.push(new HolidayObject("春分の日", [new HolidayDateSetter(0, 3, 20)], { type:CalenderUtil.NATIONAL_HOLIDAY }, 
																						[new HolidayDateSetter(1960, 3, 20),
																						new HolidayDateSetter(1964, 3, 20),
																						new HolidayDateSetter(1968, 3, 20),
																						new HolidayDateSetter(1972, 3, 20),
																						new HolidayDateSetter(1976, 3, 20),
																						new HolidayDateSetter(1980, 3, 20),
																						new HolidayDateSetter(1984, 3, 20),
																						new HolidayDateSetter(1988, 3, 20),
																						new HolidayDateSetter(1992, 3, 20),
																						new HolidayDateSetter(1993, 3, 20),
																						new HolidayDateSetter(1996, 3, 20),
																						new HolidayDateSetter(1997, 3, 20),
																						new HolidayDateSetter(2000, 3, 20),
																						new HolidayDateSetter(2001, 3, 20),
																						new HolidayDateSetter(2004, 3, 20),
																						new HolidayDateSetter(2005, 3, 20),
																						new HolidayDateSetter(2008, 3, 20),
																						new HolidayDateSetter(2009, 3, 20),
																						new HolidayDateSetter(2012, 3, 20)],
																						null, 1948, 7, 20));
														
			_datas.push(new HolidayObject("春分の日", [new HolidayDateSetter(0, 3, 21)], { type:CalenderUtil.NATIONAL_HOLIDAY }, 
																						[new HolidayDateSetter(1949, 3, 21),
																						new HolidayDateSetter(1950, 3, 21),
																						new HolidayDateSetter(1951, 3, 21),
																						new HolidayDateSetter(1952, 3, 21),
																						new HolidayDateSetter(1953, 3, 21),
																						new HolidayDateSetter(1954, 3, 21),
																						new HolidayDateSetter(1955, 3, 21),
																						new HolidayDateSetter(1956, 3, 21),
																						new HolidayDateSetter(1957, 3, 21),
																						new HolidayDateSetter(1958, 3, 21),
																						new HolidayDateSetter(1959, 3, 21),
																						new HolidayDateSetter(1961, 3, 21),
																						new HolidayDateSetter(1962, 3, 21),
																						new HolidayDateSetter(1963, 3, 21),
																						new HolidayDateSetter(1965, 3, 21),
																						new HolidayDateSetter(1966, 3, 21),
																						new HolidayDateSetter(1967, 3, 21),
																						new HolidayDateSetter(1969, 3, 21),
																						new HolidayDateSetter(1970, 3, 21),
																						new HolidayDateSetter(1971, 3, 21),
																						new HolidayDateSetter(1973, 3, 21),
																						new HolidayDateSetter(1974, 3, 21),
																						new HolidayDateSetter(1975, 3, 21),
																						new HolidayDateSetter(1977, 3, 21),
																						new HolidayDateSetter(1978, 3, 21),
																						new HolidayDateSetter(1979, 3, 21),
																						new HolidayDateSetter(1981, 3, 21),
																						new HolidayDateSetter(1982, 3, 21),
																						new HolidayDateSetter(1983, 3, 21),
																						new HolidayDateSetter(1985, 3, 21),
																						new HolidayDateSetter(1986, 3, 21),
																						new HolidayDateSetter(1987, 3, 21),
																						new HolidayDateSetter(1989, 3, 21),
																						new HolidayDateSetter(1990, 3, 21),
																						new HolidayDateSetter(1991, 3, 21),
																						new HolidayDateSetter(1994, 3, 21),
																						new HolidayDateSetter(1995, 3, 21),
																						new HolidayDateSetter(1998, 3, 21),
																						new HolidayDateSetter(1999, 3, 21),
																						new HolidayDateSetter(2002, 3, 21),
																						new HolidayDateSetter(2003, 3, 21),
																						new HolidayDateSetter(2006, 3, 21),
																						new HolidayDateSetter(2007, 3, 21),
																						new HolidayDateSetter(2010, 3, 21),
																						new HolidayDateSetter(2011, 3, 21)],
																						null, 1948, 7, 20));
																						
																						
			_datas.push(new HolidayObject("秋分の日", [new HolidayDateSetter(0, 9, 22)], { type:CalenderUtil.NATIONAL_HOLIDAY }, 
																						[new HolidayDateSetter(2012, 9, 22)],
																						null, 1948, 7, 20));
																						
			_datas.push(new HolidayObject("秋分の日", [new HolidayDateSetter(0, 9, 23)], { type:CalenderUtil.NATIONAL_HOLIDAY }, 
																						[new HolidayDateSetter(1948, 9, 23),
																						new HolidayDateSetter(1949, 9, 23),
																						new HolidayDateSetter(1950, 9, 23),
																						new HolidayDateSetter(1952, 9, 23),
																						new HolidayDateSetter(1953, 9, 23),
																						new HolidayDateSetter(1954, 9, 23),
																						new HolidayDateSetter(1956, 9, 23),
																						new HolidayDateSetter(1957, 9, 23),
																						new HolidayDateSetter(1958, 9, 23),
																						new HolidayDateSetter(1960, 9, 23),
																						new HolidayDateSetter(1961, 9, 23),
																						new HolidayDateSetter(1962, 9, 23),
																						new HolidayDateSetter(1964, 9, 23),
																						new HolidayDateSetter(1965, 9, 23),
																						new HolidayDateSetter(1966, 9, 23),
																						new HolidayDateSetter(1968, 9, 23),
																						new HolidayDateSetter(1969, 9, 23),
																						new HolidayDateSetter(1970, 9, 23),
																						new HolidayDateSetter(1972, 9, 23),
																						new HolidayDateSetter(1973, 9, 23),
																						new HolidayDateSetter(1974, 9, 23),
																						new HolidayDateSetter(1976, 9, 23),
																						new HolidayDateSetter(1977, 9, 23),
																						new HolidayDateSetter(1978, 9, 23),
																						new HolidayDateSetter(1980, 9, 23),
																						new HolidayDateSetter(1981, 9, 23),
																						new HolidayDateSetter(1982, 9, 23),
																						new HolidayDateSetter(1983, 9, 23),
																						new HolidayDateSetter(1984, 9, 23),
																						new HolidayDateSetter(1985, 9, 23),
																						new HolidayDateSetter(1986, 9, 23),
																						new HolidayDateSetter(1987, 9, 23),
																						new HolidayDateSetter(1988, 9, 23),
																						new HolidayDateSetter(1989, 9, 23),
																						new HolidayDateSetter(1990, 9, 23),
																						new HolidayDateSetter(1991, 9, 23),
																						new HolidayDateSetter(1992, 9, 23),
																						new HolidayDateSetter(1993, 9, 23),
																						new HolidayDateSetter(1994, 9, 23),
																						new HolidayDateSetter(1995, 9, 23),
																						new HolidayDateSetter(1996, 9, 23),
																						new HolidayDateSetter(1997, 9, 23),
																						new HolidayDateSetter(1998, 9, 23),
																						new HolidayDateSetter(1999, 9, 23),
																						new HolidayDateSetter(2000, 9, 23),
																						new HolidayDateSetter(2001, 9, 23),
																						new HolidayDateSetter(2002, 9, 23),
																						new HolidayDateSetter(2003, 9, 23),
																						new HolidayDateSetter(2004, 9, 23),
																						new HolidayDateSetter(2005, 9, 23),
																						new HolidayDateSetter(2006, 9, 23),
																						new HolidayDateSetter(2007, 9, 23),
																						new HolidayDateSetter(2008, 9, 23),
																						new HolidayDateSetter(2009, 9, 23),
																						new HolidayDateSetter(2010, 9, 23),
																						new HolidayDateSetter(2011, 9, 23)],
																						null, 1948, 7, 20));
																						
																						
			_datas.push(new HolidayObject("秋分の日", [new HolidayDateSetter(0, 9, 24)], { type:CalenderUtil.NATIONAL_HOLIDAY }, 
																						[new HolidayDateSetter(1951, 9, 24),
																						new HolidayDateSetter(1955, 9, 24),
																						new HolidayDateSetter(1959, 9, 24),
																						new HolidayDateSetter(1963, 9, 24),
																						new HolidayDateSetter(1967, 9, 24),
																						new HolidayDateSetter(1971, 9, 24),
																						new HolidayDateSetter(1975, 9, 24),
																						new HolidayDateSetter(1979, 9, 24)],
																						null, 1948, 7, 20));
																						
		}
	}

}