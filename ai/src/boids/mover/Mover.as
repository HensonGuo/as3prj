package boids.mover
{
	import flash.display.Graphics;
	
	import util.Rand;
	
	
	/**
	 * wander()がバグってる
	 */
	public class Mover
	{
		// 位置ベクトル
		public var x:Number;
		public var y:Number;
		
		//　速度ベクトル
		public var vx:Number;
		public var vy:Number;
		
		// 最高速度
		public var vMax:Number;
		
		// 回転
		public var rotation:Number;
		
		// 重さ
		public var mass:Number;
		
		
		/**
		 * コンストラクタ
		 * 
		 * @param x 初期位置ｘ
		 * @param y 初期位置y
		 * @param v 速度
		 * @param rotation 初期の回転
		 * 
		 */
		public function Mover(
			x:Number, y:Number,
			vMax:Number,
			rotation:Number = 0.0,
			mass:Number = 1.0
			)
		{
			this.x = x;
			this.y = y;
			
			this.vMax = vMax;
			
			this.vx = 0.0;
			this.vy = 0.0;
			
			this.rotation = rotation;
			
			this.forceX = 0.0;
			this.forceY = 0.0;
			
			this.mass = mass;
			
			
			var theta:Number = Rand.rand2() * Math.PI * 2.0;
			wanderX_ = Math.cos(theta);
			wanderY_ = Math.sin(theta);
		}
		
		
		/**
		 * 移動力リセット
		 */
		public function clearForce():void
		{
			forceX = 0.0;
			forceY = 0.0;
		}
		
		
		/**
		 * 移動
		 */
		public function update():void
		{
			if(forceX == 0.0 && forceY == 0.0){
				return;
			}
			
			if(mass != 0.0 && mass != 1.0){
				forceX /= mass;
				forceY /= mass;
			}
			
			var nf:Number = Math.sqrt(forceX*forceX + forceY*forceY);
			if(nf > 10.0){
				forceX = forceX/nf * 10.0;
				forceY = forceY/nf * 10.0;
			}
			trace(forceX, forceY);
			
			vx += forceX;
			vy += forceY;
			
			var n:Number = Math.sqrt(vx*vx + vy*vy);
			if(n > vMax){
				vx = vx/n * vMax;
				vy = vy/n * vMax;
			}
			trace(vx, vy);
			
			x += vx;
			y += vy;
			
			if(n > 0.000001){
//				rotation = (rotation + Math.atan2(vy, vx) * 180.0 / Math.PI) / 2.0;
				rotation = Math.atan2(vy, vx) * 180.0 / Math.PI;
			}
		}
		
		
		/**
		 * 追いかける
		 * 
		 * @param m 追いかけるオブジェクト
		 * @param d mまでの距離
		 * 
		 */
		public function chase(m:Mover, d:Number = Infinity):Number
		{
			var x1:Number = m.x - x;
			var y1:Number = m.y - y;
			
			if(d == Infinity){
				d = Math.sqrt(x1*x1 + y1*y1);
			}
			x1 = x1/d * vMax;
			y1 = y1/d * vMax;
			
			forceX += x1 - vx;
			forceY += y1 - vy;
			
			return d;
		}
		
		/**
		 * 追いかける
		 */
		public function chaseXY(targetX:Number, targetY:Number, d:Number = Infinity):Number
		{
			var x1:Number = targetX - x;
			var y1:Number = targetY - y;
			
			if(d == Infinity){
				d = Math.sqrt(x1*x1 + y1*y1);
			}
			x1 = x1/d * vMax;
			y1 = y1/d * vMax;
			
			forceX += x1 - vx;
			forceY += y1 - vy;
			
			return d;
		}
		
		
		/**
		 * 逃げる
		 * 
		 * @param m 逃げるオブジェクト
		 * @param r 半径、mがこの範囲に入ってたら逃げる
		 * @param d mとの距離
		 * 
		 */
		public function awayFrom(m:Mover, r:Number = Infinity, d:Number = Infinity):Number
		{
			var x1:Number = x - m.x;
			var y1:Number = y - m.y;
			
			if(d == Infinity){
				d = Math.sqrt(x1*x1 + y1*y1);
			}
			
			if(d > r){
				return d;
			}
			
			x1 = x1/d * vMax;
			y1 = y1/d * vMax;
			
			forceX += x1 - vx;
			forceY += y1 - vy;
			
			return d;
		}
		
		
		/**
		 * 吸着
		 * 
		 * @param m 吸着するオブジェクト
		 * @param decelation 速度の減衰パラメータ、大きいほど減衰する
		 * @param r 半径、mがこの範囲に入ってたら吸着する
		 * @param d mとの距離
		 * 
		 */
		public function sorb(m:Mover, decelation:Number, r:Number = Infinity, d:Number = Infinity):Number
		{
			var dx:Number = m.x - x;
			var dy:Number = m.y - y;
			
			if(d == Infinity){
				d = Math.sqrt(dx*dx + dy*dy);
			}
			
			if(d > r){
				return d;
			}
			
			if(d > vMax){
				forceX += dx / decelation;
				forceY += dy / decelation;
			}else{
				forceX += dx;
				forceY += dy;
			}
			
			return d;
		}
		
		
		/**
		 * 先回り
		 */
		public function preemptive(m:Mover, d:Number = Infinity):Number
		{
			var dx:Number = m.x - x;
			var dy:Number = m.y - y;
			
			if(d == Infinity){
				d = Math.sqrt(dx*dx + dy*dy);
			}
			
			// 互いが近くにいて
			if(d < vMax + m.vMax){
				// mが自分の方を向いていて, acos(0.9) = pi*0.45
				if((m.vx*x + m.vy*y) < -0.9){
					// 自分もmの方を向いていたら
					if(vx*m.x + vy*m.y > 0){
						// そのまま直進
						chase(m, d);
						return d;
					}
				}
			}
			
			// 先読み時間は 距離/合計速度
			var t:Number = d / (vMax + m.vMax);
			chaseXY(m.x + t*m.vx, m.y + t*m.vy, d);
			
			return d;
		}
		
		
		// ランダム
		public function random(min:Number, max:Number):void
		{
			forceX += Rand.realRange(min, max);
			forceY += Rand.realRange(min, max);
		}
		
		
		// 徘徊、てきとーにふらつく
		public function wander(g:Graphics, radius:Number = 20.0, distance:Number = 40.0, jitter:Number = 10.0):void
		{
			// ランダム付加(ローカル)
			wanderX_ += (Math.random()*2.0-1.0) * jitter;
			wanderY_ += (Math.random()*2.0-1.0) * jitter;
			
			// 原点中心の円周上に投影(ローカル)
			var n:Number = Math.sqrt(wanderX_*wanderX_+ wanderY_*wanderY_);
			wanderX_ = wanderX_/n * radius;
			wanderY_ = wanderY_/n * radius;
			
			g.clear();
			g.beginFill(0xFFF00000);
			g.drawCircle(100, 100, radius);
			g.endFill();
			g.beginFill(0xFF0F0000);
			g.drawCircle(wanderX_+100, wanderY_+100, 3);
			g.endFill();
			
			// 前方に移動(ローカル)
			var targetX:Number = wanderX_ + distance;
			var targetY:Number = wanderY_;
			
			// ワールドに投影
			// 回転
			var t:Number = Math.atan2(vy, vx);
			var sin:Number = Math.sin(t), cos:Number = Math.cos(t);
			targetX = targetX*cos + targetY*sin;
			targetY = targetY*cos - targetX*sin;
			// 平行移動
			targetX += x;
			targetY += y;
			
			g.beginFill(0x3300FF00);
			g.drawCircle(x+distance*cos, y-distance*sin, radius);
			g.endFill();
			g.beginFill(0x550000FF);
			g.drawCircle(targetX, targetY, 2);
			g.endFill();
			
			forceX += targetX - x;
			forceY += targetY - y;
		}
		
		
		private var wanderX_:Number;
		private var wanderY_:Number;
		
		
		// 速度に作用する力
		protected var forceX:Number;
		protected var forceY:Number;

	}
}

