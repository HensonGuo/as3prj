package
{
	import display.GlobalUI;
	import display.layer.LayerManager;
	import display.window.WindowEvent;
	import display.window.WindowManager;
	
	import flash.display.Stage;
	import flash.events.Event;
	
	import frame.Frame;
	import frame.FrameManager;
	import frame.FrameType;
	
	import loader.LoaderManager;
	
	import resource.FontManager;
	import resource.pools.Reuse;
	
	import timer.TimerManager;
	
	import utils.GlobalError;
	import utils.debug.LogUtil;
	import utils.trigger.Caller;
	import utils.trigger.Dispatcher;
	
	public class FrameWork
	{
		public static const FRAME_WORK_STARTED:String = "FRAME_WORK_STARTED";
		public static const VIEW_RESIZE:String = "VIEW_RESIZE";
		
		private static var _isStarted:Boolean;
		private static var _stage:Stage = null;
		private static var _isDebugMode:Boolean = true;
		private static var _isOpenViewDebug:Boolean = false;
		private static var _frameTime:Number;
		private static var _layerManager:LayerManager;
		private static var _frameManager:FrameManager;
		private static var _timerManager:TimerManager;
		private static var _globalError:GlobalError;
		private static var _loaderManager:LoaderManager;
		private static var _windowManager:WindowManager;
		private static var _globalUI:GlobalUI
		private static var _fontManager:FontManager;
		
		public function FrameWork()
		{
		}
		
		/**
		 * 框架的初始化
		 */
		public static function start(useStarling:Boolean, stage:Stage, isDebugMode:Boolean = true, isOpenViewDebug:Boolean = false):void
		{
			//set params
			_stage = stage;
			_isDebugMode = isDebugMode;
			_isOpenViewDebug = isOpenViewDebug;
			_frameTime = 1000 / _stage.frameRate;
			
			stage.addEventListener(flash.events.Event.RESIZE, onResize);
			
			init();
		}
		
		private static function onResize(event:Event):void
		{
			Caller.dispatchCmd(VIEW_RESIZE, stage.stageWidth, stage.stageHeight);
			Dispatcher.dispatchEvent(new WindowEvent(WindowEvent.ON_POS_CHANGE, null));
		}
		
		private static function init():void
		{
			_layerManager = new LayerManager();
			_frameManager = new FrameManager();
			_timerManager = new TimerManager();
			_globalError = new GlobalError();
			_loaderManager = new LoaderManager();
			_windowManager = new WindowManager();
			_fontManager = new FontManager();
			_globalUI = new GlobalUI();
			
			//init module
			_layerManager.init(stage);
			stage.addChild(_layerManager);
			
			_globalError.listenErrors(stage);
			_fontManager.setYaheiFont();
			
			activate();
			Caller.dispatchCmd(FRAME_WORK_STARTED);
			_isStarted = true;
		}
		
		public static function activate():void
		{
			LogUtil.activate();
			Reuse.create(Frame, FrameType.Render, _timerManager.activate);
		}
		
		public static function get isDebugMode():Boolean
		{
			return _isDebugMode;
		}
		
		public static function get isOpenViewDebug():Boolean
		{
			return _isOpenViewDebug;
		}
		
		public static function get stage():Stage
		{
			return _stage;
		}
		
		public static function get frameTime():Number
		{
			return _frameTime;
		}
		
		public static function get layerManager():LayerManager
		{
			return _layerManager;
		}
		
		public static function get timerManager():TimerManager
		{
			return _timerManager;
		}
		
		public static function get frameManager():FrameManager
		{
			return _frameManager;
		}
		
		public static function get loaderManager():LoaderManager
		{
			return _loaderManager;
		}
		
		public static function get windowManager():WindowManager
		{
			return _windowManager;
		}
		
		public static function get fontManager():FontManager
		{
			return _fontManager;
		}
		
		public static function get isStarted():Boolean
		{
			return _isStarted;
		}
		
		public static function get globalUI():GlobalUI
		{
			return _globalUI;
		}
	}
}