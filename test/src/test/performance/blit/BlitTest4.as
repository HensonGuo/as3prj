package test.performance.blit
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import test.ITest;
	
	import utils.debug.Profile;
	
	public class BlitTest4 implements ITest
	{
		public function BlitTest4()
		{
		}
		
		public function test(stage:Stage):void
		{
			Profile.init(this,3);
			var num:int=10000;
			var rectSide:int = 2;
			var rotationRate:int = 1;
			var i:int;
			var stageW:int = stage.stageWidth;
			var stageH:int = stage.stageHeight;
			var rectHalf:Number = rectSide/2;
			
			var initialDirection:Number;
			var speed:Number;
			
			// Initialize objects needed for steps 2 and 3.
			var dataA:Array=[];
			var datumA:Array;
			var loopN:int
			var bmpdA:Array = [];
			var bmpdA_len:int;
			var diagL:Number = Math.sqrt(2*rectSide*rectSide);
			var diagLHalf:Number = diagL/2;
			var bmpRect:Rectangle=new Rectangle(0,0,diagL,diagL);
			var pt:Point = new Point();
			/////////////////////////////////////////////////////////////////
			var tl:MovieClip = this;
			//var tl:MovieClip = new MovieClip();
			//addChild(tl)
			/////////////////////////////////////////////////////////////////
			// Populate dataA (step 2).
			initDataF();
			// Populate bmpdA (step 3).
			bitmapDataF();
			
			function initDataF():void {
				// Instead of creating num MovieClips with initial positions, speeds and angles, 	// I'm creating num arrays (datumA), that will contain initial position (a point), and vectorX and vectorY (direction of movment).  There is no object that corresponds to the datumA data.  	// These are abstract quantities that will be applied to the bitmapData objects 	// in bmpdA (created in bitmapF).
				for(i=num-1;i>=0;i--){
					datumA = [];
					// datumA's first element will be the initial position which will be 			// updated in the enterFrame loop
					datumA.push(  new Point( int(Math.random()*(stage.stageWidth-diagL)),int(Math.random()*(stage.stageHeight-diagL)) )  );
					// speed
					speed = 1+2*Math.random();
					// initial direction used with speed to define vectorX and vectoryY.  Thereafter, not needed
					initialDirection = 360*Math.random()*Math.PI/180;
					datumA.push(speed*Math.cos(initialDirection));
					datumA.push(speed*Math.sin(initialDirection));
					// datumA = [point,vectorX,vectorY]
					// Each datumA is added to dataA.  DataA serves the same purpose as 			// mcA in the MovieClip example.
					dataA[i] = datumA;
				}
			}
			// This is where step 3 is done
			function bitmapDataF():void{
				// I need a temporary display object that I can use to populate bmpA.  
				// mc will be gc'd because it's local to bitmapF()
				var mc:MovieClip = new MovieClip();
				with(mc.graphics){
					beginFill(0xaa0000);
					drawRect(-rectHalf,-rectHalf,rectSide,rectSide);
					endFill();
				}
				// I need a temporary matrix so I can apply a rotation to mc when I use the 	// draw() method to transfer mc's pixels to a bitmapData instance.  The draw() 	// method creates a bitmapData instance of the untransformed object.  That is, 	// the object as it appears in your library.  Any change you want to be seen in 	// the bitmapData object has to be applied via one or more of the draw() 	// parameters which include a transform matrix, color transform, blend mode, clip 	// rectangle and smoothig.
				var mat:Matrix = new Matrix();
				
				for (i=0; i<360; i+=rotationRate) {
					// Instantiate a bitmapData instance large enough to contain the rotated 			// square
					var bmpd:BitmapData = new BitmapData(diagL,diagL,true,0x00ffff00);
					// Unapply the previous changes to mat
					mat.identity();
					// Apply a rotation to mat
					mat.rotate(i*Math.PI/180);
					// Apply a translation to mat so mc is positioned in the center of bmpd
					mat.tx+=diagLHalf;
					mat.ty+=diagLHalf;
					// Apply the draw() method using mat to make the square appear rotated.
					bmpd.draw(mc,mat);
					// Add this bitmapData instance to bmdA so it can be used in our 				// enterFrame loop.
					bmpdA.push(bmpd);
				}
				bmpdA_len = bmpdA.length;
				// loopN used to count number of enterframe loops and choose which bitmap to display.  ie, which rotation.
				loopN = 0;
				// step 4.
				stage.addEventListener(Event.ENTER_FRAME,animateBitmapsF);
			}
			
			function animateBitmapsF(e:Event=null):void {
				tl.graphics.clear();
				for(i=num-1;i>=0;i--){
					pt = Point(dataA[i][0]);
					// This is quirky.  If i do not perform some aritmetic operation(s) (like multiply by 1), memory use increases significantly because of each of these lines of code.
					pt.x += 1*dataA[i][1];
					pt.y += 1*dataA[i][2];
					
					if (pt.x>stageW-diagL || pt.x<0) {
						dataA[i][1] *= -1;
					}
					if (pt.y>stageH-diagL|| pt.y<0) {
						dataA[i][2] *= -1;
					}
					tl.graphics.beginBitmapFill(bmpdA[loopN%bmpdA_len],null,false);
					tl.graphics.drawRect(pt.x, pt.y, rectSide, rectSide);
					tl.graphics.endFill();
					loopN++;
				}
			}
			

		}
	}
}