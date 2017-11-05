package assetsmananger
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * 唯一的资源供应源
	 * 这个Assets对象负责对资源进行缓存以便资源能够得以被重复使用
	 * 减轻垃圾回收的负担
	 */	
	public class AssetsMgr extends Sprite
	{
		private static var Assets:Dictionary = new Dictionary(true);
		private static var sTextures:Dictionary = new Dictionary(true);
		
		public function AssetsMgr()
		{
			super();
		}
		
		public static function getTexture(name:String):Texture 
		{ 
			if (Assets[name] != undefined) 
			{ 
				if (sTextures[name] == undefined) 
				{ 
					var bitmap:Bitmap = new Assets[name](); 
					sTextures[name] = Texture.fromBitmap(bitmap); 
				}
				return sTextures[name]; 
			}
			else 
				throw new Error("Resource not defined."); 
		}
		
	}
}