package resource.file
{
	import flash.utils.Dictionary;
	
	import loader.type.LoadResType;
	
	import utils.debug.LogUtil;
	
	public class Inifile
	{
		private var _dataMap:Dictionary = new Dictionary();
		private var _completeCallback:Function = null;
		
		public function Inifile(fileURL:String = null, completeCallback:Function = null, isUnshift:Boolean = false)
		{
			if (fileURL == null)
				return;
			
			_completeCallback = completeCallback;
			
			FrameWork.loaderManager.loadRes(LoadResType.TextFile, fileURL, onLoadComplete, null, isUnshift);
		}
		
		private function onLoadComplete(url:String, data:String):void
		{
			LogUtil.assert(data != null && data != "", "file data is empty!");
			
			dataAnalysis(data);
			
			if (_completeCallback != null)
				_completeCallback.call(null, this);
		}
		
		public function dataAnalysis(data:String):void
		{
			LogUtil.assert(data != null && data != "", "file data is empty!");
			
			var lines:Array = data.split("\n");
			var section:String = null;
			var sectionDictionary:Dictionary = null;
			for (var i:int = 0; i < lines.length; i++)
			{
				var line:String = lines[i];
				if (line == "")
					continue;
				if (line.charAt(0) == ";")
					continue;
				
				var index:int = line.indexOf("\r", line.length - 1);
				if (index != -1)
				{
					line = line.substring(0, line.length - 1);
				}
				
				index = line.indexOf(";", 0);
				if (index != -1)
				{
					line = line.substring(0, index);
				}
				
				index = line.indexOf("；", 0);
				if (index != -1)
				{
					line = line.substring(0, index);
				}
				
				index = line.indexOf("[", 0);
				if (index != -1)
				{
					var index2:int = line.indexOf("]", 0);
					if ((index >= index2) || (index2 == -1))
					{
						trace("bad section line=" + line + " index=" + index + " index2" + index2);
						continue;
					}
					section = line.substring(index + 1, index2);
					sectionDictionary = new Dictionary();
					this._dataMap[section] = sectionDictionary;
					continue;
				}
				
				index = line.indexOf("=", 0);
				if (index == -1)
					continue;
				if (index == 0)
				{
					trace("bed line line=" + line + " index=" + index);
					continue;
				}
				if ((section == null) || (sectionDictionary == null))
				{
					trace("no section");
					continue;
				}
				
				var key:String = line.substring(0, index);
				var value:String = line.substring(index + 1, line.length);
				sectionDictionary[key] = value;
			}
		}
		
		public function getString(section:String, key:String, def:String = null):String
		{
			var sectionDictionary:Dictionary = this._dataMap[section];
			return (sectionDictionary && sectionDictionary[key]) ? sectionDictionary[key] : def;
		}
		
		public function getSectionDictionary(section:String):Dictionary
		{
			return this._dataMap[section];
		}
		
		public function getNumber(section:String, key:String, def:Number = NaN):Number
		{
			var sectionDictionary:Dictionary = this._dataMap[section];
			return (sectionDictionary && sectionDictionary[key]) ? parseFloat(sectionDictionary[key]) : def;
		}
		
		public function getAllValue():Dictionary
		{
			return this._dataMap;
		}
	}
}