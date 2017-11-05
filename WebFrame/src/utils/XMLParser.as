package utils
{
	import flash.utils.Dictionary;

	public class XMLParser
	{
		public function XMLParser()
		{
			
		}
		/**
		 * 支持简单类型 一层XML 
		 * @param xml
		 * @param cls
		 * @return 
		 * 
		 */		
		public static function toClass( xml:XML ,cls:Class ):Object
		{
			//读取属性
			if( xml.hasSimpleContent() )
			{
				var obj:Object = new cls();
				var attlist:XMLList = xml.attributes();
				var str:String;
				for each(var xml:XML in attlist)
				{
					str = xml.name().toString();
					if( obj.hasOwnProperty( str ) )
					{
						obj[str] = xml.toString();
					}
				}
				return obj;
			}
			else
			{
				throw new Error(" not has SimpleContent");
			}
			return null;
		}		
		
		/**
		 * XML简单类型转换成 MAP 
		 * @param xml
		 * @param nodeName
		 * @param key
		 * @param cls
		 * @return 
		 * 
		 */		
		public static function toMap( xml:XML,nodeName:String,key:String ,cls:Class):Dictionary
		{
			var map:Dictionary = new Dictionary();
			var templist:XMLList = xml.elements(nodeName);
			var obj:Object;
			for each( var x:XML in templist )
			{
				obj = toClass(x,cls);
				map[ obj[key] ] = obj; 
			}
			return map;
		}
	}
}