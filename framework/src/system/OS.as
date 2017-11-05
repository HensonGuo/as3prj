package system
{
	import flash.system.Capabilities;

	public class OS
	{
		public static function get info():String
		{
			return Capabilities.os;
		}
		
		public static function isMac():Boolean{
			return Capabilities.os.toLocaleUpperCase().indexOf("MAC") != -1;
		}
		
		public static function isWindows():Boolean{
			return Capabilities.os.toLocaleUpperCase().indexOf("WIN") != -1;
		}
		
		public static function isAndriod():Boolean{
			return Capabilities.os.toLocaleUpperCase().indexOf("ANDROID") != -1;
		}
		
		public static function isIPhone():Boolean{
			return Capabilities.os.toLocaleUpperCase().indexOf("IPHONE") != -1;
		}
	}
}