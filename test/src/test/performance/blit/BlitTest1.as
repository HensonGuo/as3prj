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
	
	public class BlitTest1 implements ITest
	{
		public function BlitTest1()
		{
		}
		
		public function test(stage:Stage):void
		{
			// fps test comparing movieclips vs blitting.
			// to use comment-out one of the comment blocks, in turn.
			
			Profile.init(AnimeTest.rootContainer,3);
			var num:int=10000;
			var rectSide:int = 2;
			var rotationRate:int = 1;
			var i:int;
			
			// 15fps,27.8mb
			/*
			var mc:MovieClip;
			var mcA:Array=[];
			movieclipF();
			
			function movieclipF():void {
			//for (i=0; i<num; i++) {
			for(i=num-1;i>=0;i--){
			mc = new MovieClip();
			with (mc.graphics) {
			beginFill(0xaa0000);
			drawRect(0,0,4,4);
			endFill();
			}
			mc.speed = 1+int(2*Math.random());
			mc.angle = int(360*Math.random());
			mc.x = int(Math.random()*(stage.stageWidth-mc.width/2));
			mc.y = int(Math.random()*(stage.stageHeight-mc.height/2));
			addChild(mc);
			mc.cacheAsBitmap = true;
			mc.mouseEnabled=false;
			mc.mouseChildren=false;
			mcA[i] = mc;
			}
			this.addEventListener(Event.ENTER_FRAME,animateMovieClipsF);
			}
			
			function animateMovieClipsF(e:Event):void {
			//for (i=0; i<mcA.length; i++) {
			for(i=num-1;i>=0;i--){
			mc=MovieClip(mcA[i]);
			mc.rotation+=rotationRate;
			mc.x+=mc.speed*Math.cos(mc.angle*Math.PI/180);
			mc.y+=mc.speed*Math.sin(mc.angle*Math.PI/180);
			if (mc.x>stage.stageWidth-mc.width) {
			mc.angle=180-mc.angle;
			} else if (mc.x<0) {
			mc.angle=180-mc.angle;
			} else if (mc.y>stage.stageHeight-mc.height) {
			mc.angle*=-1;
			} else if (mc.y<0) {
			mc.angle*=-1;
			}
			}
			}
			*/
			
			// 37 fps,5.6mb
			///* 
			var bgColor:uint = 0x000000;
			// display bitmap where "frame" will be drwan.
			var displayBG_Rect:Rectangle = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
			var displayBMPD:BitmapData = new BitmapData(stage.stageWidth,stage.stageHeight,false,bgColor);
			var displayBMP:Bitmap = new Bitmap(displayBMPD);
			
			var dataA:Array=[];
			var datumA:Array;
			var loopN:int
			var bmpdA:Array = [];
			var diagL:Number = Math.sqrt(2*rectSide*rectSide);
			var bmpRect:Rectangle=new Rectangle(0,0,diagL,diagL);
			
			initDataF();
			bitmapDataF();
			
			function bitmapDataF():void{
				var mc:MovieClip = new MovieClip();
				with(mc.graphics){
					beginFill(0xaa0000);
					drawRect(-rectSide/2,-rectSide/2,rectSide,rectSide);
					endFill();
				}
				var mat:Matrix = new Matrix();
				for (i=0; i<360; i+=rotationRate) {
					var bmpd:BitmapData = new BitmapData(diagL,diagL,true,0x00ffff00);
					mat.identity();
					mat.rotate(i*Math.PI/180);
					mat.tx=diagL/2;
					mat.ty=diagL/2;
					bmpd.draw(mc,mat);
					bmpdA[i] = bmpd;
				}
				stage.addChild(displayBMP);
				// loopN used to count number of enterframe loops and choose which bitmap to display.  ie, which rotation.
				loopN = 0;
				stage.addEventListener(Event.ENTER_FRAME,animateBitmapsF);
			}
			
			function initDataF():void {
				for (i=0; i<num; i++) {
					//for(i=num-1;i>=0;i--){
					datumA = [];
					// Initial x,y
					datumA.push(new Point(int(Math.random()*(stage.stageWidth-rectSide)),int(Math.random()*(stage.stageHeight-rectSide))));
					// speed
					datumA.push(1+int(2*Math.random()));
					// initial direction
					datumA.push(360*Math.random());
					dataA[i] = datumA;
				}
			}
			
			function animateBitmapsF(e:Event=null):void {
				// Applying the lock() method stops the bitmap from being updated.  I'll unlock when the bitmap is ready to be updated.  ie, when all the copied pixels have been applied.
				displayBMPD.lock();
				displayBMPD.fillRect(displayBG_Rect,bgColor);
				for (i=0; i<num; i++) {
					//for(i=num-1;i>=0;i--){
					var pt:Point = Point(dataA[i][0])
					pt.x+=dataA[i][1]*Math.cos(dataA[i][2]*Math.PI/180);
					pt.y+=dataA[i][1]*Math.sin(dataA[i][2]*Math.PI/180);
					if (pt.x>stage.stageWidth-diagL) {
						dataA[i][2]=180-dataA[i][2];
					} else if (pt.x<0) {
						dataA[i][2]=180-dataA[i][2];
					} else if (pt.y>stage.stageHeight-diagL) {
						dataA[i][2]*=-1;
					} else if (pt.y<0) {
						dataA[i][2]*=-1;
					}
					displayBMPD.copyPixels(bmpdA[loopN%360],bmpRect,pt);
					loopN++;
				}
				displayBMPD.unlock();
			}
			//*/

		}
	}
}