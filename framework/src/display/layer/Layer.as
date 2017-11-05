package display.layer
{
	import display.BaseView;

	public class Layer extends BaseView
	{
		private var _type:String;
		private var _zIndex:int;
		
		public function Layer(type:String, zIndex:int)
		{
			super();
			_type = type;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get zIndex():int
		{
			return _zIndex;
		}
	}
}