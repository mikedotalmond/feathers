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
 * Positions items as tiles (equal width and height) from left to right
 * in multiple rows. Constrained to the suggested width, the tiled rows
 * layout will change in height as the number of items increases or
 * decreases
 */
extern class TiledRowsLayout extends EventDispatcher implements IVirtualLayout
{
	
	/**
	 * If the total item height is smaller than the height of the bounds,
	 * the items will be aligned to the top.
	 */
	public static var VERTICAL_ALIGN_TOP:String;//top";

	/**
	 * If the total item height is smaller than the height of the bounds,
	 * the items will be aligned to the middle.
	 */
	public static var VERTICAL_ALIGN_MIDDLE:String;//middle";

	/**
	 * If the total item height is smaller than the height of the bounds,
	 * the items will be aligned to the bottom.
	 */
	public static var VERTICAL_ALIGN_BOTTOM:String;//bottom";

	/**
	 * If the total item width is smaller than the width of the bounds, the
	 * items will be aligned to the left.
	 */
	public static var HORIZONTAL_ALIGN_LEFT:String;//left";

	/**
	 * If the total item width is smaller than the width of the bounds, the
	 * items will be aligned to the center.
	 */
	public static var HORIZONTAL_ALIGN_CENTER:String;//center";

	/**
	 * If the total item width is smaller than the width of the bounds, the
	 * items will be aligned to the right.
	 */
	public static var HORIZONTAL_ALIGN_RIGHT:String;//right";

	/**
	 * If an item height is smaller than the height of a tile, the item will
	 * be aligned to the top edge of the tile.
	 */
	public static var TILE_VERTICAL_ALIGN_TOP:String;//top";

	/**
	 * If an item height is smaller than the height of a tile, the item will
	 * be aligned to the middle of the tile.
	 */
	public static var TILE_VERTICAL_ALIGN_MIDDLE:String;//middle";

	/**
	 * If an item height is smaller than the height of a tile, the item will
	 * be aligned to the bottom edge of the tile.
	 */
	public static var TILE_VERTICAL_ALIGN_BOTTOM:String;//bottom";

	/**
	 * The item will be resized to fit the height of the tile.
	 */
	public static var TILE_VERTICAL_ALIGN_JUSTIFY:String;//justify";

	/**
	 * If an item width is smaller than the width of a tile, the item will
	 * be aligned to the left edge of the tile.
	 */
	public static var TILE_HORIZONTAL_ALIGN_LEFT:String;//left";

	/**
	 * If an item width is smaller than the width of a tile, the item will
	 * be aligned to the center of the tile.
	 */
	public static var TILE_HORIZONTAL_ALIGN_CENTER:String;//center";

	/**
	 * If an item width is smaller than the width of a tile, the item will
	 * be aligned to the right edge of the tile.
	 */
	public static var TILE_HORIZONTAL_ALIGN_RIGHT:String;//right";

	/**
	 * The item will be resized to fit the width of the tile.
	 */
	public static var TILE_HORIZONTAL_ALIGN_JUSTIFY:String;//justify";

	/**
	 * The items will be positioned in pages horizontally from left to right.
	 */
	public static var PAGING_HORIZONTAL:String;//horizontal";

	/**
	 * The items will be positioned in pages vertically from top to bottom.
	 */
	public static var PAGING_VERTICAL:String;//vertical";

	/**
	 * The items will not be paged. In other words, they will be positioned
	 * in a continuous set of rows without gaps.
	 */
	public static var PAGING_NONE:String;//none";

	/**
	 * Constructor.
	 */
	public function new():Void;

	
	public var gap(default, default):Float;
	public var paddingTop(default, default):Float;
	public var paddingRight(default, default):Float;
	public var paddingBottom(default, default):Float;
	public var paddingLeft(default, default):Float;
	
	public var verticalAlign(default, default):String;
	public var horizontalAlign(default, default):String;
	public var tileVerticalAlign(default, default):String;
	public var tileHorizontalAlign(default, default):String;
	public var paging(default, default):String;
	public var useSquareTiles(default, default):Bool;
	public var useVirtualLayout(default, default):Bool;
	
	public var typicalItemWidth(default, default):Float;
	public var typicalItemHeight(default, default):Float;

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
	public function getVisibleIndicesAtScrollPosition(scrollX:Float, scrollY:Float, width:Float, height:Float, itemCount:Int, result:Vector<Int> = null):Vector<Int>;
	
	/**
	 * @inheritDoc
	 */
	public function getScrollPositionForIndex(index:Int, items:Vector<DisplayObject>, x:Float, y:Float, width:Float, height:Float, result:Point = null):Point;
}
