package display.window
{
	import display.BaseView;
	
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class BaseWindow extends BaseView
	{
		protected var _uiRes:String;
		protected var _isLoadComplete:Boolean = false;
		protected var _windowName:String;
		protected var _locate:WindowLocate = null;
		
		public function BaseWindow()
		{
			var aliasName:String = getQualifiedClassName(this);
			var windowClass:Class = getDefinitionByName(aliasName) as Class;
			_windowName = getWindowNameByClass(windowClass);
			_locate = new WindowLocate();
			config();
		}
		
		/**
		 * 配置项
		 * 窗口资源路径
		 * 窗口定位
		 */
		protected function config():void
		{
			//配置资源加载
//			_uiRes = ResFileConst.ShareLib
			//定位窗口的位置
		}
		
		/**
		 * 添加到舞台时执行
		 */
		override protected function onShow():void
		{
			if (_uiRes)
			{
				FrameWork.globalUI.loadSWF(_uiRes, null, onResLoadComplete);
			}
			else
			{
				onResLoadComplete();
			}
		}
		
		/**
		 * 窗口所需要的资源是否加载完成
		 */
		private function onResLoadComplete():void
		{
			if (_isLoadComplete)
				return;
			_isLoadComplete = true;
			layout();
			update();
			locate();
		}
		
		/**
		 * 是否加载完成
		 *
		 */
		public function get isLoadComplete():Boolean
		{
			return _isLoadComplete;
		}
		
		/**
		 * 窗口名称
		 *
		 */
		public function get windowName():String
		{
			return _windowName;
		}
		
		/**
		 * 初始化参数
		 * 外部所传参数初始化，外部参数来自WindowManager里的addPopUp(classObject:Class, ...params)方法的...params
		 */
		public function initParam(...params):void
		{
			
		}
		
		/**
		 *定位
		 */
		final internal function locate():void
		{
			_locate.locate(this);
		}
		
		/**
		 * 布局
		 * 组建、图片、影片剪辑的摆放等
		 *
		 */
		protected function layout():void
		{
		}
		
		/**
		 * 刷新
		 * 取数据刷UI
		 */
		protected function update():void
		{
		}
		
		/**
		 * 安全刷新，供外部调用
		 *
		 */
		public function safeUpdate():void
		{
			if (!isLoadComplete || !visible)
				return;
			update();
		}
		
		/**
		 * 销毁
		 *
		 */
		override public function destory(isReuse:Boolean=true):void
		{
			_isLoadComplete = false;
		}
		
		/**
		 * 是否已经弹窗
		 */
		public function get hasPopup():Boolean
		{
			return this.parent != null;
		}
		
		/**
		 * 位置信息
		 */
		public function get locationInfo():String
		{
			return "(x=" + this.x + ", y=" + this.y + ", w=" + this.width + ", h=" + this.height + ")";
		}
		
		/**
		 * 显示等级
		 */
		public function get level():String
		{
			return _locate.level;
		}
		
		public static function getWindowNameByClass(classObject:Class):String
		{
			var classPath:String = getQualifiedClassName(classObject);
			var index:int = classPath.lastIndexOf(":");
			var windowName:String = classPath.substring(index + 1, classPath.length);
			return windowName;
		}
	}
}