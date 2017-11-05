package config
{
	import flash.utils.ByteArray;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	import resource.file.Tabfile;
	
	import utils.debug.LogUtil;

	public class ConfigManager
	{
		public var global:GlobalIni;
		public var navigation:Tabfile;
		
		private var _configCount:uint;
		
		private const _analysisInterval:int = 20;
		private var _analysisList:Vector.<ConfigAnalysisInfo> = new Vector.<ConfigAnalysisInfo>();
		private var _analysisTimerID:int;
		private var _analysisCompleteCount:int;
		private var _analysisCompleteCallback:Function;
		
		public function ConfigManager()
		{
		}
		
		public function loadConfigs(onConfigAnalysisCompleteCallback:Function):void
		{
			_analysisCompleteCallback = onConfigAnalysisCompleteCallback;
			
			navigation = loadTable("settings/navigation.txt", NavigationTab);
			global = loadIniFile("settings/global.ini", GlobalIni) as GlobalIni;
			
			startAnalysis();
		}
		
		private function startAnalysis():void
		{
			_analysisTimerID = setInterval(doDataAnalysis, _analysisInterval);
		}
		
		private function doDataAnalysis():void
		{
			if (_analysisList.length == 0)
			{
				clearInterval(_analysisTimerID);
				return;
			}
			var time:int = getTimer();
			var info:ConfigAnalysisInfo = null;
			while (getTimer() - time < 150 && _analysisList && _analysisList.length != 0)
			{
				info = _analysisList.shift();
				info.file.url = info.url;
				info.file.dataAnalysis(info.data);
				onLoadComplete(null);
			}
		}
		
		private function loadTable(url:String, dataItemType:Class, traceHeads:Boolean = false):Tabfile
		{
			var file:Tabfile = new Tabfile(dataItemType);
			file.traceHeads = traceHeads;
			_configCount++;
			var settingClass:Class = ConfigSwf.getDefineClass(url);
			if (settingClass)
			{
				var data:ByteArray = new settingClass();
				var dataStr:String = data.readUTFBytes(data.length);
				var info:ConfigAnalysisInfo = new ConfigAnalysisInfo();
				info.file = file;
				info.data = dataStr;
				info.url = url;
				_analysisList.push(info);
			}
			else
			{
				//方便可以直接修改配置文件测试、待思考
				file.load(url, onLoadComplete);
			}
			return file;
		}
		
		private function loadIniFile(url:String, classObject:Class):IniFileInfo
		{
			_configCount++;
			var baseIniFileInfo:IniFileInfo = new classObject(url, onLoadComplete);
			return baseIniFileInfo;
		}
		
		private function onLoadComplete(file:* = null):void
		{
			_analysisCompleteCount++;
			var percent:Number = _analysisCompleteCount / _configCount;
			var info:String = "正在解析配置: " + (percent * 100).toFixed() + "%";
			PreLoad.setPercent(_analysisCompleteCount, _configCount, info);
			
			if (_analysisCompleteCount == _configCount)
			{
				LogUtil.info("loadAllComplete:" + _analysisCompleteCount + "/" + _configCount); 
				LogUtil.assert(_analysisList.length == 0);
				clearInterval(_analysisTimerID);
				_analysisList = null;
				_analysisCompleteCallback.call(null);
			}
		}
		
		public function get configCount():uint
		{
			return _configCount;
		}
	}
}
import resource.file.Tabfile;

class ConfigAnalysisInfo
{
	public var file:Tabfile = null;
	public var data:String = null;
	public var url:String = null;
}