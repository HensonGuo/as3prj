package menu
{
	import flash.display.Sprite;
	
	import menu.base.BaseMenu;
	import menu.blue_gradient_menu.BlueGradientMenu;
	import menu.blue_gradient_menu.BlueGradientMenuItem;
	import menu.color_menu.ColorMenu;
	import menu.color_menu.ColorMenuItem;
	import menu.scale_color_menu.ScaleColorMenu;
	import menu.scale_color_menu.ScaleColorMenuItem;
	import menu.simple_text_gradient_menu.SimpleTextGradientMenu;
	import menu.simple_text_gradient_menu.SimpleTextGradientMenuItem;
	
	[SWF(width="800", height="460", backgroundColor="#000000", frameRate="24")]
	public class BuilderMenu extends Sprite
	{
		public function BuilderMenu()
		{
			super();
			var nmu:BaseMenu = new SimpleTextGradientMenu(SimpleTextGradientMenuItem);
			this.addChild(nmu);
		}
	}
}