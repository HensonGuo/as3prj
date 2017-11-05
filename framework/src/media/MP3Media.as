package media
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import utils.debug.LogUtil;
	import utils.trigger.Dispatcher;

	public class MP3Media extends MediaCore
	{
		private var _sound:Sound;
		private var _context:SoundLoaderContext;
		private var _channel:SoundChannel;
		private var _updateInterval:uint;
		private var _updateTimerID:int;
		private var _pauseTime:Number;
		
		public function MP3Media(url:String, bufferTime:int, checkPolicyFile:Boolean = false, updateInterval:Number = 250, callback:Object = null)
		{
			super(url, bufferTime);
			_updateInterval = updateInterval;
			_context = new SoundLoaderContext(bufferTime, checkPolicyFile);
			_sound = new Sound();
			_sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
			_sound.addEventListener(Event.OPEN, openEventHandler);
			_sound.addEventListener(ProgressEvent.PROGRESS, progressEventHandler);
			_sound.addEventListener(Event.COMPLETE, completeEventHandler);
			_sound.addEventListener(Event.ID3, id3DataEventHandler);
			_sound.load(new URLRequest(url), _context);
		}
		
		private function ioErrorEventHandler(e:IOErrorEvent):void 
		{
			LogUtil.error(e.text);
		}
		
		private function openEventHandler(e:Event):void 
		{
			var total:Number = _totalTime * 1000;
			_context.bufferTime > total ? _context.bufferTime = total : null;
		}
		
		private function progressEventHandler(e:ProgressEvent):void 
		{
			_loadPercent = e.bytesLoaded / e.bytesTotal;
			Dispatcher.dispatchEvent(new MediaEvent(MediaEvent.LOADING));
		}
		
		private function completeEventHandler(e:Event):void 
		{
			Dispatcher.dispatchEvent(new MediaEvent(MediaEvent.LOAD_COMPLETE));
		}
		
		private function id3DataEventHandler(e:Event):void 
		{
			if(!_sound.id3)
				return;
			_data = _sound.id3;
			_data.type = "mp3";
			Dispatcher.dispatchEvent(new MediaEvent(MediaEvent.DATA_SYNC));
		}
		
		override public function play():void
		{
			if (_state == MediaState.PLAY)
				return;
			super.play();
			_updateTimerID = setInterval(intervalUpdate, _updateInterval);
			onSoundPlayAction(0);
		}
		
		override public function pause():void
		{
			if (_state == MediaState.PAUSE)
				return;
			super.pause();
			onSoundStopAction(false);
		}
		
		override public function stop():void
		{
			if (_state == MediaState.STOP)
				return;
			super.pause();
			onSoundStopAction(true);
		}
		
		override public function resume():void
		{
			super.play();
			onSoundPlayAction(_pauseTime);
		}
		
		override public function seek(time:Number=0):void
		{
			if (time < 0 || time > _totalTime)
				return;
			_pauseTime = time * 1000;
			resume();
		}
		
		override public function seekPercent(percent:Number=0):void
		{
			var time:Number = percent * _totalTime;
			seek(time);
		}
		
		override public function destory(isReuse:Boolean=true):void
		{
			if (_channel != null)
			{
				_sound.close();
				_channel.removeEventListener(Event.SOUND_COMPLETE, onPlayComplete);
				_channel = null;
			}
			_updateInterval = 0;
			if (_updateTimerID != 0)
			{
				clearInterval(_updateTimerID);
				_updateInterval = 0;
			}
			_pauseTime = 0;
			_context = null;
			_sound.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
			_sound.removeEventListener(Event.OPEN, openEventHandler);
			_sound.removeEventListener(ProgressEvent.PROGRESS, progressEventHandler);
			_sound.removeEventListener(Event.COMPLETE, completeEventHandler);
			_sound.removeEventListener(Event.ID3, id3DataEventHandler);
			_sound = null;
			super.destory(isReuse);
		}
		
		override public function set volume(value:Number):void
		{
			super.volume = value;
			var soundTransform:SoundTransform = _channel.soundTransform;
			soundTransform.volume = value;
			_channel.soundTransform = soundTransform;
		}
		
		private function onSoundPlayAction(position:Number):void
		{
			_channel = _sound.play(position);
			_channel.addEventListener(Event.SOUND_COMPLETE, onPlayComplete);
		}
		
		private function onSoundStopAction(close:Boolean):void
		{
			_channel.stop();
			_channel.removeEventListener(Event.SOUND_COMPLETE, onPlayComplete);
			if (close) 
			{
				_pauseTime = 0;
				_sound.close();
			} 
			else 
			{
				_pauseTime = _channel.position;
			}
			_channel = null;
		}
		
		private function onPlayComplete(e:Event):void 
		{
			stop();
			Dispatcher.dispatchEvent(new MediaEvent(MediaEvent.PLAY_COMPLETE));
		}
		
		private function intervalUpdate():void
		{
			_isBuffering = _sound.isBuffering;													//设置缓冲标识
			_curPlayTime = _channel.position / 1000;										//设置播放头位置
			_totalTime = _sound.bytesTotal / (_sound.bytesLoaded / _sound.length) / 1000;		//设置播放总长度
			if (_isBuffering) 
			{
				_bufferPercent = _sound.length / (_channel.position + _bufferTime);
				Dispatcher.dispatchEvent(new MediaEvent(MediaEvent.BUFFERING));
			}
			if (_curPlayTime > 0)
			{
				Dispatcher.dispatchEvent(new MediaEvent(MediaEvent.PLAYING));
			}
		}
		
	}
}