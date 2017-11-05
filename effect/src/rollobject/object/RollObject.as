package rollobject.object
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import rollobject.RollDirection;
	import rollobject.RollInfo;
	

	public class RollObject extends Sprite
	{
		protected var _rollObj:DisplayObject;
		protected var _mask:Sprite;
		
		protected var _isPauseForDisplay:Boolean;
		protected var _isFinishRoll:Boolean;
		
		protected var _info:RollInfo;
		
		protected var _pauseStartTime:int = 0;
		
		public function RollObject()
		{
			constructRollObj();
			this.addChild(_rollObj);
		}
		
		/**
		 * 构建roll对象
		 */
		protected function constructRollObj():void
		{
			_rollObj = new DisplayObject();
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
			_mask.graphics.drawRect(0, 0, _info.rollRect.width, _info.rollRect.height);
			_mask.graphics.endFill();
			this.addChild(_mask);
			
			_rollObj.mask = _mask;
			
			//init pos
			switch(_info.direction)
			{
				case RollDirection.DOWNWARD:
					_rollObj.x = 0;
					_rollObj.y = - _rollObj.height;
					break;
				case RollDirection.UPWARD:
					_rollObj.x = 0;
					_rollObj.y = _info.rollRect.height;
					break;
				case RollDirection.LEFTWARD:
					_rollObj.x = _info.rollRect.width;
					_rollObj.y = 0;
					break;
				case RollDirection.RIGHTWARD:
					_rollObj.x = - _rollObj.width;
					_rollObj.y = 0;
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
			
			switch(_info.direction)
			{
				case RollDirection.DOWNWARD:
					_rollObj.y += _info.speed;
					_isFinishRoll = _rollObj.y >= _info.rollRect.height;
					break;
				case RollDirection.UPWARD:
					_rollObj.y -= _info.speed;
					_isFinishRoll = _rollObj.y <= -_rollObj.height;
					break;
				case RollDirection.LEFTWARD:
					_rollObj.x -= _info.speed;
					_isFinishRoll = _rollObj.x <= -_rollObj.width;
					break;
				case RollDirection.RIGHTWARD:
					_rollObj.x += _info.speed;
					_isFinishRoll = _rollObj.x >= _info.rollRect.width;
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
					_isPauseForDisplay = (_rollObj.y >= _info.rollRect.height / 2 - _rollObj.height / 2 - _info.speed) 
					&& (_rollObj.y <= _info.rollRect.height / 2  - _rollObj.height / 2 + _info.speed);
					break;
				case RollDirection.LEFTWARD:
				case RollDirection.RIGHTWARD:
					_isPauseForDisplay = (_rollObj.x >= _info.rollRect.width / 2  - _rollObj.width / 2 - _info.speed)
					&& (_rollObj.x <= _info.rollRect.width / 2  - _rollObj.width / 2 + _info.speed);
					break;
			}
		}
		
		/**
		 * 销毁
		 */
		public function dispose():void
		{
			//_rollObj和_mask不置空，便于从对象池中拿取不必创建
			
			_mask.graphics.clear();
			_info = null;
			_isFinishRoll = false;
			_isPauseForDisplay = false;
			_pauseStartTime = 0;
		}
		
		/**
		 * 是否完成滚动
		 */
		public function get isFinishRoll():Boolean
		{
			return _isFinishRoll;
		}
		
	}
}