package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import utils.LoaderInstance;
	
	/**
	 *加载版本号--配置文件--运行时共享皮肤--主程序
	 * 不用框架的内容，不然会编译进去所有框架的内容，导致swf过大
	 * @author g7842
	 */	
	public class PreLoad extends Sprite
	{
		private static const _VerisonUrl:String = "";
		private static const _MainAppUrl:String = "Web.swf";
		private static const _ConfigUrl:String = "ConfigSwf.swf";
		private static const _RunTimeShareSkinUrl:String = "";
		
		private static var _instance:PreLoad;
		
		private var _loader:LoaderInstance = new LoaderInstance();
		
		public function PreLoad()
		{
			_instance = this;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(event:Event):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			_loader.load(_ConfigUrl, LoaderInstance.TYPE_BINARY, onLoadConfigComplete, onLoadConfigProgress);
		}
		
		private function onLoadConfigProgress(bytesLoaded:Number, bytesTotal:Number):void
		{
			updateLoadProgressBar(bytesLoaded, bytesTotal, "加载配置文件..." + int(bytesLoaded / bytesTotal * 100) + "%");
		}
		
		private function onLoadConfigComplete(url:String, displayObj:DisplayObject):void
		{
			_loader.reset();
			_loader.load(_MainAppUrl, LoaderInstance.TYPE_BINARY, onWebLoadComplete, onLoadWebProgress);
		}
		
		
		private function onLoadWebProgress(bytesLoaded:Number, bytesTotal:Number):void
		{
			updateLoadProgressBar(bytesLoaded, bytesTotal, "加载主程序..." + int(bytesLoaded / bytesTotal * 100) + "%");
		}
		
		private function onWebLoadComplete(url:String, displayObj:DisplayObject):void
		{
			this.addChild(displayObj);
		}
		
		private function updateLoadProgressBar(bytesLoaded:Number, bytesTotal:Number, desc:String):void
		{
			//wait 进度条
			trace(desc);
		}
		
		public static function setPercent(bytesLoaded:Number, bytesTotal:Number, desc:String):void
		{
			_instance.updateLoadProgressBar(bytesLoaded, bytesTotal, desc);
		}
		
	}
}