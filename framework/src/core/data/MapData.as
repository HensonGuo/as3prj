/**
 *  轻量级的数据存储结构
 *  如果扩展，请继承重载
 */  
package core.data
{
	import flash.utils.Dictionary;

	public class MapData
	{
		private var _dataMap:Dictionary = new Dictionary(true);
		
		public function MapData()
		{
		}
		
		/**
		 *  存储数据
		 * @param key 键值
		 * @param data 数据
		 */
		public function save(key:String, data:*):void
		{
			_dataMap[key] = data;
		}
		
		/**
		 *  删除数据
		 *  @param key 键值
		 */
		public function remove(key:String):void
		{
			_dataMap[key] = null;
			delete _dataMap[key];
		}
		
		
		/**
		 *  获取数据
		 *  @param attrib 成员属性
		 *  @param attribValue 成员属性值
		 *  @param isMapKey 是否是Map的键值
		 */
		public function get(attrib:String, attribValue:* = null, isMapKey:Boolean = true):*
		{
			if (isMapKey)
			{
				return _dataMap[attrib];
			}
			
			if ( !(attribValue is int) && !(attribValue is String)
			&& !(attribValue is Boolean) && !(attribValue is Number) && !(attribValue is uint))
			{
				throw new Error("判断的属性值只能是基本数据类型，3Q！");
			}
			//搜索Map
			for each(var ndata:* in _dataMap)
			{
				if ((ndata as Object).hasOwnProperty(attrib))
				{
					if (ndata[attrib] == attribValue)
						return ndata;
				}
			}
			return null;
		}
		
		/**
		 *  遍历数据
		 *  @param callback 回调函数
		 */
		public function every(callback:Function):void
		{
			if (callback == null)
				return;
			for (var key:String in _dataMap)
			{
				callback.call(null, _dataMap[key]);
			}
		}
		
		/**
		 *  清除数据
		 */
		public function clear():void
		{
			_dataMap = new Dictionary(true);
		}
	}
}