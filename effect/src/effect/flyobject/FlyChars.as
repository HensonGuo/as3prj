package effect.flyobject
{
	import effect.flyobject.FlyObject;
	
	import flash.display.DisplayObjectContainer;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import resource.FontManager;
	
	public class FlyChars extends FlyObject
	{
		private static const _dropShadowFilter:DropShadowFilter = new DropShadowFilter(0.5, 45, 0x333333, 1, 2, 2, 5, BitmapFilterQuality.LOW);
		private static const _textFmt:TextFormat = new TextFormat(FontManager.MICROSOFT_YAHEI, 20, 0xfaf945, true, null, null, null, null, "center");
		
		protected var _delay:int = 1000;
		protected var _startDisappear:Boolean = false;
		protected var _startDisappearTime:int;
		protected var _canDirectDisappear:Boolean = false;
		
		public function FlyChars()
		{
			super();
		}
		
		override protected function constructEntity():void
		{
			_entity = new TextField();
			var txtFld:TextField = _entity  as TextField;
			txtFld.mouseEnabled = false;
			txtFld.width = 320;
			txtFld.height = 54;
			txtFld.defaultTextFormat = _textFmt;
			txtFld.multiline = true;
			txtFld.wordWrap = true;
			txtFld.autoSize = TextFieldAutoSize.CENTER;
			txtFld.filters = [_dropShadowFilter];
		}
		
		/**
		 * 渐变消失
		 */
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
		
		/**
		 * 开始渐变
		 */
		protected function startFading():void
		{
			_entity.alpha -= 0.005;
			_entity.y += 1;
			_isDisappeared = _entity.alpha <= 0;
		}
		
		public function set text(value:String):void
		{
			(_entity as TextField).text = value;
		}
		
		public function set size(value:Object):void
		{
			var fmt:TextFormat = _textFmt;
			fmt.size = value;
			(_entity as TextField).defaultTextFormat = fmt;
		}
		
		public function set width(value:Number):void
		{
			_entity.width = value;
		}
		
		public function get width():Number
		{
			return _entity.width;
		}
		
		public function set height(value:Number):void
		{
			_entity.height = value;
		}
		
		override protected function reset():void
		{
			_startDisappear = false;
			_startDisappearTime = 0;
			_canDirectDisappear = false;
			super.reset();
		}
		
	}
}