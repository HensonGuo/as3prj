package module.window
{
	import display.window.BaseWindow;
	import display.window.WindowLocate;
	
	import events.CallerName;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import resource.FontManager;
	
	import utils.DrawUtils;
	import utils.OptimizeUtil;
	import utils.trigger.Caller;
	
	public class WelcomeWindow extends BaseWindow
	{
		private var _title:TextField;
		private var _txtFullScreen:TextField;
		private var _txtNormal:TextField;
		
		private var _btnFullScreen:Sprite;
		private var _btnNormal:Sprite;
		
		public function WelcomeWindow()
		{
			super();
		}
		
		override protected function config():void
		{
			_locate.setting(WindowLocate.TYPE_CENTER);
		}
		
		override protected function layout():void
		{
			this.graphics.lineStyle(2, 0x999999);
			this.graphics.moveTo(0, 60);
			this.graphics.lineTo(200, 60);
			
			_title = new TextField;
			_title.defaultTextFormat = new TextFormat(FontManager.MICROSOFT_YAHEI, 30, 0x990099, true);
			_title.text = "唯  爱  至  上";
			_title.width = 200;
			_title.x = 10;
			_title.y = 10;
			OptimizeUtil.optimizeRender(_title);
			this.addChild(_title);
			
			const textFmt:TextFormat = new TextFormat(FontManager.MICROSOFT_YAHEI, 16, 0xffffff, true);
			_txtFullScreen = new TextField();
			_txtFullScreen.defaultTextFormat = textFmt;
			_txtFullScreen.text = "全屏浏览";
			_txtFullScreen.x = 20;
			_txtFullScreen.y = 70;
			OptimizeUtil.optimizeRender(_txtFullScreen);
			this.addChild(_txtFullScreen);
			
			_btnFullScreen = new Sprite();
			DrawUtils.drawBg(_btnFullScreen,70, 28, 0, 0);
			_btnFullScreen.x = 20;
			_btnFullScreen.y = 70;
			_btnFullScreen.buttonMode = true;
			this.addChild(_btnFullScreen);
			
			_txtNormal = new TextField();
			_txtNormal.defaultTextFormat = textFmt;
			_txtNormal.text = "普通浏览";
			_txtNormal.x = 110;
			_txtNormal.y = 70;
			OptimizeUtil.optimizeRender(_txtNormal);
			this.addChild(_txtNormal);
			
			_btnNormal = new Sprite();
			DrawUtils.drawBg(_btnNormal,70, 28, 0, 0);
			_btnNormal.x = 110;
			_btnNormal.y = 70;
			_btnNormal.buttonMode = true;
			this.addChild(_btnNormal);
			
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _btnFullScreen:
					stage.displayState = StageDisplayState.FULL_SCREEN;
					Caller.dispatchCmd(CallerName.ENTER_HOME);
					break;
				case _btnNormal:
					Caller.dispatchCmd(CallerName.ENTER_HOME);
					break;
			}
		}
	}
}