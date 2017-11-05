package com.flashdynamix.motion
{
   import com.flashdynamix.motion.plugins.TweensyPluginList;
   import com.flashdynamix.motion.plugins.AbstractTween;
   
   public class TweensyTimeline extends Object
   {
      
      public function TweensyTimeline()
      {
         this.ease = defaultTween;
         this._instances = [];
         this.args = defaultArgs.concat();
         super();
         this.list = [];
      }
      
      public static const YOYO:String = "yoyo";
      
      public static const REPLAY:String = "replay";
      
      public static const LOOP:String = "loop";
      
      public static const NONE:String = null;
      
      public static var defaultTween:Function = easeOut;
      
      private static var defaultArgs:Array = [0,0,1,0];
      
      public static function empty() : void
      {
         TweensyPluginList.empty();
      }
      
      private static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         var param1:Number = param1 / param4 - 1;
         return param3 * (param1 * param1 * param1 * param1 * param1 + 1) + param2;
      }
      
      public var ease:Function;
      
      public var delayStart:Number = 0;
      
      public var delayEnd:Number = 0;
      
      public var repeatType:String;
      
      public var repeats:int = -1;
      
      public var repeatCount:int = 0;
      
      public var repeatEase:Array;
      
      public var smartRotate:Boolean = true;
      
      public var snapToClosest:Boolean = false;
      
      public var autoHide:Boolean = false;
      
      public var onUpdate:Function;
      
      public var onUpdateParams:Array;
      
      public var onComplete:Function;
      
      public var onCompleteParams:Array;
      
      public var onRepeat:Function;
      
      public var onRepeatParams:Array;
      
	  public var manager:TweensyGroup;
      
	  public var next:TweensyTimeline;
      
	  public var previous:TweensyTimeline;
      
	  public var _onComplete:Function;
      
      private var _instances:Array;
      
      private var _tweens:int = 0;
      
      private var _time:Number = 0;
      
      private var _paused:Boolean = false;
      
      private var args:Array;
      
      private var _duration:Number;
      
      private var list:Array;
      
      private var disposed:Boolean = false;
      
      public function to(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc4_:AbstractTween = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         if(param1 is Array)
         {
            _loc5_ = 0;
            _loc6_ = (param1 as Array).length;
            _loc5_ < 0;
            while(_loc5_ < _loc6_)
            {
               if(param1[_loc5_] is Number || param1[_loc5_] is String)
               {
                  if(!_loc4_)
                  {
                     _loc4_ = this.add(param1,param3);
                  }
                  _loc4_.add(_loc5_.toString(),param2[_loc5_],false);
               }
               else
               {
                  this.to(param1[_loc5_],param2,param3);
               }
               _loc5_++;
            }
         }
         else
         {
            _loc4_ = this.add(param1,param3);
            _loc4_.toTarget(param2);
         }
      }
      
      public function from(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc4_:AbstractTween = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         if(param1 is Array)
         {
            _loc5_ = 0;
            _loc6_ = (param1 as Array).length;
            _loc5_ < 0;
            while(_loc5_ < _loc6_)
            {
               if(param1[_loc5_] is Number || param1[_loc5_] is String)
               {
                  if(!_loc4_)
                  {
                     _loc4_ = this.add(param1,param3);
                  }
                  _loc4_.add(_loc5_.toString(),param2[_loc5_],true);
               }
               else
               {
                  this.from(param1[_loc5_],param2,param3);
               }
               _loc5_++;
            }
         }
         else
         {
            _loc4_ = this.add(param1,param3);
            _loc4_.fromTarget(param2);
            _loc4_.apply();
         }
      }
      
      public function fromTo(param1:Object, param2:Object, param3:Object, param4:Object = null) : void
      {
         var _loc5_:AbstractTween = null;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         if(param1 is Array)
         {
            _loc6_ = 0;
            _loc7_ = (param1 as Array).length;
            _loc6_ < 0;
            while(_loc6_ < _loc7_)
            {
               if(param1[_loc6_] is Number || param1[_loc6_] is String)
               {
                  if(!_loc5_)
                  {
                     _loc5_ = this.add(param1,param4);
                  }
                  _loc5_.add(_loc6_.toString(),param2[_loc6_],true);
                  _loc5_.add(_loc6_.toString(),param3[_loc6_],false);
               }
               else
               {
                  this.fromTo(param1[_loc6_],param2,param3,param4);
               }
               _loc6_++;
            }
         }
         else
         {
            _loc5_ = this.add(param1,param4);
            _loc5_.fromTarget(param2);
            _loc5_.toTarget(param3);
            _loc5_.apply();
         }
      }
      
      public function updateTo(param1:Object, param2:Object) : void
      {
         var _loc3_:AbstractTween = null;
         var _loc4_:Number = this.ease.apply(null,this.args);
         for each(_loc3_ in this.list)
         {
            if(_loc3_.instance == param1)
            {
               _loc3_.updateTo(_loc4_,param2);
            }
         }
      }
      
      public function stop(param1:* = null, ... rest) : void
      {
         var _loc3_:AbstractTween = null;
         var _loc4_:* = 0;
         var _loc5_:Array = param1 is Array?param1:param1 == null?null:[param1];
         _loc4_ = this._tweens - 1;
         while(_loc4_ >= 0)
         {
            _loc3_ = this.list[_loc4_];
            if(_loc5_ == null || !(_loc5_.indexOf(_loc3_.instance) == -1))
            {
               if(rest.length == 0)
               {
                  _loc3_.stopAll();
               }
               else
               {
                  _loc3_.stop.apply(null,rest);
               }
               if(!_loc3_.hasAnimations)
               {
                  this.remove(_loc3_);
                  this.list.splice(_loc4_,1);
               }
            }
            _loc4_--;
         }
         if(!this.hasTweens && (this.manager))
         {
            this.manager.remove(this);
         }
      }
      
      public function stopAll() : void
      {
         this.removeAll();
         if(this.manager)
         {
            this.manager.remove(this);
         }
      }
      
      public function update(param1:Number) : Boolean
      {
         var _loc2_:* = NaN;
         var _loc3_:AbstractTween = null;
         var _loc4_:* = 0;
         var _loc6_:* = false;
         if(this.paused)
         {
            return false;
         }
         this._time = this._time + param1;
         var _loc5_:Number = this._time - this.delayStart;
         if(_loc5_ > 0)
         {
            _loc6_ = this.finished;
            _loc5_ = _loc5_ > this._duration?this._duration:_loc5_;
            this.args[0] = _loc5_;
            _loc2_ = this.ease.apply(null,this.args);
            _loc4_ = 0;
            while(_loc4_ < this._tweens)
            {
               _loc3_ = this.list[_loc4_];
               _loc3_.update(_loc2_);
               _loc4_++;
            }
            if(this.onUpdate != null)
            {
               this.onUpdate.apply(null,this.onUpdateParams);
               _loc6_ = this.finished;
            }
            if(_loc6_)
            {
               if(this.canRepeat)
               {
                  if(this.repeatType == YOYO)
                  {
                     this.yoyo();
                  }
                  else if(this.repeatType == REPLAY)
                  {
                     this.replay();
                  }
                  else if(this.repeatType == LOOP)
                  {
                     this.loop();
                  }
                  
                  
                  if(this.onRepeat != null)
                  {
                     this.onRepeat.apply(null,this.onRepeatParams);
                  }
                  _loc6_ = this.finished;
               }
               if(_loc6_)
               {
                  if(this.onComplete != null)
                  {
                     this.onComplete.apply(null,this.onCompleteParams);
                  }
                  _loc6_ = (this.finished) && !this.canRepeat;
                  if((_loc6_) && !(this._onComplete == null))
                  {
                     this._onComplete();
                  }
               }
            }
         }
         return _loc6_;
      }
      
      public function pause() : void
      {
         if(this.paused)
         {
            return;
         }
         this._paused = true;
      }
      
      public function resume() : void
      {
         if(!this.paused)
         {
            return;
         }
         this._paused = false;
      }
      
      public function loop() : void
      {
         var _loc1_:AbstractTween = null;
         var _loc2_:* = NaN;
         for each(_loc1_ in this.list)
         {
            _loc1_.swapToFrom();
         }
         _loc2_ = this.delayStart;
         this.delayStart = this.delayEnd;
         this.delayEnd = _loc2_;
         this.doRepeat();
      }
      
      public function yoyo() : void
      {
         var _loc1_:AbstractTween = null;
         for each(_loc1_ in this.list)
         {
            _loc1_.swapToFrom();
         }
         this.doRepeat();
      }
      
      public function replay() : void
      {
         var _loc1_:AbstractTween = null;
         for each(_loc1_ in this.list)
         {
            _loc1_.update(0);
         }
         this.doRepeat();
      }
      
      public function get canRepeat() : Boolean
      {
         return !(this.repeatType == NONE) && (this.repeats == -1 || this.repeatCount < this.repeats);
      }
      
      public function set position(param1:Number) : void
      {
         var _loc2_:Number = param1 * this.totalDuration - this._time;
         this.update(_loc2_);
      }
      
      public function get position() : Number
      {
         return this._time / this.totalDuration;
      }
      
      public function get finished() : Boolean
      {
         return this._time >= this.totalDuration;
      }
      
      public function get totalDuration() : Number
      {
         return this.delayStart + this._duration + this.delayEnd;
      }
      
      public function set time(param1:Number) : void
      {
         this._time = param1;
      }
      
      public function get time() : Number
      {
         return this._time;
      }
      
      public function set duration(param1:Number) : void
      {
         this.args[3] = param1;
         this._duration = param1;
      }
      
      public function get duration() : Number
      {
         return this._duration;
      }
      
      public function set easeParams(param1:Array) : void
      {
         this.args = this.args.slice(0,4).concat(param1);
      }
      
      public function get paused() : Boolean
      {
         return this._paused;
      }
      
      public function get playing() : Boolean
      {
         return this._time > this.delayStart && this._time < this.delayEnd;
      }
      
      public function get tweens() : int
      {
         return this._tweens;
      }
      
      public function get hasTweens() : Boolean
      {
         return this._tweens > 0;
      }
      
      public function get instances() : Array
      {
         return this._instances;
      }
      
      public function removeAll() : void
      {
         var _loc1_:AbstractTween = null;
         for each(_loc1_ in this.list)
         {
            this.remove(_loc1_);
         }
         this.list.length = 0;
         this._instances.length = 0;
      }
      
      public function removeOverlap(param1:TweensyTimeline) : void
      {
         var _loc2_:* = 0;
         var _loc3_:AbstractTween = null;
         var _loc4_:AbstractTween = null;
         if(!(this == param1) && (this.intersects(param1)))
         {
            for each(_loc3_ in param1.list)
            {
               _loc2_ = this._tweens - 1;
               while(_loc2_ >= 0)
               {
                  _loc4_ = this.list[_loc2_];
                  _loc4_.removeOverlap(_loc3_);
                  if(!_loc4_.hasAnimations)
                  {
                     this.remove(_loc4_);
                     this.list.splice(_loc2_,1);
                  }
                  _loc2_--;
               }
            }
            if(!this.hasTweens)
            {
               this.manager.remove(this);
            }
         }
      }
      
      public function clear() : void
      {
         this.removeAll();
         this.next = null;
         this.previous = null;
         this.args = defaultArgs.concat();
         this.manager = null;
         this.onUpdate = null;
         this.onUpdateParams = null;
         this.onComplete = null;
         this.onCompleteParams = null;
         this.onRepeat = null;
         this.onRepeatParams = null;
         this._onComplete = null;
         this.ease = defaultTween;
         this.delayStart = 0;
         this.delayEnd = 0;
         this.repeatType = NONE;
         this.repeats = -1;
         this.repeatEase = null;
         this.disposed = false;
         this._time = 0;
         this._paused = false;
         this.repeatCount = 0;
      }
      
      private function add(param1:Object, param2:Object = null) : AbstractTween
      {
         var _loc3_:AbstractTween = TweensyPluginList.checkOut(param1);
         _loc3_.timeline = this;
         _loc3_.construct(param1,param2);
         this._instances.push(_loc3_.instance);
         var _loc4_:* = this._tweens++;
         this.list[_loc4_] = _loc3_;
         return _loc3_;
      }
      
      private function remove(param1:AbstractTween) : void
      {
         param1.clear();
         TweensyPluginList.checkIn(param1);
         if(this.manager)
         {
            this.manager.removeInstance(param1.instance,this);
         }
         this._instances.splice(this._instances.indexOf(param1.instance));
         this._tweens--;
      }
      
      private function intersects(param1:TweensyTimeline) : Boolean
      {
         return param1.delayStart < this.totalDuration - this.time;
      }
      
      private function doRepeat() : void
      {
         this._time = 0;
         this.repeatCount++;
         if(this.repeatEase)
         {
            this.ease = this.repeatEase[this.repeatCount % this.repeatEase.length];
         }
      }
      
      public function dispose() : void
      {
         if(this.disposed)
         {
            return;
         }
         this.disposed = true;
         this.stopAll();
         this.next = null;
         this.previous = null;
         this.args = null;
         this.list = null;
         this.manager = null;
         this.ease = null;
         this.repeatEase = null;
         this.onUpdate = null;
         this.onUpdateParams = null;
         this.onComplete = null;
         this.onCompleteParams = null;
         this.onRepeat = null;
         this.onRepeatParams = null;
      }
      
      public function toString() : String
      {
         return "TweensyTimeline " + Tweensy.version + " {tweens:" + this._tweens + "}";
      }
   }
}
