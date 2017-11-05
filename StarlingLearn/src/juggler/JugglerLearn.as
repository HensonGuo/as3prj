package juggler
{
	import starling.animation.Juggler;
	import starling.display.Sprite;
	
	/**
	 * Juggler类允许我们控制所有实现了IAnimatable接口的对象的动画播放
	 * MovieClip类实现了该接口，你也可以自定义一个动画类在Starling中播放
	 * 你所要做的，仅仅是让你的自定义类实现IAnimatable接口，然后重载advanceTime方法即可
	 * 
	 * API
	 * add : 添加一个动画对象到juggler ∗ 
	 * advanceTime : 如果你需要手动调控Juggler的主循环逻辑的话，调用之
	 * delayCall : 延迟调用某个对象的某个方法∗   		sample : juggler.delayCall(object.removeFromParent, 1.0);
	 * elapsedTime : 指示一个juggler对象的完整生命周期时间∗
	 * isComplete : 指示一个Juggler的状态，默认情况下它总是返回flase. 
	 * purge : 一次性移除全部子对象∗ 
	 * remove : 从juggler中移除一个对象∗
	 * removeTweens : 移除全部类型为Tween的且存在指定目标的对象
	 * 
	 * 
	 * 有些时候，你会需要另一个Juggler对象来管理另一些动画对象。
	 * 比如当你的游戏暂停的时候，会弹出一个菜单面板到你暂停着的游戏面板之上，此时你就需要另一个Juggler来负责管理该菜单面板中的动画了。
	 * 实现起来也非常简单，你只需要创建一个Juggler对象并每帧调用其advanceTime方法即可。
	 * 
	 * “暂停”键的时候，你没必要逐个暂停所有面板的Juggler，直接调用Starling对象的stop方法即可做到，
	 * 当你调用此方法后Starling将会停止重绘及ENTER_FRAME事件的派发。
	 * Starling.current.stop();
	 * 
	 * 主文档类AddEnterFrameEvent
	 */	
	public class JugglerLearn extends Sprite
	{
		private var _juggler:Juggler;
		
		public function JugglerLearn()
		{
			super();
			_juggler = new Juggler();
		}
		
		public function advanceTime(time:Number):void
		{
			_juggler.advanceTime(time);
		}
		
		public override function dispose():void
		{
			_juggler.purge();
			super.dispose();
		}
		
		
		/**
		 * 好了，当外部想要激活此面板时，只需要侦听EnterFrameEvent.EVENT事件并在事件侦听器中，
		 * 以EnterFrameEvent事件对象的passedTime属性作为参数调用此面板对象的advanceTime方法即可。
		 * 集火对应的juggler
		 * 
		 * private function onFrame(event:EnterFrameEvent):void 
		 * { 
		 * 	if ( paused ) 
		 * 		juggerlearn.advanceTime( event.passedTime ); 
		 * }
		 */
		
		
	}
}