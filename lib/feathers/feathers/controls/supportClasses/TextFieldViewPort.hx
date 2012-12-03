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
package feathers.controls.supportClasses;

import feathers.core.FeathersControl;

import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.events.Event;
import starling.utils.MatrixUtil;

/**
 * @private
 */
extern class TextFieldViewPort extends FeathersControl, implements IViewPort {
	
	private static var HELPER_MATRIX:Matrix;//new Matrix();
	private static var HELPER_POINT:Point;//new Point();

	public function new():Void;
	
	public var verticalScrollStep(default, null):Float;
	
	private var _textFieldContainer:Sprite;
	private var _textField:TextField;

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
	 * The font and styles used to draw the text.
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
	private var _isHTML:Bool;//false;

	/**
	 * Determines if the TextField should display the text as HTML or not.
	 */
	public var isHTML(default, default):Bool;

	
	private var _minVisibleWidth:Float;//0;

	public var minVisibleWidth(default, default):Float;

	private var _maxVisibleWidth:Float;// = Float.POSITIVE_INFINITY;

	public var maxVisibleWidth(default, default):Float;
	
	private var _visibleWidth:Float;//;//

	public var visibleWidth(default, default):Float;
	

	private var _minVisibleHeight:Float;//0;

	public var minVisibleHeight(default, default):Float;
	

	private var _maxVisibleHeight:Float;// = Float.POSITIVE_INFINITY;

	public var maxVisibleHeight(default, default):Float;

	private var _visibleHeight:Float;//;//

	public var visibleHeight(default, default):Float;


	private var _scrollStep:Float;

	public var horizontalScrollStep(default, default):Float;

	private var _horizontalScrollPosition:Float;//0;

	public var horizontalScrollPosition(default, default):Float;

	private var _verticalScrollPosition:Float;//0;

	public var verticalScrollPosition(default, default):Float;

	private var _paddingTop:Float;//0;

	public var paddingTop(default, default):Float;

	private var _paddingRight:Float;//0;

	public var paddingRight(default, default):Float;

	private var _paddingBottom:Float;//0;

	public var paddingBottom(default, default):Float;

	private var _paddingLeft:Float;//0;

	public var paddingLeft(default, default):Float;

	private function addedToStageHandler(event:Event):Void;

	private function removedFromStageHandler(event:Event):Void;
}
