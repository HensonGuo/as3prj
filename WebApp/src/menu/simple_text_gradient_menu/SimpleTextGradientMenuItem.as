package menu.simple_text_gradient_menu
{
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import greensock.TweenLite;
	
	import menu.base.MenuItem;
	
	import resource.FontManager;
	
	public class SimpleTextGradientMenuItem extends MenuItem
	{
		private var _height:Number = 36;
		private var _width:Number = 0;
		private var _text:TextField;
		
		private var _orgColor:uint;
		private var _hoverColor:uint
		
		public function SimpleTextGradientMenuItem(orgColor:uint, hoverColor:uint)
		{
			_orgColor = orgColor;
			_hoverColor = hoverColor;
			super();
		}
		
		override protected function construct():void
		{
			_text = new TextField();
			this.addChild(_text);
		}
		
		private function adjustText():void
		{
			_text.defaultTextFormat = new TextFormat(FontManager.MICROSOFT_YAHEI, 16, _orgColor);
			_text.text = _label;
			_text.width = _text.textWidth + 4;
			_text.x = 25;
			_text.y = 4;
			
			//draw bg
			_width = _text.textWidth + _text.x + 25;
			this.graphics.clear();
			this.graphics.beginFill(16711680,0);
			this.graphics.drawRect(0,0,_width,_height);
			this.graphics.endFill();
		}
		
		override public function set selected(value:Boolean):void
		{
			if (!value)
				showMouseUpState();
			else
				_text.textColor = _hoverColor;
			super.selected = value;
		}
		
		override public function set label(label:String):void
		{
			super.label = label;
			adjustText();
		}
		
		override public function showMouseOverState():void
		{
			_text.filters = [new GlowFilter(16777215,0.5,12,12,2,3)];
			TweenLite.to(_text, 0.5, {textColor:_hoverColor});
		}
		
		override public function showMouseUpState():void
		{
			_text.filters = null;
			TweenLite.to(_text, 0.5, {textColor:_orgColor});
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		
	}
}