package file
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author lizhi
	 */
	public class FileUtils 
	{
		
		public function FileUtils() 
		{
			
		}
		
		/**
		 * Get the line count of the file
		 * @param	filestream	The filestream to count
		 * @return			The line count of the specified file
		 */
		public static function getLineCount(filestream:FileStream):Number {
			var result:Number = 0;
			var skip:Number;
			while(filestream.bytesAvailable > 0) {
				skip = getLineEnd(filestream);
				result++;
			}
			filestream.position = 0;
			return result;
		}
		
		/**
		 * Read line from the file
		 * @param	filestream	The filestream to read
		 * @return			The line of the specified file
		 */
		public static function readln(filestream:FileStream):String {
			var result:String = new String();
			var startpos:Number = filestream.position;
			var skip:Number = getLineEnd(filestream);
			var len:Number = filestream.position - startpos - skip;
			filestream.position = startpos;
			result = filestream.readUTFBytes(len);
			filestream.position += skip;
			return result;
		}
		
		/**
		 * private method
		 */
		
		/**
		 * Move the file pointer to the end of the line
		 */
		private static function getLineEnd(filestream:FileStream):Number
		{
			var skip:Number = 0;
			var code:int;
			while(filestream.bytesAvailable > 0) 
			{
				code = filestream.readByte();
				if (code == 0x0A) {
					skip = 1;
					break;
				}
				if (code == 0x0D) {
					skip = 1;
					if (filestream.bytesAvailable > 0) {
						code = filestream.readByte();
						if (code != 0x0A) {
							filestream.position -= 1;
						} else {
							skip = 2;
						}
						break;
					} else
						break;
				}
			}
			return skip;
		}
		
		public static function write(fname:String,strd:*):void {
			var nfile:File = File.applicationStorageDirectory.resolvePath(fname);
			var stream:FileStream = new FileStream();
			stream.open(nfile, FileMode.WRITE);
			stream.writeMultiByte(strd.toString(), File.systemCharset);
			stream.close();
		}
		
		public static function read(fname:String):String {
			var nfile:File = File.applicationStorageDirectory.resolvePath(fname);
			if(!nfile.exists) return "";
			var stream:FileStream = new FileStream();
			stream.open(nfile, FileMode.READ);
			var data:String = stream.readMultiByte(stream.bytesAvailable, File.systemCharset);
			stream.close();
			return data;
		}
		
		public static function getBytesFromFile(nfile:File, bytes:ByteArray = null):ByteArray 
		{
			var fs:FileStream=new FileStream();
			
			try{
				bytes=bytes||new ByteArray();
				
				fs.open(nfile,FileMode.READ);
				fs.readBytes(bytes);
				fs.close();
				bytes.position = 0;
				
				return bytes;
			}catch (e:Error) {
				
			}finally{
				fs.close();
			}
			return null;
		}
		
	  public static function getStringFromFile(nfile:File,charSet:String="utf-8"):String 
	  {
			var fs:FileStream=new FileStream();
			try{
				fs.open(nfile,FileMode.READ);
				
				return fs.readMultiByte(fs.bytesAvailable,charSet);
			}catch (e:Error) {
				
			}finally{
				fs.close();
			}
			return null;
		}
		
		public static function save(bytes:ByteArray, url:String):void 
		{
			var fil:File=new File(url);
			var fs:FileStream=new FileStream();
			try{
				fs.open(fil, FileMode.WRITE);
				bytes.position = 0;
				fs.writeBytes(bytes);
			}catch(e:Error){
				
			}finally{
				fs.close();
			}
		}
		
		public static function saveString(str:String, url:String):void 
		{
			var bytes:ByteArray = new ByteArray;
			bytes.writeUTFBytes(str);
			bytes.position = 0;
			save(bytes, url);
		}
		
	}
	
}