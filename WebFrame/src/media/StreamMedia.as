package media
{
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.StageVideo;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import utils.debug.LogUtil;
	import utils.trigger.Dispatcher;

	public class StreamMedia extends MediaCore
	{
		private var _stream:NetStream;
		private var _connection:NetConnection;
		private var _updateInterval:uint;
		private var _updateTimerID:int;
		
		public function StreamMedia(url:String, bufferTime:int, checkPolicyFile:Boolean = false, updateInterval:uint = 250)
		{
			super(url, bufferTime);
			_updateInterval = updateInterval;
			//init connection
			_connection = new NetConnection();
			_connection.connect(null);
			_connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorEventHandler);
			_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorEventHandler);
			//init stream
			_stream = new NetStream(_connection);
			_stream.bufferTime = bufferTime / 1000;
			_stream.checkPolicyFile = checkPolicyFile;
			_stream.client = { onMetaData:onMetaDataHandler, onCuePoint:onCuePointHandler };
			_stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusEventHandler);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorEventHandler);
			_stream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
			_stream.addEventListener("progress", onMetaDataHandler);
		}
		
		private function onMetaDataHandler(info:Object):void
		{
			_data = info;
			_totalTime = info.duration;
			Dispatcher.dispatchEvent(new MediaEvent(MediaEvent.DATA_SYNC));
		}
		
		private function onCuePointHandler(info:Object):void
		{
			trace("1");
		}
		
		private function securityErrorEventHandler(e:SecurityErrorEvent):void 
		{
			LogUtil.error(e.text);
		}
		
		private function asyncErrorEventHandler(e:AsyncErrorEvent):void 
		{
			LogUtil.error(e.text);
		}
		
		private function ioErrorEventHandler(e:IOErrorEvent):void 
		{
			LogUtil.error(e.text);
		}
		
		private function netStatusEventHandler(e:NetStatusEvent):void 
		{
			var code:String = e.info.code;
			var level:String = e.info.level;
			if (level == "error")
			{
				LogUtil.error(code);
				return;
			}
			if (level == "warning")
			{
				LogUtil.warn(code);
				return;
			}
			switch (code) 
			{
				case "NetStream.Buffer.Empty":
					_isBuffering = true;
					LogUtil.info("数据的接收速度不足以填充缓冲区。 数据流将在缓冲区重新填充前中断，此时将发送 NetStream.Buffer.Full 消息，并且该流将重新开始播放");
					break;
				case "NetStream.Buffer.Full":
					_isBuffering = false;
					LogUtil.info("缓冲区已满并且流将开始播放");
					break;
				case "NetStream.Buffer.Flush":
					LogUtil.info("数据已完成流式处理，剩余的缓冲区将被清空");
					break;
				case "NetStream.Play.Start":
					LogUtil.info("播放开始");
					break;
				case "NetStream.Play.Stop":
					stop();
					LogUtil.info("播放结束");
					break;
				case "NetStream.Play.Reset":
					LogUtil.info("由播放列表重置导致");
					break;
				case "NetStream.Pause.Notify":
					LogUtil.info("流已暂停");
					break;
				case "NetStream.Unpause.Notify":
					LogUtil.info("流已恢复");
					break;
				case "NetStream.Seek.Failed":
					//如果流处于不可搜索状态，则会发生搜索失败
					LogUtil.info("搜索失败");
					break;
				case "NetStream.Seek.Notify":
					_isBuffering = true;
					LogUtil.info("搜索操作完成");
					break;
				case "NetStream.Connect.Closed":
					LogUtil.info("成功关闭 P2P 连接");
					break;
				case "NetStream.Connect.Success":
					LogUtil.info("P2P 连接尝试成功");
					break;
				case "NetConnection.Connect.Closed":
					LogUtil.info("成功关闭连接");
					break;
				case "NetConnection.Connect.Success":
					LogUtil.info("连接尝试成功");
					break;
				case "NetStream.Publish.Start":
				case "NetStream.Publish.BadName":
				case "NetStream.Publish.Idle":
				case "NetStream.Unpublish.Success":
				case "NetStream.Play.PublishNotify":
				case "NetStream.Play.UnpublishNotify":
				case "NetStream.Play.InsufficientBW":
				case "NetStream.Play.Transition":
				case "NetStream.Record.Start":
				case "NetStream.Record.NoAccess":
				case "NetStream.Record.Stop":
				case "NetStream.Record.Failed":
				case "SharedObject.Flush.Success":
					LogUtil.info(code);
					break;
			}
		}
		
		override public function play():void
		{
			if (_state == MediaState.PLAY)
				return;
			super.play();
			_updateTimerID = setInterval(intervalUpdate, _updateInterval);
			_stream.play(url);
		}
		
		override public function pause():void
		{
			if (_state == MediaState.PAUSE)
				return;
			super.pause();
			_stream.pause();
		}
		
		override public function resume():void
		{
			super.play();
			_stream.resume();
		}
		
		override public function stop():void
		{
			if (_state == MediaState.STOP)
				return;
			super.stop();
			_stream.close();
			if (_updateTimerID != 0)
			{
				clearInterval(_updateTimerID);
				_updateTimerID = 0;
			}
			Dispatcher.dispatchEvent(new MediaEvent(MediaEvent.PLAY_COMPLETE));
		}
		
		override public function seek(time:Number=0):void
		{
			_stream.seek(time);
		}
		
		override public function seekPercent(percent:Number=0):void
		{
			var time:Number = percent * _totalTime;
			seek(time);
		}
		
		override public function set volume(value:Number):void
		{
			super.volume = value;
			var soundTransform:SoundTransform = _stream.soundTransform;
			soundTransform.volume = value;
			_stream.soundTransform = soundTransform;
		}
		
		override public function destory(isReuse:Boolean=true):void
		{
			_connection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorEventHandler);
			_connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorEventHandler);
			_connection.close();
			_connection = null;
			_stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusEventHandler);
			_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorEventHandler);
			_stream.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
			_stream.close();
			_stream = null;
			_updateInterval = 0;
			if (_updateTimerID != 0)
			{
				clearInterval(_updateTimerID);
				_updateInterval = 0;
			}
			super.destory(isReuse);
		}
		
		public function beAttatchedByVideo(video:Video):void
		{
			video.attachNetStream(_stream);
		}
		
		public function beAttatchedByStageVideo(video:StageVideo):void
		{
			video.attachNetStream(_stream);
		}
		
		private function intervalUpdate():void
		{
			//加载进度
			if (_stream.bytesLoaded == _stream.bytesTotal) 
			{
				Dispatcher.dispatchEvent(new MediaEvent(MediaEvent.LOAD_COMPLETE));
			}
			else 
			{
				Dispatcher.dispatchEvent(new MediaEvent(MediaEvent.LOADING));
				_loadPercent = _stream.bytesLoaded / _stream.bytesTotal;
			}
			
			//缓冲
			if (_isBuffering) 
			{
				var prog:Number = _stream.bufferLength / _stream.bufferTime;
				_bufferPercent = (prog > 1) ? 1 : prog;
				Dispatcher.dispatchEvent(new MediaEvent(MediaEvent.BUFFERING));
			}
			
			//播放进度
			if (_state == MediaState.PLAY)
			{
				_curPlayTime = _stream.time;
				Dispatcher.dispatchEvent(new MediaEvent(MediaEvent.PLAYING));
			}
		}
		
	}
}