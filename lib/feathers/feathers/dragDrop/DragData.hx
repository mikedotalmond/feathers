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
package feathers.dragDrop;
/**
 * Stores data associated with a drag and drop operation.
 *
 * @see DragDropManager
 */
extern class DragData
{
	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * Determines if the specified data format is available.
	 */
	public function hasDataForFormat(format:String):Bool;

	/**
	 * Returns data for the specified format.
	 */
	public function getDataForFormat(format:String):Dynamic;

	/**
	 * Saves data for the specified format.
	 */
	public function setDataForFormat(format:String, data:Dynamic):Void;

	/**
	 * Removes all data for the specified format.
	 */
	public function clearDataForFormat(format:String):Dynamic;
}
