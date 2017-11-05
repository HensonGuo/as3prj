package utils
{
	import flash.display.Loader;
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
	
	/**
	 * @author g7842
	 */	
	public class LoaderInstance
	{
		public static const TYPE_TEXT:String = "TYPE_TEXT";
		public static const TYPE_BINARY:String = "TYPE_BINARY";
		
		private static const VerifyLoadInterval:int = 10000;
		private var _prevVerifyLoadedBytes:Number = 0;
		private var _curLoadedBytes:Number = 0;
		private var _verifyTimerID:int = 0;
		
		private var _urlloader:URLLoader;
		private var _isLoading:Boolean;
		
		private var _url:String;
		private var _type:String;
		private var _progressCallback:Function;
		private var _completeCallback:Function;
		private var _failedCallback:Function;
		
		public function LoaderInstance()
		{
		}
		
		public function load(url:String, type:String, completeCallback:Function, progresscallback:Function, failedCallback:Function = null):void
		{
			_url = url;
			_type = type;
			_progressCallback = progresscallback;
			_completeCallback = completeCallback;
			_failedCallback = failedCallback;
			
			createUrlLoader();
			if (type == TYPE_TEXT)
				_urlloader.dataFormat = URLLoaderDataFormat.TEXT;
			else
				_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			
			var request:URLRequest = new URLRequest(url);
			_urlloader.load(request);
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
		}
		
		/**
		 *如果进度条10s无变化则重新加载 
		 */		
		private function verifyProgressIsChange():void
		{
			if (_curLoadedBytes == _prevVerifyLoadedBytes)
			{
				trace("load " + _url + "progress is not Change, reload");
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
			_urlloader = new URLLoader();
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
			_urlloader = null;
		}
		
		private function onProgress(event:ProgressEvent):void
		{
			_curLoadedBytes = event.bytesLoaded;
			if (_progressCallback != null)
				_progressCallback.call(null, event.bytesLoaded, event.bytesTotal);
		}
		
		private function onLoadFailed(e:Event):void
		{
			clearVerify();
			if (_failedCallback != null)
				_failedCallback.call(null, this);
			_isLoading = false;
		}
		
		private function onLoadComplete(e:Event):void
		{
			switch(_type)
			{
				case TYPE_BINARY:
					var lder:Loader = null;
					var loadContextComplete:Function = function(event:Event):void
					{
						lder.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadContextComplete);
						lder.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadContextFailed);
						excuteLoadCompleteCallback(lder.content);
						lder = null;
					}
					
					var loadContextFailed:Function = function(event:Event):void
					{
						lder.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadContextComplete);
						lder.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadContextFailed);
						lder = null;
					}
					
					var loadContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
					loadContext.allowCodeImport = true;
					lder = new Loader();
					lder.contentLoaderInfo.addEventListener(Event.COMPLETE, loadContextComplete);
					lder.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadContextFailed);
					lder.loadBytes(_urlloader.data, loadContext);
					break;
				case TYPE_TEXT:
					excuteLoadCompleteCallback(_urlloader.data);
					break;
			}
			clearVerify();
		}
		
		private function excuteLoadCompleteCallback(data:*):void
		{
			if (_completeCallback != null)
				_completeCallback.call(null, _url, data);
			_isLoading = false;
		}
		
		public function get isLoading():Boolean
		{
			return _isLoading;
		}
		
		public function reset():void
		{
			disposeUrlLoader();
			clearVerify();
			
			_isLoading = false;
			_url = null;
			_type = null;
			_progressCallback = null;
			_completeCallback = null;
			_failedCallback = null;
		}
		
	}
}