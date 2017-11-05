package slider.slidershow1
{
   import com.flashdynamix.motion.Tweensy;
   
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   public dynamic class PrevButton extends MovieClip
   {
	   [Embed(source = "/../lib/slide/btn_bg.png")] 
	   private static const bgBmp:Class;
	   
	   [Embed(source = "/../lib/slide/btn_border.png")] 
	   private static const borderBmp:Class;
	   
	   [Embed(source = "/../lib/slide/arrow_left.png")] 
	   private static const arrowBmp:Class;
	   
	   public var background:Bitmap;
	   public var border:Bitmap;
	   public var arrow:Bitmap;
	   
	   private var _config:SlideData;
      
      public function PrevButton()
      {
         super();
		 background = new bgBmp();
		 this.addChild(background);
		 
		 arrow = new arrowBmp();
		 arrow.y = 6.5;
		 arrow.x = 2.5;
		 this.addChild(arrow);
		 
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
		  
		  var arrowColor:ColorTransform = arrow.transform.colorTransform;
		  arrowColor.color = _config.btnArrowColorOnMouseOver;
		  
		  Tweensy.to(background.transform.colorTransform,bgColor,0.5,null,0,background);
		  Tweensy.to(border.transform.colorTransform,borderColor,0.5,null,0,border);
		  Tweensy.to(arrow.transform.colorTransform,arrowColor,0.5,null,0,arrow);
	  }
	  
	  private function onOut(event:MouseEvent) : void
	  {
		  var bgColor:ColorTransform = background.transform.colorTransform;
		  bgColor.color = _config.btnBgColor;
		  
		  var borderColor:ColorTransform = border.transform.colorTransform;
		  borderColor.color = _config.btnBorderColor;
		  
		  var arrowColor:ColorTransform = arrow.transform.colorTransform;
		  arrowColor.color = _config.btnArrowColor;
		  
		  Tweensy.to(background.transform.colorTransform,bgColor,0.5,null,0,background);
		  Tweensy.to(border.transform.colorTransform,borderColor,0.5,null,0,border);
		  Tweensy.to(arrow.transform.colorTransform,arrowColor,0.5,null,0,arrow);
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
		  
		  arrow.transform.colorTransform = arrowColor;
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
