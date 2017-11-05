package feathers
{
	import display.gui.skin.BaseSkin;
	
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	
	import flash.geom.Rectangle;
	
	public class MetalWorksSkin extends BaseSkin
	{
		public function MetalWorksSkin(altasName:String="aeon")
		{
			super(altasName);
		}
		
		override public function applySkin(compenont:FeathersControl):void
		{
			compenont.focusIndicatorSkin = new Scale9Image(_skin.getScale9Texture(_altasName, "focus-indicator-skin"));
			compenont.focusPadding = -2;
		}
		
		override protected function registerScale9():void
		{
			_scale9.register(_altasName, "focus-indicator-skin", new Rectangle(5, 5, 1, 1));
		}
	}
}