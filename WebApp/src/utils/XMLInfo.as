package utils
{
	import loader.type.LoadResType;

	public class XMLInfo
	{
		protected var _xml:XML;
		protected var _completeCallback:Function;
		
		public function XMLInfo(url:String, completeCallback:Function)
		{
			_completeCallback = completeCallback;
			FrameWork.loaderManager.loadRes(LoadResType.XMLFile, url, configFileLoaded);
		}
		
		private function configFileLoaded(url:String, xml:String):void
		{
			_xml = XML(xml);
			setParams();
			if (_completeCallback != null)
				_completeCallback.call(null);
		}
		
		protected function setParams():void
		{
		}
	}
}