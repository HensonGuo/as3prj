package display.gui.skin
{
	import display.gui.Scale9Map;
	
	import feathers.core.FeathersControl;
	import feathers.skins.SmartDisplayObjectStateValueSelector;

	public class BaseSkin
	{
		protected var _skinSelector:SmartDisplayObjectStateValueSelector;
		protected var _altasName:String;
		protected var _scale9:Scale9Map;
		protected var _skin:SkinManager;
		
		public function BaseSkin(altasName:String = "aeon")
		{
			this._altasName = altasName;
			_scale9 = FrameWork.scale9Manager;
			_skin = FrameWork.skinManager;
			_skinSelector = new SmartDisplayObjectStateValueSelector();
			registerScale9();
		}
		
		public function applySkin(compenont:FeathersControl):void
		{
			
		}
		
		protected function registerScale9():void
		{
			
		}
	}
}