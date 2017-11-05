package 
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	public class ConfigSwf extends Sprite
	{
		private static var _ConfigMap:Dictionary = new Dictionary();
		
		[Embed(source="/../bin-debug/settings/menu.txt", mimeType = "application/octet-stream")]
		private static var navigation:Class;
		_ConfigMap["settings/navigation.txt"] = navigation;
		
		[Embed(source="/../bin-debug/settings/global.ini", mimeType = "application/octet-stream")]
		private static var global:Class;
		_ConfigMap["settings/global.ini"] = global;
		
		public function ConfigSwf()
		{
		}
		
		public static function getDefineClass(url:String):Class
		{
			return _ConfigMap[url]
		}
	}
}