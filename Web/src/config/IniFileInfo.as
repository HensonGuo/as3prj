package config
{
	import flash.utils.ByteArray;
	
	import resource.file.Inifile;
	
	public class IniFileInfo
	{
		protected var _iniFile:Inifile = null;
		protected var _callBack:Function = null;
		
		public function IniFileInfo(url:String, callBack:Function)
		{
			_callBack = callBack;
			_iniFile = new Inifile(null, null);
			var defineClass:Class = ConfigSwf.getDefineClass(url);
			var data:ByteArray = new defineClass();
			var dataStr:String = data.readUTFBytes(data.length);
			_iniFile.dataAnalysis(dataStr);
			onIniComplete(_iniFile);
		}
		
		protected function onIniComplete(iniFile:Inifile):void
		{
			if (_callBack != null)
				_callBack.call(null);
			_callBack = null;
		}
	}
}