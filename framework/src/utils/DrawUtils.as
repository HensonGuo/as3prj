package utils
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class DrawUtils
	{
		public function DrawUtils()
		{
		}
		/**
		 * 画格子
		 * @param sp 
		 * @param rowWidht 一个格子的宽
		 * @param colHeight  一个格子的高
		 * @param rowTotal 横向总长度
		 * @param colTotal 纵向总长度
		 * */
		public static function drawBlock(sp:Sprite,rowWidth:int,colHeight:int,rowTotal:int,colTotal:int,arr:Array=null):void
		{
			sp.graphics.lineStyle(1,0,0);
			var hh:int=Math.ceil(colTotal/colHeight);
			var ww:int=Math.ceil(rowTotal/rowWidth);
			for(var i:int=0;i<hh;i++)
			{
				sp.graphics.moveTo(0,i*colHeight)
				sp.graphics.lineTo(rowTotal,i*colHeight)
					if(arr)arr[i]=[]
				for(var j:int=0;j<ww;j++)
				{
					sp.graphics.moveTo(j*rowWidth,0)
					sp.graphics.lineTo(j*rowWidth,colTotal);
					if(arr)arr[i][j]=[];
				}
			}
		}
		
		public static  function drawBg(sp:Sprite, width:Number, height:Number, color:uint = 0,alpha:Number=1 ):void
		{
			sp.graphics.clear()
			sp.graphics.lineStyle(1);
			sp.graphics.beginFill(color, alpha)
			sp.graphics.drawRect(0,0,width,height)
			
			sp.graphics.endFill()
		}
		
		public static function drawCircle(sp:Sprite, radius:Number,  color:uint = 0,alpha:Number=1 ):void
		{
			sp.graphics.clear();
			sp.graphics.beginFill(color, alpha);
			sp.graphics.drawCircle(0, 0, radius);
			sp.graphics.endFill();
		}
	}
}