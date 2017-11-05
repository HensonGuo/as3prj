package resource.file
{
	public interface ITabfileObject
	{
		function getKey():String;
		function onReadLineComplete():void;
		function onReadAllComplete():void;
	}
}