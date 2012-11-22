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
/**
 * Used by layout algorithms for determining the bounds in which to position
 * and size items.
 */
extern class ViewPortBounds
{
	public function new():Void;
	/**
	 * The x position of the view port, in pixels.
	 */
	public var x:Float;// = 0;

	/**
	 * The y position of the view port, in pixels.
	 */
	public var y:Float;// = 0;

	/**
	 * The explicit width of the view port, in pixels. If <code>NaN</code>,
	 * there is no explicit width value.
	 */
	public var explicitWidth:Float;//;//

	/**
	 * The explicit height of the view port, in pixels. If <code>NaN</code>,
	 * there is no explicit height value.
	 */
	public var explicitHeight:Float;//;//

	/**
	 * The minimum width of the view port, in pixels. Should be 0 or
	 * a positive number less than infinity.
	 */
	public var minWidth:Float;// = 0;

	/**
	 * The minimum width of the view port, in pixels. Should be 0 or
	 * a positive number less than infinity.
	 */
	public var minHeight:Float;// = 0;

	/**
	 * The maximum width of the view port, in pixels. Should be 0 or
	 * a positive number, including infinity.
	 */
	public var maxWidth:Float;// = Float.POSITIVE_INFINITY;

	/**
	 * The maximum height of the view port, in pixels. Should be 0 or
	 * a positive number, including infinity.
	 */
	public var maxHeight:Float;// = Float.POSITIVE_INFINITY;
}
