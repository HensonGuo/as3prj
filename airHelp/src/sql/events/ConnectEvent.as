package sql.events
{
	import flash.events.Event;

	public class ConnectEvent extends Event
	{	
	
		public static const ON_CREATE_DATA_BASE:String = "onCreateDataBase";//数据库建立成功							
		public static const ON_CREATE_TABLE:String = "onCreateTable";//表建立成功
		public static const ON_INSERT_DATA_COMPLETE:String = "onInsertDataComplete";
		public static const ON_SELECT_COMPLETE:String = "onSelectComplete";//数据返回成功
		public static const ON_SELECT_COUNT_COMPLETE:String = "onSelectCountComplete";//数据返回成功
		public static const ON_SCHEMA:String = "onSchema";//数据库的构架信息返回成功
		public static const ON_ERROR:String = "onError";//错误
		public static const ON_SELECT_EXEC_COMPLETE:String = "onSelectExecComplete";//错误
		
		public var data:*;
		public function ConnectEvent(type:String,_data:*=null, bubbles:Boolean = false,cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.data=_data;
		}
		
		override public function clone():Event
		{
			return new ConnectEvent(type, data,bubbles, cancelable);
		}
		
	}
}