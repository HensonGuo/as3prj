package com.flashdynamix.motion.plugins
{
   import flash.media.SoundTransform;
   
   public class SoundTween extends AbstractTween
   {
      
      public function SoundTween()
      {
         super();
         this._to = new SoundTransform();
         this._from = new SoundTransform();
      }
      
      private var _current:SoundTransform;
      
      protected var _to:SoundTransform;
      
      protected var _from:SoundTransform;
      
      public var updateObject:Object;
      
      override public function construct(... rest) : void
      {
         super.construct();
         this._current = rest[0];
         this.updateObject = rest[1];
         this.apply();
      }
      
      override protected function set to(param1:Object) : void
      {
         this._to = param1 as SoundTransform;
      }
      
      override protected function get to() : Object
      {
         return this._to;
      }
      
      override protected function set from(param1:Object) : void
      {
         this._from = param1 as SoundTransform;
      }
      
      override protected function get from() : Object
      {
         return this._from;
      }
      
      override public function get current() : Object
      {
         return this._current;
      }
      
      override public function get instance() : Object
      {
         return this.updateObject?this.updateObject:this.current;
      }
      
      override public function match(param1:AbstractTween) : Boolean
      {
         return param1 is SoundTween && (this.current == param1.current || !((param1 as SoundTween).updateObject == null) && this.updateObject == (param1 as SoundTween).updateObject);
      }
      
      override public function toTarget(param1:Object) : void
      {
         var _loc2_:SoundTransform = null;
         if(param1 is SoundTransform)
         {
            _loc2_ = param1 as SoundTransform;
            add("volume",_loc2_.volume,false);
            add("pan",_loc2_.pan,false);
         }
         else
         {
            super.toTarget(param1);
         }
      }
      
      override public function fromTarget(param1:Object) : void
      {
         var _loc2_:SoundTransform = null;
         if(param1 is SoundTransform)
         {
            _loc2_ = param1 as SoundTransform;
            add("volume",_loc2_.volume,true);
            add("pan",_loc2_.pan,true);
         }
         else
         {
            super.fromTarget(param1);
         }
      }
      
      override public function update(param1:Number) : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = 1 - param1;
         if(!inited && _propCount > 0)
         {
            if(this.updateObject)
            {
               this._current = this.updateObject.soundTransform;
               this._from = this.updateObject.soundTransform;
            }
            else
            {
               for(_loc2_ in propNames)
               {
                  this._from[_loc2_] = this._current[_loc2_];
               }
            }
            inited = true;
         }
         for(_loc2_ in propNames)
         {
            if(_loc2_ == "volume")
            {
               this._current.volume = this._from.volume * _loc3_ + this._to.volume * param1;
            }
            else if(_loc2_ == "pan")
            {
               this._current.pan = this._from.pan * _loc3_ + this._to.pan * param1;
            }
            else
            {
               this._current[_loc2_] = this._from[_loc2_] * _loc3_ + this._to[_loc2_] * param1;
            }
            
            if(timeline.snapToClosest)
            {
               this._current[_loc2_] = Math.round(this._current[_loc2_]);
            }
         }
         this.apply();
      }
      
      override public function apply() : void
      {
         if(this.updateObject == null)
         {
            return;
         }
         this.updateObject.soundTransform = this._current;
      }
      
      override public function dispose() : void
      {
         this._to = null;
         this._from = null;
         this._current = null;
         this.updateObject = null;
         super.dispose();
      }
   }
}
