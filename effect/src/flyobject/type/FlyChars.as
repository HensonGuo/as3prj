package flyobject.type
{
	import flash.display.DisplayObjectContainer;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	public class FlyChars extends BaseFlyObject
	{
		private static const _dropShadowFilter:DropShadowFilter = new DropShadowFilter(0.5, 45, 0x333333, 1, 2, 2, 5, BitmapFilterQuality.LOW);
		private static const _textFmt:TextFormat = new TextFormat("微软雅黑", 20, 0xfaf945, true, null, null, null, null, "center");
		
		private const _delay:int = 1000;
		private var _startDisappear:Boolean = false;
		private var _startDisappearTime:int;
		private var _canDirectDisappear:Boolean = false;
		
		public function FlyChars()
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		override protected function constructFlyObj():void
		{
			_flyObj = new TextField();
			var txtFld:TextField = _flyObj  as TextField;
			txtFld.mouseEnabled = false;
			txtFld.width = 214;
			txtFld.height = 54;
			txtFld.defaultTextFormat = _textFmt;
			txtFld.multiline = true;
			txtFld.wordWrap = true;
			txtFld.autoSize = TextFieldAutoSize.CENTER;
			txtFld.filters = [_dropShadowFilter];
			this.addChild(txtFld);
		}
		
		override protected function fadingForDisappear():void
		{
			if (_isDisappeared)
				return;
			if (!_startDisappear)
			{
				_startDisappear = true;
				_startDisappearTime = getTimer();
				return;
			}
			if (! _canDirectDisappear)
			{
				var curTime:int = getTimer();
				if (curTime - _startDisappearTime >= _delay)
				{
					startFading();
					_canDirectDisappear = true;
				}
			}
			else
			{
				startFading();
			}
		}
		
		private function startFading():void
		{
			this.alpha -= 0.005;
			this.y += 1;
			_isDisappeared = this.alpha <= 0;
		}
		
		public function set text(value:String):void
		{
			(_flyObj as TextField).text = value;
		}
		
		override public function dispose():void
		{
			_startDisappear = false;
			_startDisappearTime = 0;
			_canDirectDisappear = false;
			super.dispose();
		}
		
	}
}