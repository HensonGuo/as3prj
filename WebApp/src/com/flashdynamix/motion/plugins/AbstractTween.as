package com.flashdynamix.motion.plugins
{
   import com.flashdynamix.motion.TweensyTimeline;
   
   public class AbstractTween extends Object
   {
      
      public function AbstractTween()
      {
         this.propNames = {};
         super();
      }
      
      public var inited:Boolean = false;
      
      public var timeline:TweensyTimeline;
      
      protected var propNames:Object;
      
      protected var _propCount:int = 0;
      
      public function construct(... rest) : void
      {
         this.inited = false;
      }
      
      protected function set to(param1:Object) : void
      {
      }
      
      protected function get to() : Object
      {
         return null;
      }
      
      protected function set from(param1:Object) : void
      {
      }
      
      protected function get from() : Object
      {
         return null;
      }
      
      public function get current() : Object
      {
         return null;
      }
      
      public function get instance() : Object
      {
         return this.current;
      }
      
      protected function get properties() : Number
      {
         return this._propCount;
      }
      
      public function get hasAnimations() : Boolean
      {
         return this._propCount > 0;
      }
      
      public function add(param1:String, param2:*, param3:Boolean) : void
      {
         if(param3)
         {
            this.to[param1] = this.current[param1];
            this.current[param1] = this.translate(param1,param2);
         }
         else
         {
            this.to[param1] = this.translate(param1,param2);
         }
         if(!this.propNames[param1])
         {
            this.propNames[param1] = true;
            this._propCount++;
         }
      }
      
      public function remove(param1:String) : void
      {
         if(this.propNames[param1] == null)
         {
            return;
         }
         delete this.propNames[param1];
         true;
         this._propCount--;
      }
      
      public function has(param1:String) : Boolean
      {
         return !(this.propNames[param1] == null);
      }
      
      public function toTarget(param1:Object) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in param1)
         {
            this.add(_loc2_,param1[_loc2_],false);
         }
      }
      
      public function fromTarget(param1:Object) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in param1)
         {
            this.add(_loc2_,param1[_loc2_],true);
         }
      }
      
      public function updateTo(param1:Number, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         for(_loc3_ in param2)
         {
            if(this.has(_loc3_))
            {
               _loc4_ = param2[_loc3_];
               _loc5_ = (_loc4_ - this.current[_loc3_]) * 1 / (1 - param1);
               this.from[_loc3_] = _loc4_ - _loc5_;
               this.to[_loc3_] = _loc4_;
            }
         }
      }
      
      public function removeOverlap(param1:AbstractTween) : void
      {
         var _loc2_:String = null;
         if(this.match(param1))
         {
            for(_loc2_ in param1.propNames)
            {
               this.remove(_loc2_);
            }
         }
      }
      
      public function match(param1:AbstractTween) : Boolean
      {
         return param1.instance == this.instance;
      }
      
      public function stop(... rest) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = rest.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.remove(rest[_loc2_]);
            _loc2_++;
         }
      }
      
      public function stopAll() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this.propNames)
         {
            this.remove(_loc1_);
         }
      }
      
      public function update(param1:Number) : void
      {
      }
      
      public function swapToFrom() : void
      {
         var _loc1_:Object = this.to;
         this.to = this.from;
         this.from = _loc1_;
      }
      
      public function apply() : void
      {
      }
      
      public function clear() : void
      {
         this.stopAll();
         this.timeline = null;
      }
      
      public function dispose() : void
      {
         this.propNames = null;
         this.timeline = null;
      }
      
      protected function translate(param1:String, param2:*) : Number
      {
         var _loc3_:* = NaN;
         var _loc4_:Array = null;
         var _loc5_:* = NaN;
         var _loc6_:* = NaN;
         var _loc7_:Number = this.current[param1];
         if(param2 is String)
         {
            _loc4_ = String(param2).split(",");
            if(_loc4_.length == 1)
            {
               _loc3_ = _loc7_ + parseFloat(param2);
            }
            else
            {
               _loc5_ = parseFloat(_loc4_[0]);
               _loc6_ = parseFloat(_loc4_[1]);
               _loc3_ = _loc7_ + _loc5_ + Math.random() * (_loc6_ - _loc5_);
            }
         }
         else
         {
            _loc3_ = param2;
         }
         return _loc3_;
      }
      
      protected function smartRotate(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = 180;
         var _loc4_:Number = _loc3_ * 2;
         var param1:Number = Math.abs(param1) > _loc4_?param1 < 0?param1 % _loc4_ + _loc4_:param1 % _loc4_:param1;
         var param2:Number = Math.abs(param2) > _loc4_?param2 < 0?param2 % _loc4_ + _loc4_:param2 % _loc4_:param2;
         param2 = param2 + (Math.abs(param2 - param1) < _loc3_?0:param2 - param1 > 0?-_loc4_:_loc4_);
         return param2;
      }
   }
}
