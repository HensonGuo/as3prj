package transition
{
	import fl.transitions.*;
	import fl.transitions.Iris;
	import fl.transitions.Transition;
	import fl.transitions.TransitionManager;
	import fl.transitions.easing.Regular;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import loader.type.LoadResType;

	/**
	 *百叶窗 
	 * @author g7842
	 */	
	public class ImageTransition extends MovieClip
	{
//		private const _defaultTransiton:Class = Blinds;
//		private const _defaultTransiton:Class = Fade;
//		private const _defaultTransiton:Class = Fly;
//		private const _defaultTransiton:Class = Iris;
//		private const _defaultTransiton:Class = Photo;
//		private const _defaultTransiton:Class = Rotate;
//		private const _defaultTransiton:Class = Squeeze;
//		private const _defaultTransiton:Class = Wipe;
//		private const _defaultTransiton:Class = PixelDissolve;
		private const _defaultTransiton:Class = Zoom;
		
		private var _transition:Class = Blinds;
		private var _transitions:Array = new Array(); 
		
		public function ImageTransition(imageUrl:String, transition:Class = null)
		{
			this.mouseChildren = false;
			this.cacheAsBitmap = true;
			
			if (transition)
				this._transition = transition;
			else
				this._transition = _defaultTransiton;
			FrameWork.loaderManager.loadRes(LoadResType.ImageFile, imageUrl, onLoadComplete);
		}
		
		private function onLoadComplete(url:String, bitmap:Bitmap):void
		{
			this.addChild(bitmap);
			this.addEventListener (MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		private function onMouseOver (e:MouseEvent):void { 
			this.removeEventListener (MouseEvent.MOUSE_OVER, onMouseOver);
			startTrainsition();
		}
		
		private function startTrainsition():void
		{
			/*  
			Start a new transition with the following parametes 
			type: We use a transition type that is defined for each box 
			direction: The direction of the animation (Transition.OUT is the second option) 
			duration: Duration of the animation in seconds 
			easing: The type of easing applied to the animation 
			shape: A mask shape. Applies only when using the "Iris" transition 
			*/ 
			var myTransitionManager:TransitionManager = new TransitionManager(this); 
			myTransitionManager.startTransition ({type:this._transition,  direction:Transition.IN, duration:1, easing:Regular.easeOut, shape:Iris.CIRCLE}); 
			//Add the transition to an array, so it won’t get garbage collected 
			_transitions.push(myTransitionManager); 
			myTransitionManager.addEventListener ("allTransitionsInDone", onAnimationComplete); 
		}
		
		
		private function onAnimationComplete (e:Event):void { 
			//Start listening for the MOUSE_OVER again 
			e.target.content.addEventListener (MouseEvent.MOUSE_OVER, onMouseOver); 
		}
		
	}
}