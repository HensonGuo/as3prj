package slider.slidershow1
{
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public dynamic class LabelBlock extends MovieClip
   {
	  [Embed(source = "/../lib/slide/bg.png")] 
	  private static const bgBmp:Class;
	  
      public var textBack:Bitmap;
      public var textZone:TextField;
      
      public function LabelBlock()
      {
         super();
		 textBack = new bgBmp();
		 this.addChild(textBack);
		 
		 textZone = new TextField();
		 textZone.mouseEnabled = false;
		 textZone.autoSize = TextFieldAutoSize.LEFT;
		 textZone.multiline = true;
		 textZone.wordWrap = false;
		 textZone.condenseWhite = true;
		 textZone.defaultTextFormat = new TextFormat(null, null, null, true);
		 this.addChild(textZone);
      }
      
      
   }
}
