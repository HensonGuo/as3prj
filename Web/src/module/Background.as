package module
{
	import config.GlobalIni;
	
	import events.CallerName;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import loader.type.LoadResType;
	
	import module.base.ScaleMode;
	import module.base.WebView;
	
	import utils.trigger.Caller;
	
	/**
	 * 
	 */	
	public class Background extends WebView
	{
		private var _url:String;
		private var _shape:Shape;
		private var _image:Bitmap;
		private var _scaleMode:String;
		private var _rect:Rectangle = new Rectangle();
		
		public function Background()
		{
			super();
		}
		
		override protected function onShow():void
		{
			var cfg:GlobalIni = Web.configMgr.global;
			_scaleMode = cfg.bgScaleMode;
			if (cfg.bgUrl)
				setBgSource(cfg.bgUrl);
			else
				setBgColor(cfg.bgColor);
			setBgAphla(cfg.bgAlpha);
		}
		
		public function setBgSource(url:String):void
		{
			_url = url;
			if (_url)
				FrameWork.loaderManager.loadRes(LoadResType.ImageFile, url, OnBgSourceLoadComplete);
		}
		
		public function setBgColor(color:uint = 0xffffff):void
		{
			if (!_shape)
			{
				_shape = new Shape();
				_shape.graphics.beginFill(color);
				_shape.graphics.drawRect(0,0, stage.stageWidth, stage.stageHeight);
				_shape.graphics.endFill();
				this.addChildAt(_shape, 0);
			}
		}
		
		public function setBgAphla(alpha:Number = 1):void
		{
			this.alpha = alpha;
		}
		
		private function OnBgSourceLoadComplete(url:String, bitmap:Bitmap):void
		{
			if (_image)
			{
				_image.bitmapData.dispose();
				_image = null;
			}
			_image = bitmap;
			_image.smoothing = true;
			ScaleMode.applyScale(_image, _scaleMode, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
			this.addChild(_image);
		}
		
		/**
		 *重复填充 
		 * wait to do
		 */		
		private function repeatFill():void
		{
			
		}
		
		override protected function onResize(width:int, height:int):void
		{
			if (_shape)
			{
				_shape.width = stage.stageWidth;
				_shape.height = stage.stageHeight;
			}
			_rect.width = stage.stageWidth;
			_rect.height = stage.stageHeight;
			ScaleMode.applyScale(_image, _scaleMode, _rect);
		}
		
	}
}