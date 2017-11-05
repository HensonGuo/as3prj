package display.gui
{
	import avmplus.getQualifiedClassName;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.core.FeathersControl;
	
	import flash.utils.Dictionary;

	public class UIReset
	{
		private static var _resetFunctionMap:Dictionary = new Dictionary();
		
		public function UIReset()
		{
			_resetFunctionMap["Button"] = buttonReset;
			_resetFunctionMap["List"] = listReset;
		}
		
		public static function reset(feather:FeathersControl):void
		{
			var aliasName:String = getQualifiedClassName(feather);
			var index:int = aliasName.lastIndexOf(":");
			var className:String = aliasName.substr(index);
			var func:Function = _resetFunctionMap[className];
			func.call(null, feather);
		}
		
		private static function buttonReset(button:Button):void
		{
		}
		
		private static function listReset(list:List):void
		{
		}
		
	}
}