package menu.blue_gradient_menu
{
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import greensock.TweenLite;
	
	import menu.base.MenuItem;
	
	import utils.FontManager;
	
	public class BlueGradientMenuItem extends MenuItem
	{
		private var _height:Number = 36;
		private var _width:Number = 0;
		
		private var _item:GradientMenuItem;
		private var _text:TextField;
		
		public function BlueGradientMenuItem(width:Number)
		{
			_width = width;
			super();
		}
		
		override protected function construct():void
		{
			_item = new GradientMenuItem();
			_item.height = 0;
			_item.width = _width;
			_item.alpha = 0;
			this.addChild(_item);
			
			_text = new TextField();
			this.addChild(_text);
			
		}
		
		private function adjustText():void
		{
			_text.defaultTextFormat = new TextFormat(FontManager.MICROSOFT_YAHEI, 16, 0xffffff);
			_text.text = _label;
			_text.width = _text.textWidth + 4;
			_text.x = 25;
			_text.y = 4;
			
			//draw bg
			_width = _text.textWidth + _text.x + 25;
			_item.width = _width;
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
			{
				_item.height = _height;
				_item.alpha = 1;
			}
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
			TweenLite.to(_item, 0.5, {height:_height, alpha:1});
		}
		
		override public function showMouseUpState():void
		{
			_text.filters = null;
			TweenLite.to(_item, 0.5, {height:0, alpha:0});
		}
		
		override public function get width():Number
		{
			return _item.width;
		}
		
	}
}