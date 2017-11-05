package effect.escher
{
	import escher.EscherEffect;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.media.Video;
	
	import test.BaseTest;
	
	public class EscherTest1 extends BaseTest
	{
		//----------------------------------------
		// Flash上で配置されたインスタンス.
		//----------------------------------------
		public var mCameraButton:MovieClip;
		
		//----------------------------------------
		// パラメータ.
		//----------------------------------------
		private var mOrgBitmap:Bitmap			= null;
		private var mEscherEffect:EscherEffect= null;
		
		private var mVideo:Video				= null;
		private var mCamera:Camera				= null;
		
		public function EscherTest1(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			// 元画像データのインスタンスを作成.
			mOrgBitmap	= new Bitmap( new BitmapDataFlower( 320, 320 ) );
			
			// 表示.
			addChild( mOrgBitmap );
			
			// test.
			mEscherEffect	= new EscherEffect( mOrgBitmap );
			mOrgBitmap.filters	= [ mEscherEffect.filter ];
			
			// 置き換えマップも表示してみます.
			var effectorMap:Bitmap	= new Bitmap( mEscherEffect.mapBitmapdata );
			addChild( effectorMap );
			effectorMap.x	= mOrgBitmap.width;
		}
		
		//------------------------------------------------------------
		/**
		 * カメラ起動ボタンとして設定します.
		 */
		//------------------------------------------------------------
		private function setupCameraButton( mc:MovieClip ) :void
		{
			if ( mc == null ) {
				return;
			}
			
			mCamera	= Camera.getCamera();
			if ( mCamera == null ) {
				// カメラを取得できないときの処理.
				trace( "You need a camera." );
				mc.gotoAndStop( 4 );
				mc.alpha	= 0.2;
				return;
			}
			
			mVideo	= new Video( 320, 320 );
			
			mc.gotoAndStop( 1 );
			mc.addEventListener( MouseEvent.ROLL_OVER, cameraButtonMouseEventHandler );
			mc.addEventListener( MouseEvent.ROLL_OUT, cameraButtonMouseEventHandler );
			mc.addEventListener( MouseEvent.CLICK, cameraButtonMouseEventHandler );
		}
		
		//------------------------------------------------------------
		/**
		 * カメラ起動ボタンを押したときの処理.
		 */
		//------------------------------------------------------------
		private function cameraButtonMouseEventHandler(e:MouseEvent):void
		{
			var mc:MovieClip	= e.target as MovieClip;
			switch( e.type ) {
				case MouseEvent.ROLL_OVER:
					mc.gotoAndStop( 2 );
					break;
				case MouseEvent.ROLL_OUT:
					mc.gotoAndStop( 1 );
					break;
				case MouseEvent.CLICK:
					// ボタンを消します.
					mc.gotoAndStop( 3 );
					mc.mouseEnabled	= false;
					mc.removeEventListener( MouseEvent.ROLL_OVER, cameraButtonMouseEventHandler );
					mc.removeEventListener( MouseEvent.ROLL_OUT, cameraButtonMouseEventHandler );
					mc.removeEventListener( MouseEvent.CLICK, cameraButtonMouseEventHandler );
					// カメラを起動します.
					startCamera();
					break;
			}
		}
		
		//------------------------------------------------------------
		/**
		 * カメラを起動します.
		 */
		//------------------------------------------------------------
		private function startCamera() :void
		{
			if ( mVideo == null || mCamera == null ) {
				// カメラを取得できないときの処理.
				trace( "You need a camera." );
				mCameraButton.gotoAndStop( 4 );
				mCameraButton.alpha	= 0.2;
				return;
			}
			mVideo.attachCamera( mCamera );
			
			removeChild( mOrgBitmap );
			
			addChild( mVideo );
			mVideo.filters	= [ mEscherEffect.filter ];
		}
	}
}