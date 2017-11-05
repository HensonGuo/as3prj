package jsfl {
	import adobe.utils.MMExecute;
	
	public class JSFL {
		
		//エスケープするべき文字などをJSFL用の文字に変換
		public static  function stringReplace(param:*):String {
			var str:String = String(param);
			str = str.replace(/\n/g,"\\n");
			str = str.replace(/\r/g,"\\r");
			str = str.replace(/\t/g,"\\t");
			str = str.replace(/\f/g,"\\n");
			//str = str.replace(/\b/g,"\\b");
			//str = str.replace(/\\/g,"\\\\");
			str = str.replace(/(['"|])/g,"\\$1");
			return str;
		}
		
		public static function trace(param:*):void {
			var str:String = stringReplace(param);
			MMExecute('fl.trace("' + str + '")');
		}
		
		public static function alert(param:*):void {
			var str:String = stringReplace(param);
			MMExecute('alert("' + str + '")');
		}
		

	}
}