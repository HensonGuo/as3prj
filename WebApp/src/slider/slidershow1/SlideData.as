package slider.slidershow1
{
	import utils.XMLInfo;
	
	public class SlideData extends XMLInfo
	{
		public var mediaBgColor:uint;
		public var mediaBgOpacity:Number
		public var mediaWidth:Number
		public var mediaHeight:Number
		public var mediaPaddingX:Number
		public var mediaPaddingY:Number
		public var backgroundShadowOpacity:Number
		public var backgroundShadowBlur:Number
		public var timerBarColor:uint
		public var timerBarOpacity:Number
		public var showButtons:Boolean
		public var btnAlign:String
		public var btnArrowColor:uint
		public var btnBorderColor:uint
		public var btnBgColor:uint
		public var btnBgOpacity:Number
		public var btnBgColorOnMouseOver:uint
		public var btnBorderColorOnMouseOver:uint
		public var btnArrowColorOnMouseOver:uint
		public var autoStart:Boolean
		public var timer:uint;
		public var timerBarHeight:Number
		public var transitionType:String;
		public var textTransition:Number;
		
		public var imageCount:int;

		public var settings:XMLList;
		public var imagesList:XMLList;
		
		public function SlideData(url:String, completeCallback:Function)
		{
			super(url, completeCallback);
		}
		
		override protected function setParams():void
		{
			settings = _xml.child("settings");
			imagesList = _xml.child("images").children();
			
			mediaBgColor = settings.@mediaBgColor;
			mediaBgOpacity = settings.@mediaBgOpacity;
			mediaWidth = settings.@mediaWidth;
			mediaHeight = settings.@mediaHeight;
			mediaPaddingX = settings.@mediaPaddingX;
			mediaPaddingY = settings.@mediaPaddingY;
			backgroundShadowOpacity = settings.@backgroundShadowOpacity;
			backgroundShadowBlur = settings.@backgroundShadowBlur;
			timerBarColor = settings.@timerBarColor;
			timerBarOpacity = settings.@timerBarOpacity;
			showButtons = settings.@showButtons == "true";
			btnAlign = settings.@btnAlign;
			btnArrowColor = settings.@btnArrowColor;
			btnBorderColor = settings.@btnBorderColor;
			btnBgColor = settings.@btnBgColor;
			btnBgOpacity = settings.@btnBgOpacity;
			btnBgColorOnMouseOver = settings.@btnBgColorOnMouseOver;
			btnBorderColorOnMouseOver = settings.@btnBorderColorOnMouseOver;
			btnArrowColorOnMouseOver = settings.@btnArrowColorOnMouseOver;
			autoStart = settings.@autoStart == "true";
			timer = settings.@timer;
			timerBarHeight = settings.@timerBarHeight;
			transitionType = settings.@transitionType;
			textTransition = settings.@textTransition;
			
			imageCount = imagesList.length();
		}
		
		public function getImageSrc(index:int):String
		{
			return imagesList[index].@src;
		}
		
		public function getImageLink(index:int):String
		{
			return imagesList[index].@link;
		}
	}
}