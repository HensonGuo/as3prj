package utils.debug
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.getTimer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;

	public class ProfileMonitor extends Sprite
	{	
		protected const WIDTH : uint = 150;
		protected const HEIGHT : uint = 120;
		protected const GRAPH_Y:Number = 80;
		protected const _colors:Colors = new Colors();

		protected var _fpsText:TextField;
		protected var _msText:TextField;
		protected var _memText:TextField;
		protected var _memMaxText:TextField;
		
		protected var _graphHeight:Number;
		protected var _graphWidth:Number;
		protected var _graphTexture:Texture;
		protected var _graphImage:Image;
		protected var _graphBuffer:BitmapData;
		protected var _rectangle:Rectangle;
		
		protected var _fpsGraph:uint;
		protected var _memGraph:uint;
		protected var _memMaxGraph:uint;
		
		public function ProfileMonitor( theme : Object = null ) : void
		{
			var spacer:Number = -1;
			
			_fpsText = new TextField(WIDTH, 14, "FPS: ?", "Verdana",  10, _colors.fps);
			_fpsText.hAlign = HAlign.LEFT;
			
			_msText = new TextField(WIDTH, 14, "MS: ?", "Verdana", 10, _colors.ms);
			_msText.y = _fpsText.y + _fpsText.height + spacer;
			_msText.hAlign = HAlign.LEFT;
			
			_memText = new TextField(WIDTH, 14, "MEM: ?", "Verdana", 10, _colors.mem);
			_memText.y = _msText.y + _msText.height + spacer;
			_memText.hAlign = HAlign.LEFT;
			
			_memMaxText = new TextField(WIDTH, 14, "MAX: ?", "Verdana", 10, _colors.memmax);
			_memMaxText.y = _memText.y + _memText.height + spacer;
			_memMaxText.hAlign = HAlign.LEFT;
			
			_rectangle = new Rectangle(WIDTH - 1, GRAPH_Y, 1, HEIGHT - GRAPH_Y);
			_graphHeight = HEIGHT - GRAPH_Y;
			_graphWidth = WIDTH - 1;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e : Event) : void
		{
			addChild(_fpsText);
			addChild(_msText);
			addChild(_memText);
			addChild(_memMaxText);
			
			_graphBuffer = new BitmapData(WIDTH, HEIGHT, false, _colors.bg);
			_graphTexture = Texture.fromBitmapData(_graphBuffer);
			_graphImage = new Image(_graphTexture);
			addChildAt(_graphImage, 0);
		}
		
		private function destroy(e : Event) : void
		{
			removeChildren();			
			_graphBuffer.dispose();
			_graphImage.dispose();
			
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}		

		internal function update(ms:int, fps:int, curMemory:Number, maxMemory:Number) : void
		{
			_msText.text = "MS: " + ms;
			_fpsText.text = "FPS: " + fps + " / " + FrameWork.stage.frameRate;
			_memText.text = "MEM: " + String(curMemory);
			_memMaxText.text = "MAX: " + String(maxMemory);
			
			_fpsGraph = Math.min(_graphHeight, ( fps / FrameWork.stage.frameRate ) * _graphHeight);
			_memGraph = Math.min(_graphHeight, Math.sqrt(Math.sqrt(curMemory * 5000))) - 2;
			_memMaxGraph = Math.min(_graphHeight, Math.sqrt(Math.sqrt(maxMemory * 5000))) - 2;
			
			_graphBuffer.scroll(-1, 0);
			
			_graphBuffer.fillRect(_rectangle, _colors.bg);
			_graphBuffer.setPixel(_graphWidth, _graphHeight - _fpsGraph + GRAPH_Y, _colors.fps);
			_graphBuffer.setPixel(_graphWidth, _graphHeight - (ms >> 1) + GRAPH_Y, _colors.ms);
			_graphBuffer.setPixel(_graphWidth, _graphHeight - _memGraph + GRAPH_Y, _colors.mem);
			_graphBuffer.setPixel(_graphWidth, _graphHeight - _memMaxGraph + GRAPH_Y, _colors.memmax);
			
			_graphImage.texture.dispose();
			_graphImage.texture = Texture.fromBitmapData(_graphBuffer);
		}
		
	}
}

class Colors {
	
	public var bg : uint = 0x000033;
	public var fps : uint = 0xffff00;
	public var ms : uint = 0x00ff00;
	public var mem : uint = 0x00ffff;
	public var memmax : uint = 0xff0070;
}