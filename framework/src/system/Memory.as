package system
{
	import flash.net.*;
	import flash.system.*;
	
	public class Memory extends Object
	{
		public function Memory()
		{
			super();
		}
		
		public static function get used():uint
		{
			return flash.system.System.totalMemory;
		}
		
		public static function gc():void
		{
			System.gc();
		}
		
	}
}