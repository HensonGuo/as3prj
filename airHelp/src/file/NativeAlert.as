package file 
{
	import flash.html.HTMLLoader;
	/**
	 * ...
	 * @author lizhi
	 */
	public class NativeAlert 
	{
		private static var htmlloader:HTMLLoader = new HTMLLoader;
		public function NativeAlert() 
		{
			
		}
		
        public static function alert(message:String):void
        {
            htmlloader.window.alert(message);
        }
     
        public static function confirm(message:String):Boolean
        {
            return htmlloader.window.confirm(message);
        }
   
        public static function prompt(message:String,defaultVal:String=""):String
        {
            return htmlloader.window.prompt(message, defaultVal);
        }
	}

}