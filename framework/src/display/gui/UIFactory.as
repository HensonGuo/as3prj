package display.gui
{
	import display.gui.skin.BaseSkin;
	import display.gui.skin.ButtonSkin;
	import display.gui.theme.aeon.AeonCustomTheme;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
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
	import feathers.controls.Scroller;
	import feathers.controls.Slider;
	import feathers.controls.TabBar;
	import feathers.controls.TextArea;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.TiledRowsLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import resource.pools.ObjectPool;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Stage;
	import starling.textures.Texture;
	
	import utils.debug.LogUtil;

	/**
	 * wait to do
	 * 
	 * Factory
	 * initializer
	 * properties
	 * 
	 *样式管理
	 */	
	public class UIFactory
	{
		public function UIFactory()
		{
		}
		
		public static function init(stage:Stage):void
		{
//			new AeonCustomTheme(stage);
		}
		
		public static function applyTextFormat(target:Object, textPropertiesName:String, renderFactoryName:String, textFormat:*):void
		{
			if (textFormat is BitmapFontTextFormat)
			{
				target[renderFactoryName] = function():ITextRenderer
				{
					var textRender:BitmapFontTextRenderer = ObjectPool.getObject(BitmapFontTextRenderer);
					textRender.textFormat =  textFormat;
					return textRender;
				}
			}
			else
			{
				target[renderFactoryName] = function():ITextRenderer
				{
					var textRender:TextFieldTextRenderer = ObjectPool.getObject(TextFieldTextRenderer);
					textRender.textFormat =  textFormat;
					return textRender;
				}
			}
		}
		
		public static function image(x:int = 0,y:int = 0,width:int = 100,height:int = 100,parent:DisplayObjectContainer = null, atlasName:String = "", textureName:String = ""):Image
		{
			var texture:Texture = FrameWork.skinManager.getTexture(atlasName, textureName);
			var img:Image = ObjectPool.getObject(Image, texture);
			img.x = x;
			img.y = y;
			img.width = width;
			img.height = height;
			if (parent)
				parent.addChild(img);
			return img;
		}
		
		public static function scaleImage(x:int = 0,y:int = 0,width:int = 100,height:int = 100,parent:DisplayObjectContainer = null, atlasName:String = "", textureName:String = ""):Scale9Image
		{
			var hasRes:Boolean = FrameWork.scale9Manager.hasRegister(atlasName, textureName);
			LogUtil.assert(hasRes, "没有注册对应的缩放资源");
			var rect:Rectangle = FrameWork.scale9Manager.getScaleRectangle(atlasName, textureName);
			
			var texture:Texture = FrameWork.skinManager.getTexture(atlasName, textureName);
			var textures:Scale9Textures = new Scale9Textures(texture, rect);
			
			var img:Scale9Image = ObjectPool.getObject(Scale9Image, textures);
			img.textures = textures;
			img.x = x;
			img.y = y;
			img.width = width;
			img.height = height;
			if (parent)
				parent.addChild(img);
			return img;
		}
		
		public static function textFiledRender(text:String = "",x:int = 0,y:int = 0,width:int = 220,height:int = 20, parent:DisplayObjectContainer = null, textFormat:TextFormat = null, isHTML:Boolean = false):TextFieldTextRenderer
		{
			var field:TextFieldTextRenderer = ObjectPool.getObject(TextFieldTextRenderer);
			field.text = text;
			field.x = x;
			field.y = y;
			field.width = width;
			field.height = height;
			field.isHTML = isHTML;
			field.textFormat = textFormat;
			if (parent)
				parent.addChild(field);
			return field;
		}
		
		public static function bitmapFontTextRender(text:String = "",x:int = 0,y:int = 0,width:int = 220,height:int = 20, parent:DisplayObjectContainer = null, textFmt:BitmapFontTextFormat = null):BitmapFontTextRenderer
		{
			var field:BitmapFontTextRenderer = ObjectPool.getObject(BitmapFontTextRenderer);
			field.text = text;
			field.x = x;
			field.y = y;
			field.width = width;
			field.height = height;
			field.textFormat = textFmt;
			if (parent)
				parent.addChild(field);
			return field;
		}
		
		public static function label(str:String,x:int,y:int,width:int = 100,height:int = 25, parent:DisplayObjectContainer = null, textFmt:* = null):Label
		{
			var label:Label = ObjectPool.getObject(Label);
			label.text = str;
			label.x = x;
			label.y = y;
			label.setSize(width, height);
			applyTextFormat(label, "textRendererProperties", "textRendererFactory", textFmt);
			if (parent)
				parent.addChild(label);
			return label;
		}
		
		public static function textArea(text:String = "",x:int = 0,y:int = 0,width:int = 300,height:int = 300,parent:DisplayObjectContainer = null,styleName:String = "GTextArea"):TextArea
		{
			var textArea:TextArea = ObjectPool.getObject(TextArea);
//			textArea.styleName = styleName;
			textArea.text = text;
			textArea.x = x;
			textArea.y = y;
			textArea.width = width;
			textArea.height = height;
			textArea.verticalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
			textArea.horizontalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
			if(parent)
				parent.addChild(textArea);
			return textArea;
		}
		
		public static function textInput(x:int = 0,y:int = 0,width:int = 220,height:int = 20,parent:DisplayObjectContainer = null,styleName:String = "GTextInput"):TextInput
		{
			var textInput:TextInput = ObjectPool.getObject(TextInput);
//			textInput.styleName = styleName;
//			textInput.textEditorProperties
			textInput.x = x;
			textInput.y = y;
			textInput.width = width;
			textInput.height = height;
			textInput.restrict = null;
			textInput.maxChars = 999999999;
			textInput.touchable = true;
			textInput.isEditable = true;
			if(parent)
				parent.addChild(textInput);
			return textInput;
		}
		
		public static function button(label:String,x:int = 0,y:int = 0,width:int = 49,height:int = 22,parent:DisplayObjectContainer = null, skinName:String = "Button", textFmt:* = null):Button
		{
			FrameWork.skinManager.apply(Button, skinName);
			var btn:Button = ObjectPool.getObject(Button);
			btn.x = x;
			btn.y = y;
			btn.setSize(width, height);
			btn.label = label;
			applyTextFormat(btn, "defaultLabelProperties", "labelFactory", textFmt);
			if(parent)
				parent.addChild(btn);
			return btn;
		}
		
		public static function buttonGroup(dataProvider:ListCollection, x:int = 0,y:int = 0,width:int = 49,height:int = 22,parent:DisplayObjectContainer = null, skinName:String = "ButtonGroup"):ButtonGroup
		{
			FrameWork.skinManager.apply(ButtonGroup, skinName);
			var group:ButtonGroup = ObjectPool.getObject(ButtonGroup);
			group.x = x;
			group.y = y;
			group.setSize(width, height);
			group.dataProvider = dataProvider;
			if(parent)
				parent.addChild(group);
			return group;
		}
		
		public static function checkBox(label:String,x:int = 0,y:int = 0,width:int = 100,height:int = 28,parent:DisplayObjectContainer = null,styleName:String = "CheckBox", textFmt:* = null):Check
		{
			var cb:Check = ObjectPool.getObject(Check);
//			cb.styleName = styleName;
			cb.label = label;
			cb.x = x;
			cb.y = y;
			cb.setSize(width, height);
			applyTextFormat(cb, "defaultLabelProperties", "labelFactory", textFmt);
			if(parent)
			{
				parent.addChild(cb);
			}
			return cb;
		}
		
		public static function radioButton(label:String,x:int = 0,y:int = 0,width:int = 100,height:int = 28,parent:DisplayObjectContainer = null,styleName:String = "RadioButton", textFmt:* = null):Radio
		{
			var rb:Radio = ObjectPool.getObject(Radio);
//			rb.styleName = styleName;
			rb.label = label;
			rb.x = x;
			rb.y = y;
			rb.setSize(width, height);
			applyTextFormat(rb, "defaultLabelProperties", "labelFactory", textFmt);
			if(parent)
				parent.addChild(rb);
			return rb;
		}
		
		public static function pageIndicator(parent:DisplayObjectContainer, x:int = 0, y:int = 0, pageCount:int = 5, direction:String = PageIndicator.DIRECTION_HORIZONTAL, gap:int = 3, padding:int = 6):PageIndicator
		{
			var pageIn:PageIndicator = ObjectPool.getObject(PageIndicator);
//			pageIn.styleName = styleName;
			pageIn.x = x;
			pageIn.y = y;
			pageIn.direction = direction;
			pageIn.pageCount = pageCount;
			pageIn.gap = gap;
			pageIn.paddingTop = pageIn.paddingRight = pageIn.paddingBottom =
				pageIn.paddingLeft = 6;
			if (parent)
				parent.addChild(pageIn);
			return pageIn;
		}
		
		public static function list(x:int = 0,y:int = 0,width:int = 100,height:int = 100,parent:DisplayObjectContainer = null,styleName:String = "TileList"):List
		{
			var tl:List = ObjectPool.getObject(List);
//			tl.styleName = styleName;
			tl.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			tl.verticalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
			tl.snapToPages = true;
			
			const listLayout:TiledRowsLayout= new TiledRowsLayout();
			listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout.useSquareTiles = false;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.manageVisibility = true;
			tl.layout = listLayout;
			
			tl.x = x;
			tl.y = y;
			tl.setSize(width, height);
			if(parent)
				parent.addChild(tl);
			return tl;
		}
		
		public static function scrollBar(x:int = 0,y:int = 0, direction:String = ScrollBar.DIRECTION_VERTICAL, parent:DisplayObjectContainer = null, styleName:String = null):ScrollBar
		{
			var bar:ScrollBar = ObjectPool.getObject(ScrollBar);
			bar.direction = direction;
			bar.x = x;
			bar.y = y;
			if (parent)
				parent.addChild(bar);
			return bar;
		}
		
		public static function scrollText(x:int = 0,y:int = 0,width:int = 100,height:int = 100,parent:DisplayObjectContainer = null, styleName:String = null):ScrollText
		{
			var st:ScrollText = ObjectPool.getObject(ScrollText);
			st.x = x;
			st.y = y;
			st.setSize(width, height);
			if (parent)
				parent.addChild(st);
			return st;
		}
		
		public static function scrollContainer(x:int = 0,y:int = 0,width:int = 100,height:int = 100,parent:DisplayObjectContainer = null, styleName:String = null):ScrollContainer
		{
			var st:ScrollContainer = ObjectPool.getObject(ScrollContainer);
			st.x = x;
			st.y = y;
			st.setSize(width, height);
			if (parent)
				parent.addChild(st);
			return st;
		}
		
		public static function slider(x:int = 0,y:int = 0, direction:String = Slider.DIRECTION_HORIZONTAL, parent:DisplayObjectContainer = null, styleName:String = null):Slider
		{
			var sl:Slider = ObjectPool.getObject(Slider);
			sl.x = x;
			sl.y = y;
			sl.direction = direction;
			if (parent)
				parent.addChild(sl);
			return sl;
		}
		
		public static function pickerList(x:int,y:int,width:int = 100,height:int = 20,parent:DisplayObjectContainer = null,styleName:String = null):PickerList
		{
			var pk:PickerList = ObjectPool.getObject(PickerList);
			pk.x = x;
			pk.y = y;
			pk.setSize(width, height);
			if (parent)
				parent.addChild(pk);
			return pk;
		}
		
		public static function numericstepper(x:int,y:int,width:int = 100,height:int = 20,parent:DisplayObjectContainer = null,styleName:String = null):NumericStepper
		{
			var numstep:NumericStepper = ObjectPool.getObject(NumericStepper);
			numstep.x = x;
			numstep.y = y;
			numstep.setSize(width,height);
			if(parent)
				parent.addChild(numstep);
			return numstep; 
		}
		
		public static function progressBar(x:int = 0,y:int = 0, direction:String = ProgressBar.DIRECTION_HORIZONTAL, parent:DisplayObjectContainer = null, styleName:String = null):ProgressBar
		{
			var progressbar:ProgressBar = ObjectPool.getObject(ProgressBar);
			progressbar.direction = direction;
			progressbar.x = x;
			progressbar.y = y;
			if (parent)
				parent.addChild(progressbar);
			return progressbar;
		}
		
		public static function toggleswitch(x:int,y:int,width:int = 100,height:int = 20,parent:DisplayObjectContainer = null,styleName:String = null):ToggleSwitch
		{
			var ts:ToggleSwitch = ObjectPool.getObject(ToggleSwitch);
			ts.x = x;
			ts.y = y;
			ts.setSize(width, height);
			if (parent)
				parent.addChild(ts);
			return ts;
		}
		
		public static function tabBar(x:int,y:int,width:int = 100,height:int = 20,parent:DisplayObjectContainer = null,styleName:String = null):TabBar
		{
			var tb:TabBar = ObjectPool.getObject(TabBar);
			tb.x = x;
			tb.y = y;
			tb.setSize(width, height);
			if (parent)
				parent.addChild(tb);
			return tb;
		}
		
		public static function alert(x:int,y:int,width:int = 100,height:int = 20,parent:DisplayObjectContainer = null,styleName:String = null):Alert
		{
			var tb:Alert = ObjectPool.getObject(Alert);
			tb.x = x;
			tb.y = y;
			tb.setSize(width, height);
			if (parent)
				parent.addChild(tb);
			return tb;
		}
		
		public static function panel(x:int,y:int,width:int = 100,height:int = 20,parent:DisplayObjectContainer = null,styleName:String = null):Panel
		{
			var tb:Alert = ObjectPool.getObject(Alert);
			tb.x = x;
			tb.y = y;
			tb.setSize(width, height);
			if (parent)
				parent.addChild(tb);
			return tb;
		}
		
	}
}

