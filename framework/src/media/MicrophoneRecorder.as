package media
{
	import flash.events.SampleDataEvent;
	import flash.media.Microphone;
	import flash.utils.ByteArray;

	public class MicrophoneRecorder
	{
		public function MicrophoneRecorder()
		{
		}
		
		private var _isStarted:Boolean;
		private var _recordedBytes:ByteArray;
		private var _mic:Microphone;
		
		public function get recordedBytes():ByteArray
		{
			return _recordedBytes;
		}
		
		public function startRecording():void
		{
			if (_isStarted) {
				return;
			}
			
			_isStarted = true;
			_recordedBytes = new ByteArray();
			_mic = Microphone.getMicrophone();
			_mic.rate = 44;
			_mic.gain = 100;
			_mic.setSilenceLevel(0)
			_mic.addEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
		}
		
		private function micSampleDataHandler(e:SampleDataEvent):void
		{
			while (e.data.bytesAvailable > 0) {
				var n:Number = e.data.readFloat();
				_recordedBytes.writeFloat(n);
				_recordedBytes.writeFloat(n);
			}
		}
		
		public function endRecording():void
		{
			if (!_isStarted) {
				return;
			}
			
			_isStarted = false;
			_mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
			_mic = null;
		}
	}
}