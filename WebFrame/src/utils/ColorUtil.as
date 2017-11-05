package utils
{
	import flash.errors.IllegalOperationError;
	import flash.geom.ColorTransform;

	public class ColorUtil
	{
		public function ColorUtil()
		{
			throw new IllegalOperationError("Error #2012: ColorUtil class cannot be instantiated.");
		}
		
		public static function convertHtmlColor(value:uint):String
		{
			return "#" + value;
		}
		
		public static function convertToUintColor(str:String):uint
		{
			return parseInt(str.split("#")[1], 16);
		}
		
		public static function hsv(h:int, s:Number, v:Number):uint
		{
			return rgb.apply( null, HSVtoRGB(h, s, v));
		}
		
		public static function rgb(r:uint, g:uint, b:uint):uint
		{
			return r << 16 | g << 8 | b;
		}
		
		public static function HSVtoRGB( h:Number, s:Number, v:Number ):Array
		{
			var r:Number=0, g:Number=0, b:Number=0;
			var i:Number, x:Number, y:Number, z:Number;
			if(s<0) s=0; if(s>1) s=1; if(v<0) v=0; if(v>1) v=1;
			h = h % 360; if (h < 0) h += 360; h /= 60;
			i = h >> 0;
			x = v * (1 - s); y = v * (1 - s * (h - i)); z = v * (1 - s * (1 - h + i));
			switch(i){
				case 0 : r=v; g=z; b=x; break;
				case 1 : r=y; g=v; b=x; break;
				case 2 : r=x; g=v; b=z; break;
				case 3 : r=x; g=y; b=v; break;
				case 4 : r=z; g=x; b=v; break;
				case 5 : r=v; g=x; b=y; break;
			}
			return [ r*255>>0, g*255>>0, b*255>>0 ];
		}
		
		public static function RGBtoHSV( r:Number, g:Number, b:Number ):Array
		{
			r/=255; g/=255; b/=255;
			var h:Number=0, s:Number=0, v:Number=0;
			var x:Number, y:Number;
			if(r>=g) x=r; else x=g; if(b>x) x=b;
			if(r<=g) y=r; else y=g; if(b<y) y=b;
			v=x; 
			var c:Number=x-y;
			if(x==0) s=0; else s=c/x;
			if(s!=0){
				if(r==x){
					h=(g-b)/c;
				} else {
					if(g==x){
						h=2+(b-r)/c;
					} else {
						if(b==x){
							h=4+(r-g)/c;
						}
					}
				}
				h=h*60;
				if(h<0) h=h+360;
			}
			return [ h, s, v ];
		}
		
		public static function toRGB( rgb:uint ):Array
		{
			var r:uint = rgb >> 16 & 0xFF;
			var g:uint = rgb >> 8  & 0xFF;
			var b:uint = rgb       & 0xFF;
			return [r,g,b];
		}
		
		public static function max( col1:uint , col2:uint ):uint
		{
			var c1:Array = toRGB( col1 );
			var c2:Array = toRGB( col2 );
			var r:uint = Math.max( c1[0] , c2[0] );
			var g:uint = Math.max( c1[1] , c2[1] );
			var b:uint = Math.max( c1[2] , c2[2] );
			return r << 16 | g << 8 | b;
		}
		
		public static function min( col1:uint , col2:uint ):uint
		{
			var c1:Array = toRGB( col1 );
			var c2:Array = toRGB( col2 );
			var r:uint = Math.min( c1[0] , c2[0] );
			var g:uint = Math.min( c1[1] , c2[1] );
			var b:uint = Math.min( c1[2] , c2[2] );
			return r << 16 | g << 8 | b;
		}
		
		public static function sub( col1:uint , col2:uint ):uint
		{
			var c1:Array = toRGB( col1 );
			var c2:Array = toRGB( col2 );
			var r:uint = Math.max( c1[0]-c2[0] , 0 );
			var g:uint = Math.max( c1[1]-c2[1] , 0 );
			var b:uint = Math.max( c1[2]-c2[2] , 0 );
			return r << 16 | g << 8 | b;
		}
		
		public static function sum( col1:uint , col2:uint ):uint
		{
			var c1:Array = toRGB( col1 );
			var c2:Array = toRGB( col2 );
			var r:uint = Math.min( c1[0]+c2[0] , 255 );
			var g:uint = Math.min( c1[1]+c2[1] , 255 );
			var b:uint = Math.min( c1[2]+c2[2] , 255 );
			return r << 16 | g << 8 | b;
		}
		
		public static function subtract( col1:uint , col2:uint ):uint
		{
			var colA:Array = toRGB( col1 );
			var colB:Array = toRGB( col2 );
			var r:uint = Math.max( Math.max( colB[0]-(256-colA[0]) , colA[0]-(256-colB[0]) ) , 0 );
			var g:uint = Math.max( Math.max( colB[1]-(256-colA[1]) , colA[1]-(256-colB[1]) ) , 0 );
			var b:uint = Math.max( Math.max( colB[2]-(256-colA[2]) , colA[2]-(256-colB[2]) ) , 0 );
			return r << 16 | g << 8 | b;
		}
		
		public static function colorTransform( rgb:uint=0, amount:Number=1.0, alpha:Number=1.0 ):ColorTransform
		{
			amount = ( amount > 1 ) ? 1 : ( amount < 0 ) ? 0 : amount;
			alpha  = ( alpha  > 1 ) ? 1 : ( alpha  < 0 ) ? 0 : alpha;
			var r:Number = ( ( rgb >> 16 ) & 0xff ) * amount;
			var g:Number = ( ( rgb >> 8  ) & 0xff ) * amount;
			var b:Number = (   rgb         & 0xff ) * amount;
			var a:Number = 1-amount;
			return new ColorTransform( a, a, a, alpha, r , g , b, 0 );
		}
		
	}
}