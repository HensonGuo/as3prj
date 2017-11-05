package test.socket
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.ByteArray;
	
	import net.NetClient;
	import net.NetEvent;
	import net.Packet;
	
	import test.ITest;
	
	public class SocketTest implements ITest
	{
		private var _registPanel:RegistPanel;
		private var _client:NetClient;
		private var _tf:TextField=new TextField();
		
		public function SocketTest()
		{
		}
		
		public function test(stage:Stage):void
		{
			_client = new NetClient();
			_client.buildConnection("192.168.11.42", 4900);
			_client.addEventListener(NetEvent.READED_DATA, onReadedDataHandler);
			_client.addEventListener(Event.CONNECT, onConnectServerHandler);
			
			_registPanel = new RegistPanel();
			stage.addChild(_registPanel);
			_registPanel.addEventListener(NetEvent.NET_CONNECT, requestConnectServer);
			
			_tf.border = true;
			_tf.width = 300;
			_tf.height = 400;
			_tf.x=50;
			_tf.y = 50;
			_tf.type = TextFieldType.INPUT;
			stage.addChild(_tf);
		}
		
		private function requestConnectServer(e:NetEvent):void {
			var p:Packet = new Packet();
			p.writeShort(1000);
			p.writeInt(e.playerID);
			trace(e.playerID);
			_client.sendPacket(p);
		}
		
		private function onConnectServerHandler(e:Event):void {
			_tf.appendText("已建立连接\n");
			
			return;
			_tf.appendText("请求密匙\n");
			var packt:Packet = new Packet();
			packt.writeShort(6144);
			packt.writeShort(1);
			packt.writeInt(0);
			var bt:ByteArray = new ByteArray();
			bt.writeByte(0x80 | 0);
			packt.writeBytes(bt, 0, bt.length);
			_client.sendPacket(packt);
		}
		
		private function onReadedDataHandler(e:NetEvent):void {
			var p:Packet=new Packet(e.bytesData);
			var info:String = "---" + p.readInt() + "---" + p.readInt()+"---"+p.readString()+"\n";
			_tf.appendText(info);
		}
		
	}
}