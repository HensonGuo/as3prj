package loader.core
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import loader.LoadEvent;
	import loader.type.LoadResType;
	
	import resource.pools.Reuse;
	import resource.pools.ObjectPool;
	
	import utils.debug.LogUtil;
	import utils.trigger.Dispatcher;
	
	/**
	 * @author g7842
	 */	
	public class LoaderBox extends Reuse
	{
		private static const VerifyLoadInterval:int = 10000;
		private var _prevVerifyLoadedBytes:Number = 0;
		private var _curLoadedBytes:Number = 0;
		private var _verifyTimerID:int = 0;
		
		private var _urlloader:URLLoader;
		private var _request:RequestBox;
		private var _isLoading:Boolean;
		
		public function LoaderBox()
		{
		}
		
		public function load(request:RequestBox):void
		{
			createUrlLoader();
			_request = request;
			if (_request.resType == LoadResType.TextFile || _request.resType == LoadResType.XMLFile)
				_urlloader.dataFormat = URLLoaderDataFormat.TEXT;
			else
				_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(request.request);
			_isLoading = true;
			
			_verifyTimerID = setInterval(verifyProgressIsChange, VerifyLoadInterval);
		}
		
		public function unLoad():void
		{
			if (_isLoading)
			{
				_urlloader.close();
				_isLoading = false;
			}
			disposeUrlLoader();
			clearVerify();
			_request = null;
		}
		
		/**
		 *如果进度条10s无变化则重新加载 
		 */		
		private function verifyProgressIsChange():void
		{
			if (_curLoadedBytes == _prevVerifyLoadedBytes)
			{
				LogUtil.warn("load " + _request.url + "progress is not Change, reload");
				onLoadFailed(null);
			}
			else
			{
				_prevVerifyLoadedBytes = _curLoadedBytes;
			}
		}
		
		/**
		 * 清楚验证
		 */		
		private function clearVerify():void
		{
			if (_verifyTimerID != 0)
			{
				clearInterval(_verifyTimerID);
				_verifyTimerID = 0;
			}
		}
		
		private function createUrlLoader():void
		{
			LogUtil.assert(_urlloader == null);
			_urlloader = ObjectPool.getObject(URLLoader);
			_urlloader.addEventListener(Event.COMPLETE,onLoadComplete);
			_urlloader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_urlloader.addEventListener(IOErrorEvent.IO_ERROR, onLoadFailed);
			_urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFailed);
		}
		
		private function disposeUrlLoader():void
		{
			if (_urlloader == null)
				return;
			_urlloader.removeEventListener(Event.COMPLETE,onLoadComplete);
			_urlloader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_urlloader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadFailed);
			_urlloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadFailed);
			ObjectPool.disposeObject(_urlloader);
			_urlloader = null;
		}
		
		private function onProgress(event:ProgressEvent):void
		{
			_curLoadedBytes = event.bytesLoaded;
			if (_request.progressCallback != null)
				_request.progressCallback.call(null, event.bytesLoaded, event.bytesTotal);
		}
		
		private function onLoadFailed(e:Event):void
		{
			clearVerify();
			if (_request.faildCallback != null)
				_request.faildCallback.call(null, this);
			_isLoading = false;
		}
		
		private function onLoadComplete(e:Event):void
		{
			LogUtil.assert(_urlloader.data != null);
			LogUtil.info("load " + request.urlWithVersion + " success!!");
			switch(_request.resType)
			{
				case LoadResType.BinaryFile:
				case LoadResType.ImageFile:
				case LoadResType.SWFFile:
					var lder:ReuseLoader = null;
					var loadContextComplete:Function = function(event:Event):void
					{
						lder.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadContextComplete);
						lder.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadContextFailed);
						excuteLoadCompleteCallback(lder.content);
						lder.destory(true);
						lder = null;
					}
					
					var loadContextFailed:Function = function(event:Event):void
					{
						lder.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadContextComplete);
						lder.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadContextFailed);
						lder.destory(true);
						lder = null;
					}
					
					var loadContext:LoaderContext = _request.context;
					if (loadContext == null)
					{
						loadContext = new LoaderContext(false, ApplicationDomain.currentDomain);
						loadContext.allowCodeImport = true;
					}
					lder = ObjectPool.getObject(ReuseLoader) as ReuseLoader;
					lder.contentLoaderInfo.addEventListener(Event.COMPLETE, loadContextComplete);
					lder.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadContextFailed);
					lder.loadBytes(_urlloader.data, loadContext);
					break;
				case LoadResType.TextFile:
				case LoadResType.XMLFile:
					excuteLoadCompleteCallback(_urlloader.data);
					break;
			}
			clearVerify();
		}
		
		private function excuteLoadCompleteCallback(data:*):void
		{
			if (_request.completeCallback != null)
				_request.completeCallback.call(null, _request.url, data);
			_isLoading = false;
			Dispatcher.dispatchEvent(new LoadEvent(LoadEvent.LoadComplete, this));
		}
		
		public function get isLoading():Boolean
		{
			return _isLoading;
		}
		
		public function get request():RequestBox
		{
			return _request;
		}
		
		override protected function reset():void
		{
			disposeUrlLoader();
			clearVerify();
			_isLoading = false;
			if (_request)
			{
				_request.destory();
				_request = null;
			}
		}
		
	}
}