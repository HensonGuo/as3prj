package display.richtext.tlftextfield
{
	import fl.text.TLFTextField;
	
	import flash.events.TextEvent;
	import flash.text.TextFieldType;
	
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.FlowElement;
	
	import utils.debug.LogUtil;
	
	public class RichTextDisplay extends TLFTextField
	{
		protected static const TEXT_FLOW_HEAD:String = '<TextFlow whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p>';
		protected static const TEXT_FLOW_TAIL:String = '</p></TextFlow>';
		
		protected var _displayCacheSize:int = 0;
		protected var _linkTextClickCallback:Function = null;
		
		override public function RichTextDisplay(displayCacheSize:int = 100)
		{
			super();
			_displayCacheSize = displayCacheSize;
			this.type = TextFieldType.DYNAMIC;
			this.multiline = true;
			this.selectable = false;
		}
		
		public function appendTextCodeToTLF(textCode:String, textColor:uint = 0x000000):void
		{
			var resultTLFMakeUp:String = TEXT_FLOW_HEAD;
			var codeToTlfMakeup:Function = function(type:int, ...args):void
			{
				switch (type)
				{
					case RichTextCoder.TYPE_TEXT:
						var curTextColor:uint = textColor;
						if (args.length > 1)
							curTextColor = args[1];
						resultTLFMakeUp += textCodeToTLFMakeUp(args[0], curTextColor);
						break;
					case RichTextCoder.TYPE_SWF:
						resultTLFMakeUp += swfCodeToTlfMakeup.apply(null, args);
						break;
					case RichTextCoder.TYPE_LINKTEXT:
						resultTLFMakeUp += linkTextCodeToTLFMakeup.apply(null, args);
						break;
				}
			}
				
			RichTextCoder.coder.decode(textCode, codeToTlfMakeup);
			resultTLFMakeUp += TEXT_FLOW_TAIL;
			var flow:FlowElement = TextConverter.importToFlow(resultTLFMakeUp, TextConverter.TEXT_LAYOUT_FORMAT).getChildAt(0);
			textFlow.addChild(flow);
			
			if (textFlow.numChildren > _displayCacheSize)
			{
				while (textFlow.numChildren > _displayCacheSize / 2)
					textFlow.removeChildAt(0);
			}
			
			try
			{
				textFlow.flowComposer.updateAllControllers();
			}
			catch (error:Error)
			{
				LogUtil.error("appendTextCode " + textCode + " textColor" + textColor);
			}
			this.scrollV = this.maxScrollV;
		}
		
		public function appendTextCodeToHTML(textCode:String, textColor:uint = 0x000000):void
		{
			var resultHtml:String = "";
			var codeToHtml:Function = function(type:int, ...args):void
			{
				switch (type)
				{
					case RichTextCoder.TYPE_TEXT:
						var curTextColor:uint = textColor;
						if (args.length > 1)
							curTextColor = args[1];
						resultHtml += textCodeToHtml(args[0], curTextColor);
						break;
					case RichTextCoder.TYPE_SWF:
						resultHtml += swfCodeToHtml.apply(null, args);
						break;
					case RichTextCoder.TYPE_LINKTEXT:
						resultHtml += linkTextCodeToHtml.apply(null, args);
						break;
				}
			}
			
			RichTextCoder.coder.decode(textCode, codeToHtml);
			this.htmlText = resultHtml;
		}
		
		protected function textCodeToHtml(textCode:String, color:uint):String
		{
			return '<FONT COLOR="#' + color.toString(16) + '">' + textCode + '</FONT>';
		}
		
		protected function swfCodeToHtml(url:String, width:int, height:int):String
		{
			return '';
		}
		
		protected function linkTextCodeToHtml(href:String, normalColor:uint, text:String, textDecoration:String, preText:String = "", postText:String = "", activeColor:uint = 0, hoverColor:uint = 0):String
		{
			var preTextHtml:String = "";
			if (preText != "")
				preTextHtml = textCodeToHtml(preText, normalColor);
			var postTextHtml:String = "";
			if (postText != "")
				postTextHtml = textCodeToHtml(postText, normalColor);
			var content:String = '<A HREF="event:' + href + '" TARGET="">' + textCodeToHtml(text, normalColor) + '</A>';
			return preTextHtml + content + postTextHtml;
		}
		
		protected function textCodeToTLFMakeUp(textCode:String, color:uint):String
		{
			var colorText:String = color.toString(16);
			var result:String = RichTextCoder.text2Escape(textCode);
			return '<span color="#' + colorText + '">' + result + "</span>";
		}
		
		protected function swfCodeToTlfMakeup(url:String, width:int, height:int):String
		{
			return '<img source="' + url + '" width="' + width  + '" height="' + height + '"/>';
		}
		
		protected function linkTextCodeToTLFMakeup(href:String, normalColor:uint, text:String, textDecoration:String, preText:String = "", postText:String = "", activeColor:uint = 0, hoverColor:uint = 0):String
		{
			var preTextTlFMakeup:String = "";
			if (preText != "")
				preTextTlFMakeup = textCodeToTLFMakeUp(preText, normalColor);
			var postTextTlFMakeup:String = "";
			if (postText != "")
				postTextTlFMakeup = textCodeToTLFMakeUp(postText, normalColor);
			
			var result:String = preTextTlFMakeup + "<a href='event:" + href + "'>" + '<linkNormalFormat><TextLayoutFormat color="#' + normalColor.toString(16) + '" textDecoration="' + textDecoration + '"/></linkNormalFormat>';
			if (activeColor != 0)
				result += '<linkActiveFormat><TextLayoutFormat color="#' + activeColor.toString(16) + '" textDecoration="' + textDecoration + '"/></linkActiveFormat>';
			if (hoverColor != 0)
				result += '<linkHoverFormat><TextLayoutFormat color="#' + hoverColor.toString(16) + '" textDecoration="' + textDecoration + '"/></linkHoverFormat>';
			result += '<span>' + text + '</span></a>' + postTextTlFMakeup;
			return result;
		}

		public function set linkTextClickCallback(value:Function):void
		{
			_linkTextClickCallback = value;
			if (!this.hasEventListener(TextEvent.LINK))
				this.addEventListener(TextEvent.LINK, onLinkTextClick);
		}
		
		protected function onLinkTextClick(event:TextEvent):void
		{
			_linkTextClickCallback.call(null, event.text);
		}
	}
}