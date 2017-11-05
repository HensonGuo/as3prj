package display.richtext.tlftextfield
{
	import flash.utils.Dictionary;
	
	import utils.debug.LogUtil;
	
	public class RichTextCoder
	{
		public static const TYPE_TEXT:int = 1;
		public static const TYPE_SWF:int = 2;
		public static const TYPE_LINKTEXT:int = 3;
		public static var formatRegExp:RegExp = /\[[1-3]{1}[:]([^\]])*\]/g;
		
		public static var escapeMap:Dictionary = new Dictionary();
		escapeMap["<"] = "&lt";
		escapeMap[">"] = "&gt";
			
		private static var _coder:RichTextCoder = null;

		public function RichTextCoder()
		{
		}
		
		public static function bind(coderClass:Class):void
		{
			_coder = new coderClass();
			LogUtil.assert(_coder != null);
		}
		
		public static function get coder():RichTextCoder
		{
			if (!_coder)
				_coder = new RichTextCoder();
			
			return _coder;
		}
		
		public function encode(type:int, ...args):String
		{
			switch (type)
			{
				case TYPE_TEXT:
					return args[0];
				case TYPE_SWF:
//					url,width,height
					return "[" + type + ":" + args[0] + "," + args[1] + "," + args[2] + "]";
				case TYPE_LINKTEXT:
//					href,color,text
					return "[" + type + ":" + args[0] + "," + args[1] + "," + args[2] + "]";
				default:
					LogUtil.assert(false, "unknow type " + type);
					return "";
			}
		}
		
		public function decode(textCode:String, handler:Function):void
		{
			var textCodeList:Array = textCode.match(formatRegExp);
			var textCodeListLength:int = textCodeList.length;
			if (textCodeListLength == 0)
				handler.call(null, RichTextCoder.TYPE_TEXT, textCode);
			else
			{
				var lastIndex:int = 0;
				for (var i:int = 0; i < textCodeListLength; i++)
				{
					var code:String = textCodeList[i];
					var currentIndex:int = textCode.indexOf(code, lastIndex);
					if (currentIndex != lastIndex)
					{
						var text:String = textCode.substring(lastIndex, currentIndex);
						handler.call(null, RichTextCoder.TYPE_TEXT, text);
						lastIndex = currentIndex;
					}
					var type:String = code.charAt(1);
					var paramString:String = code.substring(3, code.length - 1);
					var paramList:Array = paramString.split(",");
					paramList.unshift(type);
					handler.apply(null, paramList);
					lastIndex += code.length;
				}
				if (lastIndex != textCode.length)
				{
					var lastText:String = textCode.substring(lastIndex);
					handler.call(null, RichTextCoder.TYPE_TEXT, lastText);
				}
			}
		}
		
		public static function text2Escape(text:String):String
		{
			for (var key:String in escapeMap)
			{
				var regExp:RegExp = new RegExp(key, "g");
				text = text.replace(regExp, escapeMap[key]);
			}
			return text;
		}
		
		public static function escape2Text(text:String):String
		{
			for (var key:String in escapeMap)
			{
				var regExp:RegExp = new RegExp(escapeMap[key], "g");
				text = text.replace(regExp, key);
			}
			return text;
		}
	}
}