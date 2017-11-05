package  test.socket
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import net.NetEvent;

	/**
	 * ...
	 * @author zkpursuit
	 */
	public class RegistPanel extends Sprite
	{
		private var tf:TextField;
		private var bt:Button;
		public function RegistPanel() 
		{
			//this.graphics.beginFill(0xcc9933);
			//this.graphics.drawRect(0, 0, 200, 200);
			//this.graphics.endFill();
			
			tf = new TextField();
			tf.border = true;
			tf.type = TextFieldType.INPUT;
			tf.width = 100;
			tf.height = 20;
			addChild(tf);
			
			bt = new Button(40, 20);
			bt.x = tf.width + 10;
			addChild(bt);
			
			bt.addEventListener(MouseEvent.CLICK, onClickHandler);
		}
		
		private function onClickHandler(e:MouseEvent):void {
			//if (!int(tf.text)) {
				var event:NetEvent = new NetEvent(NetEvent.NET_CONNECT);
				event.playerID = (int)(tf.text);
				dispatchEvent(event);
			//}
		}
	}
}