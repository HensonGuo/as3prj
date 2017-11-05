package box2d
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Box2DLearn extends Sprite
	{
		private var mMainMenu:Sprite; 
		private var bodyDef:b2BodyDef; 
		private var inc:int; 
		public var m_world:b2World; 
		public var m_velocityIterations:int = 10; 
		public var m_positionIterations:int = 10; 
		public var m_timeStep:Number = 1.0/30.0;
		
		public function Box2DLearn()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded (e:Event):void { 
			// Define the gravity vector 
			var gravity:b2Vec2 = new b2Vec2(0.0, 10.0);
			// Allow bodies to sleep 
			var doSleep:Boolean = true; 
			// Construct a world object 
			m_world = new b2World( gravity, doSleep); 
			// Vars used to create bodies 
			var body:b2Body; 
			var boxShape:b2PolygonShape; 
			var circleShape:b2CircleShape; 
			// Add ground body 
			bodyDef = new b2BodyDef(); 
			//bodyDef.position.Set(15, 19); 
			bodyDef.position.Set(10, 28); 
			//bodyDef.angle = 0.1; 
			boxShape = new b2PolygonShape(); 
			boxShape.SetAsBox(30, 3); 
			var fixtureDef:b2FixtureDef = new b2FixtureDef(); 
			fixtureDef.shape = boxShape; 
			fixtureDef.friction = 0.3; 
			// static bodies require zero density 
			fixtureDef.density = 0; 
			// Add sprite to body userData 
			var box:Quad = new Quad(2000, 200, 0xCCCCCC); 
			box.pivotX = box.width / 2.0; 
			box.pivotY = box.height / 2.0; 
			bodyDef.userData = box; 
			bodyDef.userData.width = 34 * 2 * 30; 
			bodyDef.userData.height = 30 * 2 * 3; 
			addChild(bodyDef.userData); 
			body = m_world.CreateBody(bodyDef); 
			body.CreateFixture(fixtureDef); 
			var quad:Quad; 
			// Add some objects for (var i:int = 1; i < 100; i++) { bodyDef = new b2BodyDef(); bodyDef.type = b2Body.b2_dynamicBody; bodyDef.position.x = Math.random() * 15 + 5; bodyDef.position.y = Math.random() * 10; var rX:Number = Math.random() + 0.5; var rY:Number = Math.random() + 0.5; // Box boxShape = new b2PolygonShape(); boxShape.SetAsBox(rX, rY); fixtureDef.shape = boxShape;
			fixtureDef.density = 1.0; fixtureDef.friction = 0.5; fixtureDef.restitution = 0.2; // create the quads quad = new Quad(100, 100, Math.random()*0xFFFFFF); quad.pivotX = quad.width / 2.0; quad.pivotY = quad.height / 2.0; // this is the key line, we pass as a userData the starling.display.Quad bodyDef.userData = quad; bodyDef.userData.width = rX * 2 * 30; bodyDef.userData.height = rY * 2 * 30; body = m_world.CreateBody(bodyDef); body.CreateFixture(fixtureDef); // show each quad (acting as a skin of each body) addChild(bodyDef.userData); }// on each frame addEventListener(Event.ENTER_FRAME, Update); }publi
	}
}