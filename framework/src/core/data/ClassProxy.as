package core.data
{
	public class ClassProxy
	{
		public function ClassProxy()
		{
			
		}
		
		/**
		 * 写入对象 
		 * @param object
		 * 
		 */		
		public function write( object:Object ):void
		{
			for( var key:* in object  )
			{
				if( this.hasOwnProperty( key ) )
				{
					this[key] = object[key];
				}
			}
		}
	}
}