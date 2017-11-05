package module.base
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

   public class ScaleMode extends Object
   {
      public static const STRETCH:String = "stretch";
      public static const WIDTH_ONLY:String = "widthOnly";
      public static const HEIGHT_ONLY:String = "heightOnly";
      public static const OUTSIDE:String = "outside";
      public static const INSIDE:String = "inside";
      public static const NONE:String = "none";
      
      public function ScaleMode()
      {
         super();
      }
	  
	  public static function applyScale(displayObj:DisplayObject, mode:String, parentRect:Rectangle):void
	  {
		  switch(mode)
		  {
			  case STRETCH:
				  displayObj.width = parentRect.width;
				  displayObj.height = parentRect.height;
				  break;
			  case WIDTH_ONLY:
				  displayObj.width = parentRect.width;
				  break;
			  case HEIGHT_ONLY:
				  displayObj.height = parentRect.height;
				  break;
			  case OUTSIDE:
				  var widthFactor:Number = parentRect.width / displayObj.width;
				  var heightFactor:Number = parentRect.height / displayObj.height;
				  if (widthFactor < heightFactor)
				  {
					  displayObj.width = displayObj.width * heightFactor;
					  displayObj.height = parentRect.height;
				  }
				  else if (widthFactor > heightFactor)
				  {
					  displayObj.width = parentRect.width;
					  displayObj.height = displayObj.height * widthFactor;
				  }
				  else
				  {
					  displayObj.width = parentRect.width;
					  displayObj.height = parentRect.height;
				  }
				  break;
			  case INSIDE:
				  widthFactor = parentRect.width / displayObj.width;
				  heightFactor = parentRect.height / displayObj.height;
				  if (widthFactor < heightFactor)
				  {
					  displayObj.width = parentRect.width;
					  displayObj.height = displayObj.height * widthFactor;
				  }
				  else if (widthFactor > heightFactor)
				  {
					  displayObj.width = displayObj.width * heightFactor;
					  displayObj.height = parentRect.height;
				  }
				  else
				  {
					  displayObj.width = parentRect.width;
					  displayObj.height = parentRect.height;
				  }
				  break;
			  case NONE:
				  break;
		  }
	  }
      
   }
}
