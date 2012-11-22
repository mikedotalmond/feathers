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

import feathers.controls.ScreenNavigator;
import feathers.controls.TabBar;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;

/**
 * Slides new screens from the left or right depending on the old and new
 * selected index values of a TabBar control.
 *
 * @see feathers.controls.ScreenNavigator
 * @see feathers.controls.TabBar
 */
extern class TabBarSlideTransitionManager
{
	/**
	 * Constructor.
	 */
	public function new(navigator:ScreenNavigator, tabBar:TabBar):Void;

	/**
	/**
	 * The duration of the transition, measured in seconds.
	 */
	public var duration:Float;// = 0.25;

	/**
	 * A delay before the transition starts, measured in seconds. This may
	 * be required on low-end systems that will slow down for a short time
	 * after heavy texture uploads.
	 */
	public var delay:Float;// = 0.1;

	/**
	 * The easing function to use.
	 */
	public var ease:Dynamic;// = Transitions.EASE_OUT;

}