package display.menu
{
	import display.BaseView;
	import display.gui.UIFactory;
	
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	
	import flash.system.Capabilities;
	
	import starling.events.Event;
	
	import utils.debug.LogUtil;
	
	public class Menu extends BaseView
	{
		private var _labArr:Array;
		private var _buttongroup:ButtonGroup;
		
		public function Menu()
		{
			super();
		}
		
		public function intialize(label:Array, width:Number, height:Number, bg:Scale9Image = null):void
		{
			_labArr=label;
			var ar:Array=[];
			for (var i:int = 0; i < _labArr.length; i++) 
			{
				var obj:Object={};
				obj.label=_labArr[i];
				obj.triggered= button_triggeredHandler ;
				ar.push(obj);
			}
			_buttongroup= UIFactory.buttonGroup(new ListCollection(ar), 0, 0, width, height, this);
			_buttongroup.direction=ButtonGroup.DIRECTION_VERTICAL;
			addChild(_buttongroup);
			
			if (bg == null)
			{
//				bg = UIFactory.scaleImage(
			}
		}
		
		private function button_triggeredHandler(e:Event):void
		{
			const button:Button = Button(e.currentTarget);
			LogUtil.debug(button.label + " triggered.");
		}
		
		override public function destory(isReuse:Boolean=true):void
		{
			_labArr = null;
			_buttongroup = null;
			super.destory(isReuse);
		}
		
	}
}