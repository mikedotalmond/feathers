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
package feathers.events;
/**
 * Event <code>type</code> constants. This class is not a subclass of
 * <code>starling.events.Event</code> because these constants are meant to
 * be used with <code>dispatchEventWith()</code> and take advantage of the
 * Starling's event object pooling.
 */
extern class FeathersEventType
{
	/**
	 * The <code>FeathersEventType.INITIALIZE</code> event type is meant to
	 * be used when an <code>IFeathersControl</code> has finished running
	 * its <code>initialize()</code> function.
	 */
	public static var INITIALIZE:String;//initialize";

	/**
	 * The <code>FeathersEventType.RESIZE</code> event type is meant to
	 * be used when an <code>IFeathersControl</code> has resized.
	 */
	public static var RESIZE:String;//resize";

	/**
	 * The <code>FeathersEventType.ENTER</code> event type is meant to
	 * be used when the enter key has been pressed in an input control.
	 */
	public static var ENTER:String;//enter";

	/**
	 * The <code>FeathersEventType.CLEAR</code> event type is a generic
	 * event type for when something is "cleared".
	 */
	public static var CLEAR:String;//clear";

	/**
	 * The <code>FeathersEventType.SCROLL_COMPLETE</code> event type is used
	 * when a "throw" completes in a scrolling control.
	 */
	public static var SCROLL_COMPLETE:String;//scrollComplete";

	/**
	 * The <code>FeathersEventType.BEGIN_INTERACTION</code> event type is
	 * used by many UI controls where a drag or other interaction happens
	 * over time. An example is a <code>Slider</code> control where the
	 * user touches the thumb to begin dragging.
	 */
	public static var BEGIN_INTERACTION:String;//beginInteraction";

	/**
	 * The <code>FeathersEventType.END_INTERACTION</code> event type is
	 * used by many UI controls where a drag or other interaction happens
	 * over time. An example is a <code>Slider</code> control where the
	 * user stops touching the thumb after dragging.
	 */
	public static var END_INTERACTION:String;//endInteraction";

	/**
	 * The <code>FeathersEventType.TRANSITION_START</code> event type is
	 * used by the <code>ScreenNavigator</code> to indicate when a
	 * transition between screens begins.
	 */
	public static var TRANSITION_START:String;//transitionStart";

	/**
	 * The <code>FeathersEventType.TRANSITION_COMPLETE</code> event type is
	 * used by the <code>ScreenNavigator</code> to indicate when a
	 * transition between screens ends.
	 */
	public static var TRANSITION_COMPLETE:String;//transitionComplete";

	/**
	 * The <code>FeathersEventType.FOCUS_IN</code> event type is used by
	 * Feathers components to indicate when they have received focus.
	 */
	public static var FOCUS_IN:String;//focusIn";

	/**
	 * The <code>FeathersEventType.FOCUS_OUT</code> event type is used by
	 * Feathers components to indicate when they have lost focus.
	 */
	public static var FOCUS_OUT:String;//focusOut";
	
	/**
	 * The <code>FeathersEventType.RENDERER_ADD</code> event type is used by
	 * Feathers components with item renderers to indicate when a new
	 * renderer has been added. This event type is meant to be used with
	 * virtualized layouts where only a limited set of renderers will be
	 * created for a data provider that may include a larger number of items.
	 */
	public static var RENDERER_ADD:String;// = "rendererAdd";

	/**
	 * The <code>FeathersEventType.RENDERER_REMOVE</code> event type is used
	 * by Feathers controls with item renderers to indicate when a renderer
	 * is removed. This event type is meant to be used with virtualized
	 * layouts where only a limited set of renderers will be created for
	 * a data provider that may include a larger number items.
	 */
	public static var RENDERER_REMOVE:String;//= "rendererRemove";
	
	/**
     * The <code>FeathersEventType.ERROR</code> event type is used by
     * by Feathers controls when an error occurs that can be caught and
     * safely ignored.
     */
	public static var ERROR:String;//"error";
}
