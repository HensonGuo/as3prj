package slider.slidershow1
{
   import com.flashdynamix.motion.Tweensy;
   
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   public dynamic class PlayButton extends MovieClip
   {
	  [Embed(source = "/../lib/slide/btn_bg.png")] 
	  private static const bgBmp:Class;
	   
	  [Embed(source = "/../lib/slide/btn_border.png")] 
	  private static const borderBmp:Class;
	   
	  [Embed(source = "/../lib/slide/play.png")] 
	  private static const playArrowBmp:Class;
	   
	  [Embed(source = "/../lib/slide/pause.png")] 
	  private static const pauseArrowBmp:Class;
	   
	  public var background:Bitmap;
	  public var border:Bitmap;
	  public var playArrow:Bitmap;
	  public var pauseArrow:Bitmap;
	   
	  private var _config:SlideData;
	   
      public function PlayButton()
      {
         super();
		 background = new bgBmp();
		 this.addChild(background);
		 
		 playArrow = new playArrowBmp();
		 playArrow.x = 10;
		 playArrow.y = 8;
		 this.addChild(playArrow);
		 
		 pauseArrow = new pauseArrowBmp();
		 pauseArrow.x = 10;
		 pauseArrow.y = 8;
		 this.addChild(pauseArrow);
		 
		 border = new borderBmp();
		 border.x = -1;
		 border.y = -1;
		 this.addChild(border);
		 
		 this.buttonMode = true;
		 this.mouseChildren = false;
		 this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
	  }
	  
	  private function onAdded(event:Event):void
	  {
		  this.addEventListener(MouseEvent.MOUSE_OVER,onOver);
		  this.addEventListener(MouseEvent.MOUSE_OUT,onOut);
	  }
	  
	  private function onOver(event:MouseEvent) : void
	  {
		  var bgColor:ColorTransform = background.transform.colorTransform;
		  bgColor.color = _config.btnBgColorOnMouseOver;
		  var borderColor:ColorTransform = border.transform.colorTransform;
		  borderColor.color = _config.btnBorderColorOnMouseOver;
		  var playArrowColor:ColorTransform = playArrow.transform.colorTransform;
		  playArrowColor.color = _config.btnArrowColorOnMouseOver;
		  var pauseArrowColor:ColorTransform = pauseArrow.transform.colorTransform;
		  pauseArrowColor.color = _config.btnArrowColorOnMouseOver;
		  
		  Tweensy.to(background.transform.colorTransform,bgColor,0.5,null,0,background);
		  Tweensy.to(border.transform.colorTransform,borderColor,0.5,null,0,border);
		  Tweensy.to(playArrow.transform.colorTransform,playArrowColor,0.5,null,0,playArrow);
		  Tweensy.to(pauseArrow.transform.colorTransform,pauseArrowColor,0.5,null,0,pauseArrow);
	  }
	  
	  private function onOut(param1:MouseEvent) : void
	  {
		  var bgColor:ColorTransform = background.transform.colorTransform;
		  bgColor.color = _config.btnBgColor;
		  var borderColor:ColorTransform = border.transform.colorTransform;
		  borderColor.color = _config.btnBorderColor;
		  var playArrowColor:ColorTransform = playArrow.transform.colorTransform;
		  playArrowColor.color = _config.btnArrowColor;
		  var pauseArrowColor:ColorTransform = pauseArrow.transform.colorTransform;
		  pauseArrowColor.color = _config.btnArrowColor;
		  Tweensy.to(background.transform.colorTransform,bgColor,0.5,null,0,background);
		  Tweensy.to(border.transform.colorTransform,borderColor,0.5,null,0,border);
		  Tweensy.to(playArrow.transform.colorTransform,playArrowColor,0.5,null,0,playArrow);
		  Tweensy.to(pauseArrow.transform.colorTransform,pauseArrowColor,0.5,null,0,pauseArrow);
	  }
	  
	  public function applyConfig(config:SlideData):void
	  {
		  _config = config;
		  var arrowColor:ColorTransform = new ColorTransform();
		  arrowColor.color = _config.btnArrowColor;
		  var borderColor:ColorTransform = new ColorTransform();
		  borderColor.color = _config.btnBorderColor;
		  var bgColor:ColorTransform = new ColorTransform();
		  bgColor.color = _config.btnBgColor;
		  
		  playArrow.transform.colorTransform = arrowColor;
		  pauseArrow.transform.colorTransform = arrowColor;
		  border.transform.colorTransform = borderColor;
		  background.transform.colorTransform = bgColor;
		  background.alpha = _config.btnBgOpacity / 100;
	  }
      
	  public function dispose():void
	  {
		  this.removeEventListener(MouseEvent.MOUSE_OVER,onOver);
		  this.removeEventListener(MouseEvent.MOUSE_OUT,onOut);
	  }
	  
   }
}
