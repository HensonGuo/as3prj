package display.gui.skin
{
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	
	import flash.geom.Rectangle;

	public class AeonSkin extends BaseSkin
	{
		public function AeonSkin(altasName:String="aeon")
		{
			super(altasName);
		}
		
		override public function applySkin(compenont:FeathersControl):void
		{
			compenont.focusIndicatorSkin = new Scale9Image(_skin.getScale9Texture(_altasName, "focus-indicator-skin"));
		}
		
		override protected function registerScale9():void
		{
			_scale9.register(_altasName, "focus-indicator-skin", new Rectangle(5, 4, 1, 14));
		}
	}
}