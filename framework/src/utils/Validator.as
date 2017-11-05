package utils
{

	/**
	 * 字符串验证
	 *   
	 * 正则 /gmi 全局搜索/多行搜索/忽略大小写
	 * 
	 * @author jianglang
	 * 
	 */	
	public class Validator
	{

		public function Validator()
		{

		}

		/**
		 * 验证是否为数字
		 * @param v 检测值
		 * @return true/false
		 */
		public static function isNumber(v:String):Boolean
		{
			var pattern:RegExp=/^\d+$/mi;
			return pattern.test(v);
		}

		/**
		 * 验证是否为字符
		 * @param v 检测值
		 * @return true/false
		 */
		public static function isChar(v:String):Boolean
		{
			var pattern:RegExp=/^[\u0000-\u00FF]{1}$/mi;
			return pattern.test(v);
		}

		/**
		 * 验证是否为字母
		 * @param v 检测值
		 * @return true/false
		 */
		public static function isLetter(v:String):Boolean
		{
			var pattern:RegExp=/^[a-z]{1}$/mi;
			return pattern.test(v);
		}

		/**
		 * 验证是否为英文
		 * @param v 检测值
		 * @return true/false
		 */
		public static function isEn(v:String):Boolean
		{
			var pattern:RegExp=/^[a-z]+$/mi;
			return pattern.test(v);
		}

		/**
		 * 验证是否为英文加数字
		 * @param v 检测值
		 * @return true/false
		 */
		public static function isENum(v:String):Boolean
		{
			var pattern:RegExp=/^[0-9a-z]+$/mi;
			return pattern.test(v);
		}

		/**
		 * 验证是否为布尔
		 * @param v 检测值
		 * @return true/false
		 */
		public static function isBoolean(v:String):Boolean
		{
			var pattern:RegExp=/^(true|false)$/mi;
			return pattern.test(v);
		}

		/**
		 * 验证是否为有效email
		 * @param v 检测值
		 * @return true/false
		 */
		public static function isEmail(v:String):Boolean
		{
			var pattern:RegExp=/^[^\s\@]+\@[^\s\@]+$/mi;
			return pattern.test(v);
		}

		/**
		 * 验证是否为有效url
		 * @param v 检测值
		 * @return true/false
		 */
		public static function isURL(v:String):Boolean
		{
			var pattern:RegExp=/^(http|https|ftp|file)\:\/\/[\w\W]+$/mi;
			return pattern.test(v);
		}

		/**
		 * 验证是否为有效电话号码
		 * @param v 检测值
		 * @return true/false
		 */
		public static function isTel(v:String):Boolean
		{
			var pattern:RegExp=/^(\d{3,4}-?)?(\d{7,8})(-?\d+)*$/mi;
			return pattern.test(v);
		}

		/**
		 * 验证是否为有效有机号
		 * @param v 检测值
		 * @return true/false
		 */
		public static function isMobile(v:String):Boolean
		{
			var pattern:RegExp=/^(13|15|18)\d{9}$/mi;
			return pattern.test(v);
		}

		/**
		 * 验证是否为函有非法字符
		 * @param v 检测值
		 * @return true/false
		 */
		public static function isFilter(v:String):Boolean
		{
			var pattern:RegExp=/^[^\\\/\?\:\"\<\>\|]+$/mi;
			return pattern.test(v);
		}

		/**
		 * 验证值的长度
		 * @param v 检测值
		 * @return true 存在中文 false 不存在中文
		 **/
		public static function isChinese(v:String):Boolean
		{
			var pattern:RegExp=/[\u4e00-\u9fa5]/g;
			return pattern.test(v);
		}
		/**
		 * 中国大陆身份证
		 * 是否为cnid
		 * @param v 需要校验的值
		 * @return true/false
		 */	
		public static function isCNID( value:String ):Boolean
		{
			var ai:Array = new Array();
			var tmp:String = null;
			if(value.length != 15 && value.length != 18)
			{
				return false;
			}
			value = value.toUpperCase();
			if(value.length == 15) //将15身份证升级到18位再校检
			{
				tmp = value.substring(0, 6);
				tmp = tmp + "19";
				tmp = tmp + value.substring(6, 15);
				tmp = tmp + getVerify(tmp);
				value = tmp;
			}
			return (getVerify(value) == value.substring(17, 18));
		}
		
		private static function getVerify(id:String):Object //获取末尾标识位
		{
			var wi:Array = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1];
			var vi:Array = [1, 0, 'X', 9, 8, 7, 6, 5, 4, 3, 2];
			var ai:Array = [];
			var remain:int = 0;
			var sum:int = 0;
			var k:int = 0;
			if(id.length == 18)
			{
				id = id.substring(0, 17);
			}
			for(var i:int = 0; i < 17; i++)
			{
				k = parseInt(id.substring(i, i + 1));
				ai[i] = k * 1;
			}
			for(var j:int = 0; j < 17; j++)
			{
				sum += wi[j] * ai[j];
			}
			remain = sum % 11;
			return vi[remain];
		}
		
		
		/**
		 * 中国香港身份证
		 * 是否为cnid
		 * @param v 需要校验的值
		 * @return true/false
		 */
		public static function isHKID(v:String):Boolean
		{
			var wi:Object = {'A':1, 'B':2, 'C':3, 'D':4, 'E':5, 'F':6, 'G':7, 'H':8, 'I':9, 'J':10, 'K':11, 'L':12, 'M':13, 'N':14, 'O':15, 'P':16, 'Q':17, 'R':18, 'S':19, 'T':20, 'U':21, 'V':22, 'W':23, 'X':24, 'Y':25, 'Z':26};
			var tmp:String = v.substring(0, 7);
			var a:Array = tmp.split("");
			var t:int = 0;
			var sum:int = 0;
			var verify:int = 0;
			var vi:int = parseInt(v.substring(8, 9)) * 1;
			for(var i:int = 0, j:int = 8; i < 7; i++, j--)
			{
				t = wi[a[i]] || a[i];
				sum += t * j;
			}
			verify = sum % 11 == 0 ? 0 : 11 - sum % 11;
			return (vi == verify);
		}

	}
}