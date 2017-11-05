package module
{
	import config.GlobalIni;
	
	import flash.display.DisplayObject;
	
	import loader.type.LoadResType;
	
	import module.base.WebView;
	
	public class Menu extends WebView
	{
		private var _url:String;
		
		public function Menu()
		{
			super();
		}
		
		override protected function onShow():void
		{
			var cfg:GlobalIni = Web.configMgr.global;
		}
		
		private function loadView(url:String):void
		{
			_url = url;
			if (_url)
				FrameWork.loaderManager.loadRes(LoadResType.SWFFile, url, OnViewLoadComplete);
		}
		
		private function OnViewLoadComplete(url:String, obj:DisplayObject):void
		{
			this.addChild(obj);
		}
		
		
		
	}
}