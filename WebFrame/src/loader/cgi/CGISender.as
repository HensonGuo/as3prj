package loader.cgi
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import resource.pools.ObjectPool;
	import resource.pools.Reuse;
	
	import utils.StringUtil;
	import utils.debug.LogUtil;

	public class CGISender extends Reuse
	{
		private static var SendingMap:Dictionary = new Dictionary(true);
		
		private var _reciever:Class;
		private var _urlLoad:URLLoader;
		private var _urlRequest:URLRequest;
		private var _url:String;
		
		private var _reloadInterval:int;
		private var _reloadCount:int;
		private const _maxReloadCount:int = 4;
		
		public function CGISender(reloadInterval:int = 30000)
		{
			setInitParams(reloadInterval);
		}
		
		override protected function setInitParams(...parameters):void
		{
			_reloadInterval = parameters[0];
		}
		
		public function load(url:String,reciever:Class, data:Object = null):void
		{
			LogUtil.assert(reciever is ICGIReciever, "reciever type error");
			if (SendingMap[url] != null)
				return;
			SendingMap[url] = url;
			
			_reciever = reciever;
			_url = url;
			//坑爹的字符问题
			url = StringUtil.trim(url);
			
			_urlRequest = new URLRequest(url);
			//解决读取缓存问题
			_urlRequest.method = URLRequestMethod.POST;
			var header:URLRequestHeader = new URLRequestHeader("pragma", "no-cache");
			_urlRequest.requestHeaders.push(header);
			
			if (data != null)
			{
				if (data is URLVariables)
				{
					_urlRequest.data = data;
				}
				else if (data is Object)
				{
					var variables:URLVariables = new URLVariables();
					for (var key:String in data)
					{
						variables[key] = encodeURIComponent(data[key]);
					}
					_urlRequest.data = variables;
				}
				else
				{
					LogUtil.assert(false, "data错误");
				}
			}
			
			_urlLoad = new URLLoader();
			configUrlListener();
			_urlLoad.load(_urlRequest);
		}
		
		private function reload():void
		{
			_reloadCount ++;
			if (_reloadCount > _maxReloadCount)
			{
				LogUtil.warn("load " + _url + " fail!!");
				reset();
				return;
			}
			LogUtil.info("load " + _url + " fail!!. retry ... " + _reloadCount);
			_urlLoad.load(_urlRequest);
		}
		
		private function configUrlListener():void
		{
			removeListener();
			_urlLoad.dataFormat = URLLoaderDataFormat.BINARY;
			_urlLoad.addEventListener(Event.COMPLETE,onLoadComplete);
			_urlLoad.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			_urlLoad.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onIoError);
		}
		
		private function removeListener():void
		{
			if( _urlLoad ){
				_urlLoad.removeEventListener(Event.COMPLETE,onLoadComplete);
				_urlLoad.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
				_urlLoad.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onIoError);
			}
		}
		
		private function onIoError(e:Event):void
		{
			var info:String;
			if( e is IOErrorEvent )
			{
				info = IOErrorEvent(e).text;
				//半分钟重新请求一次
				setTimeout(reload, _reloadInterval);
			}
			else
			{
				info = SecurityErrorEvent(e).text;
				LogUtil.warn("CGI SecurityError URL:" + info);
				reset();
			}
		}
		
		private function onLoadComplete(e:Event):void
		{
			if (e.target.data != null && e.target.data != "")
			{
				LogUtil.info("CGI Recieve Data is null");
				reset();
				return;
			}
			if (_reciever == null)
				return;
			(_reciever as ICGIReciever).onReciever(_url, e.target.data);
			reset();
		}
		
		override protected function reset():void
		{
			removeListener();
			SendingMap[_url] = null;
			delete SendingMap[_url];
			_reciever = null;
			_url = null;
			_urlLoad = null;
			_urlRequest = null;
			ObjectPool.disposeObject(this);
		}
	}
}