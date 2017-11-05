package
{
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;

	public class SystemData
	{
		public function SystemData()
		{
		}
		
		public static function getMacAddress():String
		{
			var netinfo:NetworkInfo=NetworkInfo.networkInfo
			var interfaces:Vector.<NetworkInterface>=netinfo.findInterfaces();
			return interfaces[0].hardwareAddress;
		}
		
		public static function getIpAddress():String
		{
			var netinfo:NetworkInfo=NetworkInfo.networkInfo
			var interfaces:Vector.<NetworkInterface>=netinfo.findInterfaces();
			return interfaces[0].addresses[0].address;
		}
		
	}
}