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
import feathers.events.FeathersEventType;
import feathers.text.StageTextField;

import flash.display.BitmapData;
import flash.display3D.textures.Texture;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.engine.FontPosture;
import flash.text.engine.FontWeight;
import flash.ui.Keyboard;
//import flash.utils.getDefinitionByName;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.events.Event;
import starling.textures.ConcreteTexture;
import starling.textures.Texture;
import starling.utils.MatrixUtil;

/**
 * A Feathers text editor that uses the native <code>StageText</code> class
 * in AIR, and the custom <code>StageTextField</code> class (that simulates
 * <code>StageText</code>) in Flash Player.
 *
 * @see http://wiki.starling-framework.org/feathers/text-editors
 * @see flash.text.StageText
 * @see feathers.text.StageTextField
 */
extern class StageTextTextEditor extends FeathersControl, implements ITextEditor
{
	/**
	 * @private
	 */
	private static var HELPER_MATRIX:Matrix;// = new Matrix();

	/**
	 * @private
	 */
	private static var HELPER_POINT:Point;// = new Point();

	/**
	 * @private
	 */
	private static var INVALIDATION_FLAG_POSITION:String;// = "position";

	/**
	 * Constructor.
	 */
	public function new():Void;


	/**
	 * The text displayed by the input.
	 */
	public var text(default, default):String;
	public var fontFamily(default, default):String;
	public var fontPosture(default, default):String;
	public var fontWeight(default, default):String;
	public var locale(default, default):String;
	public var returnKeyLabel(default, default):String;
	public var restrict(default, default):String;
	public var softKeyboardType(default, default):String;
	public var autoCapitalize(default, default):String;
	public var textAlign(default, default):String;
	public var autoCorrect(default, default):Bool;
	public var displayAsPassword(default, default):Bool;
	public var editable(default, default):Bool;
	public var color(default, default):UInt;
	public var fontSize(default, default):Int;
	public var maxChars(default, default):Int;

	/**
	 * @inheritDoc
	 */
	public function setFocus(position:Point = null):Void;
	
	/**
	 * @inheritDoc
	 */
	public function selectRange(startIndex:Int, endIndex:Int):Void;
}