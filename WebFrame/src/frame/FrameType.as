package frame
{
	/**
	 * 帧监听对象类型
	 * @author guoyunlin
	 */	
	public class FrameType
	{
		/**
		 *渲染帧，保证画质的清晰
		 */		
		public static const Render:String = "Render";
		/**
		 *逻辑帧，逻辑的执行
		 */
		public static const Logic:String = "Logic";
		
		public function FrameType()
		{
		}
	}
}