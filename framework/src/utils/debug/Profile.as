package utils.debug{

	import flash.system.System;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	public class Profile {
		private static var _fps:uint;
		private static var _ms:uint;
		private static var _mem:Number;
		private static var _memMax:Number;
		
		private static var _frameCount:int=0;
		private static var _frameTime:Number = 0;
		
		private static var _showMonitor:Boolean = false;
		private static var _monitor:ProfileMonitor;
		
		private static var _objects:Dictionary = new Dictionary(true);					
		private static var _reportBool:Boolean;														

		public function Profile() {
		}
		
		public static function init(showMonitor:Boolean = false, monitorContainer:DisplayObjectContainer = null):void
		{
			LogUtil.assert(Starling.current.isStarted, "Starling is not started!");
			_memMax = 0;
			
			if (showMonitor)
			{
				_monitor = new ProfileMonitor();
				monitorContainer.addChild(_monitor);
				_showMonitor = true;
			}
			
			Starling.current.stage.addEventListener(Event.ENTER_FRAME, active);
			setInterval(intervalCheckMemory, 180000);
		}
		
		private static function active(e:EnterFrameEvent):void {
			
			_frameCount++;
			_frameTime += e.passedTime;
			_ms = e.passedTime * 1000;
			
			if (_frameTime > 1)
			{
				_fps = int(_frameCount / _frameTime);
				_mem = Number((System.totalMemory * 0.000000954).toFixed(3));
				_memMax = _memMax > _mem ? _memMax : _mem;
				
				if (_showMonitor)
					_monitor.update(e.passedTime * 1000, _fps, _mem, _memMax);
				else
					LogUtil.info("FPS:"+ _fps + "||" + "Memory Use:" + int(_mem) + " MB" + "||" + "Max Memory Use:" +  _memMax);
				
				_frameTime = _frameCount = 0;
			}
		}
		
		private static function intervalCheckMemory():void
		{
			var curMemory:Number = Number((System.totalMemory * 0.000000954).toFixed(3));
			if (curMemory > 400)
			{
				LogUtil.warn("内存使用警告! 当前使用内存：" + curMemory);
				System.gc();
			}
		}
		
		/**
		 * Memory report
		 */
		private static function reportFunc():void{
			LogUtil.info("** MEMORY REPORT AT:" + int(getTimer()/1000));
			for(var obj:* in _objects){
				LogUtil.info(obj + "exists" + _objects[obj]);
			}
		}
		
		/**
		 * This the function you use to pass objects to be tracked.
		 */
		public static function track(obj:*,detail:*=null):void{
			_objects[obj] = detail;
		}
		
		/**
		 *  This is the function used to trigger a memory report.
		 */
		public static function report():void{
			_reportBool = true;
			reportFunc();
		}
		
	}
}