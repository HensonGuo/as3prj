package simpleastar
{
   import flash.display.Sprite;
   import flash.display.MovieClip;
   
   public class ARoad extends Sprite
   {
      
      public function ARoad()
      {
         openList = new Array();
         closeList = new Array();
         roadArr = new Array();
         super();
      }
      
      private function setGHF(param1:MovieClip, param2:MovieClip, param3:*) : *
      {
         if(!param2.G)
         {
            param2.G = 0;
         }
         param1.G = param2.G + param3;
         param1.H = (Math.abs(param1.px - endPoint.px) + Math.abs(param1.py - endPoint.py)) * 10;
         param1.F = param1.H + param1.G;
         param1.father = param2;
      }
      
      private var openList:Array;
      
      private function inArr(param1:MovieClip, param2:Array) : Boolean
      {
         var _loc3_:* = undefined;
         for each(_loc3_ in param2)
         {
            if(param1 == _loc3_)
            {
               return true;
            }
         }
         return false;
      }
      
      private function checkG(param1:MovieClip, param2:MovieClip) : *
      {
         var _loc3_:* = undefined;
         _loc3_ = param2.G + 10;
         if(_loc3_ <= param1.G)
         {
            param1.G = _loc3_;
            param1.F = param1.H + _loc3_;
            param1.father = param2;
         }
      }
      
      private var roadArr:Array;
      
      private var startPoint:MovieClip;
      
      private function addAroundPoint(param1:MovieClip) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = param1.px;
         _loc3_ = param1.py;
         if(_loc2_ > 0 && mapArr[_loc3_][_loc2_ - 1].go == 0)
         {
            if(!inArr(mapArr[_loc3_][_loc2_ - 1],closeList))
            {
               if(!inArr(mapArr[_loc3_][_loc2_ - 1],openList))
               {
                  setGHF(mapArr[_loc3_][_loc2_ - 1],param1,10);
                  openList.push(mapArr[_loc3_][_loc2_ - 1]);
               }
               else
               {
                  checkG(mapArr[_loc3_][_loc2_ - 1],param1);
               }
            }
            if(_loc3_ > 0 && mapArr[_loc3_ - 1][_loc2_ - 1].go == 0 && mapArr[_loc3_ - 1][_loc2_].go == 0)
            {
               if(!inArr(mapArr[_loc3_ - 1][_loc2_ - 1],closeList) && !inArr(mapArr[_loc3_ - 1][_loc2_ - 1],openList))
               {
                  setGHF(mapArr[_loc3_ - 1][_loc2_ - 1],param1,14);
                  openList.push(mapArr[_loc3_ - 1][_loc2_ - 1]);
               }
            }
            if(_loc3_ < h && mapArr[_loc3_ + 1][_loc2_ - 1].go == 0 && mapArr[_loc3_ + 1][_loc2_].go == 0)
            {
               if(!inArr(mapArr[_loc3_ + 1][_loc2_ - 1],closeList) && !inArr(mapArr[_loc3_ + 1][_loc2_ - 1],openList))
               {
                  setGHF(mapArr[_loc3_ + 1][_loc2_ - 1],param1,14);
                  openList.push(mapArr[_loc3_ + 1][_loc2_ - 1]);
               }
            }
         }
         if(_loc2_ < w && mapArr[_loc3_][_loc2_ + 1].go == 0)
         {
            if(!inArr(mapArr[_loc3_][_loc2_ + 1],closeList))
            {
               if(!inArr(mapArr[_loc3_][_loc2_ + 1],openList))
               {
                  setGHF(mapArr[_loc3_][_loc2_ + 1],param1,10);
                  openList.push(mapArr[_loc3_][_loc2_ + 1]);
               }
               else
               {
                  checkG(mapArr[_loc3_][_loc2_ + 1],param1);
               }
            }
            if(_loc3_ > 0 && mapArr[_loc3_ - 1][_loc2_ + 1].go == 0 && mapArr[_loc3_ - 1][_loc2_].go == 0)
            {
               if(!inArr(mapArr[_loc3_ - 1][_loc2_ + 1],closeList) && !inArr(mapArr[_loc3_ - 1][_loc2_ + 1],openList))
               {
                  setGHF(mapArr[_loc3_ - 1][_loc2_ + 1],param1,14);
                  openList.push(mapArr[_loc3_ - 1][_loc2_ + 1]);
               }
            }
            if(_loc3_ < h && mapArr[_loc3_ + 1][_loc2_ + 1].go == 0 && mapArr[_loc3_ + 1][_loc2_].go == 0)
            {
               if(!inArr(mapArr[_loc3_ + 1][_loc2_ + 1],closeList) && !inArr(mapArr[_loc3_ + 1][_loc2_ + 1],openList))
               {
                  setGHF(mapArr[_loc3_ + 1][_loc2_ + 1],param1,14);
                  openList.push(mapArr[_loc3_ + 1][_loc2_ + 1]);
               }
            }
         }
         if(_loc3_ > 0 && mapArr[_loc3_ - 1][_loc2_].go == 0)
         {
            if(!inArr(mapArr[_loc3_ - 1][_loc2_],closeList))
            {
               if(!inArr(mapArr[_loc3_ - 1][_loc2_],openList))
               {
                  setGHF(mapArr[_loc3_ - 1][_loc2_],param1,10);
                  openList.push(mapArr[_loc3_ - 1][_loc2_]);
               }
               else
               {
                  checkG(mapArr[_loc3_ - 1][_loc2_],param1);
               }
            }
         }
         if(_loc3_ < h && mapArr[_loc3_ + 1][_loc2_].go == 0)
         {
            if(!inArr(mapArr[_loc3_ + 1][_loc2_],closeList))
            {
               if(!inArr(mapArr[_loc3_ + 1][_loc2_],openList))
               {
                  setGHF(mapArr[_loc3_ + 1][_loc2_],param1,10);
                  openList.push(mapArr[_loc3_ + 1][_loc2_]);
               }
               else
               {
                  checkG(mapArr[_loc3_ + 1][_loc2_],param1);
               }
            }
         }
      }
      
      private var h:uint;
      
      private var mapArr:Array;
      
      private var endPoint:MovieClip;
      
      private var isPath:Boolean;
      
      private var w:uint;
      
      private var isSearch:Boolean;
      
      private function getMinF() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:* = undefined;
         _loc1_ = 100000000;
         _loc2_ = 0;
         for each(_loc4_ in openList)
         {
            if(_loc4_.F < _loc1_)
            {
               _loc1_ = _loc4_.F;
               _loc3_ = _loc2_;
            }
            _loc2_++;
         }
         return _loc3_;
      }
      
      private var closeList:Array;
      
      public function searchRoad(param1:MovieClip, param2:MovieClip, param3:Array) : *
      {
         var _loc4_:MovieClip = null;
         startPoint = param1;
         endPoint = param2;
         mapArr = param3;
         w = mapArr[0].length - 1;
         h = mapArr.length - 1;
         openList.push(startPoint);
         while(openList.length >= 1)
         {
            _loc4_ = openList.splice(getMinF(),1)[0];
            if(_loc4_ == endPoint)
            {
               while(_loc4_.father != startPoint.father)
               {
                  roadArr.push(_loc4_);
                  _loc4_ = _loc4_.father;
               }
               return roadArr;
            }
            closeList.push(_loc4_);
            addAroundPoint(_loc4_);
         }
         return roadArr;
      }
   }
}
