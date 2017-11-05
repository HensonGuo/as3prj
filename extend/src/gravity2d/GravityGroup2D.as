package gravity2d 
{
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import flash.display.Sprite;

	public class GravityGroup2D {
		
		public var sp:Sprite;
		public var gv:Gravity2D;

		public var density:Number;
		public var friction:Number;
		public var restitution:Number;
		public var groupIndex:int;

		public var go:Array;
		public var rj:Array;
		public var grj:Array;

		public function GravityGroup2D(_sp:Sprite, _gv:Gravity2D, _groupIndex:int = 1, _density:Number = 1, _friction:Number = 0.5, _restitution:Number = 0.5):void {
			
			sp=_sp;
			gv=_gv;
			
			density = _density;
			friction = _friction;
			restitution = _restitution;
			groupIndex = _groupIndex;
			
			go = new Array();
			rj = new Array();
			grj = new Array();
			
			createAllGravityObjects();
		}
		
		//************************************************************ create GravityObject
		public function createGravityObject(_name:String):void
		{
			var _go:GravityObject2D = new GravityObject2D(sp[_name], gv, groupIndex, density, friction, restitution);
			go[_name] = _go;
		}
		
		public function createAllGravityObjects():void
		{
			var max:uint = sp.numChildren;
			for (var i:uint = 0; i<max; i++) {
				var _sp:Sprite = sp.getChildAt(i) as Sprite;
				if (_sp) {
					var _name:String = _sp.name;
					if (!go[_name]) {
						var _go:GravityObject2D=new GravityObject2D( _sp, gv, groupIndex, density, friction, restitution);
						go[_name] = _go;
					}
				}
			}
			
			/*
			for each (var spChild:Sprite in sp) {
				if (!go[spChild.name]) {
					var _go:GravityObject2D=new GravityObject2D(spChild,gv, groupIndex, density, friction, restitution);
					go[spChild.name] = _go;
				}
			}
			*/
		}		

		//************************************************************ Joint		
		//---------------------------Create Joint
		public function createAllJoints():void {

			for each (var go1:GravityObject2D in go) {
				for each (var go2:GravityObject2D in go) {
					if (go1!=go2 && (!checkJointed(go1, go2))) {
						if ((go1.sp.width + go1.sp.height) <= (go2.sp.width + go2.sp.height)) { //いつも小さい方から大きい方に向かってジョイントする
							if (go1.sp.hitTestObject(go2.sp)) {
								var jointed:Boolean = false;
								
								if (go2.figure == "circle") tryJoint(go2, go1,  0,  0 ); //円の場合は先ず中心をtryJoint
								
								for (var _x:uint = 0; _x <= go1.sp.width / 2; _x++) {
									for (var _y:uint = 0; _y <= go1.sp.height / 2; _y++) {
										//中心から外側に向かってhitTestPointを査定
										tryJoint(go1, go2,  _x,  _y );
										tryJoint(go1, go2,  _x, -_y );
										tryJoint(go1, go2, -_x,  _y );
										tryJoint(go1, go2, -_x, -_y );
									}
								}
							}
						}
					}
				}
			}

			function checkJointed(_go1:GravityObject2D, _go2:GravityObject2D):Boolean {
				var retVal:Boolean = false;
				if (rj[_go1.b2.m_userData.name + _go2.b2.m_userData.name]) retVal = true;
				if (rj[_go2.b2.m_userData.name + _go1.b2.m_userData.name]) retVal = true;
				return retVal;
			}
			
			function tryJoint(_go1:GravityObject2D, _go2:GravityObject2D, _x:int, _y:int):void {
				if (!jointed) {
					if (_go2.sp.hitTestPoint(_go1.x + _x, _go1.y + _y, true)) {
						addJoint(_go1, _go2, _x, _y, false);
						jointed = true;
					}
				}
			}
		}

		private function addJoint(_go1:GravityObject2D, _go2:GravityObject2D, _jointX:int, _jointY:int, _rotationPoint:Boolean = true):void {
			
			var jointX:int;
			var jointY:int;
			
			if (_rotationPoint) {
				jointX = _go1.x + _jointX * Math.cos(_go1.rotation * Math.PI / 180) - _jointY * Math.sin(_go1.rotation * Math.PI / 180);
				jointY = _go1.y + _jointX * Math.sin(_go1.rotation * Math.PI / 180) + _jointY * Math.cos(_go1.rotation * Math.PI / 180);
			} else {
				jointX = _jointX + _go1.x;
				jointY = _jointY + _go1.y;
			}
			
			var _rj:b2RevoluteJoint = gv.createRJ(_go1.b2, _go2.b2, jointX, jointY);
			rj[_go1.b2.m_userData.name + _go2.b2.m_userData.name] = _rj;
		}

		public function createJoint(_name1:String, _name2:String, _jointX:int = 0, _jointY:int = 0, _rotationPoint:Boolean = true):void {
			addJoint(go[_name1], go[_name2], _jointX, _jointY, _rotationPoint);
		}
		
		//------------------------------Joint Limit
		public function setJointLimit(_name1:String, _name2:String, _lowerAngle:Number = 0, _upperAngle:Number = 0):void {
			var _name:String = (rj[_name1 + _name2])?(_name1 + _name2):(_name2 + _name1);
			gv.setJointLimit(rj[_name], _lowerAngle,_upperAngle);
		}

		public function setAllJointLimits(_lowerAngle:Number = 0, _upperAngle:Number = 0):void {
			for each (var _rj:b2RevoluteJoint in rj) {
				gv.setJointLimit(_rj, _lowerAngle,_upperAngle);
			}
		}
		
		//------------------------------free Limit
		public function freeJointLimit(_name1:String, _name2:String):void {
			var _name:String = (rj[_name1 + _name2])?(_name1 + _name2):(_name2 + _name1);
			rj[_name].m_enableLimit = false;
		}

		public function freeAllJointLimits():void {
			for each (var _rj:b2RevoluteJoint in rj) {
				_rj.m_enableLimit = false;
			}
		}
		
		//----------------------------Set motor
		public function setJointMotor(_name1:String, _name2:String, _speed:Number, _torque:Number, _freeLimit:Boolean = true):void {
			var _name:String = (rj[_name1 + _name2])?(_name1 + _name2):(_name2 + _name1);
			if (_freeLimit) freeJointLimit(_name1, _name2);
			gv.setJointMotor(rj[_name], _speed, _torque);
		}

		public function setAllJointMotors(_speed:Number, _torque:Number, _freeLimit:Boolean = true):void {
			for each (var _rj:b2RevoluteJoint in rj) {
				if (_freeLimit) freeGroundJointLimit(_rj.m_body1.m_userData.name);
				if (_rj) gv.setJointMotor(_rj, _speed, _torque);
			}
		}

		//------------------------------Destroy Joint
		public function destroyJoint(_name1:String, _name2:String):void {
			var _name:String = (rj[_name1 + _name2])?(_name1 + _name2):(_name2 + _name1);
			gv.m_world.DestroyJoint(rj[_name]);
			rj[_name] = null;
		}
		
		public function destroyAllJoints():void {
			for each (var _rj:b2RevoluteJoint in rj) {
				if (_rj) gv.m_world.DestroyJoint(_rj);
			}
			rj = new Array();
		}
		
		//************************************************************Ground Joint
		//---------------------------Create Joint
		public function createAllGroundJoints():void {
			for each (var _go:GravityObject2D in go) {
				addGroundJoint(_go, 0, 0, false);
			}
		}

		private function addGroundJoint(_go:GravityObject2D, _jointX:int, _jointY:int, _rotationPoint:Boolean = true):void {
			
			var jointX:int;
			var jointY:int;
			
			if (_rotationPoint) {
				jointX = _go.x + _jointX * Math.cos(_go.rotation * Math.PI / 180) - _jointY * Math.sin(_go.rotation * Math.PI / 180);
				jointY = _go.y + _jointX * Math.sin(_go.rotation * Math.PI / 180) + _jointY * Math.cos(_go.rotation * Math.PI / 180);
			} else {
				jointX = _jointX + _go.x;
				jointY = _jointY + _go.y;
			}
			
			var _rj:b2RevoluteJoint = gv.createRJ(_go.b2, gv.m_world.GetGroundBody(), jointX, jointY);
			grj[_go.b2.m_userData.name] = _rj;
		}

		public function createGroundJoint(_name:String, _jointX:int = 0, _jointY:int = 0, _rotationPoint:Boolean = true):void {
			addGroundJoint(go[_name], _jointX, _jointY, _rotationPoint);
		}
		
		//------------------------------Joint Limit
		public function setGroundJointLimit(_name:String, _lowerAngle:Number = 0, _upperAngle:Number = 0):void {
			gv.setJointLimit(grj[_name], _lowerAngle,_upperAngle);
		}

		public function setAllGroundJointLimits(_lowerAngle:Number = 0, _upperAngle:Number = 0):void {
			for each (var _grj:b2RevoluteJoint in grj) {
				gv.setJointLimit(_grj, _lowerAngle,_upperAngle);
			}
		}
		
		//------------------------------free Limit
		//背景へのジョイント範囲リミットを解除します。
		// @param _name:String インスタンス名を文字列で指定します。
		public function freeGroundJointLimit(_name:String):void {
			grj[_name].m_enableLimit = false;
		}

		//全てのインスタンスの背景へのジョイント範囲リミットを解除します。
		public function freeAllGroundJointLimits():void {
			for each (var _grj:b2RevoluteJoint in grj) {
				_grj.m_enableLimit = false;
			}
		}
		
		//----------------------------Set motor
		public function setGroundJointMotor(_name:String, _speed:Number, _torque:Number, _freeLimit:Boolean = true):void {
			if (_freeLimit) freeGroundJointLimit(_name);
			gv.setJointMotor(grj[_name], _speed, _torque);
		}

		public function setAllGroundJointMotors(_speed:Number, _torque:Number, _freeLimit:Boolean = true):void {
			for each (var _grj:b2RevoluteJoint in grj) {
				if (_freeLimit) freeGroundJointLimit(_grj.m_body1.m_userData.name);
				if (_grj) gv.setJointMotor(_grj, _speed, _torque);
			}
		}

		//------------------------------Destroy Joint
		public function destroyGroundJoint(_name:String):void {
			gv.m_world.DestroyJoint(grj[_name]);
			grj[_name] = null;
		}
		
		public function destroyAllGroundJoints():void {
			for each (var _grj:b2RevoluteJoint in grj) {
				if (_grj) gv.m_world.DestroyJoint(_grj);
			}
			grj = new Array();
		}
		
		//************************************************************Ohters

		//座標をダイレクトに指定して、ダイレクトに移動させる
		//移動対象のGravityObject2Dがジョイントを使っていると、上手く動かない場合があるので注意
		public function setPosition(_name:String, _x:int, _y:int, _rotation:int = 0):void {
			go[_name].setPosition(_x, _y, _rotation);
		}
		
		//相対的な位置を指定して移動させる。
		//移動対象のGravityObject2Dがジョイントを使っていると、上手く動かない場合があるので注意
		public function addPosition(_name:String, _x:int = 0, _y:int = 0, _rotation:int = 0):void {
			go[_name].addPosition(_x, _y, _rotation);
		}

		//指定した秒数後に物理オブジェクトを破棄します。
		// @param _name:String  インスタンス名をストリングで指定します。
		// @param _lifeTime:uint オブジェクトを破棄する秒数を指定します。
		public function setLifeTime(_name:String, _lifeTime:uint):void {
			go[_name].setLifeTime(_lifeTime);
		}
		
		//MovieClipのvisibleを切り替えます。
		// @param _name:String  インスタンス名をストリングで指定します。
		// @param _lifeTime:uint オブジェクトを破棄する秒数を指定します。		
		public function setHide(_name:String, _x:int, _y:int):void {
			go[_name].setHide(_x, _y);
		}

		public function setAppear(_name:String, _x:int, _y:int):void {
			go[_name].setAppear(_x, _y);
		}

		//------------------------------Destroy
		public function destroy(_name:String):void {
			go[_name].destroy();
		}

		public function destroyAll():void {
			for each (var _go:GravityObject2D in go) {
				_go.destroy();
			}
		}

		//------------------------------setForce
		public function setForce(_name:String, _vecX:Number, _vecY:Number):void {
			go[_name].setForce(_vecX, _vecY);
		}

		public function setAllForces(_vecX:Number, _vecY:Number):void {
			for each (var _go:GravityObject2D in go) {
				_go.setForce(_vecX, _vecY);
			}
		}

		//------------------------------setAngleForce
		public function setAngleForce(_name:String, _omega:Number):void {
			go[_name].setAngleForce(_omega);
		}

		public function setAllAngleForces(_omega:Number):void {
			for each (var _go:GravityObject2D in go) {
				_go.setAngleForce(_omega);
			}
		}

		//------------------------------sleep
		public function sleep(_name:String):void {
			go[_name].sleep();
		}

		public function sleepAll():void {
			for each (var _go:GravityObject2D in go) {
				_go.sleep();
			}
		}

		//------------------------------wakeup
		public function wakeup(_name:String):void {
			go[_name].wakeup();
		}

		public function wakeupAll():void {
			for each (var _go:GravityObject2D in go) {
				_go.wakeup();
			}
		}

		//------------------------------setMass
		public function setMass(_name:String, _bool:Boolean):void {
			go[_name].setMass(_bool);
		}

		public function setAllMasses(_bool:Boolean):void {
			for each (var _go:GravityObject2D in go) {
				_go.setMass(_bool);
			}
		}
		
		public function getContactList(_name:String):Array {
			return go[_name].getContactList();
		}
	}
}