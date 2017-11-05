package com.flashdynamix.motion.plugins
{
   import flash.geom.Matrix;
   import flash.display.DisplayObject;
   
   public class MatrixTween extends AbstractTween
   {
      
      public function MatrixTween()
      {
         super();
         this._to = new Matrix();
         this._from = new Matrix();
      }
      
      private var _current:Matrix;
      
      protected var _to:Matrix;
      
      protected var _from:Matrix;
      
      public var displayObject:DisplayObject;
      
      override public function construct(... rest) : void
      {
         super.construct();
         this._current = rest[0];
         this.displayObject = rest[1];
         this.apply();
      }
      
      override protected function set to(param1:Object) : void
      {
         this._to = param1 as Matrix;
      }
      
      override protected function get to() : Object
      {
         return this._to;
      }
      
      override protected function set from(param1:Object) : void
      {
         this._from = param1 as Matrix;
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
         return this.displayObject?this.displayObject:this.current;
      }
      
      override public function match(param1:AbstractTween) : Boolean
      {
         return param1 is MatrixTween && (this.current == param1.current || !((param1 as MatrixTween).displayObject == null) && this.displayObject == (param1 as MatrixTween).displayObject);
      }
      
      override public function toTarget(param1:Object) : void
      {
         var _loc2_:Matrix = null;
         if(param1 is Matrix)
         {
            _loc2_ = param1 as Matrix;
            add("tx",_loc2_.tx,false);
            add("ty",_loc2_.ty,false);
            add("a",_loc2_.a,false);
            add("b",_loc2_.b,false);
            add("c",_loc2_.c,false);
            add("d",_loc2_.d,false);
         }
         else
         {
            super.toTarget(param1);
         }
      }
      
      override public function fromTarget(param1:Object) : void
      {
         var _loc2_:Matrix = null;
         if(param1 is Matrix)
         {
            _loc2_ = param1 as Matrix;
            add("tx",_loc2_.tx,true);
            add("ty",_loc2_.ty,true);
            add("a",_loc2_.a,true);
            add("b",_loc2_.b,true);
            add("c",_loc2_.c,true);
            add("d",_loc2_.d,true);
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
            if(this.displayObject)
            {
               this._current = this.displayObject.transform.matrix;
               this._from = this.displayObject.transform.matrix;
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
            if(_loc2_ == "tx")
            {
               this._current.tx = this._from.tx * _loc3_ + this._to.tx * param1;
            }
            else if(_loc2_ == "ty")
            {
               this._current.ty = this._from.ty * _loc3_ + this._to.ty * param1;
            }
            else if(_loc2_ == "a")
            {
               this._current.a = this._from.a * _loc3_ + this._to.a * param1;
            }
            else if(_loc2_ == "b")
            {
               this._current.b = this._from.b * _loc3_ + this._to.b * param1;
            }
            else if(_loc2_ == "c")
            {
               this._current.c = this._from.c * _loc3_ + this._to.c * param1;
            }
            else if(_loc2_ == "d")
            {
               this._current.d = this._from.d * _loc3_ + this._to.d * param1;
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
         if(this.displayObject == null)
         {
            return;
         }
         this.displayObject.transform.matrix = this._current;
      }
      
      override public function dispose() : void
      {
         this._to = null;
         this._from = null;
         this._current = null;
         this.displayObject = null;
         super.dispose();
      }
   }
}
