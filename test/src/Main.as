package
{
	import effect.*;
	import effect.escher.EscherTest1;
	import effect.escher.EscherTest2;
	import effect.fluid.LiquidVideo;
	import effect.geckos.FisheyeListEffectTest;
	import effect.geckos.TreeTest;
	import effect.mapchipx.MapChipX1;
	import effect.mapchipx.MapChipX2;
	import effect.mousezoom.MouseZoomTest;
	import effect.pageflip.PageFlipTest;
	import effect.parts.PlayingWithParticlesExample1;
	import effect.parts.PlayingWithParticlesExample2;
	import effect.parts.PlayingWithParticlesExample3;
	import effect.parts.PlayingWithParticlesExample4;
	import effect.parts.PlayingWithParticlesExample5;
	import effect.parts.PlayingWithParticlesExample6;
	
	import extend.AnimeTest;
	import extend.gravity2d.Gravity2DTest1;
	import extend.gravity2d.Gravity2DTest2;
	import extend.gravity2d.Gravity2DTest3;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.system.Security;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import framework.*;
	import framework.interactive.KeyCommandTest;
	
	import geckos.NoiseText;
	
	import mapchipx.MapChipX;
	
	import terafire.TeraFire;
	
	import test.*;
	
	
	[SWF(width=1000, height=700, frameRate=60, backgroundColor='#ffffff')]
	
	public class Main extends Sprite
	{
		private static var _root:DisplayObjectContainer = new Sprite();
		private static var _stage:Stage;
		
		public function Main()
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			stage.scaleMode = StageScaleMode.NO_SCALE;
			_stage = this.stage;
			this.addChild(_root);
			
			var tes:BaseTest = new TeraFireTest(stage);
			this.addChild(tes);
			
//			var tes:BaseTest = new Test4Starling(TeraFireTest, stage);
//			this.addChild(tes);
		}
		
		public static function get rootContainer():DisplayObjectContainer
		{
			return _root;
		}
		
		public static function get stage():Stage
		{
			return _stage;
		}
		
	}
}