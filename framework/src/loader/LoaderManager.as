package loader
{
	
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import loader.core.AtOnceLoader;
	import loader.core.LoaderBox;
	import loader.core.RequestBox;
	import loader.type.LoadType;
	
	import resource.pools.Reuse;
	import resource.pools.ObjectPool;
	
	import utils.debug.LogUtil;
	import utils.trigger.Dispatcher;

	/**
	 *普通加载、一次最多加载5个文件；开辟4个作为普通加载；开辟1个为立即加载
	 * 预加载、一次加载一个文件
	 * 懒加载、一次加载一个文件
	 * 立即加载、一次加载一个文件
	 * 是否正在加载、避免重复加载
	 * 加载的资源版本号管理
	 * 加载失败后重新加载、重载次数超过3次则失败、加载进度10s无变化重新加载
	 * @author g7842
	 */	
	public class LoaderManager
	{
		public static var PrefixUrl:String = "";
		private var _versionMap:Dictionary = new Dictionary();
		
		private var _requestManager:RequestManager = new RequestManager();
		private var _loadKeyMap:Dictionary = new Dictionary();
		
		private var _preloadList:Vector.<LoadData> = new Vector.<LoadData>();
		private var _isPreloading:Boolean = false;
		
		private var _lazyLoadList:Vector.<LoadData> = new Vector.<LoadData>();
		private var _isLazyLoading:Boolean = false;
		
		private var _atOnceLoader:AtOnceLoader = new AtOnceLoader();
		private var _isAtOnceLoading:Boolean = false;
		
		public function LoaderManager()
		{
			Dispatcher.addEventListener(LoadEvent.LoadComplete, onLoadComplete);
			Dispatcher.addEventListener(LoadEvent.AtOnceLoading, atOnceLoading);
			Dispatcher.addEventListener(LoadEvent.AtOnceLoadEnd, atOnceLoadComplete);
		}
		
		public function setVersion(url:String, version:String):void
		{
			_versionMap[url] = version;
		}
		
		public function getVersion(url:String):String
		{
			return _versionMap[url];
		}
		
		/**
		 *加载资源 
		 * @param resType	资源类型
		 * @param url	资源路径
		 * @param completeCallback	完成回调
		 * @param progressCallback	过程回调
		 * @param isUnshit	是否插入到加载队列首
		 */
		public function loadRes(resType:String, url:String, completeCallback:Function, progressCallback:Function = null, isUnshit:Boolean = false, context:LoaderContext = null):void
		{
			var requset:RequestBox = _requestManager.createRequest(resType, url, completeCallback, progressCallback, onLoadFailed, context);
			requset.loadType = LoadType.General;
			_requestManager.addRequest(requset, isUnshit);
			handleRequest4Load();
		}
		
		/**
		 *预加载 
		 * @param url
		 */		
		public function preLoadFile(url:String, resType:String):void
		{
			if (_loadKeyMap[url] != null)
				return;
			_loadKeyMap[url] = url;
			_preloadList.push(new LoadData(url, resType));
			handleRequest4Load();
		}
		
		/**
		 *清除预加载 
		 */
		public function clearPreLoad():void
		{
			for (var i:int = _preloadList.length - 1; i > -1; i--)
			{
				var url:String = _preloadList[i].url;
				deleteLoadKey(url);
				_preloadList.splice(i, 1);
			}
		}
		
		/**
		 *懒加载 
		 * @param url
		 */		
		public function lazyLoad(url:String, resType:String):void
		{
			if (_loadKeyMap[url] != null)
				return;
			_loadKeyMap[url] = url;
			_lazyLoadList.push(new LoadData(url, resType));
			handleRequest4Load();
		}
		
		/**
		 *清除懒加载 
		 */
		public function clearLazyLoad():void
		{
			for (var i:int = _lazyLoadList.length - 1; i > -1; i--)
			{
				var url:String = _lazyLoadList[i].url;
				deleteLoadKey(url);
				_lazyLoadList.splice(i, 1);
			}
		}
		
		/**
		 * 是否马上加载
		 * @param url
		 * @param resType
		 * @param completeCallback
		 * @param progressCallback
		 * @param clearCurrentLoad
		 */		
		public function atOnceLoad(url:String, resType:String, completeCallback:Function, progressCallback:Function = null, clearCurrentLoad:Boolean = false):void
		{
			_atOnceLoader.load(resType, url, completeCallback, progressCallback, clearCurrentLoad);
		}
		
		private function handleRequest4Load():void
		{
			//如果正在立马加载，节省流量宽带给AtOnceLoad
			if (_isAtOnceLoading)
				return;
			if (_requestManager.isExcuteQueneFull)
				return;
			var request:RequestBox = _requestManager.excuteOneRequest();
			if (request == null)
			{
				//预加载和懒加载都是每次只执行一个加载
				//预先处理预加载队列
				if (_isPreloading)
					return;
				if (_preloadList.length != 0)
				{
					_isPreloading = true;
					var preloadData:LoadData = _preloadList.shift();
					loadRes(preloadData.resType, preloadData.url, preloadComplete, null, true);
					request.loadType = LoadType.PreLoad;
					return;
				}
				//处理懒加载
				if (_isLazyLoading)
					return;
				if (_lazyLoadList.length != 0)
				{
					_isLazyLoading = true;
					var lazyLoadData:LoadData = _lazyLoadList.shift();
					loadRes(lazyLoadData.resType, lazyLoadData.url, lazyloadCompelte, null, true);
					request.loadType = LoadType.LazyLoad;
				}
				return;
			}
			var lder:LoaderBox = Reuse.create(LoaderBox);
			lder.load(request);
		}
		
		private function preloadComplete(url:String, data:*):void
		{
			_isPreloading = false;
		}
		
		private function lazyloadCompelte(url:String, data:*):void
		{
			_isLazyLoading = false;
		}
		
		private function atOnceLoading(event:LoadEvent):void
		{
			_isAtOnceLoading = true;
		}
		
		private function atOnceLoadComplete(event:LoadEvent):void
		{
			_isAtOnceLoading = false;
			var count:int = _requestManager.freeExcuteNum;
			for (var i:uint = 0; i < count; i++)
			{
				handleRequest4Load();
			}
		}
		
		private function onLoadComplete(event:LoadEvent):void
		{
			var lder:LoaderBox = event.data as LoaderBox;
			if (lder.request.loadType == LoadType.AtOnceLoad)
			{
				_atOnceLoader.loadComplete(lder.request);
				return;
			}
			disposeLoader(lder);
			handleRequest4Load();
		}
		
		private function onLoadFailed(lder:LoaderBox):void
		{
			if (lder.request.isAlreadyRetry)
			{
				LogUtil.warn("load " + lder.request.url + " fail!!");
				disposeLoader(lder);
			}
			else
			{
				lder.request.resetForReload();													//重置
				LogUtil.info("load " + lder.request.url + " fail!!. retry ... " + lder.request.retryCount);
				_requestManager.deleteExcuteRequest(lder.request);				//删除执行的Request
				_requestManager.addRequest(lder.request, true);					//添加请求
				lder.unLoad();
				lder.destory();
				lder = null;
			}
			handleRequest4Load();
		}
		
		private function disposeLoader(lder:LoaderBox):void
		{
			deleteLoadKey(lder.request.url);												//删除Loadkey
			_requestManager.deleteExcuteRequest(lder.request);	//删除执行的Request
			lder.destory();																		//销毁loaderBox
			lder = null;
		}
		
		private function deleteLoadKey(url:String):void
		{
			_loadKeyMap[url] = null;
			delete _loadKeyMap[url];
		}
	}
}




class LoadData
{
	public var url:String;
	public var resType:String;
	
	public function LoadData(url:String, resType:String)
	{
		this.url = url;
		this.resType = resType;
	}
}