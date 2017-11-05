package display.gui.skin
{
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	
	import flash.geom.Rectangle;

	public class ButtonSkin extends BaseButtonSkin
	{
		public function ButtonSkin(altasName:String = "aeon")
		{
			super(altasName);
		}
		
		override public function applySkin(compenont:FeathersControl):void
		{
			var btn:Button = compenont as Button;
			_skinSelector.defaultValue = _skin.getScale9Texture(_altasName, "button-up-skin");
			_skinSelector.defaultSelectedValue = _skin.getScale9Texture(_altasName, "button-selected-up-skin");
			_skinSelector.setValueForState(_skin.getScale9Texture(_altasName, "button-hover-skin"), Button.STATE_HOVER, false);
			_skinSelector.setValueForState(_skin.getScale9Texture(_altasName, "button-down-skin"), Button.STATE_DOWN, false);
			_skinSelector.setValueForState(_skin.getScale9Texture(_altasName, "button-disabled-skin"), Button.STATE_DISABLED, false);
			_skinSelector.setValueForState(_skin.getScale9Texture(_altasName, "button-selected-hover-skin"), Button.STATE_HOVER, true);
			_skinSelector.setValueForState(_skin.getScale9Texture(_altasName, "button-selected-down-skin"), Button.STATE_DOWN, true);
			_skinSelector.setValueForState(_skin.getScale9Texture(_altasName, "button-selected-disabled-skin"), Button.STATE_DISABLED, true);
			btn.stateToSkinFunction = _skinSelector.updateValue;
			super.applySkin(btn);
		}
		
		override protected function registerScale9():void
		{
			const rect:Rectangle = new Rectangle(6, 6, 52, 10);
			_scale9.register(_altasName, "button-up-skin", rect);
			_scale9.register(_altasName, "button-selected-up-skin", rect);
			_scale9.register(_altasName, "button-hover-skin", rect);
			_scale9.register(_altasName, "button-down-skin", rect);
			_scale9.register(_altasName, "button-disabled-skin", rect);
			_scale9.register(_altasName, "button-selected-hover-skin", rect);
			_scale9.register(_altasName, "button-selected-down-skin", rect);
			_scale9.register(_altasName, "button-selected-disabled-skin", rect);
			super.registerScale9();
		}
		
	}
}