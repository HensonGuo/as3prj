package resource.file
{
	import flash.utils.Dictionary;
	
	import loader.type.LoadResType;
	
	import utils.debug.LogUtil;

	public class Tabfile
	{
		private var _classObject:Class = null;
		private var _dataMap:Dictionary = null;
		
		private var _completeCallback:Function = null;
		private var _traceHeads:Boolean = false;
		
		private var _complete:Boolean = false;
		public var url:String = null;
		
		public function Tabfile(classObject:Class)
		{
			LogUtil.assert(classObject != null, "class object is null!");
			_dataMap = new Dictionary();
			_classObject = classObject; 
		}
		
		public function load(path:String, completeCallback:Function = null):void
		{
			_completeCallback = completeCallback;
			
			this.url = path;
			_complete = false;
			
			if (url)
				FrameWork.loaderManager.loadRes(LoadResType.TextFile, url, onLoadComplete);
		}
		
		public function set traceHeads(value:Boolean):void
		{
			_traceHeads = value;
		}
		
		private function onLoadComplete(path:String, data:String):void
		{
			LogUtil.assert(data != null && data != "", "file data is empty!");
			LogUtil.assert(this.url == path);
			
			dataAnalysis(data);
			
			if (_completeCallback != null)
				_completeCallback.call(null, this);
		}
		
		public function dataAnalysis(data:String):void
		{
			LogUtil.assert(data != null && data != "", "file data is empty!");
			var lines:Array = data.split("\n");
			var headDatas:Array = null;
			for (var i:int = 0; i < lines.length; i++)
			{
				var line:String = lines[i];
				if (line == "")
					continue;

				var index:int = line.indexOf("\r", line.length - 1);
				if (index != -1)
					line = line.substring(0, line.length - 1);
				
				if (i == 0)
					headDatas = line.split("\t");
				else
				{
					var valueDatas:Array = line.split("\t");
					
					if (_traceHeads && i == 1)
					{
						for (var n:int = 0; n < headDatas.length; n++)
						{
							if (valueDatas[n] == "0")
							{
								trace("public var " + headDatas[n] + ":int = 0;");
								continue;
							}
							if (valueDatas[n] == "")
							{
								trace("public var " + headDatas[n] + ":String = null;");
								continue;
							}
							if (uint(valueDatas[n]) == 0)
							{
								trace("public var " + headDatas[n] + ":String = null;");
								continue;
							}
							trace("public var " + headDatas[n] + ":int = 0;");
						}
					}
					
					LogUtil.assert(headDatas.length >= valueDatas.length, "head row count < value row count, url " + url);
					
					var dataObject:Object = new _classObject();
					for (var j:int = 0; j < valueDatas.length; j++)
					{
						var propertyName:String = headDatas[j];
						if (dataObject.hasOwnProperty(propertyName) && valueDatas[j].length > 0)
						{
							dataObject[propertyName] = valueDatas[j];
						}
					}
					(dataObject as ITabfileObject).onReadLineComplete();
					
					var key:String = (dataObject as ITabfileObject).getKey();
					if (key == null)
						continue;
					_dataMap[key] = dataObject;
				}
			}
			
			for each (var dataItem:ITabfileObject in _dataMap)
			{
				dataItem.onReadAllComplete()
			}
			
			_complete = true;
		}
		
		public function getValueByCompositeKey(...arg):ITabfileObject
		{
			var key:String = null;
			for (var i:int = 0; i < arg.length; i++)
			{
				key = (key ? key + "-" : "") + arg[i].toString();
			}
			return getValue(key);
		}
		
		public static function getKey(...arg):String
		{
			var key:String = null;
			for (var i:int = 0; i < arg.length; i++)
			{
				key = (key ? key + "-" : "") + arg[i].toString();
			}
			return key;
		}
		
		public function getValue(...arg):ITabfileObject
		{
			return _dataMap[getKey.apply(null, arg)];
		}
		
		public function getAllValue():Dictionary
		{
			return _dataMap;
		}
		
		public function get complete():Boolean
		{
			return _complete;
		}
	}
}