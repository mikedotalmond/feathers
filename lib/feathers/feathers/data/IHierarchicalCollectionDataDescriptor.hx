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
package feathers.data;
import flash.Vector;
/**
 * An adapter interface to support any kind of data source in
 * hierarchical collections.
 *
 * @see HierarchicalCollection
 */
extern interface IHierarchicalCollectionDataDescriptor
{
	/**
	 * Determines if a node from the data source is a branch.
	 */
	function isBranch(node:Dynamic):Bool;

	/**
	 * The number of items at the specified location in the data source.
	 *
	 * <p>The rest arguments are the indices that make up the location. If
	 * a location is omitted, the length returned will be for the root level
	 * of the collection.</p>
	 */
	function getLength(data:Dynamic, rest:Dynamic):Int;

	/**
	 * Returns the item at the specified location in the data source.
	 *
	 * <p>The rest arguments are the indices that make up the location.</p>
	 */
	function getItemAt(data:Dynamic, index:Int, rest:Dynamic):Dynamic;

	/**
	 * Replaces the item at the specified location with a new item.
	 *
	 * <p>The rest arguments are the indices that make up the location.</p>
	 */
	function setItemAt(data:Dynamic, item:Dynamic, index:Int, rest:Dynamic):Void;

	/**
	 * Adds an item to the data source, at the specified location.
	 *
	 * <p>The rest arguments are the indices that make up the location.</p>
	 */
	function addItemAt(data:Dynamic, item:Dynamic, index:Int, rest:Dynamic):Void;

	/**
	 * Removes the item at the specified location from the data source and
	 * returns it.
	 *
	 * <p>The rest arguments are the indices that make up the location.</p>
	 */
	function removeItemAt(data:Dynamic, index:Int, rest:Dynamic):Dynamic;

	/**
	 * Determines which location the item appears at within the data source.
	 * If the item isn't in the data source, returns an empty <code>Vector.&lt;Int&gt;</code>.
	 *
	 * <p>The <code>rest</code> arguments are optional indices to narrow
	 * the search.</p>
	 */
	function getItemLocation(data:Dynamic, item:Dynamic, result:Vector<Int> = null, rest:Dynamic):Vector<Int>;
}
