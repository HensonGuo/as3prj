package escher{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.filters.DisplacementMapFilter;
	
	/**
	 * エッシャー的な絵に変換するエフェクタ.
	 * @author Hiromichi Yamada (hiromichi.yamada@gmail.com)
	 */
	public class EscherEffect {
		//----------------------------------------
		// パラメータ.
		//----------------------------------------
		private var mTarget:DisplayObject		= null;	// 変換する元画像.
		
		private var mMapBitmapData:BitmapData	= null;	// 置き換えマップデータ.
		private var mEscherMapMaker:EscherMapMaker	= null;
		
		private var mDisplacementMapFilter:DisplacementMapFilter	= null;
		
		//------------------------------------------------------------
		/**
		 * コンストラクタ.
		 * @param	target	変換対象の描画オブジェクト.
		 * @param	r1		円環領域の内径(pixel) (0 < r1 < r2 となるようにしてください).
		 * @param	r2		円環領域の外径(pixel) (r2 <= w/2 となるようにしてください).
		 * @param	apply	true:すぐに適用します, false:filterパラメータを取得して適用してください.
		 */
		//------------------------------------------------------------
		public function EscherEffect( target:DisplayObject, r1:Number = -1, r2:Number = -1, apply:Boolean = false )
		{
			//　ターゲットを設定します.
			mTarget	= target;
			
			// 置き換え画像を作成します.
			makeMap( r1, r2 );
			
			// 置き換えフィルタを作成します.
			mDisplacementMapFilter	= new DisplacementMapFilter(
											mMapBitmapData,					// mapBitmap
											null,							// mapPoint
											BitmapDataChannel.RED,			// componentX
											BitmapDataChannel.GREEN,		// componentY
											mMapBitmapData.width * 2.0,		// scaleX
											mMapBitmapData.height * 2.0,	// scaleY
											"wrap",							// mode
											0x0, 0.0						// color, alpha
											);
			
			// 適用します.
			if ( apply ) {
				mTarget.filters	= [ mDisplacementMapFilter ];
			}
		}
		
		//------------------------------------------------------------
		/**
		 * 置き換え画像を作成します.
		 * @param	r1		円環領域の内径(pixel) (0 < r1 < r2 となるようにしてください).
		 * @param	r2		円環領域の外径(pixel) (r2 <= w/2 となるようにしてください).
		 */
		//------------------------------------------------------------
		public function makeMap( r1:Number=-1, r2:Number=-1 ) :void
		{
			mMapBitmapData	= new BitmapData( mTarget.width, mTarget.height, true, 0xFF808080 );
			if ( r2 == -1 ) {
				r2	= mTarget.width * 0.4;
			}
			if ( r1 == -1 ) {
				r1	= r2 * 0.4;
			}
			mEscherMapMaker	= new EscherMapMaker( mMapBitmapData, r1, r2 );
			mEscherMapMaker.make();
		}
		
		//------------------------------------------------------------
		/**
		 * 置き換えフィルタ.
		 */
		//------------------------------------------------------------
		public function get filter() :DisplacementMapFilter
		{
			return mDisplacementMapFilter;
		}
		
		//------------------------------------------------------------
		/**
		 * 置き換え画像のBitmapData.
		 */
		//------------------------------------------------------------
		public function get mapBitmapdata() :BitmapData
		{
			return mMapBitmapData;
		}
	}
}