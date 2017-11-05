package menu.color_menu
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import menu.base.MenuItem;
	
	public class ColorMenuItem extends MenuItem
	{
		private var _color:String;
		private var _mc:MovieClip;
		
		public function ColorMenuItem(color:String)
		{
			_color = color;
			super();
		}
		
		override protected function construct():void
		{
			switch(_color)
			{
				case "gray":
					_mc = new GrayItem();
					break;
				case "green":
					_mc = new GreenItem();
					break;
				case "blue":
					_mc = new BlueItem();
					break;
				case "red":
					_mc = new RedItem();
					break;
				case "cyan":
					_mc = new CyanItem
					break;
				case "purple":
					_mc = new PurpleItem();
					break;
				case "yellow":
					_mc = new YellowItem();
					break;
			}
			_mc.stop();
			this.addChild(_mc);
		}
		
		override public function set label(label:String):void
		{
			if(_mc.getChildAt(0).hasOwnProperty("_txt"))
			{
				var text:TextField = _mc.getChildAt(0)["_txt"] as TextField;
				text.text = label;
				text.width = text.textWidth + 4;
			}
			super.label = label;
		}
		
		override public function set selected(value:Boolean):void
		{
			if (value)
			{
				_mc.gotoAndStop(17);
			}
			else
			{
				_mc.gotoAndPlay(17);
			}
			super.selected = value;
		}
		
		override public function showMouseOverState():void
		{
			_mc.gotoAndPlay(2);
		}
		
		override public function showMouseUpState():void
		{
			_mc.gotoAndPlay(17);
		}
		
	}
}