package util
{
	/**
	 * @private
	 */
	public class PriorityQueueElement
	{
		public var obj:Object;
		public var priority:int;
		
		public function PriorityQueueElement(obj:Object, priority:int)
		{
			this.obj = obj;
			this.priority = priority;
		}

	}
}