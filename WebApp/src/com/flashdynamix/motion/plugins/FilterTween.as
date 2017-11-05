package com.flashdynamix.motion.plugins
{
   import flash.utils.Dictionary;
   import flash.filters.BitmapFilter;
   import flash.display.DisplayObject;
   import flash.filters.ColorMatrixFilter;
   
   public class FilterTween extends AbstractTween
   {
      
      public function FilterTween()
      {
         super();
         this._to = {};
         this._from = {};
      }
      
      public static var filters:Dictionary = new Dictionary(true);
      
      private var _current:Object;
      
      protected var _to:Object;
      
      protected var _from:Object;
      
      protected var _filter:BitmapFilter;
      
      public var displayObject:DisplayObject;
      
      protected var filterList:Array;
      
      override public function construct(... rest) : void
      {
         super.construct();
         this._filter = rest[0];
         this.displayObject = rest[1];
         if(this._filter is ColorMatrixFilter)
         {
            this._current = ColorMatrixFilter(this._filter).matrix;
         }
         else
         {
            this._current = this._filter;
         }
         this.filterList = filters[this.displayObject];
         if(this.filterList == null || !(this.filterList.length == this.displayObject.filters.length))
         {
            this.filterList = filters[this.displayObject] = this.displayObject.filters;
         }
         if(this.filterList.indexOf(this._filter) == -1)
         {
            this.filterList.push(this._filter);
         }
         this.apply();
      }
      
      override protected function set to(param1:Object) : void
      {
         this._to = param1;
      }
      
      override protected function get to() : Object
      {
         return this._to;
      }
      
      override protected function set from(param1:Object) : void
      {
         this._from = param1;
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
         return param1 is FilterTween && (this.current == param1.current || !((param1 as FilterTween).displayObject == null) && this.displayObject == (param1 as FilterTween).displayObject);
      }
      
      override public function update(param1:Number) : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = 1 - param1;
         if(!inited && _propCount > 0)
         {
            for(_loc2_ in propNames)
            {
               this._from[_loc2_] = this._current[_loc2_];
            }
            inited = true;
         }
         for(_loc2_ in propNames)
         {
            this._current[_loc2_] = this._from[_loc2_] * _loc3_ + this._to[_loc2_] * param1;
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
         if(this._filter is ColorMatrixFilter)
         {
            ColorMatrixFilter(this._filter).matrix = this._current as Array;
         }
         this.displayObject.filters = this.filterList;
      }
      
      override public function dispose() : void
      {
         this._filter = null;
         this._current = null;
         this.displayObject = null;
         this.filterList = null;
         super.dispose();
      }
   }
}
