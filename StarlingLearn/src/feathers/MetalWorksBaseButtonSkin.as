package feathers
{
	import feathers.controls.Button;
	import feathers.controls.ToggleButton;
	import feathers.core.FeathersControl;
	
	public class MetalWorksBaseButtonSkin extends MetalWorksSkin
	{
		public function MetalWorksBaseButtonSkin(altasName:String="aeon")
		{
			super(altasName);
		}
		
		override public function applySkin(compenont:FeathersControl):void
		{
			var btn:Button = compenont as Button;
//			button.defaultLabelProperties.elementFormat = this.darkUIElementFormat;
//			button.disabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;
//			if(button is ToggleButton)
//			{
//				ToggleButton(button).selectedDisabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;
//			}
			
			
			btn.paddingTop = 4;
			btn.paddingBottom = 4;
			btn.paddingLeft = 8;
			btn.paddingRight = 8;
			btn.gap = 4;
			btn.minGap = 4;
			btn.minWidth = 12;
			btn.minHeight = 12;
			super.applySkin(compenont);
		}
	}
}