package frame
{
	import resource.interfaces.IDestory;
	import resource.pools.ObjectPool;
	import resource.pools.Reuse;

	public class Frame extends Reuse
	{
		protected var _type:String;
		protected var _id:int;
		protected var _curFrame:int;
		protected var _callback:Function;
		protected var _params:Array;
		
		public function Frame(type:String, callback:Function, ...params)
		{
			setInitParams(type, callback, params);
		}
		
		override protected function setInitParams(...parameters):void
		{
			_type = parameters[0];
			_callback = parameters[1];
			_params = parameters[2];
		}
		
		public function start():void
		{
			if (_id != 0)
				return;
			_id = FrameWork.frameManager.register(this);
		}
		
		public function stop():void
		{
			if (_id == 0)
				return;
			FrameWork.frameManager.unregister(this);
		}
		
		internal function update():void
		{
			_curFrame ++;
			_callback.apply(null, _params);
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function get curFrame():int
		{
			return _curFrame;
		}
		
		override protected function reset():void
		{
			_type = null;
			_id = 0;
			_curFrame = 0;
			_callback = null;
			_params = null;
		}
		
	}
}