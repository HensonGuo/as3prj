package effect.escher
{
	import escher.EscherImage;
	
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.events.Event;
	
	import test.BaseTest;

	public class EscherTest2  extends BaseTest
	{
		//----------------------------------------
		// パラメータ.
		//----------------------------------------
		/**
		 * 元画像データのインスタンス.
		 */
		private var mOrgBitmap:Bitmap			= null;
		
		/**
		 * エッシャーエフェクト画像を作成.
		 */
		private var mEscherImage:EscherImage	= null;
		
		/**
		 * 回転角度(radian).
		 */
		private var mRot:Number					= 0.0;
		
		private var mPreMS:Number	= 0;
		
		public function EscherTest2(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			// 元画像データのインスタンスを作成.
			mOrgBitmap	= new Bitmap( new BitmapDataFlower( 320, 320 ) );
			
			// エッシャーエフェクト画像を作成.
			mEscherImage	= new EscherImage( mOrgBitmap.bitmapData, 40, 147, 320, 320 );
			mEscherImage.makeImage();
			
			// 横に並べて表示.
			addChild( mOrgBitmap );
			addChild( mEscherImage );
			mEscherImage.x	= mOrgBitmap.width;
			
			addEventListener( Event.ENTER_FRAME, process, false, 0, true );
		}
		
		//------------------------------------------------------------
		/**
		 * 毎フレームの処理で再描画してみます.
		 */
		//------------------------------------------------------------
		private function process(e:Event):void
		{
			mRot	+= 0.2;
			
			//mPreMS	= new Date().time;
			
			// マウスカーソルの座標X,YをそれぞれR1,R2に対応させてみた.
			var r2:Number	= mEscherImage.mouseY / mEscherImage.height * (mEscherImage.width * 0.5);
			var r1:Number	= mEscherImage.mouseX / mEscherImage.width * r2;
			mEscherImage.setR1R2( r1, r2 );
			mEscherImage.makeImage( 0, 0, 1.0, mRot );
			//trace( "time(ms)  > " + (new Date().time - mPreMS) );
		}
		
	}
}