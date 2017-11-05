package utils
{
	import display.gui.UIReset;
	
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	
	import resource.interfaces.IDestory;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;

	public class DisposeUtil
	{
		public function DisposeUtil()
		{
		}
		
		public static function quickDispose(obj:IDestory):void
		{
			if (obj is DisplayObjectContainer)
			{
				var container:DisplayObjectContainer = obj as DisplayObjectContainer;
				var targetIndex:int = 0;
				while(container.numChildren > 0)
				{
					if (targetIndex >= container.numChildren)
						break;
					var child:DisplayObject = container.getChildAt(targetIndex);
					if (child is IDestory)
					{
						//回收IDestory的显示对象
						(child as IDestory).destory();
						container.removeChild(child);
						child = null;
					}
					else if (child is FeathersControl ||
					child is Scale9Image ||
					child is Image)
						container.removeChild(child);
					else
						targetIndex ++;
				}
			}
			else
				obj.destory();
		}
		
	}
}