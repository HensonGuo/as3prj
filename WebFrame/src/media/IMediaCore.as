package media
{
	import resource.interfaces.IDestory;

	public interface IMediaCore extends IDestory
	{
		function play():void;
		function pause():void;
		function resume():void;
		function stop():void;
		function seek(time:Number = 0):void;
		function seekPercent(percent:Number = 0):void;
	}
}