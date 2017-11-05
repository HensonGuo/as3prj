package config
{
	import resource.file.ITabfileObject;
	
	public class NavigationTab implements ITabfileObject
	{
		public var ID:int;
		public var Name:String;
		
		public function NavigationTab()
		{
		}
		
		public function getKey():String
		{
			return ID.toString();
		}
		
		public function onReadLineComplete():void
		{
		}
		
		public function onReadAllComplete():void
		{
		}
	}
}