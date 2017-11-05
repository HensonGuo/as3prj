package display.layer
{
	import flash.utils.Dictionary;
	
	import starling.display.Stage;
	
	public class LayerManager
	{
		private var _layerMap:Dictionary = new Dictionary();
		
		public function LayerManager()
		{
		}
		
		public function init(stage:Stage):void
		{
			stage.addChild(createLayer(LayerConstants.Background, 0));
			stage.addChild(createLayer(LayerConstants.Content, 1));
			stage.addChild(createLayer(LayerConstants.InfoTip, 2));
			stage.addChild(createLayer(LayerConstants.Mouse, 3));
			stage.addChild(createLayer(LayerConstants.PopUpLow, 4));
			stage.addChild(createLayer(LayerConstants.PopUpMiddle, 5));
			stage.addChild(createLayer(LayerConstants.PopUpHigh, 6));
			stage.addChild(createLayer(LayerConstants.Lock, 7));
		}
		
		private function createLayer(type:String, zIndex:int):Layer
		{
			_layerMap[type] = new Layer(type, zIndex)
			return _layerMap[type];
		}
		
		public function getLayer(type:String):Layer
		{
			return _layerMap[type];
		}
		
	}
}