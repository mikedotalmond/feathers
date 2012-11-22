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
import feathers.text.BitmapFontTextFormat;
import flash.Vector;

import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextFormatAlign;

import starling.core.RenderSupport;
import starling.display.Image;
import starling.display.QuadBatch;
import starling.text.BitmapChar;
import starling.text.BitmapFont;
import starling.textures.TextureSmoothing;

/**
 * Renders text using <code>starling.text.BitmapFont</code>.
 *
 * @see http://wiki.starling-framework.org/feathers/text-renderers
 * @see starling.text.BitmapFont
 */
extern class BitmapFontTextRenderer extends FeathersControl, implements ITextRenderer
{
	/**
	 * @private
	 */
	private static var HELPER_IMAGE:Image;

	/**
	 * @private
	 */
	private static var HELPER_MATRIX:Matrix;//new Matrix();

	/**
	 * @private
	 */
	private static var CHARACTER_ID_SPACE:Int;// = 32;

	/**
	 * @private
	 */
	private static var CHARACTER_ID_TAB:Int;// = 9;

	/**
	 * @private
	 */
	private static var CHARACTER_ID_LINE_FEED:Int;// = 10;

	/**
	 * @private
	 */
	private static var CHARACTER_ID_CARRIAGE_RETURN:Int;// = 13;

	/**
	 * @private
	 */
	private static var CHARACTER_BUFFER:Vector<CharLocation>;

	/**
	 * @private
	 */
	private static var CHAR_LOCATION_POOL:Vector<CharLocation>;

	/**
	 * Constructor.
	 */
	public function new():Void;
	
	/**
	 * The font and styles used to draw the text.
	 */
	public var textFormat(default, default):BitmapFontTextFormat;
	public var disabledTextFormat(default, default):BitmapFontTextFormat;
	public var text(default, default):String;
	public var smoothing(default, default):String;
	public var wordWrap(default, default):Bool;
	public var snapToPixels(default, default):Bool;
	public var truncationText(default, default):String;
	public var baseline(default, null):Float;


	/**
	 * @private
	 */
	override public function render(support:RenderSupport, alpha:Float):Void;
	
	/**
	 * @inheritDoc
	 */
	public function measureText(result:Point = null):Point;
	
	/**
	 * @private
	 */
	@:protected override function initialize():Void;
	/**
	 * @private
	 */
	@:protected override function draw():Void;

	/**
	 * @private
	 */
	private function trimBuffer(skipCount:Int):Void;
	
	/**
	 * @private
	 */
	private function alignBuffer(maxLineWidth:Float, currentLineWidth:Float, skipCount:Int):Void;
	
	/**
	 * @private
	 */
	private function addBufferToBatch(skipCount:Int):Void;
	
	/**
	 * @private
	 */
	private function moveBufferedCharacters(xOffset:Float, yOffset:Float, skipCount:Int):Void;
	/**
	 * @private
	 */
	private function addCharacterToBatch(charData:BitmapChar, x:Float, y:Float, scale:Float):Void;

	/**
	 * @private
	 */
	private function refreshTextFormat():Void;
	/**
	 * @private
	 */
	private function getTruncatedText():String;
}

import starling.text.BitmapChar;

extern class CharLocation
{
public var char:BitmapChar;
public var scale:Float;
public var x:Float;
public var y:Float;
}