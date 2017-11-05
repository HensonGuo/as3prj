package menu.base
{
	import flash.display.Sprite;
	
	public class MenuItem extends Sprite
	{
		public var clickCallback:Function;
		
		protected var _selected:Boolean;
		protected var _label:String;
		
		public function MenuItem()
		{
			super();
			this.mouseChildren = false;
			this.cacheAsBitmap = true;
			this.buttonMode = true;
			construct();
		}
		
		protected function construct():void
		{
		}
		
		public function set label(label:String):void
		{
			_label = label;
		}
		
		public function get label():String
		{
			return _label;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function showMouseOverState():void
		{
		}
		
		public function showMouseUpState():void
		{
		}
		
	}
}