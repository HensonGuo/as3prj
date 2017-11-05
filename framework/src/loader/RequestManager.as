package loader
{
	
	
	import flash.system.LoaderContext;
	
	import loader.core.RequestBox;
	
	import resource.pools.Reuse;
	import resource.pools.ObjectPool;

	public class RequestManager
	{
		//最大执行个数
		private static const MAX_EXCUTE_COUNT:int = 4;
		//缓冲队列
		private var _cacheQuene:Vector.<RequestBox> = new Vector.<RequestBox>();
		//执行队列
		private var _excuteQuene:Vector.<RequestBox> = new Vector.<RequestBox>();
		//ID列表
		private var _idList:Vector.<int> = new Vector.<int>();
		
		public function RequestManager()
		{
			for (var i:int = 0; i < RequestManager.MAX_EXCUTE_COUNT; i++)
			{
				_idList.push(i);
			}
		}
		
		/**
		 * 创建一个请求
		 * @return 
		 */		
		public function createRequest(resType:String, url:String, completeCallback:Function , progressCallback:Function = null, faildCallback:Function = null, context:LoaderContext = null):RequestBox
		{
			return Reuse.create(RequestBox, resType, url, completeCallback, progressCallback, faildCallback, context);
		}
		
		/**
		 *添加一个请求 
		 * @param request
		 * @param isUnshift
		 */		
		public function addRequest(request:RequestBox, isUnshift:Boolean):void
		{
			if (isUnshift)
				_cacheQuene.unshift(request);
			else
				_cacheQuene.push(request);
		}
		
		/**
		 *执行一个请求 
		 * @return 
		 */		
		public function excuteOneRequest():RequestBox
		{
			if (_cacheQuene.length == 0)
				return null;
			if (isExcuteQueneFull)
				return null;
			var cacheReq:RequestBox = _cacheQuene.shift();
			var ID:int = _idList.shift();
			cacheReq.id = ID;
			_excuteQuene.push(cacheReq);
			return cacheReq;
		}
		
		/**
		 * 删除一个执行请求
		 */		
		public function deleteExcuteRequest(request:RequestBox):void
		{
			_idList.push(request.id);
			var index:int = _excuteQuene.indexOf(request);
			_excuteQuene.splice(index, 1);
		}
		
		/**
		 *是否执行项满了
		 * @return 
		 */		
		public function get isExcuteQueneFull():Boolean
		{
			return _excuteQuene.length >= MAX_EXCUTE_COUNT;
		}
		
		/**
		 *空余执行个数 
		 * @return 
		 */		
		public function get freeExcuteNum():int
		{
			return MAX_EXCUTE_COUNT - _excuteQuene.length;
		}
		
	}
}