package extend{
	
	import anime.Anime;
	import anime.AnimeEvent;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import test.BaseTest;
	
	public class AnimeTest extends BaseTest {
		
		private var _an:Anime;
		private var _mc:AnimeTestMC
		
		public function AnimeTest(stage:Stage):void {
			
			super(stage);
			
		}
		
		override protected function onAdded(event:Event):void
		{
			_mc = new AnimeTestMC();
			this.addChild(_mc);
			
			_an = new Anime("image/", 30, ".png", 0, 3);
			_an.smoothing = true;
			_an.centering = true;
			_mc.addChild(_an);
			_an.x = _an.y = 150;
			_an.addEventListener(AnimeEvent.PROGRESS, Progress);
			_an.addEventListener(AnimeEvent.COMPLETE, Complete);
		}
		
		//読み込み中
		private function Progress(e:AnimeEvent):void {
			//読込済バイト数と読込予定バイト数を出力
			//trace(e.bytesLoaded + "/" + e.bytesTotal);
		}
		
		//読み込み完了
		private function Complete(e:AnimeEvent):void {
			
			//操作確認用ボタン
			_mc.Play_bt.addEventListener(MouseEvent.CLICK, ClickComponent);
			_mc.Stop_bt.addEventListener(MouseEvent.CLICK, ClickComponent);
			_mc.Next_bt.addEventListener(MouseEvent.CLICK, ClickComponent);
			_mc.Prev_bt.addEventListener(MouseEvent.CLICK, ClickComponent);
			_mc.GTPlay_bt.addEventListener(MouseEvent.CLICK, ClickComponent);
			_mc.GTStop_bt.addEventListener(MouseEvent.CLICK, ClickComponent);
			_mc.Current_bt.addEventListener(MouseEvent.CLICK, ClickComponent);
			_mc.Total_bt.addEventListener(MouseEvent.CLICK, ClickComponent);
		}
		
		//動作確認 ボタンが押された場合
		private function ClickComponent(e:MouseEvent):void {
			if (e.target.name == "Play_bt") {
				//再生
				_an.play();
			}
			else if (e.target.name == "Stop_bt") {
				//停止
				_an.stop();
			}
			else if (e.target.name == "Next_bt") {
				//次のフレームに進み、停止
				_an.nextFrame();
			}
			else if (e.target.name == "Prev_bt") {
				//前のフレームに戻り、停止
				_an.prevFrame();
			}
			else if (e.target.name == "GTPlay_bt") {
				//指定フレームに移動して再生
				_an.gotoAndPlay(10);
			}
			else if (e.target.name == "GTStop_bt") {
				//指定フレームに移動して停止
				_an.gotoAndStop(20);
			}
			else if (e.target.name == "Current_bt") {
				//現在、再生ヘッダのあるフレーム
				_mc.Current_tf.text = String(_an.currentFrame);
			}
			else if (e.target.name == "Total_bt") {
				//総フレーム数
				_mc.Total_tf.text = String(_an.totalFrames);
			}
		}
	}
}