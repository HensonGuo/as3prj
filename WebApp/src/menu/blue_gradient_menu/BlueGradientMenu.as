package menu.blue_gradient_menu
{
	import menu.base.BaseMenu;
	
	import utils.FontManager;
	
	public class BlueGradientMenu extends BaseMenu
	{
		private const _itemWidth:Number = 100;
		private const _itemSpace:Number = 2;
		
		public function BlueGradientMenu(itemClass:Class, data:Array=null)
		{
			super(itemClass, data);
		}
		
		override protected function constructItems():void
		{
			FontManager.setYaheiFont();
			
			var offsetX:Number = 0;
			for (var i:int = 0; i < _data.length; i++)
			{
				var dta:Object = _data[i];
				var item:BlueGradientMenuItem = new BlueGradientMenuItem(_itemWidth);
				if (i==0)
					defaultSelectedItem = item;
				item.label = dta.label;
				item.x = offsetX;
				offsetX += item.width + _itemSpace;
				this.addChild(item);
			}
		}
	}
}