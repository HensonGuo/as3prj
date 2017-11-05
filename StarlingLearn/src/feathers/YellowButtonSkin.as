package feathers
{
	import display.gui.skin.BaseButtonSkin;
	
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	
	import flash.geom.Rectangle;
	
	public class YellowButtonSkin extends MetalWorksBaseButtonSkin
	{
		public function YellowButtonSkin(altasName:String = "aeon")
		{
			super(altasName);
		}
		
		override public function applySkin(compenont:FeathersControl):void
		{
			var btn:Button = compenont as Button;
			const skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = _skin.getScale9Texture(_altasName, "button-up-skin");
			skinSelector.setValueForState(_skin.getScale9Texture(_altasName, "button-down-skin"), Button.STATE_DOWN, false);
			skinSelector.setValueForState(_skin.getScale9Texture(_altasName, "button-disabled-skin"), Button.STATE_DISABLED, false);
			
			skinSelector.defaultSelectedValue = _skin.getScale9Texture(_altasName, "button-selected-up-skin");
			skinSelector.setValueForState(_skin.getScale9Texture(_altasName, "button-selected-disabled-skin"), Button.STATE_DISABLED, true);
			skinSelector.displayObjectProperties =
				{
					width: 22,
						height: 22,
						textureScale: 1
				};
			
			btn.stateToSkinFunction = skinSelector.updateValue;
			
			super.applySkin(btn);
			
			btn.minWidth = 10;
			btn.minHeight = 22;
		}
		
		override protected function registerScale9():void
		{
			const rect:Rectangle = new Rectangle(3, 3, 1, 16);
			_scale9.register(_altasName, "button-up-skin", rect);
			_scale9.register(_altasName, "button-down-skin", rect);
			_scale9.register(_altasName, "button-disabled-skin", rect);
			_scale9.register(_altasName, "button-selected-up-skin", rect);
			_scale9.register(_altasName, "button-selected-disabled-skin", rect);
			super.registerScale9();
		}
	}
}