package utils
{
	import flash.utils.ByteArray;
	
	import resource.file.Inifile;
	
	public class IniFileInfo
	{
		protected var _iniFile:Inifile = null;
		
		public function IniFileInfo(url:String)
		{
			_iniFile = new Inifile(url);
		}
		
	}
}