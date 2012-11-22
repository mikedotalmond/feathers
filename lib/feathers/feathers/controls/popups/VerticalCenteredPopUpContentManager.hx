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
package feathers.controls.popups;
import feathers.core.IFeathersControl;
import feathers.core.PopUpManager;
import feathers.events.FeathersEventType;

import flash.errors.IllegalOperationError;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.events.ResizeEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * @inheritDoc
 */
@:meta(Event(name="close",type="starling.events.Event"))

/**
 * Displays a pop-up at the center of the stage, filling the vertical space.
 * The content will be sized horizontally so that it is no larger than the
 * the width or height of the stage (whichever is smaller).
 */
extern class VerticalCenteredPopUpContentManager extends EventDispatcher, implements IPopUpContentManager
{
	/**
	 * Constructor.
	 */
	public function new():Void;
	
	/**
	 * The minimum space, in pixels, between the top edge of the content and
	 * the top edge of the stage.
	 */
	public var marginTop:Float;//0;

	/**
	 * The minimum space, in pixels, between the right edge of the content
	 * and the right edge of the stage.
	 */
	public var marginRight:Float;//0;

	/**
	 * The minimum space, in pixels, between the bottom edge of the content
	 * and the bottom edge of the stage.
	 */
	public var marginBottom:Float;//0;

	/**
	 * The minimum space, in pixels, between the left edge of the content
	 * and the left edge of the stage.
	 */
	public var marginLeft:Float;//0;

	/**
	 * @private
	 */
	private var content:DisplayObject;

	/**
	 * @private
	 */
	private var touchPointID:Int;//-1;

	/**
	 * @inheritDoc
	 */
	public function open(content:DisplayObject, source:DisplayObject):Void;

	/**
	 * @inheritDoc
	 */
	public function close():Void;
	/**
	 * @inheritDoc
	 */
	public function dispose():Void;
	
	/**
	 * @private
	 */
	private function layout():Void;
	
	/**
	 * @private
	 */
	private function content_resizeHandler(event:Event):Void;

	/**
	 * @private
	 */
	private function stage_keyDownHandler(event:KeyboardEvent):Void;

	/**
	 * @private
	 */
	private function stage_resizeHandler(event:ResizeEvent):Void;

	/**
	 * @private
	 */
	private function stage_touchHandler(event:TouchEvent):Void;
}
