package simpleastar
{
   import flash.display.Sprite;
   import flash.utils.Timer;
   import flash.events.KeyboardEvent;
   import flash.events.TimerEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   
   public class Maps extends Sprite
   {
      
      public function Maps()
      {
         mapArr = new Array();
         timer_i = 0;
         super();
         init();
      }
      
      private var roadTimer:Timer;
      
      private function init() : void
      {
         w = 98;
         h = 60;
         wh = 9;
         goo = 0.3;
         createMaps();
         roadMens();
         roadTimer = new Timer(80,0);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDowns);
      }
      
      private function MC_play(param1:Array) : void
      {
         var _loc2_:* = undefined;
         param1.reverse();
         roadTimer.stop();
         timer_i = 0;
         roadTimer.addEventListener(TimerEvent.TIMER,goMap);
         roadTimer.start();
         for each(_loc2_ in param1)
         {
            _loc2_.alpha = 0.3;
         }
      }
      
      private function drawRect(param1:uint) : MovieClip
      {
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         _loc2_ = new MovieClip();
         switch(param1)
         {
            case 0:
               _loc3_ = 10066329;
               break;
            case 1:
               _loc3_ = 0;
               break;
            default:
               _loc3_ = 16711680;
         }
         _loc2_.graphics.beginFill(_loc3_);
         _loc2_.graphics.lineStyle(0.2,16777215);
         _loc2_.graphics.drawRect(0,0,wh,wh);
         _loc2_.graphics.endFill();
         return _loc2_;
      }
      
      private function goMap(param1:TimerEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = roadList[timer_i];
         roadMen.x = _loc2_.x;
         roadMen.y = _loc2_.y;
         _loc2_.alpha = 1;
         timer_i++;
         if(timer_i >= roadList.length)
         {
            roadTimer.stop();
         }
      }
      
      private var map:Sprite;
      
      private var h:uint;
      
      private var mapArr:Array;
      
      private var w:uint;
      
      private var goo:Number;
      
      private var roadMen:MovieClip;
      
      private function roadMens() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         roadMen = drawRect(2);
         _loc1_ = Math.round(Math.random() * (w - 1));
         _loc2_ = Math.round(Math.random() * (h - 1));
         roadMen.px = _loc1_;
         roadMen.py = _loc2_;
         roadMen.x = _loc1_ * wh;
         roadMen.y = _loc2_ * wh;
         mapArr[_loc2_][_loc1_].go = 0;
         map.addChild(roadMen);
      }
      
      private function createMaps() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         map = new Sprite();
         map.x = wh;
         map.y = wh;
         addChild(map);
         map.addEventListener(MouseEvent.MOUSE_DOWN,mapMousedown);
         _loc1_ = 0;
         while(_loc1_ < h)
         {
            mapArr.push(new Array());
            _loc2_ = 0;
            while(_loc2_ < w)
            {
               _loc3_ = Math.round(Math.random() - goo);
               _loc4_ = drawRect(_loc3_);
               mapArr[_loc1_].push(_loc4_);
               mapArr[_loc1_][_loc2_].px = _loc2_;
               mapArr[_loc1_][_loc2_].py = _loc1_;
               mapArr[_loc1_][_loc2_].go = _loc3_;
               mapArr[_loc1_][_loc2_].x = _loc2_ * wh;
               mapArr[_loc1_][_loc2_].y = _loc1_ * wh;
               map.addChild(mapArr[_loc1_][_loc2_]);
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public var roadinf:TextField;
      
      private var wh:uint;
      
      private function mapMousedown(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:ARoad = null;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = undefined;
         _loc2_ = Math.floor((mouseX - map.x) / wh);
         _loc3_ = Math.floor((mouseY - map.y) / wh);
         _loc4_ = mapArr[_loc3_][_loc2_];
         if(_loc4_.go == 0)
         {
            if(roadList)
            {
               for each(_loc8_ in roadList)
               {
                  _loc8_.alpha = 1;
               }
               roadList = [];
            }
            roadTimer.stop();
            roadMen.px = Math.floor(roadMen.x / wh);
            roadMen.py = Math.floor(roadMen.y / wh);
            _loc5_ = new ARoad();
            _loc6_ = new Date().getTime();
            roadList = _loc5_.searchRoad(roadMen,_loc4_,mapArr);
            _loc7_ = new Date().getTime() - _loc6_;
            if(roadList.length > 0)
            {
               roadinf.htmlText = "本次寻路<FONT color=\'#00ff00\'>" + _loc7_.toString() + "</FONT> 毫秒";
               roadLen.htmlText = "路径长度：<FONT color=\'#00ff00\'>" + roadList.length.toString() + "</FONT>";
               MC_play(roadList);
            }
            else
            {
               roadinf.htmlText = "对不起，无路可走";
            }
         }
      }
      
      public var roadLen:TextField;
      
      private var roadList:Array;
      
      private var timer_i:uint = 0;
      
      private function keyDowns(param1:KeyboardEvent) : *
      {
         var _loc2_:* = undefined;
         _loc2_ = param1.keyCode;
         if(_loc2_ == Keyboard.SPACE)
         {
            removeChild(map);
            mapArr = [];
            createMaps();
            roadMens();
            roadTimer.stop();
         }
      }
   }
}
