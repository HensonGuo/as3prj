package menu.simple_text_gradient_menu
{
	import menu.base.BaseMenu;
	
	import utils.FontManager;
	
	/**
	 *参考：http://www.nikedejia.com/ 
	 * @author Administrator
	 */	
	public class SimpleTextGradientMenu extends BaseMenu
	{
		private const _orgColor:uint = 0x999999;
		private const _hoverColor:uint = 0xffffff
		private const _itemSpace:Number = 2
			
		public function SimpleTextGradientMenu(itemClass:Class, data:Array=null)
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
				var item:SimpleTextGradientMenuItem = new SimpleTextGradientMenuItem(_orgColor, _hoverColor);
				item.label = dta.label;
				item.x = offsetX;
				if (i==0)
					defaultSelectedItem = item;
				offsetX += item.width + _itemSpace;
				this.addChild(item);
			}
		}
	}
}