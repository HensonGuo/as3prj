package test.performance.blit
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import test.ITest;
	
	import utils.debug.Profile;
	
	public class BlitTest3 implements ITest
	{
		public function BlitTest3()
		{
		}
		
		public function test(stage:Stage):void
		{
			// The next 4 lines define same variables as in the MovieClip example
			Profile.init(AnimeTest.rootContainer,3);
			var num:int=10000;
			var i:int;
			var stageW:int = stage.stageWidth;
			var stageH:int = stage.stageHeight;
			var rectSide:int = 2;
			var rectHalf:Number = rectSide/2;
			var rotationRate:int = 1;
			// The background color that will be applied to the display bitmap.
			var bgColor:uint = 0x000000;
			// Display rectangle used to "erase" the previously painted pixels.
			var displayBG_Rect:Rectangle = new Rectangle(0,0,stageW,stageH);
			// The display's bitmapData object
			var displayBMPD:BitmapData = new BitmapData(stageW,stageH,false,bgColor);
			// The display bitmap onto which all pixels will be copied and the only thing added to // the stage and viewed by the Flash user.
			var displayBMP:Bitmap = new Bitmap(displayBMPD);
			// Initialize objects needed for steps 2 and 3.
			//var dataA:Array=[];
			//var vec:Vector.<Vector.<int>> = new <Vector.<int>
			var dataA:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>(num);
			//var datumA:Array;
			var datumA:Vector.<Number>;
			//var bmpdA:Array = [];
			var bmpdA:Vector.<BitmapData> = new Vector.<BitmapData>(int(360/rotationRate));
			var loopN:int
			var bmpdAL:int = bmpdA.length
			var diagL:Number = Math.sqrt(2*rectSide*rectSide);
			var diagLHalf:Number = diagL/2;
			var bmpRect:Rectangle=new Rectangle(0,0,diagL,diagL);
			var pt:Point = new Point();
			var speed:Number;
			var initialDirection:Number;
			// Populate dataA (step 2).
			initDataF();
			// Populate bmpdA (step 3).
			bitmapDataF();
			function initDataF():void {
				// Instead of creating num MovieClips with initial positions, speeds and angles, 	// I'm creating num arrays (datumA), that will contain initial position (a 	// point), and vectorX and vectorY (direction of movment).  There is no object 	// that corresponds to the datumA data. These are abstract quantities that will 	// be applied to the bitmapData objects bmpdA (created in bitmapF).
				for(i=num-1;i>=0;i--){
					datumA = new Vector.<Number>(4);
					// datumA's first element will be the initial position which will be 			// updated in the enterFrame loop
					//datumA.push(  new Point( int(Math.random()*(stage.stageWidth-diagL)),int(Math.random()*(stage.stageHeight-diagL)) )  );
					datumA[0] = int(Math.random()*(stageW-diagL));
					datumA[1] = int(Math.random()*(stageH-diagL))
					// speed
					speed = 1+2*Math.random();
					// initialDirection used with speed to define vectorX and vectoryY.  			// Thereafter, they are not needed.
					initialDirection = 2*Math.PI*Math.random();
					datumA[2] = speed*Math.cos(initialDirection);
					datumA[3] = speed*Math.sin(initialDirection);
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
				// I need a temporary matrix so I can apply a rotation to mc when I use the 	// draw() method to transfer mc's pixels to a bitmapData instance.  The draw() 	// method creates a bitmapData instance of the untransformed object.  That is, 	// the object as it appears in your library.  Any change you want to be seen in 	// the bitmapData object has to be applied via one or more of the draw() 	//parameters which include a transform matrix, color transform, blend mode, clip 	// rectangle and smoothig.
				var mat:Matrix = new Matrix();
				for (i=0; i<360; i+=rotationRate) {
					// Instantiate a bitmapData instance large enough to contain the rotated 			// square
					var bmpd:BitmapData = new BitmapData(diagL,diagL,true,0x00ffff00);
					// Unapply the previous changes to mat so it can be reused.
					mat.identity();
					// Apply a rotation to mat
					mat.rotate(i*Math.PI/180);
					// Apply a translation to mat so mc is positioned in the center of bmpd
					mat.tx+=diagLHalf;
					mat.ty+=diagLHalf;
					// Apply the draw() method using mat to make the square appear rotated.
					bmpd.draw(mc,mat);
					// Add this bitmapData instance to bmdA so it can be used in our 				// enterFrame loop.
					bmpdA[i] = bmpd;
				}
				stage.addChild(displayBMP);
				// loopN used to count number of enterframe loops and choose which bitmap to 	// display.  ie, which rotation.
				loopN = 0;
				// step 4.
				stage.addEventListener(Event.ENTER_FRAME,animateBitmapsF);
			}
			
			function animateBitmapsF(e:Event=null):void {
				// Applying the lock() method stops the bitmap from being updated while its 	// bitmapData object is being updated.  I'll unlock when all the bitmapData 	// changes are completed so the bitmap can then be updated.  
				displayBMPD.lock();
				// This is where the pixels in displayBMPD are "erased".  Except, they are not 	// erased.  They are all colored bgColor which is the background color I chose.
				displayBMPD.fillRect(displayBG_Rect,bgColor);
				// This code is similar to the MovieClip example except instead of using mcA to 	// update MovieClips, I am using dataA and updating data.
				for(i=num-1;i>=0;i--){
					// This is quirky.  If I do not perform some aritmetic operation(s) (like 		// multiplying by 1), memory use increases significantly because of each 			// of these lines of code.
					pt.x = dataA[i][0]+1*dataA[i][2];
					pt.y = dataA[i][1]+1*dataA[i][3];;
					//pt.x += 1*dataA[i][2];
					//pt.y += 1*dataA[i][3];
					if (pt.x>stageW-diagL || pt.x<0) {
						dataA[i][2] *= -1;
					}
					if (pt.y>stageH-diagL|| pt.y<0) {
						dataA[i][3] *= -1;
					}
					dataA[i][0] = pt.x;
					dataA[i][1] = pt.y;
					// During each for-loop iteration, pixels are copied from bmpdA to 			// displayBMPD.  You can see how loopN is used to make it appear that 			// squares are rotating and you can see how pt is used to make it appear 			// as if each square is also moving across the stage.
					displayBMPD.copyPixels(bmpdA[loopN%bmpdAL],bmpRect,pt);
				}
				loopN++;
				// all the pixels, for this enterFrame loop iteration, have been applied to 	// displayBMPD
				// Finally, apply the unlock() method so the bitmap corresponding the this 	// bitmapData object, is updated.
				displayBMPD.unlock();
			}
		}
	}
}