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
import flash.utils.Dictionary;
import flash.Vector;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.display.Stage;
import starling.events.EnterFrameEvent;
import starling.events.Event;

/**
 * Adds a display object as a pop-up above all content.
 */
extern class PopUpManager
{
	/**
	 * @private
	 */
	private static var POPUP_TO_OVERLAY:Dictionary = new Dictionary(true);
	
	/**
	 * A function that returns a display object to use as an overlay for
	 * modal pop-ups.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 * <pre>function():DisplayObject</pre>
	 */
	public static var overlayFactory:Void->DisplayObject = defaultOverlayFactory;

	/**
	 * The default factory that creates overlays for modal pop-ups.
	 */
	public static function defaultOverlayFactory():DisplayObject;

	/**
	 * @private
	 */
	private static var popUps:Vector<DisplayObject>;// = new <DisplayObject>[];
	
	/**
	 * Adds a pop-up to the stage.
	 */
	public static function addPopUp(popUp:DisplayObject, isModal:Bool = true, isCentered:Bool = true, customOverlayFactory:Void->DisplayObject = null):Void;
	
	/**
	 * Removes a pop-up from the stage.
	 */
	public static function removePopUp(popUp:DisplayObject, dispose:Bool = false):Void;
	
	/**
	 * Determines if a display object is a pop-up.
	 */
	public static function isPopUp(popUp:DisplayObject):Bool;

	
	/**
	 * Centers a pop-up on the stage.
	 */
	public static function centerPopUp(popUp:DisplayObject):Void;

	/**
	 * @private
	 */
	private static function popUp_removedFromStageHandler(event:Event):Void;
}