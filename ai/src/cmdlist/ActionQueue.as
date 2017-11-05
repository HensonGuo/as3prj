package cmdlist
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * 登録されたアクションを連続して呼び出していくクラス。
	 * イベントも登録した場合、イベント終了後に次のアクションを実行する
	 * 
	 * @param thisObj 関数でthisとして使われるオブジェクト
	 * @param func 関数の参照
	 * @param params パラメーターを配列で
	 * @param completeEventDispatcher この処理の終了イベントを出すオブジェクト
	 * @param completeEventName この処理の終了イベント名
	 * 
	 * var aq : actionQueue = new ActionQueue();
	 * aq.addAction( this, myFunc );
	 * aq.addAction( this, myFunc2, [0,2], this, Event.COMPLETE );
	 * aq.execute();
	 */
	public class ActionQueue extends EventDispatcher
	{
		protected var actions : Array
		protected var _index : Number = 0;
		public var onComplete : Function;
		
		public function ActionQueue():void
		{
			actions = [];
		}
		
		
		
		public function addAction( thisObj : Object, func : Function, params: Array = null , completeEventDispatcher : Object = null, completeEventName : String= null ) : void
		{
			actions.push({
				thisObj : thisObj,
				func : func,
				completeEventDispatcher : completeEventDispatcher || thisObj,
				completeEventName : completeEventName,
				params : params
			})
		}
		
		
		//アクションの進行具合を0-100からで表す
		public function get progress():Number
		{
			return (actions.length>0)? _index / actions.length * 100 : 0;
		}
		
		
		//アクションを途中でキャンセルする。
		//この場合どうするのがいいのかね？
		public function cancel() : void
		{
			throw new Error("ActionQueue.cancel is not implemented yet");
		}
		
		
		
		public function execute() : void
		{
			doNext();
		}
		
		
		public function get index():int
		{
			return _index;
		}
		
		public function get length():int
		{
			return actions.length;
		}
		
		
		protected function doNext() : void
		{
			var act : Object = actions[ _index ];
			
			if( act.completeEventName ){
				act.completeEventDispatcher.addEventListener(act.completeEventName, _actionComplete, false, 0, true);			
				act.func.apply( act.thisObj, act.params );
			} else {
				act.func.apply( act.thisObj, act.params );
				doNext2();
			}
		}
		
		
		
		protected function doNext2() : void
		{
			var act : Object = actions[ _index ];
			
			if( act.completeEventName )
				act.completeEventDispatcher.removeEventListener(act.completeEventName, _actionComplete);
			
			_index ++;
			
			if( _index == actions.length )
			{
				actions = [];	//remove all registerd action for GC
				if( onComplete != null )
					onComplete();
				dispatchEvent( new Event(Event.COMPLETE) );	
			}else{
				doNext();
			}
		}
		
		
		
		protected function _actionComplete( e : Event ) : void
		{
			doNext2();
		}
	}
}