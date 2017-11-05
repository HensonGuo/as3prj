package loader.core
{
	import flash.display.Loader;
	
	import resource.interfaces.IDestory;
	import resource.pools.ObjectPool;
	
	public class ReuseLoader extends Loader implements IDestory
	{
		public function ReuseLoader()
		{
			super();
		}
		
		public function destory(isReuse:Boolean=true):void
		{
			this.unload();
			if (isReuse)
				ObjectPool.disposeObject(this);
		}
	}
}