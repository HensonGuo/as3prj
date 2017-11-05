package utils
{
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.IEventDispatcher;
	import flash.events.UncaughtErrorEvent;
	import flash.events.UncaughtErrorEvents;
	
	import utils.debug.LogUtil;

	/**
	 *全局错误的捕获 
	 * @author g7842
	 */	
	public class GlobalError
	{
		private var _lastErrorMsg:String;
		
		public function GlobalError()
		{
		}
		
		public function listenErrors(stage:Stage):void
		{
			watch(stage.loaderInfo);
			if(stage.loaderInfo.hasOwnProperty("uncaughtErrorEvents")) 
			{
				for(var i : int = 0;i < stage.numChildren;i++) 
				{
					watch(stage.getChildAt(i).loaderInfo);
				}
			}
		}
		
		public function unlistenErrors(stage:Stage):void
		{
			unwatch(stage.loaderInfo);
			if(stage.loaderInfo.hasOwnProperty("uncaughtErrorEvents")) 
			{
				for(var i : int = 0;i < stage.numChildren;i++) 
				{
					unwatch(stage.getChildAt(i).loaderInfo);
				}
			}
		}
		
		private function watch(loaderInfo : LoaderInfo) : void 
		{
			if(loaderInfo.hasOwnProperty("uncaughtErrorEvents")) 
			{
				IEventDispatcher(loaderInfo["uncaughtErrorEvents"]).addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
			}
		}
		
		private function unwatch(loaderInfo : LoaderInfo) : void 
		{
			if(loaderInfo.hasOwnProperty("uncaughtErrorEvents")) 
			{
				IEventDispatcher(loaderInfo["uncaughtErrorEvents"]).removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
			}
		}
		
		private function uncaughtErrorHandler(event : ErrorEvent) : void 
		{
			event.preventDefault();
			
			var message:String;
			var error : * = event['error'];
			//只有FP11.5以上才能在非debug版本中调用getStackTrace()
			if(error.hasOwnProperty("getStackTrace"))
			{
				message = error.getStackTrace();
			}
			else if (error is Error)
			{
				message = Error(error).message;
			}
			else if (error is ErrorEvent)
			{
				message = ErrorEvent(error).text;
			}
			else
			{
				message = error.toString();
			}
			if(_lastErrorMsg == message)
			{
				return;
			}
			_lastErrorMsg = message;
			LogUtil.output(LogUtil.LOG_ERROR, message, true);
		}
	}
}