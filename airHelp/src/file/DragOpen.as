package file 
{
	import flash.desktop.NativeDragManager;
	import flash.display.InteractiveObject;
	import flash.events.NativeDragEvent;
	/**
	 * ...
	 * @author lizhi
	 */
	public class DragOpen 
	{
		private var doFileFun:Function;
		private var target:InteractiveObject;
		
		public function DragOpen(target:InteractiveObject,doFileFun:Function) 
		{
			this.target = target;
			this.doFileFun = doFileFun;
			addDragOpen();
		}
		
		private function addDragOpen():void 
		{
			target.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, nativeDragEnterHandler);
			target.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, nativeDragDropHandler);
		}
		
		private function nativeDragEnterHandler(e:NativeDragEvent):void {
			NativeDragManager.acceptDragDrop(target);
			
		}

		private function nativeDragDropHandler(e:NativeDragEvent):void {
			var data:Array=e.clipboard.formats;
			for each(var type:String in data){
				doFileFun(e.clipboard.getData(type));
			}
		}
		
	}

}