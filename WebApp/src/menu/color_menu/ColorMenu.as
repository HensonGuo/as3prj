package menu.color_menu
{
	import menu.base.BaseMenu;
	
	public class ColorMenu extends BaseMenu
	{
		private const _colors:Array = ["green", "blue", "red", "cyan", "purple", "yellow", "gray"];
		
		public function ColorMenu(itemClass:Class, items:Array=null)
		{
			super(itemClass, items);
		}
		
		override protected function constructItems():void
		{
			for (var i:int = 0; i < _data.length; i++)
			{
				var color:String = _colors[i];
				var dta:Object = _data[i];
				var item:ColorMenuItem = new ColorMenuItem(color);
				if (i==0)
					defaultSelectedItem = item;
				item.label = dta.label;
				item.x = (item.width + 2) * i;
				this.addChild(item);
			}
		}
		
	}
}