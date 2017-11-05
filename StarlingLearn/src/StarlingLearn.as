package
{
	import bitmapfont.BitmapFontLearn;
	
	import button.ButtonLearn;
	
	import display.window.LogWindow;
	
	import dispose.StarlingDispose;
	
	import drawapi.DrawApi;
	
	import embedfonts.EmbedFontLearn;
	
	import enterframe.EnterFrameLearn;
	
	import feathers.FeatherLearn;
	import feathers.StyleLearn;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DRenderMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.setTimeout;
	
	import flatsprite.FlatSprite;
	
	import game1.Game1;
	
	import game2.Game2;
	
	import game3.Game3;
	
	import image.ImageLearn;
	
	import movieclip.MCLearn;
	
	import multiTouch.Game4;
	
	import rendertexture.RenderTextureLearn;
	
	import starling.core.Starling;
	
	import textfield.TextFieldLearn;
	
	import tweens.TweenLearn;
	
	import utils.debug.Profile;
	
	[SWF(width="1280", height="752", frameRate="24", backgroundColor="#002143")]
	public class StarlingLearn extends Sprite
	{
		private var _starling:Starling;
		private var _isDebugMode:Boolean;
		
		public function StarlingLearn()
		{
//			stage.align = StageAlign.TOP_LEFT; 
//			stage.scaleMode = StageScaleMode.NO_SCALE;
//			Profile.init(true, this);
			
			var contextMenu:ContextMenu = new ContextMenu();
			var item:ContextMenuItem = new ContextMenuItem("查看日志", true);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, checkLog);
			contextMenu.hideBuiltInItems();
			contextMenu.customItems.push(item);
			this.contextMenu = contextMenu;
			
			setTimeout(delayStart, 500);
			return;
		}
		
		private function delayStart():void
		{
			FrameWork.start(true, stage, ImageLearn);
		}
		
		/**
		 *查看日志
		 */
		private function checkLog(event:ContextMenuEvent):void {
			FrameWork.windowManager.addPopup(LogWindow);
		}
		
		
		
	}
}