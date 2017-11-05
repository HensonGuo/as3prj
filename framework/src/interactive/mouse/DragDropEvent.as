package interactive.mouse
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class DragDropEvent extends Event
	{
		public static const Start_Drag:String = "Start_Drag";
		public static const Start_Drop:String = "Start_Drop";
		public static const Start_Throw:String = "Start_Throw";
		
		public var dragItem:IDragDrop;
		public var dropItem:IDragDrop;
		
		public function DragDropEvent(type:String,dragItem:IDragDrop,dropItem:IDragDrop, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.dragItem = dragItem;
			this.dropItem = dropItem;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new DragDropEvent(this.type, this.dragItem, this.dropItem, this.bubbles, this.cancelable);
		}
	}
}