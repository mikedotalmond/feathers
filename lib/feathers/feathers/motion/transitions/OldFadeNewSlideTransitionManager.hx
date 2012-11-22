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
package feathers.motion.transitions;

import feathers.controls.IScreen;
import feathers.controls.ScreenNavigator;
import flash.events.Event;
import flash.Vector;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;

/**
 * A transition for <code>ScreenNavigator</code> that fades out the old
 * screen and slides in the new screen from an edge. The slide starts from
 * the right or left, depending on if the manager determines that the
 * transition is a push or a pop.
 *
 * <p>Whether a screen change is supposed to be a push or a pop is
 * determined automatically. The manager generates an identifier from the
 * fully-qualified class name of the screen, and if present, the
 * <code>screenID</code> defined by <code>IScreen</code> instances. If the
 * generated identifier is present on the stack, a screen change is
 * considered a pop. If the token is not present, it's a push. Screen IDs
 * should be tailored to this behavior to aVoid false positives.</p>
 *
 * <p>If your navigation structure requires explicit pushing and popping, a
 * custom transition manager is probably better.</p>
 *
 * @see feathers.controls.ScreenNavigator
 */
extern class OldFadeNewSlideTransitionManager
{
	/**
	 * Constructor.
	 */
	public function new(navigator:ScreenNavigator, quickStack:Class = null);

	/**
	 * The duration of the transition.
	 */
	public var duration:Float;

	/**
	 * A delay before the transition starts, measured in seconds. This may
	 * be required on low-end systems that will slow down for a short time
	 * after heavy texture uploads.
	 */
	public var delay:Float;
	
	/**
	 * The easing function to use.
	 */
	public var ease:Dynamic;
	
	/**
	 * Removes all saved classes from the stack that are used to determine
	 * which side of the <code>ScreenNavigator</code> the new screen will
	 * slide in from.
	 */
	public function clearStack():Void
	
}