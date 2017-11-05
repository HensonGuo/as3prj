package com.flashdynamix.motion
{
   import com.flashdynamix.motion.plugins.TweensyPluginList;
   
   public class Tweensy extends Object
   {
      
      public function Tweensy()
      {
         super();
      }
      
      public static const version:String = "0.2.1";
      
      public static const TIME:String = "time";
      
      public static const FRAME:String = "frame";
      
      private static var tween:TweensyGroup = new TweensyGroup(true,false,TIME);
      
      public static function to(param1:Object, param2:Object, param3:Number = 0.5, param4:Function = null, param5:Number = 0, param6:Object = null, param7:Function = null, param8:Array = null) : TweensyTimeline
      {
         return tween.to(param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      public static function from(param1:Object, param2:Object, param3:Number = 0.5, param4:Function = null, param5:Number = 0, param6:Object = null, param7:Function = null, param8:Array = null) : TweensyTimeline
      {
         return tween.from(param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      public static function fromTo(param1:Object, param2:Object, param3:Object, param4:Number = 0.5, param5:Function = null, param6:Number = 0, param7:Object = null, param8:Function = null, param9:Array = null) : TweensyTimeline
      {
         return tween.fromTo(param1,param2,param3,param4,param5,param6,param7,param8,param9);
      }
      
      public static function updateTo(param1:Object, param2:Object) : void
      {
         tween.updateTo(param1,param2);
      }
      
      public static function add(param1:TweensyTimeline) : TweensyTimeline
      {
         return tween.add(param1);
      }
      
      public static function remove(param1:TweensyTimeline) : void
      {
         tween.remove(param1);
      }
      
      public static function stop(param1:* = null, ... rest) : void
      {
         var _loc3_:Array = [param1].concat(rest);
         tween.stop.apply(null,_loc3_);
      }
      
      public static function stopAll() : void
      {
         tween.stopAll();
      }
      
      public static function pause() : void
      {
         tween.pause();
      }
      
      public static function resume() : void
      {
         tween.resume();
      }
      
      public static function empty() : void
      {
         TweensyGroup.empty();
         TweensyTimeline.empty();
         TweensyPluginList.empty();
      }
      
      public static function set snapToClosest(param1:Boolean) : void
      {
         tween.snapToClosest = param1;
      }
      
      public static function get snapToClosest() : Boolean
      {
         return tween.snapToClosest;
      }
      
      public static function set smartRotate(param1:Boolean) : void
      {
         tween.smartRotate = param1;
      }
      
      public static function get smartRotate() : Boolean
      {
         return tween.smartRotate;
      }
      
      public static function get paused() : Boolean
      {
         return tween.paused;
      }
      
      public static function set secondsPerFrame(param1:Number) : void
      {
         tween.secondsPerFrame = param1;
      }
      
      public static function get secondsPerFrame() : Number
      {
         return tween.secondsPerFrame;
      }
      
      public static function set refreshType(param1:String) : void
      {
         tween.refreshType = param1;
      }
      
      public static function get refreshType() : String
      {
         return tween.refreshType;
      }
      
      public static function get timelines() : int
      {
         return tween.timelines;
      }
      
      public static function get hasTimelines() : Boolean
      {
         return tween.hasTimelines;
      }
      
      public function toString() : String
      {
         return "Tweensy " + Tweensy.version + " {timelines:" + timelines + "}";
      }
   }
}
