package display
{
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import loader.type.LoadResType;

	/**
	 *全局Context类，主要负责加载swf资源
	 * 重复用的到的UI资源
	 * @author g7842
	 * 
	 */	
	public class GlobalUI
	{
		private var _root:LoaderContext;
		private var _urlResMap:Dictionary;
		
		public function GlobalUI()
		{
			_urlResMap = new Dictionary();
			_root = new LoaderContext(false, new ApplicationDomain(null));
		}
		
		/**
		 * 加载SWF 
		 * @param url
		 */		
		public function loadSWF(url:String, progressCallback:Function = null, completeCallback:Function = null):void
		{
			if (_urlResMap[url] != null)
				return;
			_urlResMap[url] = url;
			
			//wait to do
			FrameWork.loaderManager.loadRes(LoadResType.SWFFile, url, progressCallback, completeCallback, true, _root);
		}
		
		public function context():LoaderContext
		{
			return _root;
		}
		
		/**
		 * 是否定义
		 * @param className
		 * @return 
		 */		
		public function hasDefine(className:String):Boolean
		{
			return _root.applicationDomain.hasDefinition(className);
		}
		
		/**
		 * 获取定义
		 * @param className
		 * @return
		 */		
		public function getDefinition( className:String ):Class
		{
			var cls:Class =  _root.applicationDomain.getDefinition(className) as Class;
			if(cls)
				return cls;
			throw new Error("ReferenceError: Error #1065: Variable " + className + " is not defined." );
			return null;
		}
		
	}
}