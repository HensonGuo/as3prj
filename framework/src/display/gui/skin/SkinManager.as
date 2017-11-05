package display.gui.skin
{
	import feathers.core.DisplayListWatcher;
	import feathers.textures.Scale9Textures;
	import feathers.themes.StyleNameFunctionTheme;
	
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import loader.type.LoadResType;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import utils.debug.LogUtil;

	public class SkinManager  extends StyleNameFunctionTheme
	{
		[Embed(source="/../assets/images/aeon.png")]
		private static const aeon:Class;
		
		[Embed(source="/../assets/images/aeon.xml",mimeType="application/octet-stream")]
		private static const aeon_xml:Class;
		
		public static const DEFAULT_ATLAS:String = "aeon";
		public static const NO_ATLAS_KEY:String = "noAtlas";
		
		private var _atlasMap:Dictionary;
		private var _textureMap:Dictionary;
		private var _scale9TextureMap:Dictionary;
		private var _loadingMap:Dictionary;
		
		private var _initializerMap:Dictionary;
		
		public function SkinManager()
		{
			_atlasMap = new Dictionary(true);
			_textureMap = new Dictionary(true);
			_scale9TextureMap = new Dictionary(true);
			_scale9TextureMap[NO_ATLAS_KEY] = new Dictionary(true);
			_loadingMap = new Dictionary(true);
			_initializerMap = new Dictionary(true);
		}
		
		public function initRegister():void
		{
			registerAltas(DEFAULT_ATLAS, Bitmap(new aeon()), XML(new aeon_xml()));
			register("Button", new ButtonSkin());
			register("ButtonGroup", new ButtonGroupSkin());
		}
		
		public function register(name:String, baseSkin:BaseSkin):void
		{
			if (hasRegister(name))
				return;
			_initializerMap[name] = baseSkin;
		}
		
		public function hasRegister(name:String):Boolean
		{
			return _initializerMap[name] != null;
		}
		
		public function apply(type:Class, skinName:String):void
		{
			var skin:BaseSkin = _initializerMap[skinName];
			LogUtil.assert(skin != null, "请先注册皮肤");
			this.getStyleProviderForClass(type).defaultStyleFunction = skin.applySkin;
		}
		
		
		public function loadAltas(atlasTextureUrl:String, xmlUrl:String, completeCallback:Function = null):void
		{
			var atlasName:String = getAtlasName(atlasTextureUrl);
			if (_textureMap[atlasName] != null)
			{
				completeCallback.call(null);
				return;
			}
			if (_loadingMap[atlasName] != null)
				return;
			_loadingMap[atlasName] = new AtlasLoadingData(atlasName, completeCallback);
			
			FrameWork.loaderManager.loadRes(LoadResType.ImageFile, atlasTextureUrl, loadTextureComplete);
			FrameWork.loaderManager.loadRes(LoadResType.XMLFile, xmlUrl, loadXMLComplete);
		}
		
		public function registerAltas(atlasName:String, bitmap:Bitmap, xml:XML):void
		{
			LogUtil.assert(_atlasMap[atlasName] == null, "重复注册");
			var texture:Texture = Texture.fromBitmap(bitmap);
			var atlas:TextureAtlas = new TextureAtlas(texture, xml);
			_atlasMap[atlasName] = atlas;
			bitmap.bitmapData.dispose();
		}
		
		public function registerTexture(textureName:String, bitmap:Bitmap):void
		{
			LogUtil.assert(_textureMap[textureName] == null, "重复注册");
			var texture:Texture = Texture.fromBitmap(bitmap);
			_textureMap[textureName] = texture;
			bitmap.bitmapData.dispose();
		}
		
		public function getTexture(atlasName:String, textureName:String):Texture
		{
			if (atlasName == null || atlasName == "")
				return _textureMap[textureName];
			var altas:TextureAtlas = _atlasMap[atlasName];
			if (altas == null)
				return null;
			return altas.getTexture(textureName);
		}
		
		public function getScale9Texture(atlasName:String, textureName:String):Scale9Textures
		{
			var texturesMap:Dictionary;
			var scale9:Scale9Textures;
			if (atlasName == null || atlasName == "")
			{
				texturesMap = _scale9TextureMap[NO_ATLAS_KEY];
				scale9 = texturesMap[textureName];
				if (!scale9)
					return createScale9Texture("", textureName);
				else
					return scale9;
			}
			else
			{
				texturesMap = _scale9TextureMap[atlasName];
				if (texturesMap == null)
				{
					texturesMap = new Dictionary(true);
					_scale9TextureMap[atlasName] = texturesMap;
				}
				scale9 = texturesMap[textureName];
				if (!scale9)
					return createScale9Texture(atlasName, textureName);
				else
					return scale9;
			}
			return scale9;
		}
		
		private function createScale9Texture(atlasName:String, textureName:String):Scale9Textures
		{
			var texture:Texture = getTexture(atlasName, textureName);
			if (!texture)
				return null;
			var texturesMap:Dictionary;
			if (atlasName == null || atlasName == "")
				texturesMap = _scale9TextureMap[NO_ATLAS_KEY];
			else
				texturesMap = _scale9TextureMap[atlasName];
			var rect:Rectangle = FrameWork.scale9Manager.getScaleRectangle(atlasName, textureName);
			var scale9:Scale9Textures = new Scale9Textures(texture, rect);
			_textureMap[textureName] = scale9;
			return scale9;
		}
		
		public function getTextures(atlasName:String, prefix:String=""):Vector.<Texture>
		{
			var altas:TextureAtlas = _atlasMap[atlasName];
			if (altas == null)
				return null;
			return altas.getTextures(prefix);
		}
		
		
		private function loadTextureComplete(url:String, bitmap:Bitmap):void
		{
			var atlasName:String = getAtlasName(url);
			var loadingData:AtlasLoadingData = _loadingMap[atlasName];
			loadingData.bitmap = bitmap;
			if (loadingData.xml != null)
				loadComplete(loadingData);
		}
		
		private function loadXMLComplete(url:String, xml:Object):void
		{
			var atlasName:String = getAtlasName(url);
			var loadingData:AtlasLoadingData = _loadingMap[atlasName];
			loadingData.xml = xml;
			if (loadingData.bitmap != null)
				loadComplete(loadingData);
		}
		
		private function loadComplete(loadingData:AtlasLoadingData):void
		{
				//register
				registerAltas(loadingData.name, loadingData.bitmap, XML(loadingData.xml));
				//excute completeCallback
				loadingData.completeCallback.call(null);
				//remove from loading map
				_loadingMap[loadingData.name] = null;
				delete _loadingMap[loadingData.name];
		}
		
		private function getAtlasName(url:String):String
		{
			var index1:int = url.lastIndexOf("/");
			var index2:int = url.lastIndexOf(".");
			return url.substring(index1 + 1, index2);
		}
		
		
	}
}


import flash.display.Bitmap;

class AtlasLoadingData
{
	public var name:String;
	public var bitmap:Bitmap = null;
	public var xml:Object = null;
	public var completeCallback:Function = null;
	
	public function AtlasLoadingData(name:String, completeCallback:Function)
	{
		this.name = name;
		this.completeCallback = completeCallback;
	}
}