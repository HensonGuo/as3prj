//class LocalStorage
package utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	/**
	 *本地存储 
	 * @author g7842
	 * 
	 */	
	public class LocalStorage
	{
		public function LocalStorage()
		{
			super();
		}
		
		public function write(id:String, key:String, value:*):Boolean
		{
			var id:String;
			var key:String;
			var value:*;
			var isWriteOK:Boolean;
			var so:SharedObject;
			var result:String;
			
			var loc1:*;
			so = null;
			result = null;
			id = id;
			key = key;
			value = value;
			isWriteOK = true;
			try 
			{
				so = SharedObject.getLocal(id);
				so.data[key] = value;
				result = so.flush();
				if (result == SharedObjectFlushStatus.PENDING) 
				{
					isWriteOK = false;
				}
			}
			catch (e:Error)
			{
				isWriteOK = false;
			}
			return isWriteOK;
		}
		
		public function read(arg1:String, arg2:String):*
		{
			var id:String;
			var key:String;
			var value:*;
			var so:flash.net.SharedObject;
			
			var loc1:*;
			value = undefined;
			so = null;
			id = arg1;
			key = arg2;
			try 
			{
				so = flash.net.SharedObject.getLocal(id);
				value = so.data[key];
			}
			catch (e:Error)
			{
			};
			return value;
		}
		
		public function remove(arg1:String, arg2:String):Boolean
		{
			var id:String;
			var key:String;
			var isRemoveOK:Boolean;
			var so:flash.net.SharedObject;
			var result:String;
			
			var loc1:*;
			so = null;
			result = null;
			id = arg1;
			key = arg2;
			isRemoveOK = true;
			try 
			{
				so = SharedObject.getLocal(id);
				delete so.data[key];
				result = so.flush();
				if (result == SharedObjectFlushStatus.PENDING) 
				{
					isRemoveOK = false;
				}
			}
			catch (e:Error)
			{
				isRemoveOK = false;
			}
			return isRemoveOK;
		}
		
		public function clear(arg1:String):Boolean
		{
			var id:String;
			var isClearOK:Boolean;
			var so:SharedObject;
			
			var loc1:*;
			so = null;
			id = arg1;
			isClearOK = true;
			try 
			{
				so = SharedObject.getLocal(id);
				so.clear();
			}
			catch (e:Error)
			{
				isClearOK = false;
			}
			return isClearOK;
		}
	}
}


