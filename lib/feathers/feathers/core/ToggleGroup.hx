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
package feathers.core;
import flash.errors.IllegalOperationError;
import flash.Vector;

import starling.events.Event;
import starling.events.EventDispatcher;

/**
 * Dispatched when the selection changes.
 *
 * @eventType starling.events.Event.CHANGE
 */
@:meta(Event(name="change",type="starling.events.Event"))

/**
 * Controls the selection of two or more IToggle instances where only one
 * may be selected at a time.
 * 
 * @see IToggle
 */
extern class ToggleGroup extends EventDispatcher {
	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * @private
	 */
	private var _items:Vector<IToggle>;// = new Vector<IToggle>;

	/**
	 * @private
	 */
	private var _ignoreChanges:Bool;//false;

	/**
	 * @private
	 */
	private var _isSelectionRequired:Bool;//true;

	/**
	 * Determines if the user can deselect the currently selected item or
	 * not. The selection may always be cleared programmatically by setting
	 * the selected index to <code>-1</code> or the selected item to
	 * <code>null</code>.
	 *
	 * <p>If <code>isSelectionRequired</code> is set to <code>true</code>
	 * and the toggle group has items that were added previously, and there
	 * is no currently selected item, the item at index <code>0</code> will
	 * be selected automatically.</p>
	 */
	public var isSelectionRequired(default, default):Bool;

	
	/**
	 * The currently selected toggle.
	 */
	public var selectedItem(default, default):IToggle;
	
	/**
	 * @private
	 */
	private var _selectedIndex:Int;// = -1;
	
	/**
	 * The index of the currently selected toggle.
	 */
	public var selectedIndex(default, default):Int;
	
	/**
	 * Adds a toggle to the group. If it is the first item added to the
	 * group, and <code>isSelectionRequired</code> is <code>true</code>, it
	 * will be selected automatically.
	 */
	public function addItem(item:IToggle):Void;
	
	/**
	 * Removes a toggle from the group. If the item being removed is
	 * selected and <code>isSelectionRequired</code> is <code>true</code>,
	 * the final item will be selected. If <code>isSelectionRequired</code>
	 * is <code>false</code> instead, no item will be selected.
	 */
	public function removeItem(item:IToggle):Void;

	/**
	 * Removes all toggles from the group. No item will be selected.
	 */
	public function removeAllItems():Void;

	/**
	 * Determines if the group includes the specified item.
	 */
	public function hasItem(item:IToggle):Bool;
	
	/**
	 * @private
	 */
	private function item_changeHandler(event:Event):Void;
}