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
package feathers.controls.text;
import feathers.core.FeathersControl;
import feathers.core.ITextEditor;
import feathers.display.Image;
import feathers.display.ScrollRectManager;
import feathers.events.FeathersEventType;

import flash.display.BitmapData;
import flash.display3D.textures.Texture;
import flash.events.FocusEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.events.Event;
import starling.textures.ConcreteTexture;
import starling.textures.Texture;
import starling.utils.MatrixUtil;
import starling.utils.getNextPowerOfTwo;

/**
 * Dispatched when the text property changes.
 */
@:meta(Event(name="change",type="starling.events.Event"))

/**
 * Dispatched when the user presses the Enter key while the editor has focus.
 *
 * @eventType feathers.events.FeathersEventType.ENTER
 */
@:meta(Event(name="enter",type="starling.events.Event"))

/**
 * Dispatched when the text editor receives focus.
 *
 * @eventType feathers.events.FeathersEventType.FOCUS_IN
 */
@:meta(Event(name="focusIn",type="starling.events.Event"))

/**
 * Dispatched when the text editor loses focus.
 *
 * @eventType feathers.events.FeathersEventType.FOCUS_OUT
 */
@:meta(Event(name="focusOut",type="starling.events.Event"))

/**
 * A Feathers text editor that uses the native <code>TextField</code> class
 * set to <code>TextInputType.INPUT</code>.
 *
 * @see http://wiki.starling-framework.org/feathers/text-editors
 * @see flash.text.TextField
 */
extern class TextFieldTextEditor extends FeathersControl, implements ITextEditor
{
	/**
	 * @private
	 */
	private static var INVALIDATION_FLAG_POSITION:String;//"position";

	/**
	 * @private
	 */
	private static var HELPER_MATRIX:Matrix;//new Matrix();

	/**
	 * @private
	 */
	private static var HELPER_POINT:Point;//new Point();

	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * The text field sub-component.
	 */
	private var textField:TextField;

	/**
	 * An image that displays a snapshot of the native <code>TextField</code>
	 * in the Starling display list when the editor doesn't have focus.
	 */
	private var textSnapshot:Image;

	/**
	 * @private
	 */
	private var _textSnapshotBitmapData:BitmapData;

	/**
	 * @private
	 */
	private var _oldGlobalX:Float;//0;

	/**
	 * @private
	 */
	private var _oldGlobalY:Float;//0;

	/**
	 * @private
	 */
	private var _snapshotWidth:Int;//0;

	/**
	 * @private
	 */
	private var _snapshotHeight:Int;//0;

	/**
	 * @private
	 */
	private var _needsNewBitmap:Bool;//false;

	/**
	 * @private
	 */
	private var _frameCount:Int;//0;

	/**
	 * @private
	 */
	private var _savedSelectionIndex:Int;//-1;

	/**
	 * @private
	 */
	private var _text:String;//"";

	/**
	 * @inheritDoc
	 */
	public var text(default, default):String;

	/**
	 * @private
	 */
	private var _textFormat:TextFormat;

	/**
	 * The format of the text, such as font and styles.
	 */
	public var textFormat(default, default):TextFormat;

	/**
	 * @private
	 */
	private var _embedFonts:Bool;//false;

	/**
	 * Determines if the TextField should use an embedded font or not.
	 */
	public var embedFonts(default, default):Bool;

	/**
	 * @private
	 */
	private var _wordWrap:Bool;// = false;

	/**
	 * Determines if the TextField wraps text to the next line.
	 */
	public var wordWrap(default, default):Bool
	
	
	/**
	 * @private
	 */
	private var _isHTML:Bool;// = false;

	/**
	 * Determines if the TextField should display the text as HTML or not.
	 */
	public var isHTML(default, default):Bool;

	/**
	 * @private
	 */
	private var _alwaysShowSelection:Bool;// = false;

	/**
	 * Same as the <code>flash.text.TextField</code> property with the same name.
	 */
	public var alwaysShowSelection(default, default):Bool;

	
	/**
	 * @private
	 */
	private var _displayAsPassword:Bool;// = false;

	/**
	 * Same as the <code>flash.text.TextField</code> property with the same name.
	 */
	public var displayAsPassword(default, default):Bool;
	
	/**
	 * @private
	 */
	private var _maxChars:Int;// = Int.MAX_VALUE;

	/**
	 * Same as the <code>flash.text.TextField</code> property with the same name.
	 */
	public var maxChars(default, default):Int;

	/**
	 * @private
	 */
	private var _restrict:String;

	/**
	 * Same as the <code>flash.text.TextField</code> property with the same name.
	 */
	public var restrict():String;

	/**
	 * @private
	 */
	public function set restrict(value:String):Void;

	/**
	 * @private
	 */
	private var _textFieldHasFocus:Bool;//false;

	/**
	 * @private
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
	 * @inheritDoc
	 */
	public function setFocus(position:Point = null):Void;
	
	/**
	 * @inheritDoc
	 */
	public function selectRange(startIndex:Int, endIndex:Int):Void;

	/**
	 * @private
	 */
	private function autoSizeIfNeeded():Bool;

	/**
	 * @private
	 */
	private function commitStylesAndData():Void;

	/**
	 * @private
	 */
	private function layout(sizeInvalid:Bool):Void;
	
	/**
	 * @private
	 */
	private function doPendingActions():Void;

	/**
	 * @private
	 */
	private function refreshSnapshot():Void;
	
	/**
	 * @private
	 */
	private function removedFromStageHandler(event:Event):Void;
	

	/**
	 * @private
	 */
	private function enterFrameHandler(event:Event):Void;
	
	/**
	 * @private
	 */
	private function textField_changeHandler(event:flash.events.Event):Void;

	/**
	 * @private
	 */
	private function textField_focusInHandler(event:FocusEvent):Void;

	/**
	 * @private
	 */
	private function textField_focusOutHandler(event:FocusEvent):Void;
}
