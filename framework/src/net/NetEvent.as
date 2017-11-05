package net{
	import flash.events.Event;
	import flash.utils.ByteArray;

	/**
	 * @author zkpursuit
	 */
	public class NetEvent extends Event {
		public static const NET_CLOSE:String="net_close";
		public static const NET_CONNECT:String="net_connect";
		public static const IO_ERROR:String="io_errow";
		public static const SECURITY_ERROR:String="security_error";
		public static const SOCKET_DATA:String = "socket_data";
		public static const READED_DATA:String = "readed_data";
		public static const NULL_STREAM:String = "null_stream";
		
		private var playerId:int;
		private var _data:ByteArray;
		
		public function NetEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
		public function set bytesData(data:ByteArray):void{
			_data=data;
		}
		public function get bytesData():ByteArray{
			return _data;
		}

		public function set playerID(id:int):void {
			playerId = id;
		}
		public function get playerID():int {
			return playerId;
		}
	}
}
