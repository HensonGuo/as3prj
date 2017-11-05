package display.layer
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.Dictionary;
	
	public class LayerManager extends Sprite
	{
		private var _layerMap:Dictionary = new Dictionary();
		
		public function LayerManager()
		{
		}
		
		public function init(stage:Stage):void
		{
			stage.addChildAt(this, 0);
			this.addChild(createLayer(LayerConstants.Background, 0));
			this.addChild(createLayer(LayerConstants.Content, 1));
			this.addChild(createLayer(LayerConstants.InfoTip, 2));
			this.addChild(createLayer(LayerConstants.Mouse, 3));
			this.addChild(createLayer(LayerConstants.PopUpLow, 4));
			this.addChild(createLayer(LayerConstants.PopUpMiddle, 5));
			this.addChild(createLayer(LayerConstants.PopUpHigh, 6));
			this.addChild(createLayer(LayerConstants.Lock, 7));
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