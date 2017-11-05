package utils.debug
{
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.utils.getTimer;
	import utils.FormatDate;
	

	public class LogUtil
	{
		public static const LOG_ERROR:int = 1;
		public static const LOG_WARN:int = 2;
		public static const LOG_INFO:int = 3;
		public static const LOG_DEBUG:int = 4;
		
		private static var _logLevel:int = LOG_DEBUG;
		private static var _logPrefix:String = "";
		public static var consoleLogEnable:Boolean = false;
		public static var outputCallback:Function = null;
			
		public static var traceOutWarningCallback:Function = null;
			
		public static function activate():void
		{
			if (!FrameWork.isDebugMode)
				return;
			var now:Date = new Date();
			_logPrefix = FormatDate.formatTime(now);
			_logPrefix += "-" + getTimer();
		}
		
		public static function assert(expression:Boolean, description:String = null):void
		{
			if (!expression)
			{
				throwError(new Error("Check failed!! " + description));
			}
		}
		
		public static function debug(msg:String, externOutput:Boolean = false):void
		{
			if (_logLevel >= LOG_DEBUG)
				output(LOG_DEBUG, msg, externOutput);
		}
		
		public static function info(msg:String, externOutput:Boolean = false):void
		{
			if (_logLevel >= LOG_INFO)
				output(LOG_INFO, msg, externOutput);
		}
		
		public static function warn(msg:String, externOutput:Boolean = false):void
		{
			if (_logLevel >= LOG_WARN)
				output(LOG_WARN, msg, externOutput);
		}
		
		public static function error(msg:String, externOutput:Boolean = true):void
		{
			if (_logLevel >= LOG_ERROR)
			{
				var error:Error = new Error();
				output(LOG_ERROR, msg + error.getStackTrace(), externOutput);
			}
		}
		
		public static function set logLevel(level:int):void
		{
			_logLevel = level;
		}
		
		public static function output(type:int, msg:String, externOutput:Boolean):void
		{
			var perfix:String = _logPrefix;
			switch (type) 
			{
				case LOG_DEBUG:
					perfix += "[DEBUG]";
					break;
				case LOG_INFO:
					perfix += "[INFO]";
					break;
				case LOG_WARN:
					perfix += "[WARN]";
					break;
				case LOG_ERROR:
					perfix += "[ERROR]";
					break;
				default:
					assert(false);
					break;
			}
			
			msg = perfix + msg;
			if (consoleLogEnable)
				ExternalInterface.call('console.log', msg);
			
			if (Capabilities.isDebugger)
				trace(msg);
			
			if (outputCallback != null)
				outputCallback.call(null, type, msg);
		}
		
		public static function throwError(error:Error):void
		{
			output(LOG_ERROR, "throw error " 
				+ error.name + ", "
				+ error.errorID + ", "
				+ error.message + ", "
				+ error.getStackTrace() + ""
				+ error.toString(), 
				true
			);
			if (Capabilities.isDebugger)
			{
				throw error;
			}
		}
		
		public static function traceOutWaring(msg:String):void
		{
			if (traceOutWarningCallback != null)
				traceOutWarningCallback.call(null, msg);
		}
		
		/**
		 *解析log 
		 * @param log
		 * @param valueableKey
		 * @param excuteCallback
		 */		
		public static function pasreLog(log:String, valueableKey:String, excuteCallback:Function):void
		{
			var arr:Array = log.split("\n");
			for (var i:int = 0; i < arr.length; i++)
			{
				var logField:String = arr[i];
				var index:int = logField.indexOf(valueableKey);
				if (index == -1)
					continue;
				var valuableField:String = logField.substring(index + valueableKey.length);
				excuteCallback.call(null, valuableField);
			}
		}
	}
}