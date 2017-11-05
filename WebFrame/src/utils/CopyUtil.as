package utils
{
	import flash.utils.ByteArray;

	public class CopyUtil
	{
		public function CopyUtil()
		{
		}
		
		public static function clone(obj:Object):* {
			var copier:ByteArray = new ByteArray();
			copier.writeObject(obj);
			copier.position = 0;
			return copier.readObject();
		}
		
		/**
		 * 拷贝属性
		 */
		public static function copyProperties(orgData:Object, targetData:Object):void
		{
			for( var key:* in orgData  )
			{
				if( targetData.hasOwnProperty( key ) )
				{
					targetData[key] = orgData[key];
				}
			}
		}
		
	}
}