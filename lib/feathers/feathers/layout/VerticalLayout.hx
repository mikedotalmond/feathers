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
package feathers.layout;
import flash.geom.Point;
import flash.Vector;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.EventDispatcher;

/**
 * Positions items from top to bottom in a single column.
 */
extern class VerticalLayout extends EventDispatcher, implements IVariableVirtualLayout
{
	
	/**
	 * If the total item height is smaller than the height of the bounds,
	 * the items will be aligned to the top.
	 */
	public static var VERTICAL_ALIGN_TOP:String;// = "top";

	/**
	 * If the total item height is smaller than the height of the bounds,
	 * the items will be aligned to the middle.
	 */
	public static var VERTICAL_ALIGN_MIDDLE:String;// = "middle";

	/**
	 * If the total item height is smaller than the height of the bounds,
	 * the items will be aligned to the bottom.
	 */
	public static var VERTICAL_ALIGN_BOTTOM:String;// = "bottom";

	/**
	 * The items will be aligned to the left of the bounds.
	 */
	public static var HORIZONTAL_ALIGN_LEFT:String;// = "left";

	/**
	 * The items will be aligned to the center of the bounds.
	 */
	public static var HORIZONTAL_ALIGN_CENTER:String;// = "center";

	/**
	 * The items will be aligned to the right of the bounds.
	 */
	public static var HORIZONTAL_ALIGN_RIGHT:String;// = "right";

	/**
	 * The items will fill the width of the bounds.
	 */
	public static var HORIZONTAL_ALIGN_JUSTIFY:String;// = "justify";

	/**
	 * Constructor.
	 */
	public function new():Void;

	
	/**
	 * The space, in pixels, between items.
	 */
	public var gap(default, default):Float;// = 0;


	/**
	 * The minimum space, in pixels, above the items.
	 */
	public var paddingTop(default, default):Float;
	
	
	/**
	 * The space, in pixels, after the last item.
	 */
	public var paddingRight(default, default):Float;

	/**
	 * The minimum space, in pixels, above the items.
	 */
	public var paddingBottom(default, default):Float;
	
	/**
	 * The space, in pixels, before the first item.
	 */
	public var paddingLeft(default, default):Float;

	/**
	 * The alignment of the items vertically, on the y-axis.
	 */
	public var verticalAlign(default, default):String;
	
	/**
	 * If the total item width is less than the bounds, the positions of
	 * the items can be aligned horizontally.
	 */
	public var horizontalAlign(default, default):String;
	
	public var useVirtualLayout(default, default):Bool;
	public var hasVariableItemDimensions(default, default):Bool;
	public var typicalItemWidth(default, default):Float;
	public var typicalItemHeight(default, default):Float;
	
	/**
	 * When the scroll position is calculated for an item, an attempt will
	 * be made to align the item to this position.
	 */
	public var scrollPositionVerticalAlign(default, default):String;
	
	
	/**
	 * @inheritDoc
	 */
	public function layout(items:Vector<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult;

	/**
	 * @inheritDoc
	 */
	public function measureViewPort(itemCount:Int, viewPortBounds:ViewPortBounds = null, result:Point = null):Point;

	/**
	 * @inheritDoc
	 */
	public function resetVariableVirtualCache():Void;

	/**
	 * @inheritDoc
	 */
	public function resetVariableVirtualCacheAtIndex(index:Int, item:DisplayObject = null):Void;

	/**
	 * @inheritDoc
	 */
	public function getVisibleIndicesAtScrollPosition(scrollX:Float, scrollY:Float, width:Float, height:Float, itemCount:Int, result:Vector<Int> = null):Vector<Int>;

	/**
	 * @inheritDoc
	 */
	public function getScrollPositionForIndex(index:Int, items:Vector<DisplayObject>, x:Float, y:Float, width:Float, height:Float, result:Point = null):Point;
}
