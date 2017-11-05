package display.gui.skin
{
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.ImageLoader;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	
	import starling.display.DisplayObject;
	import starling.textures.SubTexture;
	import starling.textures.Texture;

	public class CheckBoxSkin extends AeonSkin
	{
		public function CheckBoxSkin(altasName:String="aeon")
		{
			super(altasName);
		}
		
		override public function applySkin(compenont:FeathersControl):void
		{
			var check:Check = compenont as Check;
			_skinSelector.setValueTypeHandler(SubTexture, textureValueTypeHandler);
			_skinSelector.defaultValue = _skin.getTexture(_altasName, "check-up-icon");
			_skinSelector.defaultSelectedValue = _skin.getTexture(_altasName, "check-selected-up-icon");
			_skinSelector.setValueForState( _skin.getTexture(_altasName, "check-hover-icon"), Button.STATE_HOVER, false);
			_skinSelector.setValueForState(_skin.getTexture(_altasName, "check-down-icon"), Button.STATE_DOWN, false);
			_skinSelector.setValueForState(_skin.getTexture(_altasName, "check-disabled-icon"), Button.STATE_DISABLED, false);
			_skinSelector.setValueForState(_skin.getTexture(_altasName, "check-selected-hover-icon"), Button.STATE_HOVER, true);
			_skinSelector.setValueForState(_skin.getTexture(_altasName, "check-selected-down-icon"), Button.STATE_DOWN, true);
			_skinSelector.setValueForState(_skin.getTexture(_altasName, "check-selected-disabled-icon"), Button.STATE_DISABLED, true);
			_skinSelector.displayObjectProperties =
				{
					snapToPixels: true,
					textureScale: 1
				};
			check.stateToIconFunction = _skinSelector.updateValue;
			super.applySkin(check);
			
			
//			check.defaultLabelProperties.textFormat = this.defaultTextFormat;
//			check.disabledLabelProperties.textFormat = this.disabledTextFormat;
//			check.selectedDisabledLabelProperties.textFormat = this.disabledTextFormat;
			
			check.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			check.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
			
			check.gap = 6;
			check.minWidth = 22;
			check.minHeight = 22;
		}
		
		protected static function textureValueTypeHandler(value:Texture, oldDisplayObject:DisplayObject = null):DisplayObject
		{
			var displayObject:ImageLoader = oldDisplayObject as ImageLoader;
			if(!displayObject)
			{
				displayObject = new ImageLoader();
			}
			displayObject.source = value;
			return displayObject;
		}
	}
}