package
{
	import config.ConfigManager;
	
	import display.layer.LayerConstants;
	
	import events.CallerName;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import module.Background;
	import module.window.WelcomeWindow;
	
	import utils.DrawUtils;
	import utils.debug.LogUtil;
	import utils.trigger.Caller;
	
	public class Web extends Sprite
	{
		private static var _configMgr:ConfigManager = new ConfigManager();
		
		//elements
		private var _bg:Background;
		
		public function Web()
		{
			_configMgr.loadConfigs(onSettingsAnalysisComplete);
		}
		
		private function onSettingsAnalysisComplete():void
		{
			FrameWork.start(true, stage, true, false);
			initDisplayList();
		}
		
		private function initDisplayList():void
		{
			_bg = new Background();
			FrameWork.layerManager.getLayer(LayerConstants.Background).addChild(_bg);
			FrameWork.windowManager.addPopup(WelcomeWindow);
		}
		
		public static function get configMgr():ConfigManager
		{
			return _configMgr;
		}
	}
}