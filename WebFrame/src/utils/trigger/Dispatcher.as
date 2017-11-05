package utils.trigger
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class Dispatcher
	{
		private static var dispatcher:IEventDispatcher = new EventDispatcher();
		
		public function Dispatcher()
		{
			
		}
		/**
		 * 加侦听
		 */
		public static function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ) : void 
		{
			dispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		
		/**
		 * 移除侦听
		 */
		public static function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ) : void 
		{
			dispatcher.removeEventListener( type, listener, useCapture );
		}
		
		/**
		 * 派发事件
		 */
		public static function dispatchEvent( event:Event ) : Boolean 
		{
			return dispatcher.dispatchEvent( event );
		}
		
		/**
		 * 返回是否有这个侦听
		 */
		public static function hasEventListener( type:String ) : Boolean 
		{
			return dispatcher.hasEventListener(type);
		}
	}
}
