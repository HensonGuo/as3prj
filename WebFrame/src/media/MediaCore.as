package media
{
	import resource.pools.ObjectPool;

	public class MediaCore implements IMediaCore
	{
		protected var _state:String;
		protected var _url:String;
		protected var _data:Object;
		protected var _volume:Number = 1;
		protected var _isMuted:Boolean;
		protected var _bufferTime:Number;
		protected var _isBuffering:Boolean;
		protected var _bufferPercent:Number;
		protected var _loadPercent:Number;
		protected var _curPlayTime:Number;
		protected var _totalTime:Number;
		
		public function MediaCore(url:String, bufferTime:int)
		{
			_url = url;
			_bufferTime = bufferTime;
		}
		
		public function play():void
		{
			_state = MediaState.PLAY;
		}
		
		public function pause():void
		{
			_state = MediaState.PAUSE;
		}
		
		public function resume():void
		{
		}
		
		public function stop():void
		{
			_state = MediaState.STOP;
		}
		
		public function seek(time:Number = 0):void
		{
		}
		
		public function seekPercent(percent:Number=0):void
		{
		}
		
		public function destory(isReuse:Boolean=true):void
		{
			_state = null;
			_url = null;
			_data = null;
			_volume = 0;
			_isMuted = false;
			_bufferTime = 0;
			_bufferPercent = 0;
			_isBuffering = false;
			_loadPercent = 0;
			_curPlayTime = 0;
			_totalTime = 0;
			if (isReuse)
				ObjectPool.disposeObject(this);
		}
		
		public function get state():String
		{
			return _state;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set volume(value:Number):void
		{
			_volume = value;
			_isMuted = _volume == 0;
		}
		
		public function get volume():Number
		{
			return _volume;
		}
		
		public function get isMuted():Boolean
		{
			return _isMuted;
		}
		
		public function get bufferTime():Number
		{
			return _bufferTime;
		}
		
		public function get isBuffering():Boolean
		{
			return _isBuffering;
		}
		
		public function get bufferPercent():Number
		{
			return _bufferPercent;
		}
		
		public function get loadPercent():Number
		{
			return _loadPercent
		}
		
		public function get curPlayTime():Number
		{
			return _curPlayTime;
		}
		
		public function get totalTime():Number
		{
			return _totalTime;
		}
	}
}