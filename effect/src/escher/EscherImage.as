package escher {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	/**
	 * エッシャーの騙し絵のような画像を生成します.
	 * @version 0.1.1
	 * @author Hiromichi Yamada (hiromichi.yamada@gmail.com)
	 * @see 移植元のpythonライブラリ.. http://mglab.blogspot.com/2008/09/blog-post_20.html
	 * @see オリジナル論文.. http://www.josleys.com/articles/printgallery.htm
	 * @see 私のブログエントリ.. http://d.hatena.ne.jp/octech/20080930#1222759025
	 */
	public class EscherImage extends Bitmap
	{
		//----------------------------------------
		// 定数.
		//----------------------------------------
		static private const PI2:Number	= Math.PI * 2;
		
		//----------------------------------------
		// パラメータ.
		//----------------------------------------
		private var mOrgBitmapData:BitmapData	= null;
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
		
		 //------------------------------------------------------------
		 /**
		  * コンストラクタ.
		  * @param	orgBitmapData	元BitmapDataへの参照.
		  * @param	r1				円環領域の内径(pixel) (0 < r1 < r2 となるようにしてください).
		  * @param	r2				円環領域の外径(pixel) (r2 <= w/2 となるようにしてください).
		  * @param	w				作成するイメージの幅(pixel).
		  * @param	h				作成するイメージの高さ(pixel).
		  */
		 //------------------------------------------------------------
		public function EscherImage( orgBitmapData:BitmapData, r1:Number, r2:Number, w:Number, h:Number )
		{
			mOrgBitmapData	= orgBitmapData;
			mR1				= r1;
			mR2				= r2;
			mWidth			= w;
			mHeight			= h;
			
			mLogR2R1	= Math.log( mR2 / mR1 );
			mAlpha		= Math.atan( mLogR2R1 / PI2 );
			mCosAlpha	= Math.cos( mAlpha );
			mSinAlpha	= Math.sin( mAlpha );
			mSin_CosAlpha	= mSinAlpha / mCosAlpha;
			mCenterX	= orgBitmapData.width * 0.5;
			mCenterY	= orgBitmapData.height * 0.5;
			
			bitmapData	= new BitmapData( mWidth, mHeight );
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
		 * 新しく画像を生成します.
		 * @param	cx		中央とする位置のX座標（デフォルトで画像中央の0）
		 * @param	cy		中央とする位置のY座標（デフォルトで画像中央の0）
		 * @param	scale	画像スケーリング.
		 * @param	rot		画像回転角度(radian).
		 */
		//------------------------------------------------------------
		public function makeImage( cx:Number = 0.0, cy:Number = 0.0, scale:Number = 1.0, rot:Number = 0.0 ) :void
		{
			/*
			cx = mWidth / 2 - cx;
			cy = -( mHeight / 2 - cy );
			*/
			
			const cosTheta:Number	= Math.cos( rot );
			const sinTheta:Number	= Math.sin( rot );
			const vecX:Point		= new Point(cosTheta * scale, sinTheta * scale );
			const vecY:Point		= new Point(sinTheta * scale, -cosTheta * scale );
			
			
			const widthHalf:Number	= mWidth * 0.5;
			const heightHalf:Number	= mHeight * 0.5;
		
			const startX:Number		= cx - (widthHalf * cosTheta + heightHalf * sinTheta ) * scale;
			const startY:Number		= cy + ( -widthHalf * sinTheta + heightHalf * cosTheta) * scale;
			
			const bd:BitmapData		= this.bitmapData;
			bd.lock();
			for (var i:int = 0; i < mWidth; i++) {
				for (var j:int = 0; j < mHeight; j++) {
					bd.setPixel(
						i, j,
						escherPlot(
							startX + vecX.x * i + vecY.x * j,
							startY + vecX.y * i + vecY.y * j
						)
					)
				}
			}
			bd.unlock();
		}
		
		//------------------------------------------------------------
		/**
		 * エフェクトのために指定位置の色データを取得します.
		 * @param	aX	画像のX座標(pixel)
		 * @param	aY	画像のY座標(pixel)
		 * @return	色データ.
		 */
		//------------------------------------------------------------
		private function escherPlot( aX:int, aY:int ) :uint
		{
			// 各種座標変換.
			const logR:Number	= Math.log( Math.sqrt( aX * aX + aY * aY ) );
			const theta:Number	= Math.atan2( aY, aX ) + Math.PI;
			
			const ms:Number		= (logR + theta * mSin_CosAlpha) % mLogR2R1;
			const mt:Number		= (theta - logR * mSin_CosAlpha) % PI2;
			
			// 画像での座標に変換.
			const u:int			= mR1 * Math.exp(ms) * Math.cos(mt);
			const v:int			= mR1 * Math.exp(ms) * Math.sin(mt);
			
			// 元画像から数学的座標系（中央を(0,0),情報が+Yの座標系）でピクセル色データを取得します.
			return mOrgBitmapData.getPixel( (mCenterX + u), (mCenterY - v) );
		}
	}
}
