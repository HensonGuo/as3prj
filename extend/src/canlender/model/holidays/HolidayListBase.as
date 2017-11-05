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
	import canlender.model.vo.HolidayObject;
	import canlender.utils.CalenderUtil;
	
	/**
	 * 祝日・祭日を設定するデータリストの抽象基本クラスです。このクラスを直接インスタンス化しないでください。
	 * 
	 * @author Hiiragi
	 */
	public class HolidayListBase extends Object implements IHolydayList 
	{
		
		/**
		 * 祝日・祭日を設定するHolidayObjectを格納する内部配列です。
		 */
		protected var _datas:Array = [];
		
		/**
		 * バージョン情報を保持する内部オブジェクトです。
		 */
		protected var _version:String = "";
		/**
		 * @inheritDoc
		 */
		public function get version():String { return _version; }
		
		/**
		 * 最終更新日の情報を保持する内部オブジェクトです。
		 */
		protected var _lastUpdate:Date;
		/**
		 * @inheritDoc
		 */
		public function get lastUpdate():Date { return _lastUpdate; }
		
		
		/**
		 * コンストラクタです。
		 * 
		 * @private
		 */
		public function HolidayListBase() 
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function getDatas():Array 
		{
			return _datas.concat();
		}
		
		/**
		 * 新しい祝日・祭日のリストを設定します。
		 * 
		 * @param	holidayListData	祝日を設定したHolidayObjectを格納した配列です。
		 */
		public function setDatas(holidayListData:Array):void
		{
			var holiday:HolidayObject;
			
			for each (var obj:* in holidayListData) 
			{
				if (!obj is HolidayObject)
				{
					throw new Error("holidaysの配列の中身はHolidayObjectのみである必要があります。");
					return;
				}
			}
			
			_datas = holidayListData;
		}
		
	}

}