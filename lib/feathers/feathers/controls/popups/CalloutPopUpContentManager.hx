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
import feathers.controls.Callout;

import flash.errors.IllegalOperationError;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.EventDispatcher;

/**
 * @inheritDoc
 */
@:meta(Event(name="close",type="starling.events.Event"))

/**
 * Displays pop-up content (such as the List in a PickerList) in a Callout.
 *
 * @see PickerList
 */
extern class CalloutPopUpContentManager extends EventDispatcher, implements IPopUpContentManager
{
	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * @private
	 */
	private var content:DisplayObject;

	/**
	 * @private
	 */
	private var callout:Callout;

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
	private function cleanup():Void;

	/**
	 * @private
	 */
	private function callout_closeHandler(event:Event):Void;
}
