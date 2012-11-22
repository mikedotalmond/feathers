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
import feathers.events.CollectionEventType;
import flash.Vector;

import starling.events.Event;
import starling.events.EventDispatcher;

/**
 * Dispatched when the underlying data source changes and the ui will
 * need to redraw the data.
 *
 * @eventType starling.events.Event.CHANGE
 */
@:meta(Event(name="change",type="starling.events.Event"))

/**
 * Dispatched when the collection has changed drastically, such as when
 * the underlying data source is replaced completely.
 *
 * @eventType feathers.events.CollectionEventType.RESET
 */
@:meta(Event(name="reset",type="starling.events.Event"))

/**
 * Dispatched when an item is added to the collection.
 *
 * <p>The <code>data</code> property of the event is the index path of the
 * item that has been added. It is of type <code>Array</code> and contains
 * objects of type <code>Int</code>.</p>
 *
 * @eventType feathers.events.CollectionEventType.ADD_ITEM
 */
@:meta(Event(name="addItem",type="starling.events.Event"))

/**
 * Dispatched when an item is removed from the collection.
 *
 * <p>The <code>data</code> property of the event is the index path of the
 * item that has been removed. It is of type <code>Array</code> and contains
 * objects of type <code>Int</code>.</p>
 *
 * @eventType feathers.events.CollectionEventType.REMOVE_ITEM
 */
@:meta(Event(name="removeItem",type="starling.events.Event"))

/**
 * Dispatched when an item is replaced in the collection.
 *
 * <p>The <code>data</code> property of the event is the index path of the
 * item that has been replaced. It is of type <code>Array</code> and contains
 * objects of type <code>Int</code>.</p>
 *
 * @eventType feathers.events.CollectionEventType.REPLACE_ITEM
 */
@:meta(Event(name="replaceItem",type="starling.events.Event"))

/**
 * Dispatched when a property of an item in the collection has changed
 * and the item doesn't have its own change event or signal. This signal
 * is only dispatched when the <code>updateItemAt()</code> function is
 * called on the <code>HierarchicalCollection</code>.
 *
 * <p>In general, it's better for the items themselves to dispatch events
 * or signals when their properties change.</p>
 *
 * <p>The <code>data</code> property of the event is the index path of the
 * item that has been updated. It is of type <code>Array</code> and contains
 * objects of type <code>Int</code>.</p>
 *
 * @eventType feathers.events.CollectionEventType.UPDATE_ITEM
 */
@:meta(Event(name="updateItem",type="starling.events.Event"))

@:meta(DefaultProperty("data"))
/**
 * Wraps a two-dimensional data source with a common API for use with UI
 * controls that support this type of data.
 */
extern class HierarchicalCollection extends EventDispatcher
{
	public function new(data:Dynamic = null):Void;

	/**
	 * @private
	 */
	private var _data:Dynamic;

	/**
	 * The data source for this collection. May be any type of data, but a
	 * <code>dataDescriptor</code> needs to be provided to translate from
	 * the data source's APIs to something that can be understood by
	 * <code>HierarchicalCollection</code>.
	 */
	public var data(default, default):Dynamic;
	

	/**
	 * @private
	 */
	private var _dataDescriptor:IHierarchicalCollectionDataDescriptor;// = new ArrayChildrenHierarchicalCollectionDataDescriptor();

	/**
	 * Describes the underlying data source by translating APIs.
	 */
	public var dataDescriptor(default, default):IHierarchicalCollectionDataDescriptor;

	/**
	 * Determines if a node from the data source is a branch.
	 */
	public function isBranch(node:Dynamic):Bool;

	/**
	 * The number of items at the specified location in the collection.
	 */
	public function getLength(rest:Dynamic):Int;

	/**
	 * If an item doesn't dispatch an event or signal to indicate that it
	 * has changed, you can manually tell the collection about the change,
	 * and the collection will dispatch the <code>onItemUpdate</code> signal
	 * to manually notify the component that renders the data.
	 */
	public function updateItemAt(index:Int, rest:Dynamic):Void;

	/**
	 * Returns the item at the specified location in the collection.
	 */
	public function getItemAt(index:Int, rest:Dynamic):Dynamic;

	/**
	 * Determines which location the item appears at within the collection. If
	 * the item isn't in the collection, returns <code>null</code>.
	 */
	public function getItemLocation(item:Dynamic, result:Vector<Int> = null):Vector<Int>;

	/**
	 * Adds an item to the collection, at the specified location.
	 */
	public function addItemAt(item:Dynamic, index:Int, rest:Dynamic<Dynamic>):Void;
	/**
	 * Removes the item at the specified location from the collection and
	 * returns it.
	 */
	public function removeItemAt(index:Int, rest:Dynamic):Dynamic;

	/**
	 * Removes a specific item from the collection.
	 */
	public function removeItem(item:Dynamic):Void;

	/**
	 * Replaces the item at the specified location with a new item.
	 */
	public function setItemAt(item:Dynamic, index:Int, rest:Dynamic):Void;
}
