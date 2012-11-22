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
package feathers.controls;
import feathers.core.FeathersControl;
import feathers.events.FeathersEventType;

import flash.errors.IllegalOperationError;
import flash.geom.Rectangle;
//import flash.utils.getDefinitionByName;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.ResizeEvent;

/**
 * Dispatched when the active screen changes.
 *
 * @eventType starling.events.Event.CHANGE
 */
@:meta(Event(name="change",type="starling.events.Event"))

/**
 * Dispatched when the current screen is removed and there is no active
 * screen.
 *
 * @eventType feathers.events.FeathersEventType.CLEAR
 */
@:meta(Event(name="clear",type="starling.events.Event"))

/**
 * Dispatched when the transition between screens begins.
 *
 * @eventType feathers.events.FeathersEventType.TRANSITION_START
 */
@:meta(Event(name="transitionStart",type="starling.events.Event"))

/**
 * Dispatched when the transition between screens has completed.
 *
 * @eventType feathers.events.FeathersEventType.TRANSITION_COMPLETE
 */
@:meta(Event(name="transitionComplete",type="starling.events.Event"))

/**
 * A "view stack"-like container that supports navigation between screens
 * (any display object) through events.
 *
 * @see http://wiki.starling-framework.org/feathers/screen-navigator
 * @see http://wiki.starling-framework.org/feathers/transitions
 * @see feathers.controls.ScreenNavigatorItem
 * @see feathers.controls.Screen
 */
extern class ScreenNavigator extends FeathersControl
{
	
	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * The string identifier for the currently active screen.
	 */
	public var activeScreenID(default, default):String;
	
	/**
	 * Determines if the navigator's content should be clipped to the width
	 * and height.
	 */
	public var clipContent(default, default):Bool;
	

	/**
	 * A function that is called when the <code>ScreenNavigator</code> is
	 * changing screens.
	 */
	public var transition:Dynamic;// = defaultTransition;

	
	/**
	 * Displays a screen and returns a reference to it. If a previous
	 * transition is running, the new screen will be queued, and no
	 * reference will be returned.
	 */
	public function showScreen(id:String):DisplayObject;

	/**
	 * Removes the current screen, leaving the <code>ScreenNavigator</code>
	 * empty.
	 */
	public function clearScreen():Void;

	/**
	 * @private
	 */
	private function clearScreenInternal(displayTransition:Bool):Void;

	/**
	 * Registers a new screen by its identifier.
	 */
	public function addScreen(id:String, item:ScreenNavigatorItem):Void;

	/**
	 * Removes an existing screen using its identifier.
	 */
	public function removeScreen(id:String):Void;


}