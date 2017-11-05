package menu.scale_color_menu
{
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import greensock.TweenLite;
	import greensock.easing.Back;
	import greensock.easing.Bounce;
	
	import menu.base.MenuItem;
	
	public class ScaleColorMenuItem extends MenuItem
	{
		private static const _posRect:Rectangle = new Rectangle(50, 50, 100, 100);
		private static var _pos:Point = new Point();
		
		private var _color:uint;
		private var _circle:Shape;
		private var _radius:Number;
		private var _scale:Number;
		
		public function ScaleColorMenuItem(color:uint, radius:Number, scale:Number)
		{
			_color = color;
			_radius = radius;
			_scale = scale;
			super();
		}
		
		override protected function construct():void
		{
			_circle = new Shape();
			_circle.graphics.beginFill(0xffffff, 0.2);
			_circle.graphics.drawCircle(0, 0, _radius);
			_circle.graphics.endFill();
			_circle.graphics.beginFill(_color, 0.9);
			_circle.graphics.drawCircle(0, 0, _radius - 5);
			_circle.graphics.endFill();
			this.addChild(_circle);
		}
		
		override public function showMouseOverState():void
		{
			TweenLite.to(_circle, 1, {scaleX:this._scale, scaleY:this._scale, ease:Back.easeInOut});
		}
		
		override public function showMouseUpState():void
		{
//			var duration:Number = (_circle.width - 2* _radius)
			TweenLite.to(_circle, 1, {width:2 * _radius, height:2 * _radius, ease:Back.easeInOut});
		}
		
		public static function randomPos():Point
		{
			_pos.x = _posRect.x + Math.random() * _posRect.width;
			_pos.y = _posRect.y + Math.random() * _posRect.height;
			return _pos;
		}
		
	}
}