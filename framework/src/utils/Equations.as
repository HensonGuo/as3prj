package utils {
	import caurina.transitions.Tweener;
	
	public class Equations {
		public function Equations() {
			throw new Error('Equations is a static class and should not be instantiated.');
		}
		
		public static function init():void {
			Tweener.registerTransition("easebezier",		easeBezier);
			Tweener.registerTransition("bezier",			easeBezier);
		}
		
		/**
		 * Easing equation function for a bezier.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeBezier (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
			var p_param:Array, bezier:Array, y:Number, coefficients:Array;
			var width:Number = p_params[p_params.length - 1][3][0] - p_params[0][0][0];
			var height:Number = p_params[p_params.length - 1][3][1] - p_params[0][0][1];
			
			for each (p_param in p_params) {
				bezier = Equations.getBezierArray(p_param, (d / width), (c / height));
				if (t >= bezier[0][0] && t <= bezier[3][0]) {
					coefficients = Equations.getCubicCoefficients(bezier[0][0], bezier[1][0], bezier[2][0], bezier[3][0]);
					y = Equations.getYForX(bezier, t, coefficients);
					
					if (y == 0 || isNaN(y)) {
						y = (Equations.getYForX(bezier, t - 1, coefficients) + Equations.getYForX(bezier, t + 1, coefficients)) / 2;
					}
					
					return b + y;
				}
			}
			
			return b + c;
		}
		
		private static function getBezierArray(p_param:Array, scaleX:Number, scaleY:Number):Array {
			return [
				[p_param[0][0] * scaleX, p_param[0][1] * scaleY],
				[p_param[1][0] * scaleX, p_param[1][1] * scaleY],
				[p_param[2][0] * scaleX, p_param[2][1] * scaleY],
				[p_param[3][0] * scaleX, p_param[3][1] * scaleY]
			];
		}
		
		private static function getSingleValue(t:Number, a:Number = 0, b:Number = 0, c:Number = 0, d:Number = 0):Number {
			return (t * t * (d - a) + 3 * (1 - t) * (t * (c - a) + (1 - t) * (b - a))) * t + a;
		}
		
		private static function getYForX(bezier:Array, x:Number, coefficients:Array/* = null*/):Number {
			if (bezier[0][0] < bezier[3][0]) {
				if (x <= bezier[0][0] + 0.0000000000000001) return bezier[0][1];
				if (x >= bezier[3][0] - 0.0000000000000001) return bezier[3][1];
			} else {
				if (x >= bezier[0][0] + 0.0000000000000001) return bezier[0][1];
				if (x <= bezier[3][0] - 0.0000000000000001) return bezier[3][1];
			}
			/*
			if (!coefficients) {
				coefficients = getCubicCoefficients(bezier[0][0], bezier[1][0], bezier[2][0], bezier[3][0]);
			}
			*/
			var roots:Array = getCubicRoots(coefficients[0], coefficients[1], coefficients[2], coefficients[3] - x);
			var time:Number = NaN;
			if (roots.length == 0) {
				time = 0;
			} else if (roots.length == 1) {
				time = roots[0];
			} else {
				for each (var root:Number in roots) {
					if (0 <= root && root <= 1) {
						time = root;
						break;
					}
				}
			}
			
			var y:Number = getSingleValue(time, bezier[0][1], bezier[1][1], bezier[2][1], bezier[3][1]);
			
			return y;
		}
		
		private static function getCubicCoefficients(a:Number, b:Number, c:Number, d:Number):Array {
			return [    -a + 3 * b - 3 * c + d,
					 3 * a - 6 * b + 3 * c,
					-3 * a + 3*b,
					     a];
		}
		
		private static function getCubicRoots(a:Number = 0, b:Number = 0, c:Number = 0, d:Number = 0):Array {
			if (!a) {
				return Equations.getQuadraticRoots(b, c, d);
			}
			
			if (a != 1) {
				b /= a;
				c /= a;
				d /= a;
			}
			
			var q:Number = (b * b - 3 * c) / 9;
			var qCubed:Number = q * q * q;
			var r:Number = (2 * b * b * b - 9 * b * c + 27 * d) / 54;
			
			var diff:Number = qCubed - r * r;
			if (diff >= 0) {
				/*if (!q) {
					return [0];
				}*/
				
				var theta:Number = Math.acos(r / Math.sqrt(qCubed));
				var qSqrt:Number = Math.sqrt(q);
				
				var root1:Number = -2 * qSqrt * Math.cos(theta / 3) - b / 3;
				var root2:Number = -2 * qSqrt * Math.cos((theta + 2 * Math.PI) / 3) - b / 3;
				var root3:Number = -2 * qSqrt * Math.cos((theta + 4 * Math.PI) / 3) - b / 3;
				
				return [root1, root2, root3];
			} else {
				var tmp:Number = Math.pow(Math.sqrt(-diff) + Math.abs(r), 1 / 3);
				var rSign:int = (r > 0)?  1: (r < 0)? -1: 0;
				var root:Number = -rSign * (tmp + q / tmp) - b / 3;
				return [root];
			}
			return [];
		}
		
		private static function getQuadraticRoots(a:Number, b:Number, c:Number):Array {
			var roots:Array = [];
			
			if (!a) {
				if (!b) {
					return [];
				}
				roots[0] = -c / b;
				return roots;
			}
			
			var q:Number = b * b - 4 * a * c;
			var signQ:int = (q > 0)? 1: (q < 0)? -1: 0;
			
			if (signQ < 0) {
				return [];
			} else if (!signQ) {
				roots[0] = -b / (2 * a);
			} else {
				roots[0] = roots[1] = -b / (2 * a);
				var tmp:Number = Math.sqrt(q) / (2 * a);
				roots[0] -= tmp;
				roots[1] += tmp;
			}
			
			return roots;
		}
		
	}
}