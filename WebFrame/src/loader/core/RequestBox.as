package loader.core
{
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.getTimer;
	
	import loader.LoaderManager;
	
	import mx.events.Request;
	
	import resource.pools.Reuse;

	/**
	 * 请求盒子，暂存请求的数据
	 * @author g7842
	 */	
	public class RequestBox extends Reuse
	{
		private static const InvalidID:int = -1;
		private static const MaxRetryCount:int = 3;
		
		private var _resType:String;
		private var _url:String;
		private var _urlWithVersion:String;
		private var _context:LoaderContext;
		
		public var loadType:String;//加载类型
		public var id:int;
		public var retryCount:int;//加载失败连续请求3次
		
		private var _progressCallback:Function = null;
		private var _completeCallback:Function = null;
		private var _failedCallback:Function = null;
		
		public function RequestBox(resType:String, url:String, completeCallback:Function , progressCallback:Function = null, faildCallback:Function = null, context:LoaderContext = null)
		{
			setInitParams(resType, url, completeCallback, progressCallback, faildCallback, context)
		}
		
		override protected function setInitParams(...parameters):void
		{
			_resType = parameters[0];
			_url = parameters[1];
			_completeCallback = parameters[2];
			_progressCallback = parameters[3];
			_failedCallback = parameters[4];
			_context = parameters[5];
		}
		
		public function resetForReload():void
		{
			id = InvalidID;
			retryCount ++;
		}
		
		public function get request():URLRequest
		{
			return new URLRequest(LoaderManager.PrefixUrl + urlWithVersion);
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get urlWithVersion():String
		{
			if (_urlWithVersion)
				return _urlWithVersion;
			if (_url.indexOf("?") != -1)
			{
				_urlWithVersion = _url;
				return _urlWithVersion;
			}
			var version:String = FrameWork.loaderManager.getVersion(_url);
			_urlWithVersion = version == null ? _url + "?" + getTimer() : _url + "?" + version;
			return _urlWithVersion;
		}
		
		public function get resType():String
		{
			return _resType;
		}
		
		/**
		 *是否重试加载完毕 
		 * @return 
		 */		
		public function get isAlreadyRetry():Boolean
		{
			return retryCount > MaxRetryCount;
		}
		
		public function get progressCallback():Function
		{
			return _progressCallback;
		}
		
		public function get completeCallback():Function
		{
			return _completeCallback;
		}
		
		public function get faildCallback():Function
		{
			return _failedCallback;
		}
		
		public function get context():LoaderContext
		{
			return _context;
		}
		
		override protected function reset():void
		{
			id = InvalidID;
			retryCount = 0;
			loadType = null;
			
			_url = null;
			_urlWithVersion = null;
			_resType = null;
			_completeCallback = null;
			_progressCallback = null;
			_failedCallback = null;
			_context = null;
		}
		
	}
}