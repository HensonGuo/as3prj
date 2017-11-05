package com.flashdynamix.motion.plugins
{
   import com.flashdynamix.utils.MultiTypeObjectPool;
   import flash.utils.Dictionary;
   import flash.display.MovieClip;
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   import flash.filters.BitmapFilter;
   import flash.geom.Matrix;
   import flash.media.SoundTransform;
   import com.flashdynamix.motion.TweensyGroup;
   
   public class TweensyPluginList extends Object
   {
      
      public function TweensyPluginList()
      {
         super();
      }
      
      private static var pool:MultiTypeObjectPool;
      
      private static var list:Array;
      
      private static var map:Dictionary;
      
      protected static var inited:Boolean = init();
      
      private static function init() : Boolean
      {
         if(inited)
         {
            return true;
         }
         list = [];
         map = new Dictionary(true);
         pool = new MultiTypeObjectPool();
         add(MovieClip,MovieClipTween);
         add(DisplayObject,DisplayTween);
         add(ColorTransform,ColorTween);
         add(BitmapFilter,FilterTween);
         add(Matrix,MatrixTween);
         add(SoundTransform,SoundTween);
         add(Object,ObjectTween);
         FilterTween.filters = TweensyGroup.filters;
         return true;
      }
      
      public static function add(param1:Class, param2:Class) : void
      {
         list.push(param1);
         map[param1] = param2;
         pool.add(param2);
      }
      
      public static function checkOut(param1:Object) : AbstractTween
      {
         var _loc2_:* = 0;
         var _loc3_:Class = null;
         var _loc4_:int = list.length - 1;
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = list[_loc2_];
            if(param1 is _loc3_)
            {
               return pool.checkOut(map[_loc3_]);
            }
            _loc2_++;
         }
         return pool.checkOut(map[list[_loc4_]]);
      }
      
      public static function checkIn(param1:Object) : void
      {
         pool.checkIn(param1);
      }
      
      public static function empty() : void
      {
         pool.empty();
      }
   }
}
