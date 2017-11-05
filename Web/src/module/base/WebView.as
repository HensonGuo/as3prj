package module.base
{
	import display.BaseView;
	
	import events.CallerName;
	
	import utils.trigger.Caller;
	
	public class WebView extends BaseView
	{
		public function WebView()
		{
			super();
			Caller.addCmdListener(FrameWork.VIEW_RESIZE, onResize);
		}
		
		protected function onResize(width:int, height:int):void
		{
		}
		
	}
}