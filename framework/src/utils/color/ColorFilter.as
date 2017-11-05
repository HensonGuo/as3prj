package utils.color
{
	import flash.filters.ColorMatrixFilter;

	public class ColorFilter
	{
		public function ColorFilter()
		{
		}
		
		/**
		 * 色彩饱和度
		 * 
		 * @param n: 0 ~ 255
		 * @return 
		 * 
		 */
		public static function createSaturationFilter(n:Number):ColorMatrixFilter
		{
			return new ColorMatrixFilter(
				[0.3086 * (1 - n)+ n, 0.6094 * (1 - n), 0.0820 * (1 - n), 0, 0,
					0.3086 *(1 - n), 0.6094 *(1 - n) + n, 0.0820 * (1 - n), 0, 0,
					0.3086 *(1 - n), 0.6094 * (1 - n), 0.0820 * (1 - n) + n, 0, 0,
					0, 0, 0, 1, 0]);
		}
		
		/**
		 * 对比度
		 * 
		 * @param n: 0 ~ 10
		 * @return 
		 * 
		 */
		public static function createContrastFilter(n:Number):ColorMatrixFilter
		{
			return new ColorMatrixFilter(
				[n, 0, 0, 0, 128 * (1 - n),
					0, n, 0, 0, 128 * (1 - n),
					0, 0, n, 0, 128 * (1 - n),
					0, 0, 0, 1, 0]);
		}
		
		/**
		 * 亮度
		 * 
		 * @param n: -255 ~ 255
		 * @return 
		 * 
		 */
		public static function createBrightnessFilter(n:Number):ColorMatrixFilter
		{
			return new ColorMatrixFilter(
				[1, 0, 0, 0, n,
					0, 1, 0, 0, n,
					0, 0, 1, 0, n,
					0, 0, 0, 1, 0]);
		}
		
		/**
		 * 颜色反相
		 * 
		 * @return 
		 * 
		 */
		public static function createInversionFilter():ColorMatrixFilter
		{
			return new ColorMatrixFilter(
				[-1, 0, 0, 0, 255,
					0, -1, 0, 0, 255,
					0, 0, -1, 0, 255,
					0, 0, 0, 1, 0]);
		}
		
		/**
		 * 色相偏移
		 *  
		 * @param n: 0 ~ 360
		 * @return 
		 * 
		 */
		public static function createHueFilter(n:Number):ColorMatrixFilter
		{
			const p1:Number = Math.cos(n * Math.PI / 180);
			const p2:Number = Math.sin(n * Math.PI / 180);
			const p4:Number = 0.213;
			const p5:Number = 0.715;
			const p6:Number = 0.072;
			return new ColorMatrixFilter([p4 + p1 * (1 - p4) + p2 * (0 - p4), p5 + p1 * (0 - p5) + p2 * (0 - p5), p6 + p1 * (0 - p6) + p2 * (1 - p6), 0, 0, 
				p4 + p1 * (0 - p4) + p2 * 0.143, p5 + p1 * (1 - p5) + p2 * 0.14, p6 + p1 * (0 - p6) + p2 * -0.283, 0, 0, 
				p4 + p1 * (0 - p4) + p2 * (0 - (1 - p4)), p5 + p1 * (0 - p5) + p2 * p5, p6 + p1 * (1 - p6) + p2 * p6, 0, 0,
				0, 0, 0, 1, 0]);
		}
		
		/**
		 * 阈值
		 * 
		 * @param n: -255 ~ 255
		 * @return 
		 * 
		 */
		public static function createThresholdFilter(n:int):ColorMatrixFilter
		{
			return new ColorMatrixFilter(
				[0.3086*256, 0.6094*256, 0.0820*256, 0, -256*n,
					0.3086*256, 0.6094*256, 0.0820*256, 0, -256*n,
					0.3086*256, 0.6094*256, 0.0820*256, 0, -256*n,
					0, 0, 0, 1, 0]);
		}
	}
}