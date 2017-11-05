package effect.flyobject
{
	import effect.EffectObj;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class FlyObject extends EffectObj
	{
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

		
		public function FlyObject()
		{
			super();
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
			_entity.x = _srcPos.x;
			_entity.y = _srcPos.y;
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
			}
			else
				flying();
		}
		
		/**
		 * 飞
		 */
		protected function flying():void
		{
			_speed = _speed + _acceleration * _speed;
			var speedX:Number = _distanceX / _distance * _speed;
			var speedY:Number = _distanceY / _distance * _speed;
			
			_entity.x += speedX;
			_entity.y += speedY;
			
			// judge arrived
			var arrivedX:Boolean;
			if (_distanceX < 0)
				arrivedX = _entity.x <= _targetPos.x;
			else
				arrivedX = _entity.x >= _targetPos.x;
			
			var arrivedY:Boolean
			if (_distanceY < 0)
				arrivedY = _entity.y <= _targetPos.y;
			else
				arrivedY = _entity.y >= _targetPos.y;
			
			_isArried = arrivedX && arrivedY;
		}
		
		/**
		 * 渐变消失
		 */
		protected function fadingForDisappear():void
		{
			if (_isDisappeared)
				return;
			_entity.alpha -= 0.1;
			_isDisappeared = _entity.alpha <= 0;
		}
		
		override protected function reset():void
		{
			_speed = 0;
			_acceleration = 0;
			_srcPos = null;
			_targetPos = null;
			_isArried = false;
			_isDisappeared = false;
			_entity.x = 0;
			_entity.y = 0;
			_entity.alpha = 1;
			super.reset();
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