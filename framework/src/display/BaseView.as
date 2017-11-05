package display
{
	import resource.interfaces.IDestory;
	import resource.pools.ObjectPool;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	import utils.DisposeUtil;
	
	/**
	 *starling render
	 * all view elements entends this 
	 * @author g7842
	 * 
	 */	
	public class BaseView extends Sprite implements IDestory
	{
		public function BaseView()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
		}
		
		private function onAddToStage(event:Event):void
		{
			onShow();
		}
		
		private function removeFromStage(event:Event):void
		{
			onHide();
		}
		
		protected function onHide():void
		{
		}
		
		protected function onShow():void
		{
		}
		
		public function get isHide():Boolean
		{
			return this.parent == null;
		}
		
		public function destory(isReuse:Boolean=true):void
		{
			//快速回收IDispose对象
			DisposeUtil.quickDispose(this);
			if (isReuse)
				ObjectPool.disposeObject(this);
			else
			{
				this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
				this.removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
				this.dispose();
			}
		}
		
	}
}