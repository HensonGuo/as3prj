package multiTouch
{
	import flash.geom.Point;
	
	import game3.CustomSprite;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Game4 extends Sprite
	{
		private var customSprite:CustomSprite;
		private var mouseX:Number = 0; 
		private var mouseY:Number = 0;
		
		public function Game4()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded ( e:Event ):void 
		{ 
			// create the custom sprite 
			customSprite = new CustomSprite(200, 200); 
			// positions it by default in the center of the stage
			// we add half width because of the registration point of the custom sprite (middle) 
			customSprite.x = (stage.stageWidth - customSprite.width >> 1 ) + (customSprite.width >> 1); 
			customSprite.y = (stage.stageHeight - customSprite.height >> 1) + (customSprite.height >> 1); 
			// show it 
			addChild(customSprite); 
			// we listen to the mouse movement on the stage 
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			// need to comment this one ? ;) 
			stage.addEventListener(Event.ENTER_FRAME, onFrame); 
			// when the sprite is touched 
			customSprite.addEventListener(TouchEvent.TOUCH, onTouchedSprite);
		}
		
		private function onFrame (e:Event):void 
		{
			// we update our custom sprite 
			customSprite.update(); 
		}
		
		/**
		 *Starling中并没有设计鼠标的概念 
		 * 通过对TouchEvent.TOUCH事件的侦听，我们可以对鼠标/手指移动的侦测，
		 * 这个事件的用法就像我们经典的MousEvent.MOUSE_MOVE事件一样。
		 * 每一帧我们都可以依靠TouchEvent中的辅助API如getTouch及getLocation来获取并保存当前鼠标位置
		 * 
		 * ，在原生Flash提供的那些API基础上，Starling又额外提供了一个极其有用的API——removeEventListeners。
		 * 在任何时候只要你想移除某个对象对于某个事件注册的全部事件侦听器，只需要调用该方法并传入欲移除的事件类型作为参数即可： 
		 * button.removeEventListeners(Event.TRIGGERED); 
		 * 若你想要一次性移除某个对象的全部事件侦听器（无论是对什么事件注册的），只需要保持removeEventListeners方法的参数为空即可： 
		 * button.removeEventListeners ();
		 * 
		 * Starling中的事件机制保留了事件冒泡阶段，却没有事件捕捉阶段
		 * 
		 * ，Starling的前身是Sparrow（一款手机应用开发框架）
		 * 因此Starling中会存在一些与手机应用相关的概念也是理所应当，我们知道，当前手机交互一般是依靠手指触摸来实现，
		 * 因此Starling中的Touch事件是为手指触摸式交互设计的
		 * 
		 * Starling的类结构中不存在InteractiveObject这个类，也就是说，Starling中所有的DisplayObject都是支持交互的
		 * 换句话说，Starling中的DisplayObject类已经内置了交互功能
		 * 
		 * ∗ began : 鼠标/手指开始交互（类似于mouseDown） 
		 * ∗ ended : 鼠标/手指停止交互（类似于mouseClick） 
		 * ∗ hover : 鼠标/手指悬于物体上（类似于mouseOver） 
		 * ∗ moved : 鼠标/手指在物体上移动（类似于mouseDown + mouseMove） 
		 * ∗ stationary : 鼠标/手指停止与物体的交互但仍停留在其上
		 * ∗ ctrlKey : 触发Touch事件是是否按住Ctrl键
		 * ∗ getTouch: 得到此事件的Touch对象
		 * ∗ getTouches : 得到一组Touch对象（用于多点交互）
		 *  ∗ shiftKey: 触发Touch事件是是否按住Shift键
		 * ∗ timestamp : 事件触发时间
		 * ∗ touches : 得到同一时间发生的全部Touch对象
		 * 
		 * ∗ clone : 复制一个副本
		 * ∗ getLocation: 得到Touch事件触发的对应于当前坐标系的位置
		 * ∗ getPreviousLocation: 得到之前触发的Touch事件对应于当前坐标系的位置
		 * ∗ globalX、Y: 得到Touch事件触发的舞台位置
		 * ∗ id: 一个Touch对象所拥有的独一无二的标示符
		 * ∗ phase : 指示当前事件触发的类型（阶段） 
		 * ∗ previousGlobalX、Y : 得到之前触发的Touch事件舞台位置
		 * ∗ tapCount : 手指轻拍显示对象的次数（用以识别手指双拍） 
		 * ∗ target : 触发Touch事件的对象
		 * ∗ timestamp : 事件触发时间（此时间是从应用程序启动开始计时的）
		 */		
		private function onTouch (e:TouchEvent):void 
		{ 
			// get the mouse location related to the stage 
			var touch:Touch = e.getTouch(stage); 
			if (touch == null)
				return;
			var pos:Point = touch.getLocation(stage); 
			// store the mouse coordinates 
			mouseX = pos.x; 
			mouseY = pos.y; 
		}
		
		private function onTouchedSprite(e:TouchEvent):void {
			// retrieves the touch points 
			var touches:Vector.<Touch> = e.touches; 
			// if two fingers 
			if ( touches.length == 2 ) 
			{ 
				var finger1:Touch = touches[0]; 
				var finger2:Touch = touches[1]; 
				var distance:int; 
				var dx:int; 
				var dy:int; 
				// if both fingers moving (dragging) 
				if ( finger1.phase == TouchPhase.MOVED && finger2.phase == TouchPhase.MOVED ) 
				{
					// calculate the distance between each axes 
					dx = Math.abs ( finger1.globalX - finger2.globalX ); 
					dy = Math.abs ( finger1.globalY - finger2.globalY ); 
					// calculate the distance 
					distance = Math.sqrt(dx*dx+dy*dy); 
					trace ( distance ); 
				}
			}
		}
		
	}
}