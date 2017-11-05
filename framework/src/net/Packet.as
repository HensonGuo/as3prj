/**
 * var p:Packet=new Packet();
 * p.writeInt(40);
 * p.writeShort(20);
 * p.writeString("天下大统");
 * 
 * p.flip();
 * 
 * trace(p.readInt());
 * trace(p.readShort());
 * trace(p.readString());
 */
package net{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * 数据包
	 * @author zkpursuit
	 */
	public class Packet {
		private var _bytes:ByteArray;
		
		public function Packet(bytes:ByteArray=null, endian:String = Endian.LITTLE_ENDIAN){
			if(bytes!=null){
				this._bytes=bytes;
			}else{
				this._bytes=new ByteArray();
			}
			this._bytes.endian = endian;
		}
		public static function warp(bytes:ByteArray):Packet{
			return new Packet(bytes);
		}
		
		public function writeShort(value:int):void{
			_bytes.writeShort(value);
		}
		public function writeUShort(value:uint):void{
			_bytes.writeShort(value);
		}
		public function writeInt(value:int):void{
			_bytes.writeInt(value);
		}
		public function writeUint(value:uint):void{
			_bytes.writeUnsignedInt(value);
		}
		public function writeFloat(value:Number):void{
			_bytes.writeFloat(value);
		}
		public function writeDouble(value:Number):void{
			_bytes.writeDouble(value);
		}
		public function writeByte(value:int):void{
			_bytes.writeByte(value);
		}
		public function writeBytes(bytes:ByteArray,offset:int=0,length:int=0):void{
			bytes.writeBytes(bytes, offset, length);
		}
		public function writeString(value:String,charset:String="UTF-8"):void{
			var ba:ByteArray=new ByteArray();
			ba.writeMultiByte(value, charset);
			var len:int=ba.length;
			writeShort(len);
			_bytes.writeBytes(ba);
		}
		
		
		public function readShort():int{
			return _bytes.readShort();
		}
		public function readUShort():int{
			return _bytes.readUnsignedShort();
		}
		public function readInt():int{
			return  _bytes.readInt();
		}
		public function readUint():uint{
			return _bytes.readUnsignedInt();
		}
		public function readFloat():Number{
			return _bytes.readFloat();
		}
		public function readDouble():Number{
			return _bytes.readDouble();
		}
		public function readByte():int{
			return _bytes.readByte();
		}
		public function readBytes(offset:int=0,length:int=0):ByteArray{
			var _bytes:ByteArray=new ByteArray();
			_bytes.readBytes(_bytes, offset, length);
			return _bytes;
		}
		public function readString(charset:String="UTF-8"):String{
			var str_len:int=readShort();
			return _bytes.readMultiByte(str_len, charset);
		}
		
		public function flip():void{
			_bytes.position=0;
		}
		public function array():ByteArray{
			return _bytes;
		}
		public function size():int{
			return _bytes.length;
		}
		public function clear():void{
			_bytes.clear();
		}
		public function set position(value:int):void{
			_bytes.position=value;
		}
		public function get position():int{
			return _bytes.position;
		}
		
		/**
		 *  得到数的二进制的某一位是否为1
		 *  @param i 原数字
		 *  @param bitNum 第几位
		 */
		public static function getBit(i : uint,bitNum : uint) : Boolean {
			return (i & (1 << bitNum)) != 0;
		}

		/**
		 * 把数字某位改写为1或0
		 *@param i 原数字
		 *@param bitNum 第几位
		 *@param have true 为写为1，false为0 
		 */
		public static function setBit(i : uint,bitNum : uint,have : Boolean = true) : uint {
			var t : uint = i;
			if(have)
			t |= (1 << bitNum);
			else
			t ^= t & (1 << bitNum);
			/*if(getBit(i, bitNum) == have)return;
			else*/ 
			return t;
		}
	}
}
