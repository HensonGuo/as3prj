package framework.colormatrix
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	import test.BaseTest;
	
	import utils.color.ColorMatrix;
	
	public class ColorMatrixTest extends BaseTest
	{
		private var _main:MAIN;
		
		public function ColorMatrixTest(stage:Stage)
		{
			super(stage);
		}
		
		override protected function onAdded(event:Event):void
		{
			_main = new MAIN();
			this.addChild(_main);
			_main.resetButton.addEventListener(MouseEvent.CLICK, onReset, false, 0, true);
			_main.brightnessNS.addEventListener(Event.CHANGE, handleChange, false, 0, true);
			_main.contrastNS.addEventListener(Event.CHANGE, handleChange, false, 0, true);
			_main.saturationNS.addEventListener(Event.CHANGE, handleChange, false, 0, true);
			_main.hueNS.addEventListener(Event.CHANGE, handleChange, false, 0, true);
		}
		
		protected function handleChange(e:Event):void 
		{
			update();
		}
		
		protected function onReset(e:MouseEvent):void
		{
			// Set the values for the NumericSteppers to 0.
			_main.brightnessNS.value = _main.contrastNS.value = _main.saturationNS.value = _main.hueNS.value = 0;
			update();
		}
		
		// Updates the clip's ColorMatrixFilter property based on the values of the NumericSteppers.
		protected function update():void
		{
			var cm:ColorMatrix = new ColorMatrix();
			cm.adjustColor(_main.brightnessNS.value, _main.contrastNS.value,_main. saturationNS.value, _main.hueNS.value);
			_main.clip.filters = [new ColorMatrixFilter(cm)];
		}
		
	}
}