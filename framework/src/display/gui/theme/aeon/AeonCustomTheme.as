package display.gui.theme.aeon
{
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.core.IFeathersControl;
	import feathers.display.Scale9Image;
	import feathers.skins.Scale9ImageStateValueSelector;
	import feathers.utils.math.roundToNearest;
	
	import flash.text.TextFormat;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	
	/**
	 *皮肤渲染调用
	 * compenont(dispatcher(Event.ADDED))  --->DisplayListWatcher(initObject)
	 * if (compenont not in initializedObjects)
	 * @author g7842
	 * 
	 */	
	public class AeonCustomTheme extends AeonDesktopTheme
	{
		protected static var  smallDarkTextFormat:TextFormat;
		protected static var  smallLightTextFormat:TextFormat;
		
		public function AeonCustomTheme(container:DisplayObjectContainer=null)
		{
//			super(container);
		}
		
		
		override protected function setBaseButtonStyles(button:Button):void
		{
			button.focusIndicatorSkin = new Scale9Image(this.focusIndicatorSkinTextures);
			button.focusPadding = -1;
			
//			button.defaultLabelProperties.textFormat = this.defaultTextFormat;
//			button.disabledLabelProperties.textFormat = this.disabledTextFormat;
			
			button.paddingTop = this.extraSmallGutterSize;
			button.paddingBottom = this.extraSmallGutterSize;
			button.paddingLeft = this.smallGutterSize;
			button.paddingRight = this.smallGutterSize;
			button.gap = this.extraSmallGutterSize;
			button.minGap = this.extraSmallGutterSize;
			button.minWidth = this.smallControlSize;
			button.minHeight = this.smallControlSize;
		}
		
//		public function removeFromInitializedMap(featherControl:IFeathersControl):void
//		{
//			this.initializedObjects[featherControl] = null;
//			delete this.initializedObjects[featherControl];
//		}
		
	}
}