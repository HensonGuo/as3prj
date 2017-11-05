package interactive.mouse
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	
	import greensock.TweenMax;
	import greensock.easing.Quint;
	
	import utils.trigger.Dispatcher;

	public class DragDropManager
	{
		public var _dragItem:IDragDrop;
		public var _dropItem:IDragDrop;
		
		private var _thumb:Sprite = new Sprite();
		private var _thumbOrgBounds:Rectangle;

		private var _layer:DisplayObjectContainer;
		
		public function DragDropManager()
		{
			_thumb.mouseEnabled=false;
			_thumb.mouseChildren=false;
		}
		
		public function setLayer(layer:DisplayObjectContainer):void
		{
			_layer = layer;
		}

		public function startDrag(itemDrag:IDragDrop):void
		{
			if (!itemDrag.isDragAble)
				return;
			
			var dragObject:DisplayObject=itemDrag as DisplayObject;
			var rect:Rectangle=dragObject.getBounds((itemDrag as DisplayObject).parent);
			var mouse_x:Number=dragObject.parent.mouseX;
			var mouse_y:Number=dragObject.parent.mouseY;
			//检测点击的位置是否在些物件上面
			if (mouse_x > rect.left && mouse_x < rect.right && 
				mouse_y > rect.top && mouse_y < rect.bottom)
			{
				//register event
				_dragItem=itemDrag;
				_thumbOrgBounds = rect;
				_dragItem.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseOnDragItem);
				_dragItem.addEventListener(MouseEvent.MOUSE_UP, handleMouseOnDragItem);
			}
		}
		
		private function handleMouseOnDragItem(e:MouseEvent):void
		{
			_dragItem.removeEventListener(MouseEvent.MOUSE_UP, handleMouseOnDragItem);
			_dragItem.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseOnDragItem);
			 
			if (e.type == MouseEvent.MOUSE_UP)
				return;
			var thumBitmap:Bitmap=new Bitmap(_dragItem.dragThumbData);
			_thumb.addChild(thumBitmap);
			_thumb.x=_layer.mouseX;
			_thumb.y=_layer.mouseY;
			_layer.addChild(_thumb);
			_thumb.startDrag();
			_thumb.stage.addEventListener(MouseEvent.MOUSE_UP, startDrop);
			
			Dispatcher.dispatchEvent(new DragDropEvent(DragDropEvent.Start_Drag, _dragItem, _dropItem, true));
		}
		
		private function startDrop(e:MouseEvent):void
		{
			_thumb.stage.removeEventListener(MouseEvent.MOUSE_UP, startDrop);
			_thumb.stopDrag();

			var vContainer:DisplayObject = getMainContainer(_thumb.dropTarget);
			if (vContainer is IDragDrop)
			{
				var dropTarget:IDragDrop = vContainer as IDragDrop;
				if (dropTarget.canDrop(_dragItem))
				{
					_dropItem=vContainer as IDragDrop;
					Dispatcher.dispatchEvent(new DragDropEvent(DragDropEvent.Start_Drop, _dragItem, _dropItem));
					destory();
				}
				else
				{
					recycle();
				}
			}
			else
			{
				if (!_dragItem.isThrowAble)
				{
					recycle();
				}
				else
				{
					destory();
					Dispatcher.dispatchEvent(new DragDropEvent(DragDropEvent.Start_Throw, _dragItem, _dropItem, true));
				}
			}
		}

		private function recycle():void
		{
			if (_dragItem)
				TweenMax.to(_thumb, 0.2, {x: _thumbOrgBounds.left, y: _thumbOrgBounds.top, onComplete: destory, ease: Quint.easeOut});
			else
			{
				destory();
			}
		}

		private function destory():void
		{
			if (_layer.contains(_thumb))
				_layer.removeChild(_thumb);
			_thumb=null;
			_dragItem = null;
			_dropItem = null;
			_thumbOrgBounds = null;
		}

		private function getMainContainer(vItem:DisplayObject):DisplayObject
		{
			if (!vItem)
				return null;
			if (vItem is IDragDrop && (vItem as IDragDrop).isDropAble)
				return vItem;
			else if (vItem.parent is IDragDrop && (vItem.parent as IDragDrop).isDropAble)
				return vItem.parent;
			else if (vItem.parent == FrameWork.stage)
				return null;
			else
				return getMainContainer(vItem.parent);
		}
	}
}
