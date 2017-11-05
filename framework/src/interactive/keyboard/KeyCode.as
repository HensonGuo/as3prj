package interactive.keyboard
{
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	public class KeyCode
	{
		
		public static const N0:uint = 48;
		public static const N1:uint = 49;
		public static const N2:uint = 50;
		public static const N3:uint = 51;
		public static const N4:uint = 52;
		public static const N5:uint = 53;
		public static const N6:uint = 54;
		public static const N7:uint = 55;
		public static const N8:uint = 56;
		public static const N9:uint = 57;
		
		public static const A:uint = 65;
		public static const B:uint = 66;
		public static const C:uint = 67;
		public static const D:uint = 68;
		public static const E:uint = 69;
		public static const F:uint = 70;
		public static const G:uint = 71;
		public static const H:uint = 72;
		public static const I:uint = 73;
		public static const J:uint = 74;
		public static const K:uint = 75;
		public static const L:uint = 76;
		public static const M:uint = 77;
		public static const N:uint = 78;
		public static const O:uint = 79;
		public static const P:uint = 80;
		public static const Q:uint = 81;
		public static const R:uint = 82;
		public static const S:uint = 83;
		public static const T:uint = 84;
		public static const U:uint = 85;
		public static const V:uint = 86;
		public static const W:uint = 87;
		public static const X:uint = 88;
		public static const Y:uint = 89;
		public static const Z:uint = 90;
		
		public static const BackSpace:uint = 8;
		
		public static const SPACE:uint = 32;
		public static const ENTER:uint = 13;
		public static const ESCAPE:uint = 27;
		public static const CONTROL:uint = 17;		
		public static const SHIFT:uint = 16;	
		
		public static const LEFT:uint = 37; 
		public static const UP:uint = 38;
		public static const RIGHT:uint = 39;	
		public static const DOWN:uint = 40;
		
		public static const F1:uint = 112;
		public static const F2:uint = 113;
		public static const F3:uint = 114;
		public static const F4:uint = 115;
		public static const F5:uint = 116;
		public static const F6:uint = 117;
		public static const F7:uint = 118;
		public static const F8:uint = 119;
		public static const F9:uint = 120;
		public static const F10:uint = 121;
		public static const F11:uint = 122;
		public static const F12:uint = 123;
		
		public static const TAB:uint = 9;
		
		
		public static const CTRL:uint = 100000;
		
		public static const SHIFT_NUM:uint = 1000000;
		
		private static var _keyNameMap:Dictionary;
		
		
		
		public function KeyCode()
		{
			
		}
		
		public static function getKeyName( keyCode:uint ):String
		{
			initKeyName();
			return _keyNameMap[keyCode];
		}
		
		private static function initKeyName():void
		{
			if(_keyNameMap == null  )
			{
				_keyNameMap = new Dictionary();
				
				_keyNameMap[48] = "0";
				_keyNameMap[49] = "1";
				_keyNameMap[50] = "2";
				_keyNameMap[51] = "3";
				_keyNameMap[52] = "4";
				_keyNameMap[53] = "5";
				_keyNameMap[54] = "6";
				_keyNameMap[55] = "7";
				_keyNameMap[56] = "8";
				_keyNameMap[57] = "9";
				
				_keyNameMap[65] = "A";
				_keyNameMap[66] = "B";
				_keyNameMap[67] = "C";
				_keyNameMap[68] = "D";
				_keyNameMap[69] = "E";
				_keyNameMap[70] = "F";
				_keyNameMap[71] = "G";
				_keyNameMap[72] = "H";
				_keyNameMap[73] = "I";
				_keyNameMap[74] = "J";
				_keyNameMap[75] = "K";
				_keyNameMap[76] = "L";
				_keyNameMap[77] = "M";
				_keyNameMap[78] = "N";
				_keyNameMap[79] = "O";
				_keyNameMap[80] = "P";
				_keyNameMap[81] = "Q";
				_keyNameMap[82] = "R";
				_keyNameMap[83] = "S";
				_keyNameMap[84] = "T";
				_keyNameMap[85] = "U";
				_keyNameMap[86] = "V";
				_keyNameMap[87] = "W";
				_keyNameMap[88] = "X";
				_keyNameMap[89] = "Y";
				_keyNameMap[90] = "Z";
				
				_keyNameMap[8] = "backSpace";
				_keyNameMap[32] = "space";
				_keyNameMap[13] = "enter";
				_keyNameMap[27] = "esc";
				_keyNameMap[17] = "ctrl";		
				_keyNameMap[16] = "shift";	
				
				_keyNameMap[37] = "LEFT"; 
				_keyNameMap[38] = "UP";
				_keyNameMap[39] = "RIGHT";	
				_keyNameMap[40] = "DOWN";
				
				_keyNameMap[112] = "F1";
				_keyNameMap[113] = "F2";
				_keyNameMap[114] = "F3";
				_keyNameMap[115] = "F4";
				_keyNameMap[116] = "F5";
				_keyNameMap[117] = "F6";
				_keyNameMap[118] = "F7";
				_keyNameMap[119] = "F8";
				_keyNameMap[120] = "F9";
				_keyNameMap[121] = "F10";
				_keyNameMap[122] = "F11";
				_keyNameMap[123] = "F12";
				
				_keyNameMap[9] = "tab";
				
				
//				_keyNameMap[100000] = "CTRL";
				
//				_keyNameMap[1000000] = "SHIFT_NUM";
			}
		}
	}
}