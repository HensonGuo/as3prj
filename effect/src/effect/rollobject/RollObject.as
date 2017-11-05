package effect.rollobject
{
	
	import effect.EffectObj;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	public class RollObject extends EffectObj
	{
		protected var _isPauseForDisplay:Boolean;
		protected var _isFinishRoll:Boolean;
		
		protected var _mask:Sprite;
		protected var _info:RollInfo;
		
		protected var _limitPos:Number;
		protected var _pausePosMin:Number;
		protected var _pausePosMax:Number;
		
		protected var _pauseStartTime:int = 0;
		
		public function RollObject()
		{
		}
		
		/**
		 * 初始化
		 * @param info 滚动信息数据
		 */
		public function init(info:RollInfo):void
		{
			_info = info;
			
			//create mask;
			if (_mask == null)
				_mask = new Sprite;
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect(_info.rollRect.x, _info.rollRect.y, _info.rollRect.width, _info.rollRect.height);
			_mask.graphics.endFill();
			
			_entity.mask = _mask;
			
			//init pos
			switch(_info.direction)
			{
				case RollDirection.DOWNWARD:
					_entity.x = _info.rollRect.x + (_info.rollRect.width - _entity.width) / 2;
					_entity.y = _info.rollRect.y - _entity.height;
					
					_limitPos = _info.rollRect.y + _info.rollRect.height;
					_pausePosMin = _info.rollRect.y + _info.rollRect.height / 2 - _entity.height / 2 - _info.speed;
					_pausePosMax = _info.rollRect.y + _info.rollRect.height / 2  - _entity.height / 2 + _info.speed;
					break;
				case RollDirection.UPWARD:
					_entity.x = _info.rollRect.x + (_info.rollRect.width - _entity.width) / 2;
					_entity.y = _info.rollRect.y + _info.rollRect.height;
					
					_limitPos = _info.rollRect.y - _entity.height;
					_pausePosMin = _info.rollRect.y + _info.rollRect.height / 2 - _entity.height / 2 - _info.speed;
					_pausePosMax = _info.rollRect.y + _info.rollRect.height / 2  - _entity.height / 2 + _info.speed;
					break;
				case RollDirection.LEFTWARD:
					_entity.x = _info.rollRect.x + _info.rollRect.width;
					_entity.y = _info.rollRect.y + (_info.rollRect.height - _entity.height) / 2;
					
					_limitPos = _info.rollRect.x - _entity.width;
					_pausePosMin = _info.rollRect.x + _info.rollRect.width / 2  - _entity.width / 2 - _info.speed;
					_pausePosMax = _info.rollRect.x + _info.rollRect.width / 2  - _entity.width / 2 + _info.speed;
					break;
				case RollDirection.RIGHTWARD:
					_entity.x = _info.rollRect.x - _entity.width;
					_entity.y = _info.rollRect.y + (_info.rollRect.height - _entity.height) / 2;
					
					_limitPos = _info.rollRect.x + _info.rollRect.width;
					_pausePosMin = _info.rollRect.x + _info.rollRect.width / 2  - _entity.width / 2 - _info.speed;
					_pausePosMax = _info.rollRect.x + _info.rollRect.width / 2  - _entity.width / 2 + _info.speed;
					break;
			}
		}
		
		/**
		 *更新
		 */
		public function update():void
		{
			if (_isFinishRoll)
				return;
			checkCanPauseForDisplay();
			
			if (_isPauseForDisplay)
			{
				if (_pauseStartTime == 0)
				{
					_pauseStartTime = getTimer();
					return;
				}
				if (getTimer() - _pauseStartTime <= _info.pauseDisplayTime)
					return;
				_isPauseForDisplay = false;
			}
			rolling();
		}
		
		protected function rolling():void
		{
			switch(_info.direction)
			{
				case RollDirection.DOWNWARD:
					_entity.y += _info.speed;
					_isFinishRoll = _entity.y >= _limitPos;
					break;
				case RollDirection.UPWARD:
					_entity.y -= _info.speed;
					_isFinishRoll = _entity.y <= _limitPos;
					break;
				case RollDirection.LEFTWARD:
					_entity.x -= _info.speed;
					_isFinishRoll = _entity.x <= _limitPos;
					break;
				case RollDirection.RIGHTWARD:
					_entity.x += _info.speed;
					_isFinishRoll = _entity.x >= _limitPos;
					break;
			}
		}
		
		/**
		 *检测是否为了展示暂停滚动
		 */
		protected function checkCanPauseForDisplay():void
		{
			switch(_info.direction)
			{
				case RollDirection.DOWNWARD:
				case RollDirection.UPWARD:
					_isPauseForDisplay = (_entity.y >= _pausePosMin) 
					&& (_entity.y <= _pausePosMax);
					break;
				case RollDirection.LEFTWARD:
				case RollDirection.RIGHTWARD:
					_isPauseForDisplay = (_entity.x >= _pausePosMin)
					&& (_entity.x <= _pausePosMax);
					break;
			}
		}
		
		override public function show(parent:DisplayObjectContainer, isHigh:Boolean=false):void
		{
			parent.addChild(_mask);
			super.show(parent, isHigh);
		}
		
		override public function hide():void
		{
			if (_mask.parent)
				_mask.parent.removeChild(_mask);
			super.hide();
		}
		
		override protected function reset():void
		{
			_mask.graphics.clear();
			_info = null;
			_isFinishRoll = false;
			_isPauseForDisplay = false;
			_pauseStartTime = 0;
			_pausePosMax = 0;
			_pausePosMin = 0;
			_limitPos = 0;
			
			_entity.mask = null;
			super.reset();
		}
		
		/**
		 * 是否完成滚动
		 */
		public function get isFinishRoll():Boolean
		{
			return _isFinishRoll;
		}
		
		public function equal(rollInfo:RollInfo):Boolean
		{
			return false;
		}
	}
}