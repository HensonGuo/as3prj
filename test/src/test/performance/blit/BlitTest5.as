package test.performance.blit
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import test.ITest;
	
	import utils.debug.Profile;
	
	public class BlitTest5 implements ITest
	{
		public function BlitTest5()
		{
		}
		
		public function test(stage:Stage):void
		{
			Profile.init(AnimeTest.rootContainer,3);
			var num:int=10000;
			var i:int;
			var rectSide:int = 2;
			var rectHalf:Number = rectSide/2;
			var rotationRate:int = 1;
			
			var dataA:Vector.<Array> = new Vector.<Array>(num);
			//var dataA:Array = new Array(num);
			var datumA:Array;
			var loopN:int
			var bmpdA:Vector.<BitmapData> = new Vector.<BitmapData>(int(360/rotationRate));
			//var bmpdA:Array = new Array(int(360/rotationRate));
			var diagL:Number = Math.sqrt(2*rectSide*rectSide);
			var diagLHalf:Number = diagL/2;
			var bmpdAL:int = bmpdA.length;
			var stageW:int = stage.stageWidth;
			var stageH:int = stage.stageHeight;
			var speed:Number;
			var initialDirection:Number;
			
			initF();
			bitmapDataF();
			// The only significant change here is datumA[0] is a Bitmap.  Its bitmapData property will be assigned in animateBitmapsF().
			function initF():void {
				for (i=num-1;i>=0;i--) {
					datumA = [];
					// Create the Bitmaps that will be added to the display list 
					datumA[0] = new Bitmap(null,"auto",true);
					// Add to the display list
					stage.addChild(datumA[0]);
					// Assign initial positions
					datumA[0].x = int(Math.random()*(stageW-diagL));
					datumA[0].y = int(Math.random()*(stageH-diagL));
					// use speed and initialDirection to define vectorX and vectorY
					speed = 1+2*Math.random();
					initialDirection = 2*Math.PI*Math.random();
					// store vectorX and vectorY
					datumA[1] = speed*Math.cos(initialDirection);
					datumA[2] = speed*Math.sin(initialDirection);
					dataA[i] = datumA;
				}
			}
			// No significant change in bitmapDataF()
			function bitmapDataF():void{
				var mc:MovieClip = new MovieClip();
				with(mc.graphics){
					beginFill(0xaa0000);
					drawRect(-rectHalf,-rectHalf,rectSide,rectSide);
					endFill();
				}
				var mat:Matrix = new Matrix();
				for (i=0; i<360; i+=rotationRate) {
					var bmpd:BitmapData = new BitmapData(diagL,diagL,true,0x00ffff00);
					mat.identity();
					mat.rotate(i*Math.PI/180);
					mat.tx+=diagLHalf;
					mat.ty+=diagLHalf;
					bmpd.draw(mc,mat);
					bmpdA[i] = bmpd;
				}
				loopN = 0;
				stage.addEventListener(Event.ENTER_FRAME,animateBitmapsF);
			}
			
			function animateBitmapsF(e:Event=null):void {
				for (i=num-1;i>=0;i--) {
					// Update the Bitmaps' positions directly
					dataA[i][0].x += 1*dataA[i][1];
					dataA[i][0].y += 1*dataA[i][2];
					if (dataA[i][0].x>stageW-diagL || dataA[i][0].x<0) {
						dataA[i][1] *= -1;
					}
					if (dataA[i][0].y>stageH-diagL || dataA[i][0].y<0) {
						dataA[i][2]*=-1;
					}
					// Assign the bitmapData property for each Bitmap.
					dataA[i][0].bitmapData = bmpdA[loopN%bmpdA.length];
				}
				loopN++;
			}
		}
	}
}