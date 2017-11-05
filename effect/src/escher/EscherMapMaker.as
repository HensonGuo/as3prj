package escher{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	/**
	 * 置き換えマップを作成するクラスです.
	 * @author Hiromichi Yamada (hiromichi.yamada@gmail.com)
	 */
	public class EscherMapMaker {
		//----------------------------------------
		// 定数.
		//----------------------------------------
		static private const PI2:Number	= Math.PI * 2;
		
		//----------------------------------------
		// パラメータ.
		//----------------------------------------
		private var mDstBitmapData:BitmapData	= null;	// 出力先BitmapData
		private	var mCenterX:int	= 0;
		private	var mCenterY:int	= 0;
		private var	mR1:Number		= 0;
		private var	mR2:Number		= 0;
		private var	mWidth:Number	= 0;
		private var	mHeight:Number	= 0;
		private var mAlpha:Number	= 0;
		private var mCosAlpha:Number	= 0;
		private var mSinAlpha:Number	= 0;
		private var mSin_CosAlpha:Number	= 0;
		private var mLogR2R1:Number	= 0;
		
		private var	mByWidth:Number		= 0;	// 1/mWidth
		private var	mByHeight:Number	= 0;	// 1/mHeight
		
		 //------------------------------------------------------------
		 /**
		  * コンストラクタ.
		  * @param	dstBitmapData	出力先BitmapDataへの参照.
		  * @param	r1				円環領域の内径(pixel) (0 < r1 < r2 となるようにしてください).
		  * @param	r2				円環領域の外径(pixel) (r2 <= w/2 となるようにしてください).
		  */
		 //------------------------------------------------------------
		public function EscherMapMaker( dstBitmapData:BitmapData, r1:Number, r2:Number )
		{
			mDstBitmapData	= dstBitmapData;
			
			mR1				= r1;
			mR2				= r2;
			mWidth			= mDstBitmapData.width;
			mHeight			= mDstBitmapData.height;
			
			mLogR2R1	= Math.log( mR2 / mR1 );
			mAlpha		= Math.atan( mLogR2R1 / PI2 );
			mCosAlpha	= Math.cos( mAlpha );
			mSinAlpha	= Math.sin( mAlpha );
			mSin_CosAlpha	= mSinAlpha / mCosAlpha;
			mCenterX	= mWidth * 0.5;
			mCenterY	= mHeight * 0.5;
			
			mByWidth		= 1.0 / mWidth;
			mByHeight		= 1.0 / mHeight;
		}
		
		//------------------------------------------------------------
		/**
		 * R1, R2パラメータを再設定します.
		 * @param	r1				円環領域の内径(pixel) (0 < r1 < r2 となるようにしてください).
		 * @param	r2				円環領域の外径(pixel) (r2 <= w/2 となるようにしてください).
		 */
		//------------------------------------------------------------
		public function setR1R2( r1:Number, r2:Number ) :void
		{
			mR1				= r1;
			mR2				= r2;
			
			mLogR2R1	= Math.log( mR2 / mR1 );
			mAlpha		= Math.atan( mLogR2R1 / PI2 );
			mCosAlpha	= Math.cos( mAlpha );
			mSinAlpha	= Math.sin( mAlpha );
			mSin_CosAlpha	= mSinAlpha / mCosAlpha;
		}
		

		//------------------------------------------------------------
		/**
		 * 置き換え画像を画像を生成します.
		 * @param	cx		中央とする位置のX座標（デフォルトで画像中央の0）
		 * @param	cy		中央とする位置のY座標（デフォルトで画像中央の0）
		 * @param	scale	画像スケーリング.
		 * @param	rot		画像回転角度(radian).
		 */
		//------------------------------------------------------------
		public function make( cx:Number = 0.0, cy:Number = 0.0, scale:Number = 1.0, rot:Number = 3.141592653589793 ) :void
		{
			const cosTheta:Number	= Math.cos( rot );
			const sinTheta:Number	= Math.sin( rot );
			const vecX:Point		= new Point(cosTheta * scale, sinTheta * scale );
			const vecY:Point		= new Point(sinTheta * scale, -cosTheta * scale );
			
			const startX:Number		= cx - (mCenterX * cosTheta + mCenterY * sinTheta ) * scale;
			const startY:Number		= cy + ( -mCenterX * sinTheta + mCenterY * cosTheta) * scale;
			
			mDstBitmapData.lock();
			var plotPoint:Point	= null;
			for (var i:int = 0; i < mWidth; i++) {
				for (var j:int = 0; j < mHeight; j++) {
					plotPoint	= getEscherPlotPoint( (startX + vecX.x * i + vecY.x * j), (startY + vecX.y * i + vecY.y * j) );
					mDstBitmapData.setPixel( i, j, getMapColor( i, j, plotPoint.x, plotPoint.y ) );
				}
			}
			mDstBitmapData.unlock();
		}
		
		//------------------------------------------------------------
		/**
		 * 二つの位置間の距離から色を返します.
		 * @return	X方向の移動量をR, Y方向の移動量をGに格納したデータを返します.
		 */
		//------------------------------------------------------------
		private function getMapColor( orgX:Number, orgY:Number, plotX:Number, plotY:Number ) :uint
		{
			// X方向最大移動量:mWidth、Y方向最大移動量:mHeight とします.
			const retR:uint	= (uint((plotX - orgX) * mByWidth * 128) + 0x80) & 0xFF;
			const retG:uint	= (uint((plotY - orgY) * mByHeight * 128) + 0x80) & 0xFF;
			
			return ( (retR << 16) | (retG << 8) | 0x00 );
		}
		
		//------------------------------------------------------------
		/**
		 * エフェクトのために指定位置の色データを取得します.
		 * @param	aX	画像のX座標(pixel)
		 * @param	aY	画像のY座標(pixel)
		 * @return	対応する画像座表を格納したPointデータ.
		 */
		//------------------------------------------------------------
		private function getEscherPlotPoint( aX:int, aY:int ) :Point
		{
			// 各種座標変換.
			const logR:Number	= Math.log( Math.sqrt( aX * aX + aY * aY ) );
			const theta:Number	= Math.atan2( aY, aX ) + Math.PI;
			
			const ms:Number		= (logR + theta * mSin_CosAlpha) % mLogR2R1;
			const mt:Number		= (theta - logR * mSin_CosAlpha) % PI2;
			
			// 画像での座標に変換.
			const u:int			= mR1 * Math.exp(ms) * Math.cos(mt);
			const v:int			= mR1 * Math.exp(ms) * Math.sin(mt);
			
			// .
			return new Point( (mCenterX + u), (mCenterY - v) );
		}
	}
	
}