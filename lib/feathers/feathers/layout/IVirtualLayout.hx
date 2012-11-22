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

/**
 * A layout algorithm that supports virtualization of items so that only
 * the visible items need to be created. Useful in lists with dozens or
 * hundreds of items are needed, but only a small subset of the items are
 * visible at any given moment.
 */
extern interface IVirtualLayout implements ILayout
{
	/**
	 * Determines if virtual layout can be used. Some components don't
	 * support virtual layouts. In those cases, the virtual layout options
	 * will be ignored.
	 */
	var useVirtualLayout(default, default):Bool;

	/**
	 * The width, in pixels, of a "typical" item that is used to virtually
	 * fill in blanks for the layout.
	 */
	var typicalItemWidth(default, default):Float;
	
	/**
	 * The width, in pixels, of a "typical" item that is used to virtually
	 * fill in blanks for the layout.
	 */
	var typicalItemHeight(default, default):Float;
	
	
	/**
	 * Using the typical item bounds and suggested bounds, returns a set of
	 * calculated dimensions for the view port.
	 */
	function measureViewPort(itemCount:Int, viewPortBounds:ViewPortBounds = null, result:Point = null):Point;

	/**
	 * Determines which indices are visible with the specified view port
	 * bounds and scroll position. Indices that aren't returned are
	 * typically not displayed and can be replaced virtually.
	 */
	function getVisibleIndicesAtScrollPosition(scrollX:Float, scrollY:Float, width:Float, height:Float, itemCount:Int, result:Vector<Int> = null):Vector<Int>;
}
