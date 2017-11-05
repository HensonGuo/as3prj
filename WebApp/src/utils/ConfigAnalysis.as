package utils
{
	import resource.file.Inifile;
	import resource.file.Tabfile;

	public class ConfigAnalysis
	{
		public function ConfigAnalysis()
		{
		}
		
		public static function loadTable(url:String, dataItemType:Class, traceHeads:Boolean = false):Tabfile
		{
			var file:Tabfile = new Tabfile(dataItemType);
			file.traceHeads = traceHeads;
			file.load(url);
			return file;
		}
		
		public static function loadIniFile(url:String, classObject:Class):IniFileInfo
		{
			var ini:IniFileInfo = new classObject(url) as IniFileInfo;
			return ini;
		}
		
		public static function loadXML(url:String, classObject:Class, completeCallback:Function):XMLInfo
		{
			var xmlInfo:XMLInfo = new classObject(url, completeCallback) as XMLInfo;
			return xmlInfo;
		}
		
	}
}