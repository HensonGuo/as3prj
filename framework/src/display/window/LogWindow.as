package display.window
{
	import display.BaseView;
	import display.gui.UIFactory;
	
	import feathers.controls.Button;
	import feathers.controls.text.TextFieldTextRenderer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import starling.events.Event;
	
	import utils.debug.SimulateLog;
	
	public class LogWindow extends BaseWindow
	{
		private var _copyButton:Button;
		private var _closeButton:Button;
		private var _clearButton:Button;
		private var _simulateButton:Button;
		private var _txtField:TextFieldTextRenderer;
		
		private var _logMsg:String = "日志消息";
		private var _simulateMode:SimulateLog = new SimulateLog();
		
		public function LogWindow()
		{
			super();
		}
		
		override protected function config():void
		{
			_locate.setting(WindowLocate.TYPE_TOP_LEFT, WindowLayer.LOW);
			
			FrameWork.skinManager.registerTexture("GrayBg", new Bitmap(new BitmapData(10, 10, true, 0x33cccccc)));
			FrameWork.scale9Manager.register("", "GrayBg", new Rectangle(1, 1, 7, 7));
		}
		
		override protected function layout():void
		{
			UIFactory.scaleImage(0, 0, stage.stageWidth, stage.stageHeight, this, "","GrayBg");
			_txtField = UIFactory.textFiledRender("", 14, 14, stage.stageWidth - 28, stage.stageHeight - 42, this);
			
			_copyButton = UIFactory.button("复制", 20, stage.stageHeight - 30, 50, 20, this);
			_copyButton.addEventListener(Event.TRIGGERED, onMouseClick);
			_clearButton = UIFactory.button("清除", 80, stage.stageHeight - 30, 50, 20, this);
			_clearButton.addEventListener(Event.TRIGGERED, onMouseClick);
			_closeButton = UIFactory.button("关闭", 140, stage.stageHeight - 30, 50, 20, this);
			_closeButton.addEventListener(Event.TRIGGERED, onMouseClick);
			_simulateButton = UIFactory.button("模拟", 200, stage.stageHeight - 30, 50, 20, this);
			_simulateButton.addEventListener(Event.TRIGGERED, onMouseClick);
		}
		
		override protected function update():void
		{
			_txtField.text = _logMsg;
		}
		
		override public function destory(isReuse:Boolean=true):void
		{
			super.destory(isReuse);
			_copyButton = null;
			_closeButton = null;
			_simulateButton = null;
			this.removeEventListener(Event.TRIGGERED, onMouseClick);
		}
		
		private function onMouseClick(event:Event):void
		{
			switch(event.target)
			{
				case _closeButton:
					FrameWork.windowManager.removePopup(LogWindow);
					break;
				case _copyButton:
					System.setClipboard(_txtField.text);
					break;
				 case _simulateButton:
					 _simulateMode.start(_txtField.text);
					 FrameWork.windowManager.removePopup(LogWindow);
					 break;
				 case _clearButton:
					 _logMsg = "";
					 update();
					 break;
			}
		}
		
		public function appendLog(log:String):void
		{
			_logMsg += "\n" + log;
			if (hasPopup)
				update();
		}
		
	}
	
}