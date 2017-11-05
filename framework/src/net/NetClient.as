package net{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import utils.debug.LogUtil;

	/**
	 * socket客户端，此类适用于  dataLen + data  的数据协议
	 * 处理断包，粘包问题
	 * @author zkpursuit
	 */
	public class NetClient extends EventDispatcher{

		private var _socket:Socket;
		private var _recieveBuffer:ByteArray;	//数据缓存
		private var _dataLength:int;					//接收到的数据长度
		private var _headLen:int;						//数据包首部长度
		
		public function NetClient(){
			_recieveBuffer = new ByteArray();
			//数据长度，一般由服务器定义的数据协议中规定的数据包长度的数据类型的字节大小，int占有4个字节
			_headLen = 4;
		}
		
		/**
		 * 建立socket连接
		 * @param	host 服务器IP地址
		 * @param	port 服务器开放供客户连接的端口
		 */
		public function buildConnection(host:String = "127.0.0.1", port:int = 8088):void {
			_socket = new Socket(host, port);
			_socket.addEventListener(Event.CLOSE, closeHandler);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_socket.addEventListener(Event.CONNECT, connectHandler);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, receivedHandler);
		}
		
		private function closeHandler(e:Event):void {
			_socket.removeEventListener(Event.CLOSE, closeHandler);
			_socket.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_socket.removeEventListener(Event.CONNECT, connectHandler);
			_socket.removeEventListener(ProgressEvent.SOCKET_DATA, receivedHandler);
			dispatchEvent(e);
			LogUtil.info("服务器已关闭此连接");
		}
		private function ioErrorHandler(e:IOErrorEvent):void {
			LogUtil.error("socket连接失败"+e.text);
		}
		private function securityErrorHandler(e:SecurityErrorEvent):void {
			LogUtil.error("未正确设置安全策略文件"+e.text+"\n注意：\n1、返回的策略文件IP和端口要正确。" +
				"\n2、返回的策略文件结尾要加\\0否则无法正常解析");
		}
		private function connectHandler(e:Event):void {
			LogUtil.info("已建立连接");
		}
		private function receivedHandler(e:ProgressEvent):void {
			parse();
		}
		
		/**
		 * 为避免一次接收到多条数据包，必须进行数据包的分离解码
		 * 网络数据解码
		 */
		private function parse():void{
			//开始读取数据的标记
			var readFlag:Boolean = false;
			//每读取一条数据bytesAvailable值将随之减少
			//while (socket.bytesAvailable>=headLen) {
			while (_socket.bytesAvailable) {
				if (!readFlag && _socket.bytesAvailable >= _headLen) {
					//读取数据长度
					_dataLength = _socket.readInt();
					readFlag = true;
				}
				//如果为0,表示收到异常消息，避免无限循环地等待
				if(_dataLength==0){
					dispatchEvent(new NetEvent(NetEvent.NULL_STREAM));
					return;
				}
				if (!readFlag)
					return;
				//开始读数据
				if (_socket.bytesAvailable >= _dataLength){
					//指针回归
					_recieveBuffer.position = 0;
					//取出指定长度的字节
					_socket.readBytes(_recieveBuffer, 0, _dataLength);

					//读取完一条消息后发送消息内容
					var event:NetEvent=new NetEvent(NetEvent.READED_DATA);
					event.bytesData=_recieveBuffer;
					dispatchEvent(event);
					
					//reset
					_recieveBuffer.clear();
					_dataLength = 0;
					readFlag = false;
				}
				else
				{
					LogUtil.error("***出现断包***");
				}
			}
		}
		/**
		 * 发送数据
		 * @param	bytes
		 */
		public function send(bytes:ByteArray):void{
			var bytes_len:int = bytes.length;
			//数据的长度
			_socket.writeInt(bytes_len);
			//发送的数据内容
			_socket.writeBytes(bytes);
			_socket.flush();
		}
		/**
		 * 发送自定义数据包
		 * @param	packet
		 */
		public function sendPacket(packet:Packet):void {
			send(packet.array());
		}
	}
}
