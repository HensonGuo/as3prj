package test
{
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	[SWF(width="200", height="200", backgroundColor="#ffffff", frameRate="24")]
	public class Sample extends Sprite
	{
		private var _text:TextField;
		
		public function Sample()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var button:PushButton = new PushButton(this, 50, 50, "button", onButtonClick);
			_text = new TextField();
			_text.x = 70;
			_text.y = 100;
			_text.text = "点我啊";
			this.addChild(_text);
		}
		
		private var _count:int;
		private function onButtonClick(event:MouseEvent):void
		{
			_text.text = _count++.toString();
		}
	}
}