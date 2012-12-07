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
import feathers.core.ITextRenderer;

import flash.display.BitmapData;
import flash.display3D.textures.Texture;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.Image;
import starling.events.Event;
import starling.textures.ConcreteTexture;
import starling.textures.Texture;
//import starling.utils.getNextPowerOfTwo;

/**
 * Renders text with a native <code>flash.text.TextField</code>.
 *
 * @see http://wiki.starling-framework.org/feathers/text-renderers
 * @see flash.text.TextField
 */
extern class TextFieldTextRenderer extends FeathersControl, implements ITextRenderer {
	
	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * @private
	 */
	@:protected private var _textField:TextField;

	/**
	 * @private
	 */
	@:protected private var _textSnapshot:Image;

	/**
	 * @private
	 */
	@:protected private var _textSnapshotBitmapData:BitmapData;
	
	/**
	 * @private
	 */
	@:protected private var _previousTextFieldWidth:Float;// = 0;

	/**
	 * @private
	 */
	@:protected private var _previousTextFieldHeight:Float;// = 0;

	/**
	 * @private
	 */
	@:protected private var _snapshotWidth:Int;//0;

	/**
	 * @private
	 */
	@:protected private var _snapshotHeight:Int;//0;

	/**
	 * @private
	 */
	@:protected private var _needsNewBitmap:Bool;//false;

	/**
	 * @private
	 */
	@:protected private var _frameCount:Int;//0;

	/**
	 * @private
	 */
	@:protected private var _text:String;//"";

	/**
	 * @inheritDoc
	 */
	public var text(default, default):String;

	/**
	 * @private
	 */
	@:protected private var _textFormat:TextFormat;

	/**
	 * The font and styles used to draw the text.
	 */
	public var textFormat(default, default):TextFormat;
	
	/**
	 * @inheritDoc
	 */
	public var baseline(default, null):Float;

	/**
	 * @private
	 */
	@:protected private var _embedFonts:Bool;//false;

	/**
	 * Determines if the TextField should use an embedded font or not.
	 */
	public var embedFonts(default, default):Bool;

	/**
	 * @private
	 */
	@:protected private var _wordWrap:Bool;//false;

	/**
	 * Determines if the TextField wraps text to the next line.
	 */
	public var wordWrap(default, default):Bool;

	/**
	 * @private
	 */
	@:protected private var _isHTML:Bool;//false;

	/**
	 * Determines if the TextField should display the text as HTML or not.
	 */
	public var isHTML(default, default):Bool;

	/**
	 * @private
	 */
	@:protected private var _snapToPixels:Bool;//true;

	/**
	 * Determines if the text should be snapped to the nearest whole pixel
	 * when rendered. When this is <code>false</code>, text may be displayed
	 * on sub-pixels, which often results in blurred rendering.
	 */
	public var snapToPixels(default, default):Bool;

	/**
	 * @inheritDoc
	 */
	public function measureText(result:Point = null):Point;


	/**
	 * @private
	 */
	private function commit():Void;
	
	/**
	 * @private
	 */
	private function measure(result:Point = null):Point;
	
	/**
	 * @private
	 */
	private function layout(sizeInvalid:Bool):Void;
	
	/**
	 * @private
	 */
	private function autoSizeIfNeeded():Bool;
	
	/**
	 * @private
	 */
	private function refreshSnapshot():Void;
	
	/**
	 * @private
	 */
	private function addedToStageHandler(event:Event):Void;
	
	/**
	 * @private
	 */
	private function removedFromStageHandler(event:Event):Void;
	
	private function enterFrameHandler(event:Event):Void;
}
