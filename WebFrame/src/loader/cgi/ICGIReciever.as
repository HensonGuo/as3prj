package loader.cgi
{
	public interface ICGIReciever
	{
		function onReciever(url:String, data:Object):void
	}
}