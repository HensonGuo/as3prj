package feathers
{
	import com.BmpFontFormatConst;
	import com.FontManager;
	
	import display.gui.UIFactory;
	
	import feathers.controls.Button;
	import feathers.data.ListCollection;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	import utils.debug.LogUtil;
	import utils.debug.Profile;
	import utils.trigger.Caller;
	
	public class StyleLearn extends Sprite
	{
		public function StyleLearn()
		{
			super();
			Caller.addCmdListener(FrameWork.FRAME_WORK_STARTED, onStarted);
		}
		
		private function onStarted():void
		{
			FontManager.init();
//			Profile.init(true, this);
			stage.color = 0x002143;
			
			FrameWork.skinManager.loadAltas("feathers/metalworks_desktop.png", "feathers/metalworks_desktop.xml", loadThemeComplete);
			
			UIFactory.button("点击1", 200, 0, 80, 22, this, "Button", BmpFontFormatConst.formatWhite);
			UIFactory.buttonGroup(new ListCollection(["item1", "item2", "item3"]), 300, 0, 80, 100, this);
		}
		
		private function loadThemeComplete():void
		{
			FrameWork.skinManager.register("YellowButton", new YellowButtonSkin("metalworks_desktop"));
			FrameWork.skinManager.register("YellowButtonGroup", new YellowButtonGroupSkin("metalworks_desktop"));
			
			UIFactory.button("点击2", 200, 25, 80, 22, this, "YellowButton", BmpFontFormatConst.formatWhite);
			UIFactory.buttonGroup(new ListCollection(["item1", "item2", "item3"]), 400, 0, 80, 100, this, "YellowButtonGroup");
		}
	}
}