package menu.base
{
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.MouseEvent;
	
	public class BaseMenu extends Sprite
	{
		private const _defaultItems:Array = [{label:"主页", click:null}, {label:"照片墙", click:null}, {label:"视频区", click:null}, {label:"祝福墙", click:null}, {label:"LoveShow", click:null}];
		private var _prevSelectedItem:MenuItem;
		protected var _data:Array;
		protected var _itemClass:Class
		
		public function BaseMenu(itemClass:Class, data:Array = null)
		{
			super();
			_itemClass = itemClass;
			if (data == null)
				_data = _defaultItems;
			construct();
		}
		
		private function construct():void
		{
			constructItems();
			configEventListener();
		}
		
		private function reContruct():void
		{
			while(this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
			constructItems();
		}
		
		/**
		 * 构建item项
		 * 负责item项的排列等 
		 */		
		protected function constructItems():void
		{
		}
		
		private function configEventListener():void
		{
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		private function unRegisterEventListener():void
		{
			this.removeEventListener(MouseEvent.CLICK, onMouseClick);
			this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		private function onMouseClick(event:MouseEvent):void
		{
			if (event.target is MenuItem)
			{
				var item:MenuItem = event.target as MenuItem;
				if (_prevSelectedItem == item)
					return;
				defaultSelectedItem = item;
				if (item.clickCallback != null)
					item.clickCallback.call(null);
			}
		}
		
		private function onMouseOver(event:MouseEvent):void
		{
			if (event.target is MenuItem)
			{
				var item:MenuItem = event.target as MenuItem;
				if (item.selected)
					return;
				item.showMouseOverState();
			}
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
			if (event.target is MenuItem)
			{
				var item:MenuItem = event.target as MenuItem;
				if (item.selected)
					return;
				item.showMouseUpState();
			}
		}
		
		/**
		 *数据 
		 * @param arr
		 * 
		 */		
		public function dataProvider(arr:Array):void
		{
			_data = arr;
			reContruct();
		}
		
		/**
		 *默认选择项 
		 * @param item
		 * 
		 */		
		public function set defaultSelectedItem(item:MenuItem):void
		{
			item.selected = true;
			if (_prevSelectedItem)
				_prevSelectedItem.selected = false;
			_prevSelectedItem = item;
		}
		
		/**
		 *销毁 
		 * 
		 */		
		public function dispose():void
		{
			while(this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
			_itemClass = null;
			_data = null;
			_prevSelectedItem = null;
			unRegisterEventListener();
		}
	}
}