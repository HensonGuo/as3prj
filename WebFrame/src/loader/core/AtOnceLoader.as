package loader.core
{
	import loader.LoadEvent;
	import loader.type.LoadType;
	
	import resource.pools.Reuse;
	import resource.pools.ObjectPool;
	
	import utils.debug.LogUtil;
	import utils.trigger.Dispatcher;

	public class AtOnceLoader
	{
		private var _loaderBox:LoaderBox = Reuse.create(LoaderBox);
		private var _requestQuene:Vector.<RequestBox> = new Vector.<RequestBox>();
		
		public function AtOnceLoader()
		{
		}
		
		public function load(resType:String, url:String, completeCallback:Function, progressCallback:Function = null, clearCurrentLoad:Boolean = false):void
		{
			var request:RequestBox = null;
			if (clearCurrentLoad)
			{
				_loaderBox.unLoad();
				for (var i:uint = _requestQuene.length - 1; i > -1 ; i --)
				{
					request = _requestQuene[i];
					request.destory();
					request = null;
					_requestQuene.splice(i, 1);
				}
			}
			request = ObjectPool.getObject(RequestBox, resType, url, completeCallback, progressCallback, null, onLoadFailed);
			request.loadType = LoadType.AtOnceLoad;
			_requestQuene.unshift(request);
			handleRequest4Load();
		}
		
		public function loadComplete(request:RequestBox):void
		{
			request.destory();
			request = null;
			_loaderBox.unLoad();
			handleRequest4Load();
		}
		
		private function handleRequest4Load():void
		{
			if (_requestQuene.length == 0)
			{
				Dispatcher.dispatchEvent(new LoadEvent(LoadEvent.AtOnceLoadEnd, null));
				return;
			}
			Dispatcher.dispatchEvent(new LoadEvent(LoadEvent.AtOnceLoading, null));
			var request:RequestBox = _requestQuene.shift();
			_loaderBox.load(request);
		}
		
		private function onLoadFailed(lder:LoaderBox):void
		{
			var request:RequestBox = lder.request;
			if (request.isAlreadyRetry)
			{
				request.destory();
				request = null;
				LogUtil.warn("onAtOnceLoadFailed" + request.url);
				return;
			}
			request.resetForReload();	
			LogUtil.warn("onAtOnceLoadFailed " + request.url + "retry : " + request.retryCount);
			_requestQuene.unshift(request);
			handleRequest4Load();
		}
		
		public function get isLoading():Boolean
		{
			return _requestQuene.length != 0
		}
		
		
	}
}