package resource
{
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class FontManager extends Object
   {
      public static var MICROSOFT_YAHEI:String = "Microsoft YaHei";
      
      public function FontManager() {
         super();
      }
      
      public function setYaheiFont() : void 
	  {
         var _loc1_:TextField = new TextField();
         _loc1_.defaultTextFormat = new TextFormat("Microsoft YaHei",12,16777215);
         _loc1_.text = "雅黑";
		 
         var _loc2_:TextField = new TextField();
         _loc2_.defaultTextFormat = new TextFormat("微软雅黑",12,16777215);
         _loc2_.text = "雅黑";
		 
         var _loc3_:TextField = new TextField();
         _loc3_.defaultTextFormat = new TextFormat(null,12,16777215);
         _loc3_.text = "雅黑";
		 
         if(_loc1_.textHeight == _loc3_.textHeight)
            MICROSOFT_YAHEI = "微软雅黑";
         if(_loc1_.textHeight >= _loc2_.textHeight)
            MICROSOFT_YAHEI = "Microsoft YaHei";
      }
	  
   }
}
