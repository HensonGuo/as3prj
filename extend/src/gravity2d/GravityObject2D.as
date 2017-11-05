package gravity2d
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import Box2D.Collision.Shapes.b2ShapeDef;
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Common.Math.b2Vec2;
	
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class GravityObject2D {
		
		public var sp:Sprite;
		public var figure:String;

		public var jointGO2D:GravityObject2D;
		public var rj:b2RevoluteJoint;
		public var b2:b2Body;
		private var gv:Gravity2D;
		private var rjg:b2RevoluteJoint;
		public var isJoint:Boolean = false;

		private var directMoveX:Boolean = false;
		private var directMoveY:Boolean = false;
		private var directMoveR:Boolean = false;

		private var newX:int;
		private var newY:int;
		private var newR:int;

		private var width:Number;
		private var height:Number;

		public var lifeTimer:Timer;

		/**
		 * @param _mcMovieClipを指定
		 * @param _gvGravity2Dを指定
		 * @param _groupIndex衝突判定を行うグループを指定（マイナス値を指定すると、同じ値のオブジェクトとは衝突判定を行わなくなります）
		 * @param _density密度を指定（密度x大きさ＝重さ）
		 * @param _friction摩擦係数を指定
		 * @param _restitution反発係数を指定（衝突した際の跳ね返る大きさ。１で同じ強さで跳ね返る）
		 */
		public function GravityObject2D(_sp:Sprite, _gv:Gravity2D, _groupIndex:int = 1, _density:Number = 1, _friction:Number = 0.5, _restitution:Number = 0.5):void {
			sp = _sp;
			gv = _gv;

			var Rotation:Number = sp.rotation;
			sp.rotation = 0;
			width = sp.width;
			height = sp.height;
			sp.rotation = Rotation;

			figure = "square";
			if (Math.floor(width) == Math.floor(height)) {
				var r:uint = width / 2;
				if (!sp.hitTestPoint(x + r - 1, y + r - 1, true) && 
					 !sp.hitTestPoint(x + r - 1, y - r + 1, true) &&
					 !sp.hitTestPoint(x - r + 1, y + r - 1, true) &&
					 !sp.hitTestPoint(x - r + 1, y - r + 1, true)) {
					figure = "circle";
				}
			}

			var sd:b2ShapeDef;
			switch (figure) {
				case "square" :
					sd = gv.createPolygonDef(width,height,_density,_friction,_restitution,_groupIndex);
					b2 = gv.createBox(sd,x,y,rotation,sp);
					break;
				case "circle" :
					sd = gv.createCircleDef(width,_density,_friction,_restitution,_groupIndex);
					b2 = gv.createCircle(sd,x,y,rotation,sp);
					break;
			}

			if (sp.x != x || sp.y != y) {
				b2.m_userData.globalX = x - sp.x;
				b2.m_userData.globalY = y - sp.y;
			} else {
				b2.m_userData.globalX = 0;
				b2.m_userData.globalY = 0;
			}

			b2.AllowSleeping(false);
			gv.go2D.push(this);
			
			removeTimer();
		}

		// 座標Xを取得
		public function get x():int {
			var point:Point = sp.localToGlobal(new Point(0,0));
			return point.x;
		}

		// 座標Xを設定
		public function set x(value:int):void {
			directMoveX = true;
			newX = value;
		}

		// 座標Yを取得
		public function get y():int {
			var point:Point = sp.localToGlobal(new Point(0,0));
			return point.y;
		}

		// 座標Yを設定
		public function set y(value:int):void {
			directMoveY = true;
			newY = value;
		}

		// Rotationを取得
		public function get rotation():int {
			return sp.rotation;
		}

		// Rotationを設定
		public function set rotation(value:int):void {
			directMoveR = true;
			newR = value;
		}

		// x, y, rotationプロパティを設定した場合、enterFrameイベントでこのfunctionによって移動が行われます。
		public function move():void {
			if (directMoveX || directMoveY || directMoveR) {

				if (! directMoveX) {
					newX = x;
				}
				if (! directMoveY) {
					newY = y;
				}
				if (! directMoveR) {
					newR = rotation;
				}

				gv.movePosition(b2, newX, newY, newR);

				directMoveX = false;
				directMoveY = false;
				directMoveR = false;

				b2.PutToSleep();//移動は重力をクリアしながら行う。(移動中の重力がたまって最後に爆発する為)
			}
		}

		//座標を指定して、ダイレクトに移動させる
		//ジョイントを使っていると、上手く動かない場合があるので注意
		public function setPosition(_x:int, _y:int, _rotation:int = 0):void {
			gv.movePosition(b2, _x, _y, _rotation);
		}

		//相対的な位置を指定して移動させる。
		//ジョイントを使っていると、上手く動かない場合があるので注意
		public function addPosition(_x:int, _y:int, _rotation:int = 0):void {
			if (_x != 0) {
				x += _x;
			}
			if (_y!=0) {
				y+=_y;
			}
			if (_rotation!=0) {
				rotation+=_rotation;
			}
		}

		public function sleep():void {
			b2.PutToSleep();
		}

		public function wakeup():void {
			b2.WakeUp();
		}

		// x, y, rotationプロパティを直指定して移動させる
		public function moveTo(_x:int, _y:int, _rotation:Number):void {
			gv.movePosition(b2, _x, _y, _rotation);
			//b2.PutToSleep(); //移動は重力をクリアしながら行う。
		}

		//RevolutionJoint (２つのオブジェクトの中心と中心を、指定した座標を中心として時計の針みたいな感じでジョイントする)
		//自分自身の中心座標を基準（0,0）とした相対座標でJointX,JointYを指定する
		//_staticPoint=falseを指定すると、Spriteのrotationに合わせてジョイント座標も回転させる
		public function createJoint(_jointGO2D:GravityObject2D, _jointX:Number = 0, _jointY:Number = 0, _staticPoint:Boolean = true):void {
			destroyJoint();
			jointGO2D=_jointGO2D;
			
			var jointX:int;
			var jointY:int;
			
			if (_staticPoint) {
				jointX = _jointX + x;
				jointY = _jointY + y;
			} else {
				jointX = x + _jointX * Math.cos(rotation * Math.PI / 180) - _jointY * Math.sin(rotation * Math.PI / 180);
				jointY = y + _jointX * Math.sin(rotation * Math.PI / 180) + _jointY * Math.cos(rotation * Math.PI / 180);
			}
			
			rj=gv.createRJ(b2,jointGO2D.b2, jointX, jointY);
			isJoint=true;
		}

		//自分自身の中心座標を基準（0,0）とした相対座標でJointX,JointYを指定する
		//_staticPoint=falseを指定すると、Spriteのrotationに合わせてジョイント座標も回転させる
		public function createGroundJoint(_jointX:Number = 0, _jointY:Number = 0, _staticPoint:Boolean = true):void {
			
			destroyGroundJoint();
			
			var jointX:int;
			var jointY:int;
			
			if (_staticPoint) {
				jointX = _jointX + x;
				jointY = _jointY + y;
			} else {
				jointX = x + _jointX * Math.cos(rotation * Math.PI / 180) - _jointY * Math.sin(rotation * Math.PI / 180);
				jointY = y + _jointX * Math.sin(rotation * Math.PI / 180) + _jointY * Math.cos(rotation * Math.PI / 180);
			}
			
			rjg = gv.createRJ(b2,gv.m_world.GetGroundBody(), jointX, jointY);
		}

		//オブジェクトへのジョイントを破棄します。
		public function destroyJoint():void {
			if (rj) {
				gv.m_world.DestroyJoint(rj);
				isJoint=false;
			}
		}

		//背景へのジョイントを破棄します。
		public function destroyGroundJoint():void {
			if (rjg) {
				gv.m_world.DestroyJoint(rjg);
			}
		}

		//ジョイントの最小角度、最大角度を指定する
		public function setJointLimit(_lowerAngle:Number = 0, _upperAngle:Number = 0):void {
			gv.setJointLimit(rj, _lowerAngle,_upperAngle);
		}

		//地面ジョイントの最小角度、最大角度を指定する
		public function setGroundJointLimit(_lowerAngle:Number = 0, _upperAngle:Number = 0):void {
			gv.setJointLimit(rjg, _lowerAngle,_upperAngle);
		}

		//モーターをセットする
		public function setJointMotor(_speed:Number, _torque:Number):void {
			gv.setJointMotor(rj, _speed, _torque);
		}

		//モーターをセットする
		public function setGroundJointMotor(_speed:Number, _torque:Number):void {
			gv.setJointMotor(rjg, _speed, _torque);
		}

		//オブジェクトを破棄する。
		public function destroy():void {
			
			removeTimer();
			
			if (b2) {
				gv.m_world.DestroyBody(b2);//ジョイントはDestroyBodyで削除される
				b2=null;
				isJoint=false;
				
				sp.x = 0;
				sp.y = 0;
				sp.rotation = 0;
				sp.visible = false;
				//gv.sliceGo2D();
			}
		}

		//一方向への力を加える。
		public function setForce(vecX:Number, vecY:Number):void {
			b2.SetLinearVelocity(new b2Vec2(vecX, vecY));
		}

		//回転の力を加える。
		public function setAngleForce(omega:Number):void {
			b2.SetAngularVelocity(omega);
		}

		//重力の影響を受けるかどうか指定します。
		public function setMass(_bool:Boolean):void {
			if (_bool) {
				b2.SetMassFromShapes();
			} else {
				var mass:b2MassData = new b2MassData();
				b2.SetMass(mass);
			}
		}

		//指定した秒数後に物理オブジェクトを破棄します
		public function setLifeTime(_time:uint):void {
			
			removeTimer();

			lifeTimer = new Timer(_time);
			lifeTimer.addEventListener(TimerEvent.TIMER, eLifeTimer);
			lifeTimer.start();
		}
		
		private function eLifeTimer(e:TimerEvent):void {
			removeTimer();
			destroy();
		}
		
		private function removeTimer():void {
			if (lifeTimer) {
				lifeTimer.stop();
				lifeTimer.removeEventListener(TimerEvent.TIMER, eLifeTimer);
				lifeTimer = null;
			}
		}
		
		//当たり判定等に使う、コンタクトリストを取得します。
		public function getContactList():Array {
			
			var retArray:Array = new Array();
			for (var ce:b2ContactEdge = b2.m_contactList; ce != null; ce = ce.next) {  
				
				var obj2:b2Body = ce.contact.GetShape2().m_body; //当たり先のb2Body
				if (obj2.m_userData.name != sp.name) {
					retArray.push(obj2.m_userData.name);
				}
			}
			
			return retArray;
		}

	}
}