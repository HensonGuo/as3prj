package util
{
	/**
	 * @private
	 */
	public class PriorityQueueDsc2
	{
		public function PriorityQueueDsc2()
		{
			list_ = [];
		}
		
		
		public function insert(obj:Object, priority:int):void
		{
			var l:int = list_.length;
			
			for(var i:int = 0; i < l; i++){
				var e:PriorityQueueElement = list_[i];
				if(priority >= e.priority){
					list_.splice(i, 0, new PriorityQueueElement(obj, priority));
					break;
				}
			}
			if(i == l){
				list_.push(new PriorityQueueElement(obj, priority));
			}
		}
		
		
		public function pop():Array
		{
			var e:PriorityQueueElement = list_.pop();
			return [e.obj, e.priority];
		}
		
		
		private var list_:Array /* of PriorityQueueElement */;

	}
}