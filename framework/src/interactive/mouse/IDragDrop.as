package interactive.mouse
{
	import flash.display.BitmapData;
	import flash.events.IEventDispatcher;

	public interface IDragDrop extends IEventDispatcher
	{
		function get isDragAble():Boolean;
		function get isDropAble():Boolean;
		function get isThrowAble():Boolean;
		function get dragThumbData():BitmapData;
		function canDrop(drag:IDragDrop):Boolean;
	}
}