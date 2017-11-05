package feathers
{
	import display.gui.UIFactory;
	import display.gui.skin.BaseSkin;
	
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.core.FeathersControl;
	
	public class YellowButtonGroupSkin extends MetalWorksSkin
	{
		public function YellowButtonGroupSkin(altasName:String="aeon")
		{
			super(altasName);
		}
		
		override public function applySkin(compenont:FeathersControl):void
		{
			var group:ButtonGroup = compenont as ButtonGroup
			group.gap = 6;
			group.buttonFactory = function():Button
			{
				return UIFactory.button("", 0, 0, 49, 22, null, "YellowButton");
			}
		}
	}
}