package drawapi
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 只需要先使用原生绘图API绘制好要绘制的图案（这工作是由CPU完成的），
	 * 之后将图案复制到Bitmap或者BitmapData中并将其做成一个texture后上传至GPU即可。
	 * @author g7842
	 * 
	 */	
	public class DrawApi extends Sprite
	{
		private var _bmpData:BitmapData;
		private var _rect:Rectangle;
		
		public function DrawApi()
		{
			super();
			_bmpData = new BitmapData(40, 40, true);
			_rect = new Rectangle();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		
		private function onAdded ( e:Event ):void 
		{
			for (var i:int = 0; i < 100; i++)
			{
				// create a vector shape (Graphics) 
				var shape:flash.display.Sprite = new flash.display.Sprite();
				// pick a color 
				var color:uint = Math.random() * 0xFFFFFF; 
				// set color fill
				shape.graphics.beginFill(color, 1);
				// radius 
				var radius:uint = 20; 
				// draw circle with a specified radius 
				shape.graphics.drawCircle(radius,radius,radius); 
				shape.graphics.endFill();
				
				// create a BitmapData buffer 
				var buffer:BitmapData = _bmpData;
				_rect.width = 2 * radius;
				_rect.height = 2 * radius;
				buffer.fillRect(_rect, color);
//				buffer.new BitmapData(radius * 2, radius * 2, true, color); 
				// draw the shape on the bitmap 
				buffer.draw(shape);
				// create a Texture out of the BitmapData
				var texture:Texture = Texture.fromBitmapData(buffer); 
				// create an Image out of the texture 
				var img:Image = new Image(texture); 
				img.x = Math.random()*stage.stageWidth 
				img.y = Math.random()*stage.stageHeight 
				// show it! 
				addChild(img);
			}
		}
	}
}