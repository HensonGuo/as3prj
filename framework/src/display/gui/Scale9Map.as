package display.gui
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class Scale9Map
	{
		private const _ScatteredKey:String = "Scattered";
		private var _map:Dictionary;
		
		public function Scale9Map()
		{
			_map = new Dictionary(true);
			_map[_ScatteredKey] = new Dictionary(true);
		}
		
		public function register(parentKey:String, subKey:String, rect:Rectangle):void
		{
			if (parentKey == "" || parentKey == null)
				_map[_ScatteredKey][subKey] = rect;
			else
			{
				if (_map[parentKey] == null)
					_map[parentKey] = new Dictionary(true);
				_map[parentKey][subKey] = rect;
			}
		}
		
		public function hasRegister(parentKey:String, subKey:String):Boolean
		{
			if (parentKey == "" || parentKey == null)
				return _map[_ScatteredKey][subKey] != null;
			return _map[parentKey][subKey]  != null;
		}
		
		public function getScaleRectangle(parentKey:String, subKey:String):Rectangle
		{
			if (parentKey == "" || parentKey == null)
				return _map[_ScatteredKey][subKey];
			return _map[parentKey][subKey];
		}
		
	}
}