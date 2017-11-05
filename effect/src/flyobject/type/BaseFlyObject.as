package flyobject.type
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class BaseFlyObject extends Sprite
	{
		protected var _flyObj:DisplayObject;
		
		//param
		protected var _srcPos:Point;
		protected var _targetPos:Point;
		protected var _speed:Number;
		protected var _acceleration:Number;//加速度
		
		protected var _isArried:Boolean = false;
		protected var _isDisappeared:Boolean = false;
		
		protected var _distanceX:Number;
		protected var _distanceY:Number;
		protected var _distance:Number;

		
		public function BaseFlyObject()
		{
			super();
			constructFlyObj();
		}
		
		/**
		* 构建fly对象
		*/
		protected function constructFlyObj():void
		{
			_flyObj = new DisplayObject();
			this.addChild(_flyObj);
		}
		
		/**
		 * @param srcPos 起始位置
		 * @param targetPos 目标位置
		 * @param speed 飞行速度
		 * @param acceleration 加速度
		 */
		public function init(srcPos:Point, targetPos:Point, speed:Number, acceleration:Number):void
		{
			_srcPos  = srcPos;
			_targetPos = targetPos;
			_distanceX = _targetPos.x - _srcPos.x;
			_distanceY = _targetPos.y - _srcPos.y;
			_distance = Math.sqrt(_distanceX * _distanceX + _distanceY * _distanceY);
			this.x = _srcPos.x;
			this.y = _srcPos.y;
			_targetPos = _targetPos;
			_speed = speed;
			_acceleration = acceleration;
		}
		
		/**
		 * 更新
		 */
		public function update():void
		{
			if (_isArried)
			{
				if (_isDisappeared)
					return;
				//渐变消失
				fadingForDisappear();
				return;
			}
			
			_speed = _speed + _acceleration * _speed;
			var speedX:Number = _distanceX / _distance * _speed;
			var speedY:Number = _distanceY / _distance * _speed;
			
			this.x += speedX;
			this.y += speedY;
			
			// judge arrived
			var arrivedX:Boolean;
			if (_distanceX < 0)
				arrivedX = this.x <= _targetPos.x;
			else
				arrivedX = this.x >= _targetPos.x;
			
			var arrivedY:Boolean
			if (_distanceY < 0)
				arrivedY = this.y <= _targetPos.y;
			else
				arrivedY = this.y >= _targetPos.y;
			
//			if ((arrivedX && !arrivedY) || (!arrivedX && arrivedY))
//			{
//				trace("精度丢失，发生偏移");
//			}
			_isArried = arrivedX && arrivedY;
		}
		
		/**
		 * 渐变消失
		 */
		protected function fadingForDisappear():void
		{
			if (_isDisappeared)
				return;
			this.alpha -= 0.1;
			_isDisappeared = this.alpha <= 0;
		}
		
		/**
		 * 销毁
		 */
		public function dispose():void
		{
			_speed = 0;
			_acceleration = 0;
			_isArried = false;
			
			this.removeChild(_flyObj);
			_flyObj = null;
		}
		
		/**
		 * 速度
		 */
		public function get speed():Number
		{
			return _speed;
		}
		
		/**
		 * 加速度
		 */
		public function get acceleration():Number
		{
			return _acceleration;
		}
		
		/**
		 * 是否到达
		 */
		public function get isArried():Boolean
		{
			return _isArried;
		}
		
		/**
		 *  是否消失
		 */
		public function get isDisappeared():Boolean
		{
			return _isDisappeared;
		}

		
	}
}