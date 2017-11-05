package utils
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class GeomUtil
	{
		public static function getGlobalRect(target:DisplayObject):Rectangle
		{
			var rect:Rectangle = target.getBounds(target.parent);
			var pt:Point = new Point(rect.x, rect.y);
			pt = target.parent.localToGlobal(pt);
			return new Rectangle(pt.x, pt.y, rect.width, rect.height);
		}
		
		/**
		 * 线是否与矩形相交
		 */
		public static function isLineIntersectRectangle(linePointX1:int  , linePointY1:int   , linePointX2:int   , linePointY2:int   , rectangleLeftTopX:int   , rectangleLeftTopY:int   , rectangleRightBottomX:int   , rectangleRightBottomY:int):Boolean
		{
			var lineHeight:int = linePointY1 - linePointY2;  
			var lineWidth:int = linePointX2 - linePointX1;  
			// 计算叉乘  
			var c:int = linePointX1 * linePointY2 - linePointX2 * linePointY1;
			if(   (lineHeight * rectangleLeftTopX + lineWidth * rectangleLeftTopY + c >= 0 && lineHeight * rectangleRightBottomX + lineWidth * rectangleRightBottomY + c <= 0)
				|| (lineHeight * rectangleLeftTopX + lineWidth * rectangleLeftTopY + c <= 0 && lineHeight * rectangleRightBottomX + lineWidth * rectangleRightBottomY + c >= 0)
				|| (lineHeight * rectangleLeftTopX + lineWidth * rectangleRightBottomY + c >= 0 && lineHeight * rectangleRightBottomX + lineWidth * rectangleLeftTopY + c <= 0)
				|| (lineHeight * rectangleLeftTopX + lineWidth * rectangleRightBottomY + c <= 0 && lineHeight * rectangleRightBottomX + lineWidth * rectangleLeftTopY + c >= 0)  )
			{
				if (rectangleLeftTopX > rectangleRightBottomX) 
				{    
					var temp1:int = rectangleLeftTopX;
					rectangleLeftTopX = rectangleRightBottomX;
					rectangleRightBottomX = temp1;
				}   
				if (rectangleLeftTopY < rectangleRightBottomY) 
				{    
					var temp2:int = rectangleLeftTopY;
					rectangleLeftTopY = rectangleRightBottomY;
					rectangleRightBottomY = temp2;
				}   
				if ( (linePointX1 < rectangleLeftTopX && linePointX2 < rectangleLeftTopX)      
					|| (linePointX1 > rectangleRightBottomX && linePointX2 > rectangleRightBottomX)
					|| (linePointY1 > rectangleLeftTopY && linePointY2 > rectangleLeftTopY)
					|| (linePointY1 < rectangleRightBottomY && linePointY2 < rectangleRightBottomY) ) 
				{    
					return false;
				} 
				else 
				{    
					return true;
				} 
			}
			return false;
		}
		
		/**
		 * 给出坐标的角度计算（后者在前者的什么方向）
		 */
		public static function angleCompute(x1 : Number,y1 : Number,x2 : Number,y2 : Number) : Number {
			var temp_a : Number = x2 - x1;
			var temp_b : Number = y2 - y1;
			var temp_c : Number = Math.sqrt(temp_a * temp_a + temp_b * temp_b);
			var temp_angle : Number = Math.abs(Math.asin(temp_b / temp_c) * 180 / Math.PI);
			if (x2 > x1) {
				if (y2 > y1) {
					temp_angle = 360 - temp_angle;
				} else if (y2 < y1) {
				} else {
					temp_angle = 0;
				}
			} else if (x2 < x1) {
				if (y2 > y1) {
					temp_angle = 180 + temp_angle;
				} else if (y2 < y1) {
					temp_angle = 180 - temp_angle;
				} else {
					temp_angle = 180;
				}
			} else {
				if (y2 > y1) {
					temp_angle = 270;
				} else if (y2 < y1) {
					temp_angle = 90;
				} else {
					//temp_angle = null;
				}
			}
			return temp_angle;
		}
		
		
		/**
		 *计算2个角度的最小夹角
		 */
		public static function intersectionAngle(agl1 : Number,agl2 : Number) : Number {
			agl1 = reAngle(agl1);
			agl2 = reAngle(agl2);
			var aglDis : Number = Math.abs(agl2 - agl1);
			if (aglDis > 270) {
				aglDis = 360 - aglDis;
			}else if (aglDis > 180) {
				aglDis = 270 - aglDis;
			}else if (aglDis > 90) {
				aglDis = 180 - aglDis;
			}
			return aglDis;
		}
		
		
		/**
		 * 角度转换-限定在0-360之间
		 */
		public static function reAngle(angle : Number) : Number {
			var rst : Number = angle % 360;
			if (rst < 0) {
				rst += 360;
			}
			return rst;
		}
		
		
		/**
		 * 计算2点中点
		 */
		public static function centerCompute(x1 : Number,y1 : Number,x2 : Number,y2 : Number) : Point {
			var ctX : Number = x1 + (x2 - x1) / 2;
			var ctY : Number = y1 + (y2 - y1) / 2;
			return new Point(ctX, ctY);
		}
		
	}
}