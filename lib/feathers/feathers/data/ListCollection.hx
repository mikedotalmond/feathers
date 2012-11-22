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
 * <p>The <code>data</code> property of the event is the index of the
 * item that has been updated. It is of type <code>Int</code>.</p>
 *
 * @eventType feathers.events.CollectionEventType.ADD_ITEM
 */
@:meta(Event(name="addItem",type="starling.events.Event"))

/**
 * Dispatched when an item is removed from the collection.
 *
 * <p>The <code>data</code> property of the event is the index of the
 * item that has been updated. It is of type <code>Int</code>.</p>
 *
 * @eventType feathers.events.CollectionEventType.REMOVE_ITEM
 */
@:meta(Event(name="removeItem",type="starling.events.Event"))

/**
 * Dispatched when an item is replaced in the collection.
 *
 * <p>The <code>data</code> property of the event is the index of the
 * item that has been updated. It is of type <code>Int</code>.</p>
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
 * <p>The <code>data</code> property of the event is the index of the
 * item that has been updated. It is of type <code>Int</code>.</p>
 *
 * @eventType feathers.events.CollectionEventType.UPDATE_ITEM
 */
@:meta(Event(name="updateItem",type="starling.events.Event"))

@:meta(DefaultProperty("data"))
/**
 * Wraps a data source with a common API for use with UI controls, like
 * lists, that support one dimensional collections of data. Supports custom
 * "data descriptors" so that unexpected data sources may be used. Supports
 * Arrays, Vectors, and XMLLists automatically.
 * 
 * @see ArrayListCollectionDataDescriptor
 * @see VectorListCollectionDataDescriptor
 * @see XMLListListCollectionDataDescriptor
 */
extern class ListCollection extends EventDispatcher
{
	/**
	 * Constructor
	 */
	public function new(data:Dynamic = null):Void;
	
	/**
	 * The data source for this collection. May be any type of data, but a
	 * <code>dataDescriptor</code> needs to be provided to translate from
	 * the data source's APIs to something that can be understood by
	 * <code>ListCollection</code>.
	 * 
	 * <p>Data sources of type Array, Vector, and XMLList are automatically
	 * detected, and no <code>dataDescriptor</code> needs to be set if the
	 * <code>ListCollection</code> uses one of these types.</p>
	 */
	public var data(default, default):Dynamic;
	
	
	/**
	 * Describes the underlying data source by translating APIs.
	 * 
	 * @see IListCollectionDataDescriptor
	 */
	public var dataDescriptor(default, default):IListCollectionDataDescriptor;
	

	/**
	 * The number of items in the collection.
	 */
	public var length(default, null):Int;
	

	/**
	 * If an item doesn't dispatch an event or signal to indicate that it
	 * has changed, you can manually tell the collection about the change,
	 * and the collection will dispatch the <code>onItemUpdate</code> signal
	 * to manually notify the component that renders the data.
	 */
	public function updateItemAt(index:Int):Void;
	
	/**
	 * Returns the item at the specified index in the collection.
	 */
	public function getItemAt(index:Int):Dynamic;
	
	/**
	 * Determines which index the item appears at within the collection. If
	 * the item isn't in the collection, returns <code>-1</code>.
	 */
	public function getItemIndex(item:Dynamic):Int;
	
	/**
	 * Adds an item to the collection, at the specified index.
	 */
	public function addItemAt(item:Dynamic, index:Int):Void;
	
	/**
	 * Removes the item at the specified index from the collection and
	 * returns it.
	 */
	public function removeItemAt(index:Int):Dynamic;
	
	/**
	 * Removes a specific item from the collection.
	 */
	public function removeItem(item:Dynamic):Void;
	
	/**
	 * Replaces the item at the specified index with a new item.
	 */
	public function setItemAt(item:Dynamic, index:Int):Void;
	
	/**
	 * Adds an item to the end of the collection.
	 */
	public function push(item:Dynamic):Void;
	
	/**
	 * Removes the item from the end of the collection and returns it.
	 */
	public function pop():Dynamic;
	
	/**
	 * Adds an item to the beginning of the collection.
	 */
	public function unshift(item:Dynamic):Void;
	
	/**
	 * Removed the item from the beginning of the collection and returns it. 
	 */
	public function shift():Dynamic;
}