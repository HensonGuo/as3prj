package core.data
{
	public class ArrayData
	{
		private var _arr:Array = new Array();
		
		public function ArrayData()
		{
		}
		
		public function save(data:*, isUnshift:Boolean = false):void
		{
			if (isUnshift)
			{
				_arr.unshift(data);
			}
			else
			{
				_arr.push(data);
			}
		}
		
		public function remove(index:int):void
		{
			_arr.splice(index, 1);
		}
		
		public function get(index:int):*
		{
			if (index >= _arr.length)
				return null;
			return _arr[index];
		}
		
		public function every(startIndex:int, endIndex:int, callback:Function):void
		{
			if (callback == null)
				return;
			for (var i:int = startIndex; i <= endIndex; i++)
			{
				var nData:Object = _arr[i];
				callback.call(null, nData);
			}
		}
		
		public function get length():uint
		{
			return _arr.length;
		}
		
		public function clear():void
		{
			_arr.length = 0;
		}
		
	}
}