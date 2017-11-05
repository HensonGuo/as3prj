/*
Copyright (c) 2008, Adobe Systems Incorporated
All rights reserved.

Copyright (c) 2010, Yasunobu Ikeda (clockmaker)
All rights reserved.

※as3corelibのJSONクラスを改変したためライセンス条項(new BSD License)に
基づいて元の著作権表示を残しています。

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

* Neither the name of Adobe Systems Incorporated nor the names of its
contributors may be used to endorse or promote products derived from
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package serialization.xml
{
	import flash.utils.describeType;
	import __AS3__.vec.Vector;

	/**
	 * XMLEncoder クラスはオブジェクトをXMLにシリアライズします。
	 */
	public class XMLEncoder
	{
		/**
		 * 新しい XMLEncoder インスタンスを作成します。
		 *
		 * @param o The object to encode as a JSON string
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 */
		public function XMLEncoder(value:*)
		{
			_xmlString = '<XMLSerializer version="' + "0.1.2" + '">' + convertToString(value) + "</XMLSerializer>";
		}
		
		/** The string that is going to represent the object we're encoding */
		private var _xmlString:String;
		
		/**
		 * エンコーダーからXMLインスタンスを取得します。
		 *
		 * @return コンストラクタの引数で与えたネイティブのオブジェクトから変換したXMLインスンタンスです。
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */
		public function getXML():XML
		{
			return new XML(_xmlString);
		}
		/**
		 * エンコーダーからXML文字列を取得します。
		 *
		 * @return コンストラクタの引数で与えたネイティブのオブジェクトから変換したXMLの文字列です。
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 10.0
		 * @tiptext
		 */
		public function getString():String
		{
			return _xmlString;
		}
		/**
		 * Converts a value to it's JSON string equivalent.
		 *
		 * @param value The value to convert.  Could be any
		 *		type (object, number, array, etc)
		 */
		private function convertToString(value:*, key:String = null, index:Number = -1):String
		{
			var nameStr:String = key ? " name='" + key + "'" : "";
			var indexStr:String = index > -1 ? " index='" + index + "'" : "";

			// determine what value is and convert it based on it's type
			if (value is String)
			{
				return "<property" + nameStr + indexStr + " type='String'><![CDATA[" + value + "]]></property>";
			}
			else if (value is Number)
			{
				var numStr:String = isFinite( value as Number) ? value.toString() : "null";
				// only encode numbers that finate
				return "<property" + nameStr + indexStr + " type='Number'>" + numStr + "</property>";
			}
			else if (value is Boolean)
			{
				// convert boolean to string easily
				return "<property" + nameStr + indexStr + " type='Boolean'>" + (value ? "true" : "false") + "</property>";
			}
			else if (value is Array)
			{
				// call the helper method to convert an array
				return arrayToString(value as Array, key, index);
			}
			else if(value is Vector.<*>)
			{
				//消除警告 wait to do
//				return vectorToString(value as Vector.<*>, key, index);
			}	
			else(value is Object && value != null)
			{
				// call the helper method to convert an object
				return objectToString(value, key, index);
			}
			return "<property" + nameStr + indexStr + ">null</property>";
		}
		/**
		 * Converts an array to it's JSON string equivalent
		 *
		 * @param a The array to convert
		 * @return The JSON string representation of <code>a</code>
		 */
		private function arrayToString(a:Array, key:String = null, index:Number = -1):String
		{
			var nameStr:String = key ? " name='" + key + "'" : "";
			var indexStr:String = index > -1 ? " index='" + index + "'" : "";

			// create a string to store the array's jsonstring value
			var s:String = "";

			// loop over the elements in the array and add their converted
			// values to the string
			for (var i:int = 0; i < a.length; i++)
			{
				// convert the value to a string
				s += convertToString(a[i], null, i);
			}
			
			// [Tips] Arrayをハッシュに使った場合は対応できないので注意ください
			// myArray["foo"] = "bar";

			return "<property" + nameStr + indexStr + " type='Array'>" + s + "</property>";
		}
		
		
		/**
		 * Converts an array to it's JSON string equivalent
		 *
		 * @param a The array to convert
		 * @return The JSON string representation of <code>a</code>
		 */
		private function vectorToString(a:*, key:String = null, index:Number = -1):String
		{
			var nameStr:String = key ? " name='" + key + "'" : "";
			var indexStr:String = index > -1 ? " index='" + index + "'" : "";

			// create a string to store the array's jsonstring value
			var s:String = "";

			// loop over the elements in the array and add their converted
			// values to the string
			for (var i:int = 0; i < a.length; i++)
			{
				// convert the value to a string
				s += convertToString(a[i], null, i);
			}
			var classInfo:XML = describeType(a);

			return "<property" + nameStr + indexStr +  " type='" + entity(classInfo.@name.toString()) + "'>" + s + "</property>";
		}
		

		/**
		 * Converts an object to it's JSON string equivalent
		 *
		 * @param o The object to convert
		 * @return The JSON string representation of <code>o</code>
		 */
		private function objectToString(o:Object, key:String = null, index:Number = -1):String
		{
			var nameStr:String = key ? " name='" + key + "'" : "";
			var indexStr:String = index > -1 ? " index='" + index + "'" : "";

			// create a string to store the object's jsonstring value
			var s:String = "";
			var arr:Array;
			var i:int;

			// determine if o is a class instance or a plain object
			var classInfo:XML = describeType(o);
			if (classInfo.@name.toString() == "Object")
			{
				// the value of o[key] in the loop below - store this 
				// as a variable so we don't have to keep looking up o[key]
				// when testing for valid values to convert
				var value:Object;

				// loop over the keys in the object and add their converted
				// values to the string
				arr = [];
				for (var key:String in o)
				{
					// assign value to a variable for quick lookup
					value = o[key];

					// don't add function's to the JSON string
					if (value is Function)
					{
						// skip this key and try another
						continue;
					}

					arr.push({ key:key , value:value });
				}
				
				// プロパティ名にソート
				arr.sortOn("key");
				
				for( i= 0; i < arr.length; i++)
				{
					s += convertToString(arr[i].value, arr[i].key);
				}
			}
			
			else // o is a class instance
			{
				// Loop over all of the variables and accessors in the class and 
				// serialize them along with their values.
				arr = [];
				for each (var v:XML in classInfo..*.(
						name() == "variable"
					||
					(
						name() == "accessor"
						&& attribute("access") == "readwrite")
					))
				{
					// Issue #110 - If [Transient] metadata exists, then we should skip
					if (v.metadata && v.metadata.(@name == "Transient").length() > 0)
					{
						continue;
					}

					arr.push({ key:v.@name.toString() , value:o[v.@name] });
				}
				
				// プロパティ名にソート
				arr.sortOn("key");
				
				for( i= 0; i < arr.length; i++)
				{
					s += convertToString(arr[i].value, arr[i].key);
				}

			}

			return "<property" + nameStr + indexStr + " type='" + entity(classInfo.@name.toString()) + "'>" + s + "</property>";
		}

		private function entity(str:String):String
		{
			// create a string to store the string's jsonstring value
			var s:String = "";
			// current character in the string we're processing
			var ch:String;
			// store the length in a local variable to reduce lookups
			var len:Number = str.length;

			// loop over all of the characters in the string
			for (var i:int = 0; i < len; i++)
			{
				// examine the character to determine if we have to escape it
				ch = str.charAt(i);

				switch (ch)
				{
					case '<': // quotation mark
						s += "&lt;";
						break;
					case '>': // quotation mark
						s += "&gt;";
						break;
					case '&': // quotation mark
						s += "&amp;";
						break;
					case '"': // quotation mark
						s += "&quot;";
						break;
					case "'": // quotation mark
						s += "&apos;";
						break;
					default:
						// check for a control character and escape as unicode
						if (ch < ' ')
						{
							// get the hex digit(s) of the character (either 1 or 2 digits)
							var hexCode:String = ch.charCodeAt(0).toString(16);

							// ensure that there are 4 digits by adjusting
							// the # of zeros accordingly.
							var zeroPad:String = hexCode.length == 2 ? "00" : "000";

							// create the unicode escape sequence with 4 hex digits
							s += "\\u" + zeroPad + hexCode;
						}
						else
						{
							// no need to do any special encoding, just pass-through
							s += ch;
						}
				}
			}
			return s;
		}
	}
}

