package utils
{
	import flash.utils.Dictionary;

	public class StringUtil
	{
		public function StringUtil()
		{
		}
		
		public static  function StringToNumber(number:String, dictionary:String = "0123456789ABCDEF"):Number
		{
			var _dictionary:Dictionary = new Dictionary(); // 連想配列
			var _base:Number = dictionary.length;
			var _numSize:int;
			var _i:int;
			var _ret:Number = 0;
			var _point:int = number.indexOf(".");
			number = number.replace(".", "");
			_numSize = number.length;
			for ( _i = 0; _i < _base; _i++ )
			{
				_dictionary[dictionary.charCodeAt(_i)] = _i;
			}
			for ( _i = 0; _i < _numSize; _i++ )
			{
				_ret *= _base;
				_ret += _dictionary[number.charCodeAt(_i)];
			}
			if ( _point > 0 )
			{
				_ret /= Math.pow( _base, _numSize - _point );
			}
			return _ret;
		}
		
		public static function getCharLength(str:String):int
		{
			var len:int = str.length;
			var mlen:int=0;
			for(var i:int=0;i<len;i++)
			{
				var n:Number = str.charCodeAt(i);
				if(n > 255||n<0)
				{
					mlen += 2;
				}else
				{
					mlen += 1;
				}
			}
			return mlen;
		}
		
		public static function trim(str:String):String
		{
			if (str == null) return '';
			
			var startIndex:int = 0;
			while (isWhitespace(str.charAt(startIndex)))
				++startIndex;
			
			var endIndex:int = str.length - 1;
			while (isWhitespace(str.charAt(endIndex)))
				--endIndex;
			
			if (endIndex >= startIndex)
				return str.slice(startIndex, endIndex + 1);
			else
				return "";
		}
		
		public static function isWhitespace(character:String):Boolean
		{
			switch (character)
			{
				case "":
				case " ":
				case "　":
				case "\t":
				case "\r":
				case "\n":
				case "\f":
					return true;
					
				default:
					return false;
			}
		}
		
		public static function getString( value:String ):String
		{
			return value == null?"":value;
		}
		
		/**
		 * 正则替换符号
		 * @param str
		 * @param rest
		 * @return 
		 * 
		 */		
		public static function substitute(str:String, ... rest):String
		{
			if (str == null) return '';
			
			// Replace all of the parameters in the msg string.
			var len:uint = rest.length;
			var args:Array;
			if (len == 1 && rest[0] is Array)
			{
				args = rest[0] as Array;
				len = args.length;
			}
			else
			{
				args = rest;
			}
			
			for (var i:int = 0; i < len; i++)
			{
				str = str.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
			}
			
			return str;
		}
		
		/**
		 * 生成 由 count 个 input 组成的字符串
		 * 
		 * @param	input	<b>	String	</b> intput 为 null | "" 时,返回 input
		 * @param	count	<b>	int		</b> count >= 0, 如果count < 0 ,则count = 0;
		 * @return
		 */
		static public function memset(input:String, count:int):String
		{
			if (!input || count <= 0) return str;			// (null || "") 返回本身   
			
			var str:String = "";
			while (count--)
			{
				str += input;
			}
			return str;
		}
		
		//URL地址;
		public static function isURL(char:String):Boolean 
		{
			if (char == null) {
				return false;
			}
			char = trim(char).toLowerCase();
			var pattern:RegExp = /^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		
		//中文;
		public static function isChinese(char:String):Boolean {
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[\u0391-\uFFE5]+$/; ;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		
		//含有中文字符
		public static function hasChineseChar(char:String):Boolean {
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /[^\x00-\xff]/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
	}
}