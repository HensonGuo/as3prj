package utils
{
	import flash.geom.Point;

	public class MathUitl
	{
		/**
		 * 一弧度的角度数 
		 */		
		public static const ONE_RADIANS:Number = 180 / Math.PI; 
		/**
		 * 一角度的弧度数 
		 */		
		public static const ONE_ANGLE:Number = Math.PI/180; 
		
		public function MathUitl()
		{
		}
		
		/**
		 * 获取p1到p2的弧度 
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */		
		public static function getRadiansByPoint(p1:Point,p2:Point ):Number
		{
			return Math.atan2(p2.y - p1.y,p2.x - p1.x);
		}
		/**
		 * 获取两点角度  x1 到 x2的弧度
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 * 
		 */			
		public static function getRadiansByXY(x1:Number,y1:Number,x2:Number,y2:Number ):Number
		{
			return Math.atan2(y2-y1,x2-x1);
		}
		
		/**
		 * 获取弧度 
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 * 
		 */		
		public static function getAngleByXY(x1:Number,y1:Number,x2:Number,y2:Number ):Number
		{
			return getRadiansByXY(x1,y1,x2,y2) * ONE_RADIANS;
		}
		
		/**
		 * 角度转换成弧度 
		 * @param radians
		 * @return 
		 * 
		 */	
		public static function getRadians( angle:Number ):Number
		{
			return 	angle * ONE_ANGLE;
		}
		
		/**
		 * 弧度转换成角度 
		 * @param degrees
		 * @return 
		 * 
		 */		
		public static function getAngle( radians:Number ):Number
		{
			return 	radians * ONE_RADIANS;
		}
		
		/**
		 * 获取两点之间的距离 
		 * @param x1
		 * @param x2
		 * @param y1
		 * @param y2
		 * @return 
		 * 
		 */		
		public static function getDistance(x1:Number,x2:Number,y1:Number,y2:Number):Number
		{
			var x:Number = x2 - x1;
			var y:Number = y2 - y1;
			return Math.sqrt(x * x + y * y);
		}
		
		/**
		 * 随机 min 到 max 的数 
		 * @param min
		 * @param max
		 * @return 
		 * 
		 */	
		public static function random(min:int,max:int):int
		{
			var num:int = max - min;
			return Math.round(Math.random()*num) + min;
		}
		
		private static const MAX_RATIO:Number = 1 / uint.MAX_VALUE;  
		private static var r:uint;         
		public static function setSeed(seed:uint/* = 0*/):void
		{  
			r = seed;  
		}  
		
		public static function getNext():Number  
		{  
			r ^= (r << 21);  
			r ^= (r >>> 35);  
			r ^= (r << 4);  
			return (r * MAX_RATIO);  
		}  
		
		/**
		 * 获取一个数字的符号，大于0返回1 小于0返回-1 等于0 返回0 
		 * @param num
		 * @return 
		 * 
		 */		
		public static function getSign(num:Number):int
		{
			if(num > 0)
			{
				return 1;
			}
			else if(num < 0)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}
		
		public static function average( ...numbers ):Number
		{
			return sum.apply(null,numbers)/numbers.length;
		}
		
		public static function sum( ...numbers ):Number
		{
			var a:Number = 0;
			var leng:uint = numbers.length;
			for(var i:uint=0;i<leng;i++) a+=numbers[i];
			return a;
		}
		
		/**
		 * 0.0% 0.1%之间的模拟乱数生成。perlin噪点指的是没有任何关系。
		 * @param i
		 * @param seed
		 * @return 
		 */		
		public static function noise( i:uint, seed:Number=0.0 ):Number
		{
			seed %= 0xFFF;
			i %= 0x7FF;
			var P:Number  = 3.14159265358979 * ( seed + 0.5 );
			var t:Number  = 173*i*i*i+13577 % 3568927;
			var r:Number  = (i*2.71828182845905+t)*P%1;
			return r;
		}
	}
}