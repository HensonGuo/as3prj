package display.richtext.tlftextfield
{
	import fl.text.TLFTextField;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	import flashx.textLayout.edit.IEditManager;
	import flashx.textLayout.edit.SelectionFormat;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	
	import utils.debug.LogUtil;
	
	public class RichTextInput extends TLFTextField
	{
		protected var DEFAULT_CARETCOLOR:uint = 0xFFFFFF;
		protected var _caretColor:uint = DEFAULT_CARETCOLOR;
		
		override public function RichTextInput()
		{
			super();
			this.type = TextFieldType.INPUT;
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function insertText(value:String):void
		{
			if (this.maxChars != 0 && text.length + value.length > this.maxChars)
				return;
			
			setFocus();
			var editManager:IEditManager = IEditManager(textFlow.interactionManager);
			editManager.insertText(value);
			textFlow.flowComposer.updateAllControllers();
			textFlow.interactionManager.setFocus();
		}
		
		public function insertSwf(url:String, width:int, height:int):void
		{
			if (this.maxChars != 0 && text.length + 1 > this.maxChars)
				return;
			
			var paragraph:ParagraphElement = textFlow.getChildAt(0) as ParagraphElement;
			var childIndex:int = paragraph.findChildIndexAtPosition(selectionBeginIndex);
			var span:SpanElement = new SpanElement();
			paragraph.addChildAt(childIndex + 1, span);
			var editManager:IEditManager = IEditManager(textFlow.interactionManager);
			editManager.insertInlineGraphic(url, width, height);
			textFlow.flowComposer.updateAllControllers();
			textFlow.interactionManager.setFocus();
			this.scrollV = textHeight;
		}
		
		public function insertLinkText(href:String, color:uint, linkText:String):void
		{
			if (this.maxChars != 0 && text.length + linkText.length > this.maxChars)
				return;
			
			var paragraph:ParagraphElement = textFlow.getChildAt(0) as ParagraphElement;
			var elementChildIndex:int = paragraph.findChildIndexAtPosition(selectionEndIndex);
			var flowElement:FlowElement = paragraph.getChildAt(elementChildIndex);
			var absoluteStart:int = flowElement.getAbsoluteStart();
			
			var insertChildIndex:int = -1;
			if (flowElement is SpanElement)
			{
				flowElement.splitAtPosition(selectionEndIndex - absoluteStart);
				insertChildIndex = elementChildIndex + 1;
			}
			else
				insertChildIndex = elementChildIndex;
			LogUtil.assert(insertChildIndex != -1);
			var link:LinkElement = new LinkElement();
			link.href = href;
			link.linkNormalFormat={color: color, textDecoration: "none"};
			var span:SpanElement = new SpanElement();
			span.text = linkText;
			link.addChild(span);
			paragraph.addChildAt(insertChildIndex, link);
			
			var currentIndex:int = selectionEndIndex + span.text.length;
			setSelection(currentIndex, currentIndex);
			
			textFlow.flowComposer.updateAllControllers();
			textFlow.interactionManager.setFocus();
		}
		
		public function setFocus():void
		{
			this.setSelection(this.selectionBeginIndex, this.selectionEndIndex);
			this.textFlow.flowComposer.updateAllControllers();
			this.textFlow.interactionManager.setFocus();
			updateCaretColor();
		}
		
		public function set caretColor(color:uint):void
		{
			_caretColor = color;
			updateCaretColor();
		}
		
		protected function updateCaretColor():void
		{
			var selectionFormat:SelectionFormat = new SelectionFormat(DEFAULT_CARETCOLOR, 1, "difference", _caretColor);
			textFlow.interactionManager.focusedSelectionFormat = selectionFormat;
		}
		
		public function clear():void
		{
			this.htmlText = "";
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			onAdjustSelectionIndex(selectionBeginIndex, selectionEndIndex, true);
			updateCaretColor();
			textFlow.interactionManager.setFocus();
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.BACKSPACE:
					onDelete(selectionBeginIndex - 1);
					break;
				case Keyboard.DELETE:
					onDelete(selectionBeginIndex + 1);
					break;
				case Keyboard.LEFT:
					onAdjustSelectionIndex(selectionBeginIndex, selectionEndIndex, false);
					break;
				case Keyboard.RIGHT:
					onAdjustSelectionIndex(selectionBeginIndex, selectionEndIndex, true);
					break;
			}
		}
		
		protected function onDelete(selectionIndex:int):void
		{
			var paragraph:ParagraphElement = textFlow.getChildAt(0) as ParagraphElement;
			var childIndex:int = paragraph.findChildIndexAtPosition(selectionIndex);
			var flowElement:FlowElement = paragraph.getChildAt(childIndex);
			if (flowElement is LinkElement)
			{
				setSelection(flowElement.parentRelativeStart, flowElement.parentRelativeStart);
				paragraph.removeChild(flowElement);
				textFlow.flowComposer.updateAllControllers();
				textFlow.interactionManager.setFocus();
			}
		}
		
		protected function onAdjustSelectionIndex(beginIndex:int, endIndex:int, isMoveRight:Boolean):Boolean
		{
			var adjustBeginIndex:int = beginIndex;
			var adjustEndIndex:int = endIndex;
			
			var paragraph:ParagraphElement = textFlow.getChildAt(0) as ParagraphElement;
			var beginChildIndex:int = paragraph.findChildIndexAtPosition(beginIndex);
			var beginFlowElement:FlowElement = paragraph.getChildAt(beginChildIndex);
			if (beginFlowElement != null)
			{
				var beginElementParentRelativeEnd:int = beginChildIndex + 1 == paragraph.numChildren ? 
					beginFlowElement.parentRelativeEnd - 1 : beginFlowElement.parentRelativeEnd;
				if (beginFlowElement is LinkElement && 
					beginIndex > beginFlowElement.parentRelativeStart && 
					beginIndex < beginElementParentRelativeEnd)
				{
					adjustBeginIndex = isMoveRight ? beginFlowElement.parentRelativeEnd : beginFlowElement.parentRelativeStart;
				}
			}
			
			var endChildIndex:int = paragraph.findChildIndexAtPosition(endIndex);
			var endFlowElement:FlowElement = paragraph.getChildAt(endChildIndex);
			if (endFlowElement != null)
			{
				var endElementParentRelativeEnd:int = endChildIndex + 1 == paragraph.numChildren ? 
					endFlowElement.parentRelativeEnd - 1 : endFlowElement.parentRelativeEnd;
				if (endFlowElement is LinkElement && 
					endIndex > endFlowElement.parentRelativeStart && 
					endIndex < endElementParentRelativeEnd)
				{
					adjustEndIndex = isMoveRight ? endFlowElement.parentRelativeEnd : endFlowElement.parentRelativeStart;
				}
			}
		
			if (adjustBeginIndex == beginIndex && adjustEndIndex == endIndex)
				return false;
			
			LogUtil.assert(beginIndex <= endIndex);
			
			setSelection(adjustBeginIndex, adjustEndIndex);
			return true;
		}
		
		public function get textCode():String
		{
			var result:String = "";
			for (var i:int = 0; i < textFlow.numChildren; i++)
			{
				if (i > 0 && i < textFlow.numChildren)
					result += "\n";
				var paragraph:ParagraphElement = textFlow.getChildAt(i) as ParagraphElement;
				for (var j:int = 0; j < paragraph.numChildren; j++)
				{
					var childElement:FlowElement = paragraph.getChildAt(j);
					var spanElement:SpanElement = childElement as SpanElement;
					if (spanElement)
					{
						result += RichTextCoder.coder.encode(RichTextCoder.TYPE_TEXT, spanElement.text);
						continue;
					}
					var inlineGraphicElement:InlineGraphicElement = childElement as InlineGraphicElement;
					if (inlineGraphicElement)
					{
						result += RichTextCoder.coder.encode(RichTextCoder.TYPE_SWF, inlineGraphicElement.source as String, inlineGraphicElement.width, inlineGraphicElement.height);
						continue;
					}
					var linkElement:LinkElement = childElement as LinkElement;
					if (linkElement)
					{
						var txt:String = linkElement.getText();
						result += RichTextCoder.coder.encode(RichTextCoder.TYPE_LINKTEXT, linkElement.href, linkElement.linkNormalFormat.color, txt);
						continue;
					}
				}
			}
			return result;
		}
	}
}