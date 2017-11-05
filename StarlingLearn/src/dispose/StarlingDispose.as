package dispose
{
	import flash.display.Bitmap;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class StarlingDispose extends Sprite
	{
		[Embed(source = "/../bin-debug/assets/greenbg.jpg")] 
		private static const GreenBg:Class;
		
		public function StarlingDispose()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded (e:Event):void { 
			// create a Bitmap object out of the embedded image 
			var pigTexture:Bitmap = new GreenBg(); 
			// create a Texture object to feed the Image object 
			var texture:Texture = Texture.fromBitmap(pigTexture);
			
			var img:Image = new Image(texture);
			this.addChild(img);
			img.texture.dispose();
			
		}
		
	}
}