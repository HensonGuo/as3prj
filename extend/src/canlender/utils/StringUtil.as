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
	/**
	 * 文字列に関する処理をまとめたユーティリティクラスです。
	 * 
	 * @author Hiiragi
	 */
	public final class StringUtil extends Object 
	{
		
		/**
		 * コンストラクタです。
		 * 
		 * @private
		 */
		public function StringUtil() 
		{
			throw new Error("このクラスはインスタンス化できません。静的メソッド、静的プロパティを使用してください。");
		}
		
		
		
		/**
		 * 数値の前を0で埋めて、桁を合わせます。
		 * 
		 * @param	originalNumber	加工前の数値です。Numberの整数、intの正の数、uint、整数値のStringに対応します。その他の場合はこの関数は空白の文字列を返します。
		 * @param	digit	最終的に出力したい桁数です。
		 * @return	0で埋めた文字列を返します。originalNumberがNumberの正の整数値、intの正の数、uint、整数値のString以外だった場合、空白の文字列を返します。
		 */
		public static function fillZero(originalNumber:*, digit:uint):String
		{
			if (((originalNumber is Number) && (originalNumber.toString().indexOf(".") != -1))
				|| ((originalNumber is int) && (originalNumber >= 0))
				|| (originalNumber is uint)
				|| (originalNumber.match(/^\d*$/g).length == 1))
			{
				var str:String = originalNumber.toString();
				for (var i:int = 0; i < digit; i++) str = "0" + str;
				return str.substr( -digit, digit);
			}
			
			return "";
		}
		
	}

}