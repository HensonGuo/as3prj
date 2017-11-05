package mapchipx {

	/**
	 * ...
	 * @author KAZUMiX
	 */
	public dynamic class ChipInfoArray extends Array {
		
		private var _chipWidth:uint;
		private var _chipHeight:uint;
		
		public function get chipWidth():uint {
			return _chipWidth;
		}
		
		public function get chipHeight():uint {
			return _chipHeight;
		}
		
		public function ChipInfoArray(chipWidth:uint, chipHeight:uint, ...args) {
			this._chipWidth = chipWidth;
			this._chipHeight = chipHeight;
			
			// http://livedocs.adobe.com/flex/3_jp/html/help.html?content=10_Lists_of_data_7.html
			// 以下↑そのまんま
			var n:uint=args.length;
			if (n == 1 && (args[0] is Number)) {
				var dlen:Number = args[0];
				var ulen:uint = dlen;
				if (ulen!=dlen) {
					throw new RangeError("Array index is not a 32-bit unsigned integer (" + dlen + ")");
				}
				length = ulen;
			} else {
				length = n;
				for (var i:int=0; i < n; i++) {
					this[i] = args[i];
				}
			}
		}
	}
}