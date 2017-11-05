package slider.slidershow1
{
   import com.flashdynamix.motion.Tweensy;
   
   import fl.motion.easing.*;
   
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import flash.filters.BlurFilter;
   import flash.geom.ColorTransform;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.*;
   import flash.utils.Timer;
   
   import loader.type.LoadResType;
   
   import utils.ConfigAnalysis;
   
   /**
    *http://www.vosmel.com/#/shipin/53 
    * @author g7842
    */   
   public class Slideshow extends Sprite
   {
	  private var  _config:SlideData;
      private var _background:Sprite;
      private var _shadow:Sprite;
	  
      private var _slideContainer:Sprite;
      private var _slideOne:Sprite;
      private var _slideTwo:Sprite;
      private var _currentSlide:Sprite;
      
      private var _playBtn:PlayButton;
      private var _prevBtn:PrevButton;
      private var _nextBtn:NextButton;
      private var _btnsContainer:Sprite;
      
      private var _firstLoad:Boolean = true;
      
      private var _image:Bitmap;
      private var _imgIdx:uint = 0;
      
      
      private var _textBgColor:ColorTransform;
      
      private var _showTextIndex:int = 0;
      
      private var _showTextArray:Array;
      
      private var _showTextTimer:Timer;
      
      private var _slideshowTimer:Timer;
      
      private var _timerBar:Shape;
      
      private var _slideInMask:Sprite;
      private var _squareOutMask:Sprite;
      
      private var _squareOutArray:Array;
      
      private var _squareOutTotal:int;
      
      private var _squareOutCols:int;
      
      private var _squareOutRows:int;
      
      private var _squareOutTimer:Timer;
      
      private var _squareOutIdx:int;
      
      private var _squareInMask:Sprite;
      
      private var _squareInArray:Array;
      
      private var _squareInTotal:int;
      
      private var _squareInCols:int;
      
      private var _squareInRows:int;
      
      private var _squareInTimer:Timer;
      
      private var _squareInTLIdx:int;
      
      private var _squareInTRIdx:int;
      
      private var _squareInBLIdx:int;
      
      private var _squareInBRIdx:int;
      
      private var _topLeftCell:int;
      
      private var _topRightCell:int;
      
      private var _btmLeftCell:int;
      
      private var _btmRightCell:int;
      
      public function Slideshow()
      {
         super();
         if(stage)
            init();
         else
            addEventListener(Event.ADDED_TO_STAGE, init);
         addEventListener(Event.REMOVED_FROM_STAGE,removedFromStage);
      }
      
      private function init(param1:Event = null) : void
      {
		 if(!FrameWork.isStarted)
			 FrameWork.start(false, stage);
		 stage.align = StageAlign.TOP_LEFT;
		 stage.scaleMode = StageScaleMode.NO_SCALE;
         removeEventListener(Event.ADDED_TO_STAGE,init);
		 _config = ConfigAnalysis.loadXML("slideshow1/slideshow2.xml", SlideData, configFileLoaded) as SlideData;
      }
      
      private function configFileLoaded() : void
      {
         addElements();
      }
      
      private function addElements() : void
      {
         _background = new Sprite();
         _background.graphics.lineStyle(0,_config.mediaBgColor,_config.mediaBgOpacity / 100,true,"none");
         _background.graphics.beginFill(_config.mediaBgColor,_config.mediaBgOpacity / 100);
         _background.graphics.drawRect(0,0,Number(_config.mediaWidth) + 2 * Number(_config.mediaPaddingX),Number(_config.mediaHeight) + 2 * _config.mediaPaddingY);
         _background.graphics.endFill();
         addChild(_background);
		 
         _shadow = new Sprite();
         _shadow.graphics.beginFill(0,_config.backgroundShadowOpacity / 100);
         _shadow.graphics.drawEllipse(0,0,_background.width - 100,20);
         _shadow.graphics.endFill();
         _shadow.filters = [new BlurFilter(_config.backgroundShadowBlur,_config.backgroundShadowBlur,3)];
         _shadow.alpha = _config.backgroundShadowOpacity / 100;
         addChildAt(_shadow,0);
         _shadow.x = (_background.width - _shadow.width) * 0.5;
         _shadow.y = _background.height;
		 
         _slideOne = new Sprite();
         _slideTwo = new Sprite();
         _slideContainer = new Sprite();
         _slideContainer.addChild(_slideOne);
         _slideContainer.addChild(_slideTwo);
         _slideContainer.x = _config.mediaPaddingX;
         _slideContainer.y = _config.mediaPaddingY;
         addChild(_slideContainer);
         _currentSlide = _slideTwo;
		 
         var mask:Sprite = new Sprite();
         mask.graphics.beginFill(0,1);
         mask.graphics.drawRect(0,0,_config.mediaWidth,_config.mediaHeight);
         mask.graphics.endFill();
         addChild(mask);
         mask.x = _config.mediaPaddingX;
         mask.y = _config.mediaPaddingY;
         _slideContainer.mask = mask;
		 
         _timerBar = new Shape();
         _timerBar.graphics.beginFill(_config.timerBarColor,_config.timerBarOpacity / 100);
         _timerBar.graphics.drawRect(0,0,1,_config.timerBarHeight);
         _timerBar.graphics.endFill();
         _timerBar.x = _config.mediaPaddingX;
         _timerBar.y = _config.mediaPaddingY;
         addChild(_timerBar);
		 
        _prevBtn = new PrevButton();
		_prevBtn.applyConfig(_config);
		 
         _nextBtn = new NextButton();
         _nextBtn.x = _prevBtn.width + 1;
		 _nextBtn.applyConfig(_config);
		 
         _playBtn = new PlayButton();
         _playBtn.x = _nextBtn.x + _nextBtn.width + 1;
		 _playBtn.applyConfig(_config);
         if(_config.autoStart)
            _playBtn.playArrow.visible = false;
         else
            _playBtn.pauseArrow.visible = false;
		 
         _btnsContainer = new Sprite();
         _btnsContainer.addChild(_prevBtn);
         _btnsContainer.addChild(_nextBtn);
         _btnsContainer.addChild(_playBtn);
         addChild(_btnsContainer);
         _btnsContainer.visible = _config.showButtons;
		 this.addEventListener(MouseEvent.CLICK, onMouseClick);
		 
		 switch(_config.btnAlign)
		 {
			 case "center":
	             _btnsContainer.x = (_background.width - _btnsContainer.width) * 0.5;
				 break;
			 case "right":
	             _btnsContainer.x = _background.width - _btnsContainer.width - Number(_config.mediaPaddingX) - 2;
				 break;
			 case "left":
	             _btnsContainer.x = Number(_config.mediaPaddingX) + 2;
				 break;
		 }
         _btnsContainer.y = _background.height - _btnsContainer.height - Number(_config.mediaPaddingY) - 2;
		 
         currentPic = _config.getImageSrc(_imgIdx);
		 
         _slideshowTimer = new Timer(_config.timer * 1000);
         _slideshowTimer.addEventListener(TimerEvent.TIMER,startSlide);
      }
	  
	  private function onMouseClick(event:MouseEvent):void
	  {
		  switch(event.target)
		  {
			  case _prevBtn:
				  _prevBtn.mouseEnabled = false;
				  _nextBtn.mouseEnabled = false;
				  if(_imgIdx == 0)
					  _imgIdx = _config.imageCount- 1;
				  else
					  _imgIdx--;
				  currentPic = _config.getImageSrc(_imgIdx);
				  break;
			  case _nextBtn:
				  _prevBtn.mouseEnabled = false;
				  _nextBtn.mouseEnabled = false;
				  _imgIdx++;
				  if(_imgIdx == _config.imageCount)
					  _imgIdx = 0;
				  currentPic = _config.getImageSrc(_imgIdx);
				  break;
			  case _playBtn:
				  if(_config.autoStart)
				  {
					  _slideshowTimer.stop();
					  _playBtn.pauseArrow.visible = false;
					  _playBtn.playArrow.visible = true;
					  _config.autoStart = false;
				  }
				  else if(!_config.autoStart)
				  {
					  _slideshowTimer.start();
					  Tweensy.to(_timerBar,{"width":_config.mediaWidth},_config.timer,Linear.easeNone);
					  _playBtn.pauseArrow.visible = true;
					  _playBtn.playArrow.visible = false;
					  _config.autoStart = true;
				  }
				  break;
		  }
	  }
      
      private function startSlide(param1:TimerEvent) : void
      {
         _prevBtn.mouseEnabled = false;
         _nextBtn.mouseEnabled = false;
         _imgIdx++;
         _slideshowTimer.stop();
         if(_imgIdx == _config.imageCount)
         {
            _imgIdx = 0;
         }
         currentPic = _config.getImageSrc(_imgIdx);
      }
      
      private function set currentPic(url:String) : void
      {
         if(_currentSlide == _slideTwo)
         {
            _currentSlide = _slideOne;
         }
         else
         {
            _currentSlide = _slideTwo;
         }
         _slideContainer.swapChildren(_slideTwo,_slideOne);
         _currentSlide.alpha = 0;
		 
		 FrameWork.loaderManager.loadRes(LoadResType.ImageFile, url, imgLoaded, imgLoading);
      }
      
      private function imgLoaded(url:String, bitmap:Bitmap) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
		 if (_image)
		 {
			 _image.bitmapData.dispose();
		 }
         _image = bitmap;
         _image.width = _config.mediaWidth;
         _image.height = _config.mediaHeight;
         _image.smoothing = true;
         _image.cacheAsBitmap = true;
         if(_currentSlide.numChildren > 0)
         {
            _loc2_ = _currentSlide.numChildren - 1;
            while(_loc2_ >= 0)
            {
               _currentSlide.removeChildAt(_loc2_);
               _loc2_--;
            }
         }
         if(_firstLoad)
         {
            _currentSlide.addChild(_image);
            Tweensy.to(_currentSlide,{"alpha":1},0.5,Sine.easeIn,0,null,textInfo);
            _firstLoad = false;
         }
         else
         {
            if(_config.transitionType == "random")
            {
               _loc3_ = Math.floor(Math.random() * 3);
            }
            else if(_config.transitionType == "slideIn")
            {
               _loc3_ = 0;
            }
            else if(_config.transitionType == "squareOut")
            {
               _loc3_ = 1;
            }
            else if(_config.transitionType == "squareIn")
            {
               _loc3_ = 2;
            }
            transition(_loc3_);
         }
         Tweensy.stop(_timerBar);
         _timerBar.width = 0;
         if(_config.autoStart)
         {
            Tweensy.to(_timerBar,{"width":_config.mediaWidth},Number(_config.timer),Linear.easeNone);
         }
         _currentSlide.addEventListener(MouseEvent.CLICK,onCurrentSlideClicked);
         _slideshowTimer.stop();
         if(_config.autoStart)
         {
            _slideshowTimer.start();
			_config.autoStart = true;
         }
      }
      
      private function onCurrentSlideClicked(param1:MouseEvent) : void
      {
		 var link:String = _config.getImageLink(_imgIdx);
         if(link != null && link != "")
            navigateToURL(new URLRequest(link),"_blank");
      }
      
      private function imgLoading( bytesLoaded:Number, bytesTotal:Number) : void
      {
         _timerBar.width = bytesLoaded / bytesTotal * Number(_config.mediaWidth);
      }
      
      private function transition(param1:uint) : void
      {
         switch(param1)
         {
            case 0:
               slideInTrans();
               return;
            case 1:
               squareOut();
               return;
            case 2:
               squareIn();
               return;
            default:
               return;
         }
      }
      
      private function slideInTrans() : void
      {
         var _loc1_:* = 0;
         _slideInMask = new Sprite();
         _slideInMask.graphics.beginFill(16777215,1);
         _slideInMask.graphics.drawRect(0,0,_config.mediaWidth,_config.mediaHeight);
         _slideInMask.graphics.endFill();
         _slideInMask.cacheAsBitmap = true;
         _slideInMask.x = -1.5 * _slideInMask.width;
         _slideInMask.rotation = 15;
         _slideInMask.scaleY = 2;
         _slideInMask.y = -_slideInMask.width / 4;
         _image.alpha = 0;
         if(_currentSlide.numChildren > 0)
         {
            _loc1_ = _currentSlide.numChildren - 1;
            while(_loc1_ >= 0)
            {
               _currentSlide.removeChildAt(_loc1_);
               _loc1_--;
            }
         }
         _currentSlide.addChild(_slideInMask);
         _currentSlide.addChild(_image);
         _image.mask = _slideInMask;
         _image.x = -30;
         _currentSlide.alpha = 1;
         if(_currentSlide == _slideTwo && _slideOne.numChildren == 1)
         {
            Tweensy.to(_slideOne.getChildAt(0),{"x":10},1,Linear.easeNone,0.3);
         }
         else if(_currentSlide == _slideTwo)
         {
            Tweensy.to(_slideOne.getChildAt(1),{"x":10},1,Linear.easeNone,0.3);
         }
         else
         {
            Tweensy.to(_slideTwo.getChildAt(1),{"x":10},1,Linear.easeNone,0.3);
         }
         
         Tweensy.to(_image,{"alpha":1},0.8,Linear.easeNone,0,null,slideInTransTweenCom);
         Tweensy.to(_image,{"x":0},0.7,Linear.easeNone);
         Tweensy.to(_slideInMask,{"x":0},0.7,Linear.easeNone);
         Tweensy.to(_slideInMask,{"rotation":0},0.3,Linear.easeNone,0.5);
      }
      
      private function slideInTransTweenCom() : void
      {
         _prevBtn.mouseEnabled = true;
         _nextBtn.mouseEnabled = true;
         textInfo();
      }
      
      private function squareOut() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Sprite = null;
         var _loc3_:* = 0;
         var _loc6_:uint = 0;
         _squareOutIdx = 0;
         _squareOutMask = new Sprite();
         _squareOutMask.cacheAsBitmap = true;
         _squareOutArray = new Array();
         _squareOutCols = 13;
         _squareOutRows = 7;
         _squareOutTotal = _squareOutCols * _squareOutRows;
         var _loc4_:Number = Number(_config.mediaWidth) / _squareOutCols;
         var _loc5_:Number = Number(_config.mediaHeight) / _squareOutRows;
         while(_loc6_ < _squareOutRows)
         {
            _loc1_ = 0;
            while(_loc1_ < _squareOutCols)
            {
               _loc2_ = new Sprite();
               _loc2_.graphics.lineStyle(0,16777215,1);
               _loc2_.graphics.beginFill(16777215,1);
               _loc2_.graphics.drawRect(_loc1_ * _loc4_,_loc6_ * _loc5_,_loc4_,_loc5_);
               _loc2_.graphics.endFill();
               _loc2_.cacheAsBitmap = true;
               _loc2_.alpha = 0;
               _squareOutMask.addChild(_loc2_);
               _squareOutArray.push(_loc2_);
               _loc1_++;
            }
            _loc6_++;
         }
         if(_currentSlide.numChildren > 0)
         {
            _loc3_ = _currentSlide.numChildren - 1;
            while(_loc3_ >= 0)
            {
               _currentSlide.removeChildAt(_loc3_);
               _loc3_--;
            }
         }
         _currentSlide.addChild(_squareOutMask);
         _currentSlide.addChild(_image);
         _image.mask = _squareOutMask;
         _image.alpha = 0;
         _currentSlide.alpha = 1;
         _squareOutTimer = new Timer(30);
         _squareOutTimer.start();
         _squareOutTimer.addEventListener(TimerEvent.TIMER,squareOutEvent,false,0,true);
      }
      
      private function squareOutEvent(param1:TimerEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(_squareOutIdx >= _squareOutTotal)
         {
            _squareOutTimer.stop();
			_prevBtn.mouseEnabled = true;
			_nextBtn.mouseEnabled = true;
            textInfo();
         }
         else
         {
            Tweensy.to(_image,{"alpha":1},0.5,Linear.easeNone);
            if(_squareOutIdx <= _squareOutRows - 1)
            {
               _loc2_ = _squareOutIdx;
               while(_loc2_ <= _squareOutIdx * (_squareOutCols - 1) + _squareOutIdx)
               {
                  Tweensy.to(_squareOutArray[_loc2_],{"alpha":1},0.5,Linear.easeNone);
                  _loc2_ = _loc2_ + (_squareOutCols - 1);
               }
            }
            else if(_squareOutIdx > _squareOutRows - 1 && _squareOutIdx <= _squareOutCols - 1)
            {
               _loc3_ = _squareOutIdx;
               while(_loc3_ <= Math.floor(_squareOutCols / 2) * (_squareOutCols - 1) + _squareOutIdx)
               {
                  Tweensy.to(_squareOutArray[_loc3_],{"alpha":1},0.5,Linear.easeNone);
                  _loc3_ = _loc3_ + (_squareOutCols - 1);
               }
            }
            else if(_squareOutIdx > _squareOutCols - 1)
            {
               _squareOutIdx = _squareOutIdx + (_squareOutCols - 1);
               _loc4_ = _squareOutIdx;
               while(_loc4_ <= (_squareOutRows - (_squareOutIdx + 1) / _squareOutCols) * (_squareOutCols - 1) + _squareOutIdx)
               {
                  Tweensy.to(_squareOutArray[_loc4_],{"alpha":1},0.5,Linear.easeNone);
                  _loc4_ = _loc4_ + (_squareOutCols - 1);
               }
            }
            
            
            _squareOutIdx++;
         }
      }
      
      private function squareIn() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Sprite = null;
         var _loc3_:* = 0;
         var _loc6_:uint = 0;
         _squareInMask = new Sprite();
         _squareInMask.cacheAsBitmap = true;
         _squareInArray = new Array();
         _squareInCols = 13;
         _squareInRows = 7;
         _squareInTotal = _squareInCols * _squareInRows;
         var _loc4_:Number = Number(_config.mediaWidth) / _squareInCols;
         var _loc5_:Number = Number(_config.mediaHeight) / _squareInRows;
         while(_loc6_ < _squareInRows)
         {
            _loc1_ = 0;
            while(_loc1_ < _squareInCols)
            {
               _loc2_ = new Sprite();
               _loc2_.graphics.lineStyle(0,16777215,1);
               _loc2_.graphics.beginFill(16777215,1);
               _loc2_.graphics.drawRect(_loc1_ * _loc4_,_loc6_ * _loc5_,_loc4_,_loc5_);
               _loc2_.graphics.endFill();
               _loc2_.cacheAsBitmap = true;
               _loc2_.alpha = 0;
               _squareInMask.addChild(_loc2_);
               _squareInArray.push(_loc2_);
               _loc1_++;
            }
            _loc6_++;
         }
         _squareInTLIdx = _squareInTRIdx = _squareInBLIdx = _squareInBRIdx = Math.floor(_squareInArray.length / 2);
         _topLeftCell = _squareInTLIdx - Math.floor(_squareInCols / 2);
         _topRightCell = _squareInTRIdx + Math.floor(_squareInCols / 2);
         _btmLeftCell = _squareInBLIdx - Math.floor(_squareInCols / 2);
         _btmRightCell = _squareInTRIdx + Math.floor(_squareInCols / 2);
         if(_currentSlide.numChildren > 0)
         {
            _loc3_ = _currentSlide.numChildren - 1;
            while(_loc3_ >= 0)
            {
               _currentSlide.removeChildAt(_loc3_);
               _loc3_--;
            }
         }
         _currentSlide.addChild(_squareInMask);
         _currentSlide.addChild(_image);
         _image.mask = _squareInMask;
         _image.alpha = 0;
         _currentSlide.alpha = 1;
         _squareInTimer = new Timer(40);
         _squareInTimer.start();
         _squareInTimer.addEventListener(TimerEvent.TIMER,squareInEvent,false,0,true);
      }
      
      private function squareInEvent(param1:TimerEvent) : void
      {
         if(_squareInTLIdx <= 0 && _squareInTRIdx <= _squareInCols && _squareInBLIdx >= _squareInCols * (_squareInRows - 1) - 1 && _squareInBRIdx >= _squareInTotal)
         {
            _squareInTimer.stop();
			_prevBtn.mouseEnabled = true;
			_nextBtn.mouseEnabled = true;
            textInfo();
         }
         Tweensy.to(_image,{"alpha":1},0.5,Linear.easeNone);
         topLeft();
         _squareInTLIdx--;
         topRight();
         _squareInTRIdx++;
         bottomLeft();
         _squareInBLIdx--;
         bottomRight();
         _squareInBRIdx++;
      }
      
      private function topLeft() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         if(_squareInTLIdx >= _topLeftCell + Math.floor(_squareInCols / 4))
         {
            _loc1_ = _squareInTLIdx;
            while(_loc1_ >= _squareInTLIdx - (Math.floor(_squareInArray.length / 2) - _squareInTLIdx) * (_squareInCols - 1))
            {
               Tweensy.to(_squareInArray[_loc1_],{"alpha":1},0.5,Linear.easeNone);
               _loc1_ = _loc1_ - (_squareInCols - 1);
            }
         }
         else if(_squareInTLIdx < _topLeftCell + Math.floor(_squareInCols / 4) && _squareInTLIdx >= _topLeftCell)
         {
            _loc2_ = _squareInTLIdx;
            while(_loc2_ >= _squareInTLIdx - (Math.floor(_squareInArray.length / 2) - _squareInTLIdx) * (_squareInCols - 1) + (_topLeftCell + Math.floor(_squareInCols / 4) - _squareInTLIdx) * (_squareInCols - 1))
            {
               Tweensy.to(_squareInArray[_loc2_],{"alpha":1},0.5,Linear.easeNone);
               _loc2_ = _loc2_ - (_squareInCols - 1);
            }
         }
         else if(_squareInTLIdx < _topLeftCell)
         {
            _squareInTLIdx = _squareInTLIdx - (_squareInCols - 1);
            _loc3_ = _squareInTLIdx;
            while(_loc3_ >= _squareInTLIdx / _squareInCols)
            {
               Tweensy.to(_squareInArray[_loc3_],{"alpha":1},0.5,Linear.easeNone);
               _loc3_ = _loc3_ - (_squareInCols - 1);
            }
         }
      }
      
      private function topRight() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         if(_squareInTRIdx <= _topRightCell - Math.floor(_squareInCols / 4))
         {
            _loc1_ = _squareInTRIdx;
            while(_loc1_ >= _squareInTRIdx - (_squareInTRIdx - Math.floor(_squareInArray.length / 2)) * (_squareInCols + 1))
            {
               Tweensy.to(_squareInArray[_loc1_],{"alpha":1},0.5,Linear.easeNone);
               _loc1_ = _loc1_ - (_squareInCols + 1);
            }
         }
         else if(_squareInTRIdx > _topRightCell - Math.floor(_squareInCols / 4) && _squareInTRIdx <= _topRightCell)
         {
            _loc2_ = _squareInTRIdx;
            while(_loc2_ >= _squareInTRIdx - (_squareInTRIdx - Math.floor(_squareInArray.length / 2)) * (_squareInCols + 1) + (_squareInTRIdx - _topRightCell + Math.floor(_squareInCols / 4)) * (_squareInCols + 1))
            {
               Tweensy.to(_squareInArray[_loc2_],{"alpha":1},0.5,Linear.easeNone);
               _loc2_ = _loc2_ - (_squareInCols + 1);
            }
         }
         else if(_squareInTRIdx > _topRightCell)
         {
            _squareInTRIdx = _squareInTRIdx - (_squareInCols + 1);
            _topRightCell = _squareInTRIdx;
            _loc3_ = _squareInTRIdx;
            while(_loc3_ >= _squareInTRIdx % (_squareInCols + 1))
            {
               if(_loc3_ > 0)
               {
                  Tweensy.to(_squareInArray[_loc3_],{"alpha":1},0.5,Linear.easeNone);
               }
               _loc3_ = _loc3_ - (_squareInCols + 1);
            }
         }
      }
      
      private function bottomLeft() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:* = 0;
         if(_squareInBLIdx >= _btmLeftCell + Math.floor(_squareInCols / 4))
         {
            _loc1_ = _squareInBLIdx;
            while(_loc1_ <= _squareInBLIdx + (Math.floor(_squareInArray.length / 2) - _squareInBLIdx) * (_squareInCols + 1))
            {
               Tweensy.to(_squareInArray[_loc1_],{"alpha":1},0.5,Linear.easeNone);
               _loc1_ = _loc1_ + (_squareInCols + 1);
            }
         }
         else if(_squareInBLIdx < _btmLeftCell + Math.floor(_squareInCols / 4) && _squareInBLIdx >= _btmLeftCell)
         {
            _loc2_ = _squareInBLIdx;
            while(_loc2_ <= _squareInBLIdx + (Math.floor(_squareInArray.length / 2) - _squareInBLIdx) * (_squareInCols + 1) - (_btmLeftCell + Math.floor(_squareInCols / 4) - _squareInBLIdx) * (_squareInCols + 1))
            {
               Tweensy.to(_squareInArray[_loc2_],{"alpha":1},0.5,Linear.easeNone);
               _loc2_ = _loc2_ + (_squareInCols + 1);
            }
         }
         else if(_squareInBLIdx < _btmLeftCell)
         {
            _squareInBLIdx = _squareInBLIdx + (_squareInCols + 1);
            _btmLeftCell = _squareInBLIdx;
            _loc3_ = _squareInBLIdx;
            while(_loc3_ <= (_squareInRows - 1 - _squareInBLIdx / _squareInCols) * (_squareInCols + 1) + _squareInBLIdx)
            {
               Tweensy.to(_squareInArray[_loc3_],{"alpha":1},0.5,Linear.easeNone);
               _loc3_ = _loc3_ + (_squareInCols + 1);
            }
         }
      }
      
      private function bottomRight() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:uint = 0;
         if(_squareInBRIdx <= _btmRightCell - Math.floor(_squareInCols / 4))
         {
            _loc1_ = _squareInBRIdx;
            while(_loc1_ <= _squareInBRIdx + (_squareInBRIdx - Math.floor(_squareInArray.length / 2)) * (_squareInCols - 1))
            {
               Tweensy.to(_squareInArray[_loc1_],{"alpha":1},0.5,Linear.easeNone);
               _loc1_ = _loc1_ + (_squareInCols - 1);
            }
         }
         else if(_squareInBRIdx > _btmRightCell - Math.floor(_squareInCols / 4) && _squareInBRIdx <= _btmRightCell)
         {
            _loc2_ = _squareInBRIdx;
            while(_loc2_ <= _squareInBRIdx + (_squareInBRIdx - Math.floor(_squareInArray.length / 2)) * (_squareInCols - 1) - (_squareInBRIdx - _btmRightCell + Math.floor(_squareInCols / 4)) * (_squareInCols - 1))
            {
               Tweensy.to(_squareInArray[_loc2_],{"alpha":1},0.5,Linear.easeNone);
               _loc2_ = _loc2_ + (_squareInCols - 1);
            }
         }
         else if(_squareInBRIdx > _btmRightCell)
         {
            _squareInBRIdx = _squareInBRIdx + (_squareInCols - 1);
            _loc3_ = _squareInBRIdx;
            while(_loc3_ <= (_squareInRows - (_squareInBRIdx + 1) / _squareInCols) * (_squareInCols - 1) + _squareInBRIdx)
            {
               Tweensy.to(_squareInArray[_loc3_],{"alpha":1},0.5,Linear.easeNone);
               _loc3_ = _loc3_ + (_squareInCols - 1);
            }
         }
         
         
      }
      
      private function textInfo() : void
      {
         var textDistance:* = NaN;
         var index:uint = 0;
         var _loc3_:LabelBlock = null;
         if("text" in _config.imagesList[_imgIdx])
         {
            var textY:Number = _config.imagesList[_imgIdx].@textY;
            var textX:Number = _config.imagesList[_imgIdx].@textX;
            textDistance = _config.imagesList[_imgIdx].@textDistance;
            _textBgColor = new ColorTransform();
            _showTextArray = new Array();
            index = 0;
            while(index < _config.imagesList[_imgIdx].children().length())
            {
               _loc3_ = new LabelBlock();
               _loc3_.x = textX;
               _loc3_.y = textY;
               _textBgColor.color = _config.imagesList[_imgIdx].children()[index].@bgColor;
               _loc3_.textBack.transform.colorTransform = _textBgColor;
               _loc3_.textZone.htmlText = _config.imagesList[_imgIdx].children()[index];
               if(_loc3_.textZone.width > _background.width - 2 * Number(_config.mediaPaddingX) - _loc3_.x)
               {
                  _loc3_.textZone.autoSize = TextFieldAutoSize.LEFT;
                  _loc3_.textZone.wordWrap = true;
                  _loc3_.textZone.width = _background.width - 2 * Number(_config.mediaPaddingX) - _loc3_.x - 20;
                  _loc3_.textZone.htmlText = _config.imagesList[_imgIdx].children()[index];
               }
               if(_loc3_.x + _loc3_.width >= _background.width - 2 * Number(_config.mediaPaddingX))
               {
                  _loc3_.x = _background.width - 2 * Number(_config.mediaPaddingX) - _loc3_.width - 20;
               }
               if(_loc3_.y + _loc3_.height >= _background.height - 2 * Number(_config.mediaPaddingY))
               {
                  _loc3_.y = _background.height - 2 * Number(_config.mediaPaddingY) - _loc3_.height;
               }
               _loc3_.textBack.width = _loc3_.textZone.width + 10;
               _loc3_.textBack.height = 0;
               _loc3_.textBack.alpha = _config.imagesList[_imgIdx].children()[index].@bgOpacity / 100;
               _loc3_.textZone.alpha = 0;
               _loc3_.textZone.x = _loc3_.textBack.width / 2 - _loc3_.textZone.width / 2;
			   textY = textY + (_loc3_.height + textDistance);
               _showTextArray.push(_loc3_);
               _currentSlide.addChild(_showTextArray[index]);
               index++;
            }
            _showTextIndex = 0;
            _showTextTimer = new Timer(Number(_config.textTransition) * 1000);
            _showTextTimer.addEventListener(TimerEvent.TIMER,showTextTimer,false,0,true);
            _showTextTimer.start();
         }
      }
      
      private function showTextTimer(param1:TimerEvent) : void
      {
         if(_showTextIndex > _showTextArray.length - 1)
         {
            _showTextTimer.stop();
         }
         else
         {
            Tweensy.to(_showTextArray[_showTextIndex].textBack,{"height":_showTextArray[_showTextIndex].textZone.height + 10},0.5);
            Tweensy.to(_showTextArray[_showTextIndex].textZone,{"alpha":1},1);
            _showTextIndex++;
         }
      }
      
      private function removedFromStage(param1:Event) : void
      {
         var childrenNum:uint = numChildren - 1;
         while(childrenNum > 0)
         {
            removeChildAt(childrenNum);
            childrenNum--;
         }
         this.removeChildAt(0);
		 this.removeEventListener(MouseEvent.CLICK, onMouseClick);
		 _playBtn.dispose();
         _slideshowTimer.stop();
         _slideshowTimer.removeEventListener(TimerEvent.TIMER,startSlide);
      }
	  
	  override public function get width() : Number
	  {
		  return _background.width;
	  }
	  
	  override public function get height() : Number
	  {
		  return _background.height;
	  }
	  
   }
}
