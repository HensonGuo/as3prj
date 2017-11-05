package config
{
	import utils.ColorUtil;

	public class GlobalIni extends IniFileInfo
	{
		public function GlobalIni(url:String, callBack:Function)
		{
			super(url, callBack);
		}
		
		public function get bgUrl():String
		{
			return _iniFile.getString("BG", "bgUrl");
		}
		
		public function get bgColor():uint
		{
			return ColorUtil.convertToUintColor(_iniFile.getString("BG", "bgColor"));
		}
		
		public function get bgAlpha():Number
		{
			return _iniFile.getNumber("BG", "bgAlpha");
		}
		
		public function get bgScaleMode():String
		{
			return _iniFile.getString("BG", "bgScaleMode");
		}
		
		public function get menuResUrl():String
		{
			return _iniFile.getString("MENU", "resUrl");
		}
		
		public function get menuLocate():String
		{
			return _iniFile.getString("MENU", "locate");
		}
		
		public function get menuOffsetX():String
		{
			return _iniFile.getString("MENU", "offsetX");
		}
		
		public function get menuOffsetY():String
		{
			return _iniFile.getString("MENU", "offsetY");
		}
	}
}