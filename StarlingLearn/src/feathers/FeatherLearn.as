package feathers
{
	import com.BmpFontFormatConst;
	import com.FontManager;
	
	import display.gui.UIFactory;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.NumericStepper;
	import feathers.controls.PageIndicator;
	import feathers.controls.Panel;
	import feathers.controls.PickerList;
	import feathers.controls.ProgressBar;
	import feathers.controls.Radio;
	import feathers.controls.ScrollBar;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ScrollText;
	import feathers.controls.Slider;
	import feathers.controls.TabBar;
	import feathers.controls.TextArea;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.core.ToggleGroup;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import resource.pools.ObjectPool;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	import utils.debug.LogUtil;
	import utils.debug.Profile;
	
	public class FeatherLearn extends Sprite
	{
		[Embed(source = "/../bin-debug/assets/greenbg.jpg")] 
		private static const GreenBg:Class;
		
		public function FeatherLearn()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void
		{
			FrameWork.init(StarlingLearn.root, true, false, stage);
			FontManager.init();
			Profile.init(true, this);
			stage.color = 0x002143;
			
			var btn1:Button = display.gui.UIFactory.button("点击", 200, 0, 80, 22, this, "Button", BmpFontFormatConst.formatWhite);
			return;
			
			var btn2:Button = display.gui.UIFactory.button("点击", 200, 30, 80, 22, this, null, new TextFormat("宋体", 15, 0x00ff00));
			var label1:Label = display.gui.UIFactory.label("标签", 200, 60, 80, 22, this, BmpFontFormatConst.formatYellow);
			var label2:Label = display.gui.UIFactory.label("标签", 200, 90, 80, 22, this, new TextFormat("宋体", 15, 0xffff00));
			var field:TextFieldTextRenderer = display.gui.UIFactory.textFiledRender("<font color='#ff0000' size='18'><u>点击</u></font>", 300, 0, 80, 30, this, null, true);
			var bmpField:BitmapFontTextRenderer = display.gui.UIFactory.bitmapFontTextRender("点击", 300, 30, 80, 22, this, BmpFontFormatConst.formatGreen);
			var textArea:TextArea = display.gui.UIFactory.textArea("wahaha", 300, 30, 80, 100, this);
			var textInput:TextInput = display.gui.UIFactory.textInput(300, 130, 80, 20, this);
			var checkbox:Check = UIFactory.checkBox("标签", 300, 160, 80, 20, this);
			
			var toggleGroup:ToggleGroup = new ToggleGroup();
			var radio1:Radio = UIFactory.radioButton("标签1", 300, 190, 80, 20, this);
			radio1.toggleGroup = toggleGroup;
			var radio2:Radio = UIFactory.radioButton("标签2", 360, 190, 80, 20, this);
			radio2.toggleGroup = toggleGroup;
			
			var list:List = UIFactory.list(300, 220, 200, 200, this);
			list.dataProvider = new ListCollection(["a", "b", "c"])
			list.itemRendererFactory = tileListItemRendererFactory;
			
			return;
			
			var pageIndicator:PageIndicator = UIFactory.pageIndicator(this, 300, 430);
			
			 var scrollbar:ScrollBar = UIFactory.scrollBar(300, 450, ScrollBar.DIRECTION_VERTICAL, this);
			 scrollbar.height = 200;
//			 scrollbar.ad
//			 scrollbar.width = 50;
			 //要设置3项属性
			 scrollbar.maximumTrackFactory = function():void
			 {
				 
			 };
			 scrollbar.minimumTrackFactory;
			 scrollbar.thumbFactory;
			 
			 ///////////////
			 var scrollText:ScrollText = UIFactory.scrollText(600, 0, 300, 300, this);
			 scrollText.text = "发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬" +
				 "发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬" +
				 "发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬" +
				 "发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬" +
				 "发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬" +
				 "发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬" +
				 "发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬" +
				 "发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬发斯蒂芬水电费浪费空间SD卡路附近熟练度空间发斯蒂芬";
			
			 var img:Image = new Image(Texture.fromEmbeddedAsset(GreenBg));
//			 this.addChild(img);
			 var scrollContainer:ScrollContainer = UIFactory.scrollContainer(600, 320, 200, 200, this);
			scrollContainer.layout = new HorizontalLayout();
			scrollContainer.addChild(img);
			
			var slider:Slider = UIFactory.slider(600, 550, Slider.DIRECTION_HORIZONTAL, this);
			slider.maximum = 100;
			slider.value = 5;
			
			var pickerList:PickerList = UIFactory.pickerList(600, 580, 100, 22, this);
			pickerList.dataProvider = new ListCollection(["aa", "ab"]);
			
			var numericStepper:NumericStepper = UIFactory.numericstepper(600, 610, 100, 20, this);
			numericStepper.maximum = 100;
			numericStepper.step = 1;
			
			var progressbar:ProgressBar = UIFactory.progressBar(600, 640, ProgressBar.DIRECTION_HORIZONTAL, this);
			progressbar.width = 200;
			progressbar.height = 20;
//			progressbar.backgroundSkin
//			progressbar.backgroundDisabledSkin
//			progressbar.fillSkin
//			progressbar.fillDisabledSkin
			
			var toggleSwitch:ToggleSwitch = UIFactory.toggleswitch(600, 670, 48, 20, this);
//			toggleSwitch.offLabelProperties
//			toggleSwitch.offTrackProperties
//			toggleSwitch.onLabelProperties
//			toggleSwitch.onTrackProperties
			
			var tabbar:TabBar = UIFactory.tabBar(600, 700, 150, 20, this);
			tabbar.dataProvider = new ListCollection([{label:"ab"}, {label:"bc"}])
				
			var alert:Alert = UIFactory.alert(1000, 0, 300, 100, this);
			alert.title = "警告";
			
			var panel:Panel = UIFactory.panel(1000, 110, 300, 100, this);
		}
		
		protected function tileListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.labelField = "label";
			renderer.iconSourceField = "texture";
			renderer.iconPosition = Button.ICON_POSITION_TOP;
			renderer.width = 100;
			
//			renderer.defaultLabelProperties.textFormat = new BitmapFontTextFormat(this._font, NaN, 0x000000);
			return renderer;
		}
		
	}
}