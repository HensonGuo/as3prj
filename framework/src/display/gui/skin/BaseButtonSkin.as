package display.gui.skin
{
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	
	import flash.geom.Rectangle;

	public class BaseButtonSkin extends AeonSkin
	{
		public function BaseButtonSkin(altasName:String = "aeon")
		{
			super(altasName);
		}
		
		override public function applySkin(compenont:FeathersControl):void
		{
			var btn:Button = compenont as Button;
			btn.focusPadding = -1;
			btn.paddingTop = btn.paddingBottom = 2;
			btn.paddingLeft = btn.paddingRight = 10;
			btn.gap = 2;
			btn.minWidth = btn.minHeight = 12;
			super.applySkin(compenont);
		}
	}
}