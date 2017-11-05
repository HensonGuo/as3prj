package shake
{
	import flash.display.DisplayObject;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	/**
	 * ...
	 * @author wdc
	 */
	public class Shake 
	{
		private var mc:DisplayObject;
		private var ar:Array;
		private var _updateInterval:uint;
		private var ww:Number;
		
		public function Shake(mc:DisplayObject,ww:Number) 
		{
			this.ww = ww;
			this.mc = mc;
			ar = [];
		}
		public function start():void
		{
			
			for (var i:int = 0; i <4; i++) 
			{
				var item: Object = new Object();
				var sca:Number = Math.random() * 0.04;
				item.scale = sca + 1;
				var dir:int = 1;;
				//if (Math.random() > 0.5) 
				dir = -1;
				var ranglex:Number = ww * sca * dir;
				item.offsetX = ranglex;
				ar.push(item);
			}
			ar.push( { scale:1, offsetX:0 } );
			
			_updateInterval=setInterval(update, 50);
			
		}
		
		private function update():void 
		{
			if (ar.length == 0)
			{
				clearInterval(_updateInterval);
				return;
			}
			var item:Object = ar.shift();
			mc.scaleX = mc.scaleY = item.scale;
			mc.x = item.offsetX;
		}
		
	}

}