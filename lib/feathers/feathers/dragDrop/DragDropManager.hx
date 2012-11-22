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
import feathers.core.PopUpManager;
import feathers.events.DragDropEvent;

import flash.errors.IllegalOperationError;
import flash.events.KeyboardEvent;
import flash.geom.Point;
import flash.ui.Keyboard;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Stage;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * Handles drag and drop operations based on Starling touch events.
 *
 * @see IDragSource
 * @see IDropTarget
 * @see DragData
 */
extern class DragDropManager
{
	/**
	 * The ID of the touch that initiated the current drag. Returns <code>-1</code>
	 * if there is not an active drag action. In multi-touch applications,
	 * knowing the touch ID is useful if additional actions need to happen
	 * using the same touch.
	 */
	public static var touchPointID(default, null):Int;
	
	/**
	 * The <code>IDragSource</code> that started the current drag.
	 */
	public static var dragSource(default, null):IDragSource;

	/**
	 * Determines if the drag and drop manager is currently handling a drag.
	 * Only one drag may be active at a time.
	 */
	public static var isDragging(default, null):Bool;

	/**
	 * The data associated with the current drag. Returns <code>null</code>
	 * if there is not a current drag.
	 */
	public static var dragData(default, null):DragData;
	
	/**
	 * Starts a new drag. If another drag is currently active, it is
	 * immediately cancelled. Includes an optional "avatar", a visual
	 * representation of the data that is being dragged.
	 */
	public static function startDrag(source:IDragSource, touch:Touch, data:DragData, dragAvatar:DisplayObject = null, dragAvatarOffsetX:Float = 0, dragAvatarOffsetY:Float = 0):Void;

	/**
	 * Tells the drag and drop manager if the target will accept the current
	 * drop. Meant to be called in a listener for the target's
	 * <code>onDragEnter</code> signal.
	 */
	public static function acceptDrag(target:IDropTarget):Void;
	/**
	 * Immediately cancels the current drag.
	 */
	public static function cancelDrag():Void;

}
