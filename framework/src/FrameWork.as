package
{
	import core.global.GlobalError;
	
	import display.gui.Scale9Map;
	import display.gui.UIFactory;
	import display.gui.skin.SkinManager;
	import display.layer.LayerManager;
	import display.window.LogWindow;
	import display.window.WindowEvent;
	import display.window.WindowManager;
	
	import flash.display.Stage;
	import flash.events.Event;
	
	import frame.Frame;
	import frame.FrameManager;
	import frame.FrameType;
	
	import interactive.mouse.DragDropManager;
	
	import loader.LoaderManager;
	
	import resource.FontManager;
	import resource.pools.Reuse;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	import timer.TimerManager;
	
	import utils.debug.LogUtil;
	import utils.trigger.Caller;
	import utils.trigger.Dispatcher;

	public class FrameWork
	{
		public static const FRAME_WORK_STARTED:String = "FRAME_WORK_STARTED";
		public static const VIEW_RESIZE:String = "VIEW_RESIZE";
		
		private static var _isStarted:Boolean;
		private static var _starling:Starling;
		private static var _isUseStarling:Boolean;
		private static var _stage:Stage = null;
		private static var _rootClass:Class;
		private static var _isDebugMode:Boolean = true;
		private static var _isOpenViewDebug:Boolean = false;
		private static var _isHardWareDrive:Boolean = false;// 判断是否使用硬件渲染 ,根据不同渲染模式决定优化策略
		private static var _frameTime:Number;
		private static var _layerManager:LayerManager;
		private static var _frameManager:FrameManager;
		private static var _timerManager:TimerManager;
		private static var _globalError:GlobalError;
		private static var _loaderManager:LoaderManager;
		private static var _windowManager:WindowManager;
		private static var _scale9Manager:Scale9Map;
		private static var _skinManager:SkinManager;
		private static var _dragManager:DragDropManager;
		private static var _fontManager:FontManager;
		
		public function FrameWork()
		{
		}
		
		/**
		 * 框架的初始化
		 */
		public static function start(useStarling:Boolean, stage:Stage, rootClass:Class = null, isDebugMode:Boolean = true, isOpenViewDebug:Boolean = false):void
		{
			//set params
			_isUseStarling = useStarling;
			_stage = stage;
			_rootClass = rootClass;
			_isDebugMode = isDebugMode;
			_isOpenViewDebug = isOpenViewDebug;
			_frameTime = 1000 / _stage.frameRate;
			
			stage.addEventListener(flash.events.Event.RESIZE, onResize);
			
			if (!_isUseStarling)
			{
				init();
				return;
			}
			
			Starling.handleLostContext = true;
			_starling = new Starling(_rootClass, stage);
			_starling.simulateMultitouch = false;
			_starling.enableErrorChecking = false;
			_starling.antiAliasing = 1;
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, onStarlingReady);
		}
		
		private static function onResize(event:flash.events.Event):void
		{
			Caller.dispatchCmd(VIEW_RESIZE, stage.stageWidth, stage.stageHeight);
			Dispatcher.dispatchEvent(new WindowEvent(WindowEvent.ON_POS_CHANGE, null));
		}
		
		private static function onStarlingReady(e:starling.events.Event) : void 
		{ 
			_starling.removeEventListener(starling.events.Event.ROOT_CREATED, onStarlingReady);
			_starling.start();
			init();
		}
		
		private static function init():void
		{
			_layerManager = new LayerManager();
			_frameManager = new FrameManager();
			_timerManager = new TimerManager();
			_globalError = new GlobalError();
			_loaderManager = new LoaderManager();
			_windowManager = new WindowManager();
			_scale9Manager = new Scale9Map();
			_skinManager = new SkinManager();
			_dragManager = new DragDropManager();
			_fontManager = new FontManager();
			
			if (_isUseStarling)
			{
				_isHardWareDrive = Starling.context.driverInfo.toLowerCase().indexOf("software") == -1;
				_skinManager.initRegister();
				//init module
				_layerManager.init(_starling.stage);
				//init ui factory
				UIFactory.init(_starling.stage);
				//log
				if (isDebugMode)
				{
					var logWindow:LogWindow = _windowManager.addPopup(LogWindow) as LogWindow;
					_windowManager.removePopup(LogWindow);
					var callback:Function = function(type:int, msg:String):void
					{
						logWindow.appendLog(msg);
					};
					LogUtil.outputCallback = callback;
				}
			}
			else
			{
				//wait to do
			}
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
		
		public static function get isUseStarling():Boolean
		{
			return _isUseStarling;
		}
		
		public static function get isDebugMode():Boolean
		{
			return _isDebugMode;
		}
		
		public static function get isOpenViewDebug():Boolean
		{
			return _isOpenViewDebug;
		}
		
		public static function get isHardwareDrive():Boolean
		{
			return _isHardWareDrive;
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
		
		public static function get starling():Starling
		{
			return _starling;
		}
		
		public static function get scale9Manager():Scale9Map
		{
			return _scale9Manager;
		}
		
		public static function get skinManager():SkinManager
		{
			return _skinManager;
		}
		
		public static function get dragManager():DragDropManager
		{
			return _dragManager;
		}
		
		public static function get fontManager():FontManager
		{
			return _fontManager;
		}
		
		public static function get isStarted():Boolean
		{
			return _isStarted;
		}
	}
}