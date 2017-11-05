package display.window
{
	import display.layer.Layer;
	import display.layer.LayerConstants;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import resource.pools.ObjectPool;
	
	import utils.trigger.Caller;
	import utils.trigger.Dispatcher;

	public class WindowManager
	{
		private var _windows:Dictionary = new Dictionary();
		
		public function WindowManager()
		{
			Dispatcher.addEventListener(WindowEvent.UPDATE, onWindowUpdate);
			Dispatcher.addEventListener(WindowEvent.ON_POS_CHANGE, onWindowResize);
		}
		
		private function onWindowUpdate(event:WindowEvent):void
		{
			var cls:Class = event.window;
			var window:BaseWindow = getWindow(cls);
			if (!window || !window.isLoadComplete || window.isHide)
				return;
			window.safeUpdate();
		}
		
		private function onWindowResize(event:WindowEvent):void
		{
			for each(var window:BaseWindow in _windows)
			{
				if (!window || !window.isLoadComplete || window.isHide)
					continue;
				window.locate();
			}
		}
		
		/**
		 * 弹窗
		 *
		 */
		public function addPopup(classObject:Class, ...params):BaseWindow
		{
			var window:BaseWindow = getWindow(classObject);
			if (window == null)
				window = createWindow(classObject);
			
			if (params.length != 0)
				window.initParam.apply(null, params);
			
			if (window.hasPopup)
			{
				window.safeUpdate();
				return window;
			}
			var layer:Layer = getLayer(window.level);
			layer.addChild(window);
			return window;
		}
		
		/**
		 * 移除弹窗
		 *
		 */
		public function removePopup(classObject:Class):void
		{
			var window:BaseWindow = getWindow(classObject);
			if (window == null || !window.hasPopup)
				return;
			
			var layer:Layer = getLayer(window.level);
			layer.removeChild(window);
			window.destory();
		}
		
		/**
		 * 渲染区域
		 *
		 */
		public function get renderRect():Rectangle
		{
			var layer:Layer = getLayer(WindowLayer.MIDDLE);
			var width:int = layer.stage.stageWidth;
			var height:int = layer.stage.stageHeight;
			return new Rectangle(0, 0, width, height);
		}
		
		/**
		 * 获取窗口
		 *
		 */
		public function getWindow(classObject:Class):BaseWindow
		{
			var windowKey:String = BaseWindow.getWindowNameByClass(classObject);
			var window:BaseWindow = _windows[windowKey];
			return window;
		}
		
		private function createWindow(classObject:Class, multiKey:String = null):BaseWindow
		{
			var window:BaseWindow = ObjectPool.getObject(classObject) as BaseWindow;
			var windowKey:String = BaseWindow.getWindowNameByClass(classObject);
			_windows[windowKey] = window;
			return window;
		}
		
		private function getLayer(level:String):Layer
		{
			switch(level)
			{
				case WindowLayer.LOW:
					return FrameWork.layerManager.getLayer(LayerConstants.PopUpLow);
				case WindowLayer.MIDDLE:
					return FrameWork.layerManager.getLayer(LayerConstants.PopUpMiddle);
				case WindowLayer.HIGH:
					return FrameWork.layerManager.getLayer(LayerConstants.PopUpHigh);
			}
			return null;
		}
		
	}
}