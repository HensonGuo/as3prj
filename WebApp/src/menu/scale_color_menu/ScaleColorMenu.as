package menu.scale_color_menu
{
	import flash.geom.Rectangle;
	
	import menu.base.BaseMenu;
	
	public class ScaleColorMenu extends BaseMenu
	{
		private const _radius:Number = 40;
		private const _scale:Number = 2;
		private const _attribs:Array = [{x:100, y:100, color:0x7FE680}, {x:200, y:150, color:0x12C9FF}, {x:120, y:180, color:0xFEACA0}, {x:100, y:150, color:0xFE98B2}];
		
		public function ScaleColorMenu(itemClass:Class, items:Array=null)
		{
			super(itemClass, items);
		}
		
		override protected function constructItems():void
		{
			for (var i:int = 0; i < _data.length; i++)
			{
				var attrib:Object = _attribs[i];
				var item:ScaleColorMenuItem = new ScaleColorMenuItem(attrib.color, _radius, _scale);
				item.x = attrib.x;
				item.y = attrib.y;
				this.addChild(item);
			}
		}
		
		
	}
}