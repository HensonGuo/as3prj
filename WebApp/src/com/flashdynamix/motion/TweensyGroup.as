package com.flashdynamix.motion
{
   import com.flashdynamix.utils.ObjectPool;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import flash.media.SoundTransform;
   import flash.media.SoundChannel;
   import flash.filters.BitmapFilter;
   import flash.utils.getQualifiedClassName;
   import flash.geom.ColorTransform;
   import flash.utils.getTimer;
   import flash.events.Event;
   
   public class TweensyGroup extends Object
   {
      
      public function TweensyGroup(param1:Boolean = true, param2:Boolean = false, param3:String = "time")
      {
         super();
         this.lazyMode = param1;
         this.useObjectPooling = param2;
         this.refreshType = param3;
         this.time = getTimer();
      }
      
      private static var pool:ObjectPool = new ObjectPool(TweensyTimeline);
      
      private static var nFrame:Sprite = new Sprite();
      
      private static var map:Dictionary = new Dictionary(true);
      
      private static var keyframes:Dictionary = new Dictionary(true);
      
      public static var filters:Dictionary = new Dictionary(true);
      
      public static function empty() : void
      {
         pool.empty();
         map = new Dictionary(true);
         keyframes = new Dictionary(true);
         filters = new Dictionary(true);
      }
      
      public var lazyMode:Boolean = true;
      
      public var useObjectPooling:Boolean = false;
      
      public var smartRotate:Boolean = true;
      
      public var snapToClosest:Boolean = false;
      
      public var autoHide:Boolean = false;
      
      public var secondsPerFrame:Number = 0.0333333333333333;
      
      public var refreshType:String = "time";
      
      public var onUpdate:Function;
      
      public var onUpdateParams:Array;
      
      public var onComplete:Function;
      
      public var onCompleteParams:Array;
      
      private var first:TweensyTimeline;
      
      private var last:TweensyTimeline;
      
      private var time:Number;
      
      private var _timelines:int = 0;
      
      private var _paused:Boolean;
      
      private var disposed:Boolean = false;
      
      public function to(param1:Object, param2:Object, param3:Number = 0.5, param4:Function = null, param5:Number = 0, param6:Object = null, param7:Function = null, param8:Array = null) : TweensyTimeline
      {
         var _loc9_:TweensyTimeline = this.setup(param3,param4,param5,param7,param8);
         _loc9_.to(param1,param2,param6);
         return this.add(_loc9_);
      }
      
      public function from(param1:Object, param2:Object, param3:Number = 0.5, param4:Function = null, param5:Number = 0, param6:Object = null, param7:Function = null, param8:Array = null) : TweensyTimeline
      {
         var _loc9_:TweensyTimeline = this.setup(param3,param4,param5,param7,param8);
         _loc9_.from(param1,param2,param6);
         return this.add(_loc9_);
      }
      
      public function fromTo(param1:Object, param2:Object, param3:Object, param4:Number = 0.5, param5:Function = null, param6:Number = 0, param7:Object = null, param8:Function = null, param9:Array = null) : TweensyTimeline
      {
         var _loc10_:TweensyTimeline = this.setup(param4,param5,param6,param8,param9);
         _loc10_.fromTo(param1,param2,param3,param7);
         return this.add(_loc10_);
      }
      
      public function updateTo(param1:Object, param2:Object) : void
      {
         var _loc3_:TweensyTimeline = this.first;
         var _loc4_:Array = map[param1];
         for each(_loc3_ in _loc4_)
         {
            _loc3_.updateTo(param1,param2);
         }
      }
      
      public function functionTo(param1:Object, param2:Object, param3:Function, param4:Number = 0.5, param5:Function = null, param6:Number = 0) : TweensyTimeline
      {
         var _loc7_:TweensyTimeline = this.setup(param4,param5,param6);
         _loc7_.to(param1,param2);
         _loc7_.onUpdate = param3;
         _loc7_.onUpdateParams = [param1];
         this.add(_loc7_);
         return _loc7_;
      }
      
      public function alphaTo(param1:Object, param2:Number, param3:Number = 0.5, param4:Function = null, param5:Number = 0) : TweensyTimeline
      {
         var _loc6_:TweensyTimeline = this.setup(param3,param4,param5);
         _loc6_.to(param1,{"alpha":param2});
         this.add(_loc6_);
         return _loc6_;
      }
      
      public function scaleTo(param1:Object, param2:Number, param3:Number = 0.5, param4:Function = null, param5:Number = 0) : TweensyTimeline
      {
         var _loc6_:TweensyTimeline = this.setup(param3,param4,param5);
         _loc6_.to(param1,{
            "scaleX":param2,
            "scaleY":param2
         });
         this.add(_loc6_);
         return _loc6_;
      }
      
      public function slideTo(param1:Object, param2:Number, param3:Number, param4:Number = 0.5, param5:Function = null, param6:Number = 0) : TweensyTimeline
      {
         var _loc7_:TweensyTimeline = this.setup(param4,param5,param6);
         _loc7_.to(param1,{
            "x":param2,
            "y":param3
         });
         this.add(_loc7_);
         return _loc7_;
      }
      
      public function rotateTo(param1:Object, param2:Number, param3:Number = 0.5, param4:Function = null, param5:Number = 0) : TweensyTimeline
      {
         var _loc6_:TweensyTimeline = this.setup(param3,param4,param5);
         _loc6_.to(param1,{"rotation":param2});
         this.add(_loc6_);
         return _loc6_;
      }
      
      public function matrixTo(param1:DisplayObject, param2:Matrix, param3:Number = 0.5, param4:Function = null, param5:Number = 0) : TweensyTimeline
      {
         var _loc6_:TweensyTimeline = this.setup(param3,param4,param5);
         _loc6_.to(param1.transform.matrix,param2,param1);
         this.add(_loc6_);
         return _loc6_;
      }
      
      public function soundTransformTo(param1:Object, param2:SoundTransform, param3:Number = 0.5, param4:Function = null, param5:Number = 0) : TweensyTimeline
      {
         var _loc6_:TweensyTimeline = this.setup(param3,param4,param5);
         if(param1 is SoundChannel)
         {
            _loc6_.to((param1 as SoundChannel).soundTransform,param2,param1);
         }
         else
         {
            _loc6_.to((param1 as Sprite).soundTransform,param2,param1);
         }
         this.add(_loc6_);
         return _loc6_;
      }
      
      public function filterTo(param1:DisplayObject, param2:BitmapFilter, param3:Object, param4:Number = 0.5, param5:Function = null, param6:Number = 0, param7:Boolean = true, param8:Boolean = false) : TweensyTimeline
      {
         var filterMatch:BitmapFilter = null;
         var instanceFilters:Array = null;
         var filterItem:BitmapFilter = null;
         var instance:DisplayObject = param1;
         var filter:BitmapFilter = param2;
         var to:Object = param3;
         var duration:Number = param4;
         var ease:Function = param5;
         var delayStart:Number = param6;
         var uniqueFilters:Boolean = param7;
         var autoRemove:Boolean = param8;
         var timeline:TweensyTimeline = this.setup(duration,ease,delayStart);
         if(uniqueFilters)
         {
            if(filters[instance] == null)
            {
               filters[instance] = instance.filters;
            }
            instanceFilters = filters[instance];
            for each(filterItem in instanceFilters)
            {
               if(getQualifiedClassName(filter) == getQualifiedClassName(filterItem))
               {
                  filterMatch = filterItem;
               }
            }
            filter = filterMatch?filterMatch:filter;
         }
         timeline.to(filter,to,instance);
         this.add(timeline);
         if(autoRemove)
         {
            timeline._onComplete = function():void
            {
               var _loc1_:Array = filters[instance];
               _loc1_.splice(_loc1_.indexOf(filter),1);
               instance.filters = _loc1_;
            };
         }
         return timeline;
      }
      
      public function retrieveFilters(param1:DisplayObject) : Array
      {
         return filters[param1];
      }
      
      public function colorTo(param1:DisplayObject, param2:uint, param3:Number = 0.5, param4:Function = null, param5:Number = 0) : TweensyTimeline
      {
         var _loc6_:TweensyTimeline = this.setup(param3,param4,param5);
         var _loc7_:ColorTransform = new ColorTransform();
         _loc7_.color = param2;
         _loc6_.to(param1.transform.colorTransform,_loc7_,param1);
         this.add(_loc6_);
         return _loc6_;
      }
      
      public function colorTransformTo(param1:DisplayObject, param2:ColorTransform, param3:Number = 0.5, param4:Function = null, param5:Number = 0) : TweensyTimeline
      {
         var _loc6_:TweensyTimeline = this.setup(param3,param4,param5);
         _loc6_.to(param1.transform.colorTransform,param2,param1);
         this.add(_loc6_);
         return _loc6_;
      }
      
      public function contrastTo(param1:DisplayObject, param2:Number, param3:Number = 0.5, param4:Function = null, param5:Number = 0) : TweensyTimeline
      {
         var _loc6_:TweensyTimeline = this.setup(param3,param4,param5);
         var _loc7_:ColorTransform = new ColorTransform(1,1,1,1,param2 * 255,param2 * 255,param2 * 255);
         _loc6_.to(param1.transform.colorTransform,_loc7_,param1);
         this.add(_loc6_);
         return _loc6_;
      }
      
      public function brightnessTo(param1:DisplayObject, param2:Number, param3:Number = 0.5, param4:Function = null, param5:Number = 0) : TweensyTimeline
      {
         var _loc6_:ColorTransform = null;
         var _loc7_:TweensyTimeline = this.setup(param3,param4,param5);
         if(param2 > 0)
         {
            _loc6_ = new ColorTransform(param2,param2,param2,1,param2 * 255,param2 * 255,param2 * 255);
         }
         else
         {
            _loc6_ = new ColorTransform(1 + param2,1 + param2,1 + param2);
         }
         _loc7_.to(param1.transform.colorTransform,_loc6_,param1);
         this.add(_loc7_);
         return _loc7_;
      }
      
      public function keyframeTo(param1:Object, param2:int, param3:Number = 0.5, param4:Function = null, param5:Number = 0) : TweensyTimeline
      {
         var _loc6_:Object = this.getKeyframe(param1,param2);
         if(_loc6_ == null)
         {
            return null;
         }
         var _loc7_:TweensyTimeline = this.setup(param3,param4,param5);
         _loc7_.to(param1,_loc6_);
         this.add(_loc7_);
         return _loc7_;
      }
      
      public function addKeyframe(param1:Object, ... rest) : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = {};
         var _loc5_:Array = keyframes[param1];
         if(!_loc5_)
         {
            _loc5_ = keyframes[param1] = [];
         }
         _loc5_.push(_loc4_);
         for each(_loc3_ in rest)
         {
            _loc4_[_loc3_] = param1[_loc3_];
         }
      }
      
      public function removeKeyframe(param1:Object, param2:int) : int
      {
         var _loc3_:Array = null;
         if(keyframes[param1])
         {
            _loc3_ = keyframes[param1];
            _loc3_.splice(param2,1);
            return _loc3_.length;
         }
         return -1;
      }
      
      public function getKeyframe(param1:Object, param2:int) : Object
      {
         var _loc3_:Array = keyframes[param1];
         if(_loc3_)
         {
            return _loc3_[param2];
         }
         return null;
      }
      
      public function add(param1:TweensyTimeline) : TweensyTimeline
      {
         var _loc2_:Object = null;
         for each(_loc2_ in param1.instances)
         {
            this.addInstance(_loc2_,param1);
         }
         if(!this.hasTimelines)
         {
            this.startUpdate();
         }
         param1.manager = this;
         param1.smartRotate = this.smartRotate;
         param1.snapToClosest = this.snapToClosest;
         param1.autoHide = this.autoHide;
         if(this.first)
         {
            this.first.previous = param1;
         }
         else
         {
            this.last = param1;
         }
         param1.next = this.first;
         this.first = param1;
         this._timelines++;
         return param1;
      }
      
      public function remove(param1:TweensyTimeline) : int
      {
         var _loc2_:Object = null;
         if(param1.manager != this)
         {
            return 0;
         }
         if(param1.previous)
         {
            param1.previous.next = param1.next;
         }
         if(param1.next)
         {
            param1.next.previous = param1.previous;
         }
         if(param1 == this.first)
         {
            this.first = this.first.next;
            if(this.first)
            {
               this.first.previous = null;
            }
         }
         if(param1 == this.last)
         {
            this.last = param1.previous;
            if(this.last)
            {
               this.last.next = null;
            }
         }
         var _loc3_:Array = param1.instances;
         for each(_loc2_ in _loc3_)
         {
            this.removeInstance(_loc2_,param1);
         }
         if(this.useObjectPooling)
         {
            pool.checkIn(param1);
            param1.clear();
         }
         this._timelines--;
         if(!this.hasTimelines)
         {
            this.stopUpdate();
         }
         return this._timelines;
      }
      
      public function addInstance(param1:Object, param2:TweensyTimeline) : void
      {
         var _loc3_:TweensyTimeline = null;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:Array = map[param1];
         if(this.lazyMode)
         {
            if(_loc6_)
            {
               _loc4_ = _loc6_.length - 1;
               _loc5_ = _loc4_;
               while(_loc5_ >= 0)
               {
                  _loc3_ = _loc6_[_loc5_];
                  _loc3_.removeOverlap(param2);
                  _loc5_--;
               }
            }
         }
         if(!_loc6_)
         {
            _loc6_ = map[param1] = [];
         }
         _loc6_[_loc6_.length] = param2;
      }
      
      public function removeInstance(param1:Object, param2:TweensyTimeline) : void
      {
         var _loc3_:* = 0;
         var _loc4_:Array = map[param1];
         if(_loc4_)
         {
            _loc3_ = _loc4_.indexOf(param2);
            if(_loc3_ != -1)
            {
               _loc4_.splice(_loc3_,1);
               if(_loc4_.length == 0)
               {
                  map[param1] = null;
               }
            }
         }
      }
      
      public function stop(param1:* = null, ... rest) : void
      {
         var _loc3_:TweensyTimeline = null;
         var _loc4_:Array = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:Array = map[param1];
         if(_loc7_)
         {
            _loc4_ = [param1].concat(rest);
            _loc5_ = _loc7_.length - 1;
            _loc6_ = _loc5_;
            while(_loc6_ >= 0)
            {
               _loc3_ = _loc7_[_loc6_];
               _loc3_.stop.apply(null,_loc4_);
               _loc6_--;
            }
         }
      }
      
      public function stopAll() : void
      {
         var _loc1_:TweensyTimeline = null;
         if(this._timelines > 0)
         {
            _loc1_ = this.first;
         }
         while(_loc1_)
         {
            _loc1_.stopAll();
            _loc1_ = _loc1_.next;
         }
      }
      
      public function pause() : void
      {
         this._paused = true;
         var _loc1_:TweensyTimeline = this.first;
         while(_loc1_)
         {
            _loc1_.pause();
            _loc1_ = _loc1_.next;
         }
      }
      
      public function resume() : void
      {
         this._paused = false;
         var _loc1_:TweensyTimeline = this.first;
         while(_loc1_)
         {
            _loc1_.resume();
            _loc1_ = _loc1_.next;
         }
      }
      
      public function get paused() : Boolean
      {
         return this._paused;
      }
      
      public function get hasTimelines() : Boolean
      {
         return this._timelines > 0;
      }
      
      public function get timelines() : int
      {
         return this._timelines;
      }
      
      private function setup(param1:Number, param2:Function, param3:Number, param4:Function = null, param5:Array = null) : TweensyTimeline
      {
         var _loc6_:TweensyTimeline = null;
         if(this.useObjectPooling)
         {
            _loc6_ = pool.checkOut();
         }
         else
         {
            _loc6_ = new TweensyTimeline();
         }
         _loc6_.manager = this;
         _loc6_.duration = param1;
         if(param2 != null)
         {
            _loc6_.ease = param2;
         }
         _loc6_.delayStart = param3;
         _loc6_.onComplete = param4;
         _loc6_.onCompleteParams = param5;
         return _loc6_;
      }
      
      private function startUpdate() : void
      {
         this.time = getTimer();
		 nFrame.addEventListener(Event.ENTER_FRAME,this.update,false,0,true);
      }
      
      private function stopUpdate() : void
      {
		  nFrame.removeEventListener(Event.ENTER_FRAME,this.update);
      }
      
      private function update(param1:Event) : void
      {
         var _loc2_:TweensyTimeline = null;
         var _loc3_:TweensyTimeline = this.first;
         var _loc4_:Number = this.secondsPerFrame;
         if(this.refreshType == Tweensy.TIME)
         {
            _loc4_ = getTimer() - this.time;
            this.time = this.time + _loc4_;
            _loc4_ = _loc4_ * 0.001;
         }
         while(_loc3_)
         {
            _loc2_ = _loc3_.next;
            if(_loc3_.update(_loc4_))
            {
               this.remove(_loc3_);
            }
            _loc3_ = _loc2_;
         }
         if(this.onUpdate != null)
         {
            this.onUpdate.apply(this,this.onUpdateParams);
         }
         if(!this.hasTimelines && !(this.onComplete == null))
         {
            this.onComplete.apply(this,this.onCompleteParams);
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
         this.first = null;
         this.last = null;
         this.onComplete = null;
         this.onCompleteParams = null;
         this.onUpdate = null;
         this.onUpdateParams = null;
         this._timelines = 0;
      }
      
      public function toString() : String
      {
         return "TweensyGroup " + Tweensy.version + " {timelines:" + this._timelines + "}";
      }
   }
}
