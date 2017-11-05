package test.error
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;
	
//	import framework.util.pools.ObjectPool;
	
	public class UrlLoaderBox
	{
		private var _callBack:Function;
		private var _urlLrd:URLLoader;
		private var _url:String;
		
		public function UrlLoaderBox()
		{
		}
		
		public function load(url:String,callback:Function, data:Object = null):void
		{
			_callBack = callback;
			_url = url;
			
			var urlReq:URLRequest = new URLRequest(url);
			if (data != null)
			{
//				urlReq.contentType = "multipart/form-data";
				urlReq.data = data;
				urlReq.method = URLRequestMethod.GET;
				var header1:URLRequestHeader = new URLRequestHeader("Cache-Control", "no-cache");
				var header2:URLRequestHeader = new URLRequestHeader("Cache-Control", "no-store");
				var header3:URLRequestHeader = new URLRequestHeader("Cache-Control", "must-revalidate");
				var header4:URLRequestHeader = new URLRequestHeader("post-check", "0");
				var header5:URLRequestHeader = new URLRequestHeader("pre-check", "0");
				urlReq.requestHeaders.push(header1, header2, header3, header4, header5);
			}
			_urlLrd = new URLLoader();
			configUrlListener();
			_urlLrd.load(urlReq);
		}
		
		private function configUrlListener():void
		{
			removeListener();
			_urlLrd.dataFormat = URLLoaderDataFormat.BINARY;
			_urlLrd.addEventListener(Event.COMPLETE,onLoadComplete);
			_urlLrd.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			_urlLrd.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onIoError);
		}
		
		private function removeListener():void
		{
			if( _urlLrd ){
				_urlLrd.removeEventListener(Event.COMPLETE,onLoadComplete);
				_urlLrd.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
				_urlLrd.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onIoError);
			}
		}
		
		private function onIoError(e:Event):void
		{
			var info:String;
			if( e is IOErrorEvent )
				info = IOErrorEvent(e).text;
			else
				info = SecurityErrorEvent(e).text;
			trace(info);
		}
		
		private function onLoadComplete(e:Event):void
		{
			if (e.target.data != null && e.target.data != "")
			{
				if (_callBack != null)
				{
					var params:Array = new Array();
					params.push(_url, e.target.data);
					_callBack.apply(this, params);
				}
			}
			
			dispose();
		}
		
		private function dispose():void
		{
			removeListener();
			_callBack = null;
			_url = null;
			_urlLrd = null;
//			ObjectPool.disposeObject(this);
		}
		
	}
}