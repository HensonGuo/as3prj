package effect
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import resource.pools.Reuse;
	
	import utils.OptimizeUtil;
	
	public class EffectObj extends Reuse
	{
		protected var _entity:DisplayObject;
		
		public function EffectObj()
		{
			super();
			constructEntity();
			OptimizeUtil.optimizeRender(_entity);
		}
		
		/**
		 *构建实体对象 
		 */		
		protected function constructEntity():void
		{
			_entity = new DisplayObject();
		}
		
		/**
		 *显示 
		 * @param parent
		 * 
		 */		
		public function show(parent:DisplayObjectContainer, isHigh:Boolean = false):void
		{
			if (isHigh)
				parent.addChildAt(_entity, 0);
			else
				parent.addChild(_entity);
		}
		
		/**
		 *隐藏 
		 */		
		public function hide():void
		{
			if (_entity.parent)
				_entity.parent.removeChild(_entity);
		}
		
		override protected function reset():void
		{
			hide();
		}
		
		public function set x(value:Number):void
		{
			_entity.x = value;
		}
		
		public function set y(value:Number):void
		{
			_entity.y = value;
		}
		
	}
}