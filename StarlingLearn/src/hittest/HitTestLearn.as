package hittest
{
	/**
	 * 材质可由BitmapData来生成，因此我们可用BitmapData对象提供的hitTest这个API来做到像素级碰撞检测。
	 * 
	 * public function hitTest(firstPoint:Point, firstAlphaThreshold:uint, 
	 * secondObject:Object, secondBitmapDataPoint:Point = null, secondAlphaThreshold:uint = 1):Boolean
	 * 
	 * 注意此方法中的secondObject参数可以接受一个Point、Rectangle或BitmapData类型的对象，这让此方法的应用范围又广了不少
	 * 
	 */	
	public class HitTestLearn
	{
		public function HitTestLearn()
		{
		}
		
		/**
		 *第一组两个，即第一、二个参数表示了检测源的左上角坐标及其允许的最小检测透明度，这里设置为255，即完全不透明 
		 */		
		private function test1():void
		{
			if ( sausageBitmapData1.hitTest(
				new Point(sausageImage1.x, sausageImage1.y), 
				255, 
				sausageBitmapData2, 
				new Point(sausageImage2.x, sausageImage2.y), 
				255))
			{
				trace ("touched!") 
			}
		}
		
	}
}