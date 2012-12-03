/*
Copyright (c) 2012 Josh Tynjala

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package feathers.controls;
import feathers.core.FeathersControl;
import feathers.core.ITextEditor;
import feathers.core.PropertyProxy;

import feathers.events.FeathersEventType;

import flash.geom.Point;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * Dispatched when the text input's text value changes.
 *
 * @eventType starling.events.Event.CHANGE
 */
@:meta(Event(name="change",type="starling.events.Event"))

/**
 * Dispatched when the user presses the Enter key while the text input
 * has focus.
 *
 * @eventType feathers.events.FeathersEventType.ENTER
 */
@:meta(Event(name="enter",type="starling.events.Event"))

/**
 * Dispatched when the text input receives focus.
 *
 * @eventType feathers.events.FeathersEventType.FOCUS_IN
 */
@:meta(Event(name="focusIn",type="starling.events.Event"))

/**
 * Dispatched when the text input loses focus.
 *
 * @eventType feathers.events.FeathersEventType.FOCUS_OUT
 */
@:meta(Event(name="focusOut",type="starling.events.Event"))

/**
 * A text entry control that allows users to enter and edit a single line of
 * uniformly-formatted text.
 *
 * <p>To set things like font properties, the ability to display as
 * password, and character restrictions, use the <code>textEditorProperties</code> to pass
 * values to the <code>ITextEditor</code> instance.</p>
 *
 * @see http://wiki.starling-framework.org/feathers/text-input
 * @see feathers.core.ITextEditor
 */
extern class TextInput extends FeathersControl
{

	/**
	 * @private
	 */
	private static var HELPER_POINT:Point;//new Point();

	/**
	 * @private
	 */
	private static var FONT_SIZE:String;//"fontSize";

	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * The text editor sub-component.
	 */
	private var textEditor:ITextEditor;

	/**
	 * The currently selected background, based on state.
	 */
	private var currentBackground:DisplayObject;

	/**
	 * @private
	 */
	private var _textEditorHasFocus:Bool;//false;

	/**
	 * @private
	 */
	private var _touchPointID:Int;//-1;

	/**
	 * @private
	 */
	private var _text:String;//"";

	/**
	 * The text displayed by the input.
	 */
	public var text(default,default):String;
	
	/**
	 * @private
	 */
	private var _textEditorFactory:Void->ITextEditor;

	/**
	 * A function used to instantiate the text editor. If null,
	 * <code>FeathersControl.defaultTextEditorFactory</code> is used
	 * instead.
	 *
	 * <p>The factory should have the following function signature:</p>
	 * <pre>function():ITextEditor</pre>
	 *
	 * @see feathers.core.ITextEditor
	 * @see feathers.core.FeathersControl#defaultTextEditorFactory
	 */
	public var textEditorFactory(default,default):Void->ITextEditor;

	/**
	 * @private
	 * The width of the first skin that was displayed.
	 */
	private var _originalSkinWidth:Float;//;//

	/**
	 * @private
	 * The height of the first skin that was displayed.
	 */
	private var _originalSkinHeight:Float;//;//

	/**
	 * @private
	 */
	private var _backgroundSkin:DisplayObject;

	/**
	 * A display object displayed behind the header's content.
	 */
	public var backgroundSkin(default,default):DisplayObject;

	/**
	 * @private
	 */
	private var _backgroundFocusedSkin:DisplayObject;

	/**
	 * A display object displayed behind the header's content when the
	 * TextInput has focus.
	 */
	public var backgroundFocusedSkin(default,default):DisplayObject;

	/**
	 * @private
	 */
	private var _backgroundDisabledSkin:DisplayObject;

	/**
	 * A background to display when the header is disabled.
	 */
	public var backgroundDisabledSkin(default,default):DisplayObject;

	/**
	 * @private
	 */
	private var _paddingTop:Float;//0;

	/**
	 * The minimum space, in pixels, between the input's top edge and the
	 * input's content.
	 */
	public var paddingTop(default,default):Float;

	/**
	 * @private
	 */
	private var _paddingRight:Float;//0;

	/**
	 * The minimum space, in pixels, between the input's right edge and the
	 * input's content.
	 */
	public var paddingRight(default,default):Float;

	/**
	 * @private
	 */
	private var _paddingBottom:Float;//0;

	/**
	 * The minimum space, in pixels, between the input's bottom edge and
	 * the input's content.
	 */
	public var paddingBottom(default,default):Float;

	/**
	 * @private
	 */
	private var _paddingLeft:Float;//0;

	/**
	 * The minimum space, in pixels, between the input's left edge and the
	 * input's content.
	 */
	public var paddingLeft(default,default):Float;
	
	/**
	 * @private
	 * Flag indicating that the text editor should get focus after it is
	 * created.
	 */
	private var _isWaitingToSetFocus:Bool;//false;

	/**
	 * @private
	 */
	private var _pendingSelectionStartIndex:Int;//-1;

	/**
	 * @private
	 */
	private var _pendingSelectionEndIndex:Int;//-1;

	/**
	 * @private
	 */
	private var _oldMouseCursor:String;//null;

	/**
	 * @private
	 */
	private var _textEditorProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to the text input's
	 * <code>ITextEditor</code> instance.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * @see feathers.core.ITextEditor
	 */
	public var textEditorProperties(default,default):Dynamic;
	

	/**
	 * Focuses the text input control so that it may be edited.
	 */
	public function setFocus():Void;
	
	/**
	 * Sets the range of selected characters. If both values are the same,
	 * or the end index is <code>-1</code>, the text insertion position is
	 * changed and nothing is selected.
	 */
	public function selectRange(startIndex:Int, endIndex:Int = -1):Void;

	
	/**
	 * @private
	 */
	private function autoSizeIfNeeded():Bool;
	
	/**
	 * @private
	 */
	private function createTextEditor():Void;
	

	/**
	 * @private
	 */
	private function doPendingActions():Void;
	
	/**
	 * @private
	 */
	private function refreshTextEditorProperties():Void;

	/**
	 * @private
	 */
	private function refreshBackground():Void;

	/**
	 * @private
	 */
	private function layout():Void;

	/**
	 * @private
	 */
	private function childProperties_onChange(proxy:PropertyProxy, name:Dynamic):Void;

	/**
	 * @private
	 */
	private function touchHandler(event:TouchEvent):Void;
	
	/**
	 * @private
	 */
	private function textEditor_changeHandler(event:Event):Void;

	/**
	 * @private
	 */
	private function textEditor_enterHandler(event:Event):Void;
	
	/**
	 * @private
	 */
	private function textEditor_focusInHandler(event:Event):Void;

	/**
	 * @private
	 */
	private function textEditor_focusOutHandler(event:Event):Void;
}
