package resource.pools
{
	
	import flash.errors.IllegalOperationError;
	

	/**
	 * 图片、影片剪辑、Loader等对象的重用
	 * 重用对象通过外部调用dispose方法处理
	 * 只能通过create方法创建
	 * @author g7842
	 */	
	public class Reuse
	{
		private static var _instantiatedByCreateFunc:Boolean = false;
		private var _isNewObj:Boolean = true;
		
		public function Reuse()
		{
			if (!_instantiatedByCreateFunc)
				throw new IllegalOperationError("Error #2012: 重用类不能直接被实例化，请通过Reuse.Create()创建");
		}
		
		/**
		 * 创建
		 * @param cls
		 */		
		public static function create(type:Class, ...parameters):*
		{
			_instantiatedByCreateFunc = true;
			parameters.unshift(type)
			var obj:Reuse = ObjectPool.getObject.apply(null, parameters) as Reuse;
			if (!obj._isNewObj)
			{
				parameters.shift();
				obj.setInitParams.apply(null, parameters);
			}
			_instantiatedByCreateFunc = false;
			return obj;
		}
		
		protected function setInitParams(...parameters):void
		{
			
		}
		
		/**
		 * 重置
		 */		
		protected function reset():void
		{
		}
		
		/**
		 * 销毁 
		 */		
		final public function destory():void
		{
			reset();
			ObjectPool.disposeObject(this);
			_isNewObj = false;
		}
		
	}
}