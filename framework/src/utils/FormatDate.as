package utils
{
	public class FormatDate
	{
		public function FormatDate()
		{
		}
		
		public static function formatTime(time:Date):String
		{
			var text:String = getNumber(time.fullYear, 4);
			text += getNumber(time.month, 2);
			text += getNumber(time.date, 2);
			text += "-";
			text += getNumber(time.hours, 2);
			text += getNumber(time.minutes, 2);
			text += getNumber(time.seconds, 2);
			
			return text; 
		}
		
		private static function getNumber(value:Number, length:int):String
		{
			var perfix:String = "00000000";
			var text:String = value.toString();
			if (length > text.length) {
				text = perfix.substr(0, length - text.length) + text;
			}
			return text;
		}
	}
}