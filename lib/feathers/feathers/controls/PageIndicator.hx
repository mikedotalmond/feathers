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

import feathers.layout.HorizontalLayout;
import feathers.layout.ILayout;
import feathers.layout.IVirtualLayout;
import feathers.layout.LayoutBoundsResult;
import feathers.layout.VerticalLayout;
import feathers.layout.ViewPortBounds;
import flash.Vector;

import flash.geom.Point;

import starling.display.DisplayObject;
import starling.display.Quad;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * Dispatched when the selected item changes.
 *
 * @eventType starling.events.Event.CHANGE
 */
@:meta(Event(name="change",type="starling.events.Event"))

/**
 * Displays a selected index, usually corresponding to a page index in
 * another UI control, using a highlighted symbol.
 *
 * @see http://wiki.starling-framework.org/feathers/page-indicator
 */
extern class PageIndicator extends FeathersControl
{
	/**
	 * @private
	 */
	private static var LAYOUT_RESULT:LayoutBoundsResult;//new LayoutBoundsResult();

	/**
	 * @private
	 */
	private static var SUGGESTED_BOUNDS:ViewPortBounds;//new ViewPortBounds();

	/**
	 * @private
	 */
	private static var HELPER_POINT:Point;//new Point();

	/**
	 * The page indicator's symbols will be positioned vertically, from top
	 * to bottom.
	 */
	public static var DIRECTION_VERTICAL:String;//"vertical";

	/**
	 * The page indicator's symbols will be positioned horizontally, from
	 * left to right.
	 */
	public static var DIRECTION_HORIZONTAL:String;//"horizontal";

	/**
	 * The symbols will be vertically aligned to the top.
	 */
	public static var VERTICAL_ALIGN_TOP:String;//"top";

	/**
	 * The symbols will be vertically aligned to the middle.
	 */
	public static var VERTICAL_ALIGN_MIDDLE:String;//"middle";

	/**
	 * The symbols will be vertically aligned to the bottom.
	 */
	public static var VERTICAL_ALIGN_BOTTOM:String;//"bottom";

	/**
	 * The symbols will be horizontally aligned to the left.
	 */
	public static var HORIZONTAL_ALIGN_LEFT:String;//"left";

	/**
	 * The symbols will be horizontally aligned to the center.
	 */
	public static var HORIZONTAL_ALIGN_CENTER:String;//"center";

	/**
	 * The symbols will be horizontally aligned to the right.
	 */
	public static var HORIZONTAL_ALIGN_RIGHT:String;//"right";

	/**
	 * @private
	 */
	private static function defaultSelectedSymbolFactory():Quad;

	/**
	 * @private
	 */
	private static function defaultNormalSymbolFactory():Quad;

	/**
	 * Constructor.
	 */
	public function new():Void;
	/**
	 * @private
	 */
	private var selectedSymbol:DisplayObject;

	/**
	 * @private
	 */
	private var cache:Vector<DisplayObject>;// = new <DisplayObject>[];

	/**
	 * @private
	 */
	private var unselectedSymbols:Vector<DisplayObject>;// = new <DisplayObject>[];

	/**
	 * @private
	 */
	private var symbols:Vector<DisplayObject>;// = new <DisplayObject>[];

	/**
	 * @private
	 */
	private var touchPointID:Int;//-1;

	/**
	 * @private
	 */
	private var _pageCount:Int;//1;

	/**
	 * The number of available pages.
	 */
	public var pageCount(default, default):Int;

	/**
	 * @private
	 */
	private var _selectedIndex:Int;//0;

	/**
	 * The currently selected index.
	 */
	public var selectedIndex(default, default):Int;

	/**
	 * @private
	 */
	private var _layout:ILayout;

	/**
	 * @private
	 */
	private var _direction:String;// = DIRECTION_HORIZONTAL;

	@:meta(Inspectable(type="String",enumeration="horizontal,vertical"))
	/**
	 * The symbols may be positioned vertically or horizontally.
	 */
	public var direction(default, default):String;

	/**
	 * @private
	 */
	private var _horizontalAlign:String;// = HORIZONTAL_ALIGN_CENTER;

	@:meta(Inspectable(type="String",enumeration="horizontal,vertical"))
	/**
	 * The alignment of the symbols on the horizontal axis.
	 */
	public var horizontalAlign(default, default):String;
	

	/**
	 * @private
	 */
	private var _verticalAlign:String;// = VERTICAL_ALIGN_MIDDLE;

	@:meta(Inspectable(type="String",enumeration="top,middle,bottom"))
	/**
	 * The alignment of the symbols on the vertical axis.
	 */
	public var verticalAlign(default, default):String;

	/**
	 * @private
	 */
	private var _gap:Float;//0;

	/**
	 * The spacing, in pixels, between symbols.
	 */
	public var gap(default, default):Float;

	/**
	 * @private
	 */
	private var _paddingTop:Float;//0;

	/**
	 * The minimum space, in pixels, between the top edge of the component
	 * and the top edge of the content.
	 */
	public var paddingTop(default, default):Float;

	/**
	 * @private
	 */
	private var _paddingRight:Float;//0;

	/**
	 * The minimum space, in pixels, between the right edge of the component
	 * and the right edge of the content.
	 */
	public var paddingRight(default, default):Float;

	/**
	 * @private
	 */
	private var _paddingBottom:Float;//0;

	/**
	 * The minimum space, in pixels, between the bottom edge of the component
	 * and the bottom edge of the content.
	 */
	public var paddingBottom(default, default):Float;


	/**
	 * @private
	 */
	private var _paddingLeft:Float;//0;

	/**
	 * The minimum space, in pixels, between the left edge of the component
	 * and the left edge of the content.
	 */
	public var paddingLeft(default, default):Float;


	/**
	 * @private
	 */
	private var _normalSymbolFactory:Void->DisplayObject;// = defaultNormalSymbolFactory;

	/**
	 * A function used to create a normal symbol.
	 *
	 * <p>This function should have the following signature:</p>
	 * <pre>function():DisplayObject</pre>
	 */
	public var normalSymbolFactory(default, default):Void->DisplayObject;

	/**
	 * @private
	 */
	private var _selectedSymbolFactory:Void->DisplayObject;// = defaultSelectedSymbolFactory;

	/**
	 * A function used to create a selected symbol.
	 *
	 * <p>This function should have the following signature:</p>
	 * <pre>function():DisplayObject</pre>
	 */
	public var selectedSymbolFactory(default, default):Void->DisplayObject;

	
	/**
	 * @private
	 */
	private function refreshSymbols(symbolsInvalid:Bool):Void;
	
	/**
	 * @private
	 */
	private function layoutSymbols(layoutInvalid:Bool):Void;
	
	/**
	 * @private
	 */
	private function touchHandler(event:TouchEvent):Void;
}
