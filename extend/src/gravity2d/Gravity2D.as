package gravity2d {
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2ShapeDef;
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.b2AABB;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Common.Math.b2Vec2;
//	import General.FpsCounter;
//	import General.FRateLimiter;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/*
		更新履歴
		v.1.0.1 2010/08/25 コンストラクタのTop、Leftを変更した場合の枠幅がおかしくなる部分を修正
	*/
	public class Gravity2D extends Sprite {
		
		public var version:String = "v.1.0.1";
		
		public var m_world:b2World;

		public var renderStep:Number=3/60;// 各フレームで進行させるコマ
		public var renderAccuracy:int=50;// 各フレームの物理計算精度

		public var go2D:Array;

		private var m_physScale:Number=10;//この値を大きくすると、計算が簡略化され、処理速度が上がる（と思われる）
		private var dd:b2DebugDraw;
//		private var fps:FpsCounter;

		/**
		 * @param Top物理計算を行う範囲のTopを指定します。
		 * @param Left物理計算を行う範囲のLeftを指定します。
		 * @param Width物理計算を行う範囲のWidthを指定します。
		 * @param Height物理計算を行う範囲のHeightを指定します。
		 * @param wallFriction壁の摩擦係数を指定します。
		 * @param wallRestitution 壁の反発係数を指定します。
		 */
		public function Gravity2D(Top:int = 0, Left:int = 0, Width:uint = 600, Height:uint = 400, wallFriction:Number = 0.8, wallRestitution:Number = 0.8):void {
			
			trace("Gravity2D " + version);
			
			super();
			init();
			start();

			function init():void {
				var tickness:uint=50;
				var worldAABB:b2AABB = new b2AABB();
				worldAABB.lowerBound.Set( Left / m_physScale, Top / m_physScale);
				worldAABB.upperBound.Set( (Left + Width) / m_physScale, (Top + Height) / m_physScale);
				
				var gravity:b2Vec2=new b2Vec2(0,3.0);
				var doSleep:Boolean=true;
				m_world=new b2World(worldAABB,gravity,doSleep);

				var sd_h:b2PolygonDef = createPolygonDef(Width + (tickness * 2), tickness,  0, wallFriction, wallRestitution);
				var sd_v:b2PolygonDef   = createPolygonDef(tickness, Height + (tickness * 2), 0, wallFriction, wallRestitution);

				createBox(sd_h, Left + Width / 2, Top + Height + (tickness / 2) - 1, 0,  null);
				createBox(sd_h, Left + Width / 2, Top          - (tickness / 2) + 1, 0,  null);
				createBox(sd_v, Left - (tickness / 2) + 1, Top + Height / 2, 0, null);
				createBox(sd_v, Left + Width + (tickness / 2) - 1, Top + Height / 2, 0, null);

				dd = new b2DebugDraw();
				dd.m_drawScale=m_physScale;
				dd.m_alpha=1;
				dd.m_fillAlpha=0;
//				fps = new FpsCounter();
//				addChild(fps);

				setDebugDraw(0);

				go2D = new Array();
			}
		}

		public function setDebugDraw(_no:uint = 2):void {
			switch (_no) {
				case 0 ://描画しない
					m_world.SetDebugDraw(null);
					dd.m_drawFlags=0;
//					fps.visible=false;
					break;
				case 1 ://ジョイントのみ描画する。
					dd.m_sprite=this;
					m_world.SetDebugDraw(dd);
					dd.m_drawFlags=2;
//					fps.visible=false;
					break;
				case 2 ://オブジェクトの輪郭とジョイントを描画する。
					dd.m_sprite=this;
					m_world.SetDebugDraw(dd);
					dd.m_drawFlags=3;
//					fps.visible=true;
					break;
			}
		}

		/**
		 * @param Horizontal水平方向の重力を指定
		 * @param Vertical垂直方向の重力を指定
		 */
		public function setGravity(Horizontal:Number, Vertical:Number):void {
			m_world.m_gravity=new b2Vec2(Horizontal,Vertical);
		}

		public function destroy():void {
			stop();
		}

		public function start():void {
			addEventListener(Event.ENTER_FRAME, e_enter);
		}

		public function stop():void {
			removeEventListener(Event.ENTER_FRAME, e_enter);
		}

		private function e_enter(e:Event = null):void {

			m_world.Step( renderStep, renderAccuracy );

			for (var bb:b2Body = m_world.m_bodyList; bb; bb = bb.m_next) {
				if (bb.m_userData is Sprite) {
					bb.m_userData.x = (bb.GetPosition().x - bb.m_userData.globalX / m_physScale) * m_physScale;
					bb.m_userData.y = (bb.GetPosition().y - bb.m_userData.globalY / m_physScale) * m_physScale;
					bb.m_userData.rotation = bb.GetAngle() * (180/Math.PI);
				}
			}

			for (var i:uint = 0; i<go2D.length; i++) {
				if (go2D[i]) go2D[i].move();
			}

//			if (dd.m_drawFlags==3) fps.update();
			//FRateLimiter.limitFrame(60);
		}

		public function sliceGo2D():void {
			/*
			var moto:Array = new Array([1, 2, 3, 4, 5]);
			var newA:Array = deleteAt(moto, 2);
			trace(newA);
			*/

			for (var i:uint = 0; i<=go2D.length; i++) {
				//if (!go2D[i].b2) {
				/*
				var newGo2D:Array = deleteAt(go2D, i);
				go2D = newGo2D;
				*/
				return;
				//}
			}

			function deleteAt(tmplist:Array, pos:uint):Array {
				var newlist:Array = new Array();
				if (pos==0) {
					newlist=tmplist.slice(1);
				} else {
					//var list1:Array = tmplist.slice(0, pos-1);
					var list1:Array=tmplist.slice(0,3);
					trace("list1", list1);
					var list2:Array=tmplist.slice(pos+1);
					trace("list2", list2);
					newlist=newlist.concat(list1,list2);
				}
				return newlist;
			}
		}

		//-----------------------------------------以下　GravityObject2D用関数

		/**
		 * @param _widthBoxオブジェクトの幅
		 * @param _heightBoxオブジェクトの高さ
		 * @param _density質量
		 * @param _friction摩擦量
		 * @param _restitution反発量
		 */
		public function createPolygonDef(prmWidth:Number, prmHeight:Number,
		prmDensity:Number, prmFriction:Number, prmRestitution:Number, prmGroupIndex:int = 1):b2PolygonDef {
			var b2pd:b2PolygonDef = new b2PolygonDef();
			b2pd.SetAsBox(prmWidth / m_physScale / 2, prmHeight / m_physScale / 2);
			b2pd.density=prmDensity;
			b2pd.friction=prmFriction;
			b2pd.restitution=prmRestitution;
			b2pd.filter.groupIndex=prmGroupIndex;
			return b2pd;
		}

		/**
		 * @param _b2pdb2ShapeDef
		 * @param _xBoxオブジェクトのX座標
		 * @param _yBoxオブジェクトのY座標
		 * @param _rotationBoxオブジェクトのRotation
		 * @param _mc表示させるMovieClip
		 */
		public function createBox(_b2pd:b2ShapeDef, _x:int, _y:int, _rotation:int, _sp:Sprite):b2Body {
			var box:b2Body=createShapeWithPd(_x,_y,_rotation,_b2pd,_sp);
			return box;
		}

		/**
		 * @param _radius円オブジェクトの半径
		 * @param _density質量
		 * @param _friction摩擦量
		 * @param _restitution反発量
		 */
		public function createCircleDef(prmRadius:Number, prmDensity:Number, prmFriction:Number, prmRestitution:Number, prmGroupIndex:int = 1):b2CircleDef {
			var b2cc:b2CircleDef = new b2CircleDef();
			b2cc.radius=prmRadius/m_physScale/2;
			b2cc.density=prmDensity;
			b2cc.friction=prmFriction;
			b2cc.restitution=prmRestitution;
			b2cc.filter.groupIndex=prmGroupIndex;
			return b2cc;
		}

		/**
		 * @param _xBoxオブジェクトのX座標
		 * @param _yBoxオブジェクトのY座標
		 * @param _mc表示させるMovieClip
		 */
		public function createCircle(_b2cd:b2ShapeDef, _x:int, _y:int, _rotation:int, _sp:Sprite):b2Body {
			var cir:b2Body=createShapeWithPd(_x,_y,_rotation,_b2cd,_sp);
			return cir;
		}

		private function createShapeWithPd(X:Number, Y:Number, prmRotation:Number, prmPD:b2ShapeDef, prmSp:Sprite):b2Body {
			var b2bd:b2BodyDef = new b2BodyDef();
			b2bd.position.Set(X / m_physScale, Y / m_physScale);
			b2bd.angle=prmRotation*Math.PI/180;
			if (prmSp) {
				b2bd.userData=prmSp;
			}

			var b2b:b2Body=m_world.CreateBody(b2bd);
			b2b.CreateShape(prmPD);

			b2b.SetMassFromShapes();

			return b2b;
		}


		/**
		 * @param _jtモーターをセットするb2RevoluteJoint
		 * @param _speedモーターのスピード（回転の速さ）
		 * @param _torqueモーターのトルク（回転の力）
		 */
		public function setJointMotor(_jt:b2RevoluteJoint, _speed:Number, _torque:Number):void {
			if (_jt) {
				_jt.SetMotorSpeed(_speed);
				_jt.SetMaxMotorTorque(_torque);
				_jt.EnableMotor(true);
			}
		}

		/**
		 * @param _b1ジョイント元となるb2Body
		 * @param _b2ジョイント先となるb2Body
		 * @param _xジョイントの中心X座標
		 * @param _yジョイントの中心Y座標
		 */
		public function createRJ(_b1:b2Body, _b2:b2Body, _x:int, _y:int):b2RevoluteJoint {
			var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
			jd.Initialize(_b1, _b2, new b2Vec2(_x / m_physScale, _y / m_physScale));
			jd.enableLimit=false;

			var jt:b2RevoluteJoint=m_world.CreateJoint(jd) as b2RevoluteJoint;
			return jt;
		}

		/**
		 * @param _rjジョイントをセットするb2RevoluteJoint
		 * @param _lowerAngleジョイントの最小角度
		 * @param _upperAngleジョイントの最大角度
		 */
		public function setJointLimit(_rj:b2RevoluteJoint, _lowerAngle:Number, _upperAngle:Number):void {
			if (_rj) {
				_rj.SetLimits(_lowerAngle / (180/Math.PI), _upperAngle / (180/Math.PI) );
				_rj.m_enableLimit=true;
			}
		}

		public function movePosition(b2:b2Body, _x:Number, _y:Number, _rotation:Number):void {
			var pos:b2Vec2 = new b2Vec2(_x/m_physScale,_y/m_physScale);
			b2.SetXForm(pos, _rotation  * Math.PI / 180);
		}

	}
}