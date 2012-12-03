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

Below is a list of certain publicly available software that is the source of
intellectual property in this class, along with the licensing terms that pertain
to those sources of IP.

The velocity and throwing physics calculations are loosely based on code from
the TouchScrolling library by Pavel fljot.
Copyright (c) 2011 Pavel fljot
License: Same as above.
Source: https://github.com/fljot/TouchScrolling
*/
package feathers.controls;
import feathers.controls.supportClasses.IViewPort;
import feathers.core.FeathersControl;
import feathers.core.PropertyProxy;
import starling.display.Sprite;

import feathers.events.FeathersEventType;
import feathers.system.DeviceCapabilities;
import flash.Vector;


import flash.errors.IllegalOperationError;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
//import flash.utils.getTimer;s

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * Dispatched when the scroller scrolls in either direction.
 *
 * @eventType starling.events.Event.SCROLL
 */
@:meta(Event(name="scroll",type="starling.events.Event"))

/**
 * Dispatched when the scroller finishes scrolling in either direction after
 * being thrown.
 *
 * @eventType feathers.events.FeathersEventType.SCROLL_COMPLETE
 */
@:meta(Event(name="scrollComplete",type="starling.events.Event"))

/**
 * Dispatched when the user starts dragging the scroller.
 *
 * @eventType feathers.events.FeathersEventType.BEGIN_INTERACTION
 */
@:meta(Event(name="beginInteraction",type="starling.events.Event"))

/**
 * Dispatched when the user stops dragging the scroller.
 *
 * @eventType feathers.events.FeathersEventType.END_INTERACTION
 */
@:meta(Event(name="endInteraction",type="starling.events.Event"))

/**
 * Allows horizontal and vertical scrolling of a <em>viewport</em>. Not
 * meant to be used as a standalone container or component. Generally meant
 * to be a sub-component of another component that needs to support
 * scrolling. To put components in a generic scrollable container (with
 * optional layout), see <code>ScrollContainer</code>. To scroll long
 * passages of text, see <code>ScrollText</code>.
 *
 * <p>Will react to the <code>onResize</code> signal dispatched by UI
 * controls to adjust the maximum scroll positions. For regular Starling
 * display objects, the <code>invalidate()</code> function needs to be
 * called on the <code>Scroller</code> when they resize because the
 * <code>Scroller</code> cannot detect the change.</p>
 *
 * @see http://wiki.starling-framework.org/feathers/scroller
 * @see ScrollContainer
 * @see ScrollText
 */
extern class Scroller extends FeathersControl
{
	/**
	 * @private
	 */
	private static var HELPER_POINT:Point;//new Point();

	/**
	 * @private
	 */
	private static var INVALIDATION_FLAG_SCROLL_BAR_RENDERER:String;//"scrollBarRenderer";

	/**
	 * The scroller may scroll if the view port is larger than the
	 * scroller's bounds. If the interaction mode is touch, the elastic
	 * edges will only be active if the maximum scroll position is greater
	 * than zero. If the scroll bar display mode is fixed, the scroll bar
	 * will only be visible when the maximum scroll position is greater than
	 * zero.
	 */
	public static var SCROLL_POLICY_AUTO:String;//"auto";

	/**
	 * The scroller will always scroll. If the interaction mode is touch,
	 * elastic edges will always be active, even when the maximum scroll
	 * position is zero. If the scroll bar display mode is fixed, the scroll
	 * bar will always be visible.
	 */
	public static var SCROLL_POLICY_ON:String;//"on";
	
	/**
	 * The scroller does not scroll at all. If the scroll bar display mode
	 * is fixed or float, the scroll bar will never be visible.
	 */
	public static var SCROLL_POLICY_OFF:String;//"off";
	
	/**
	 * Aligns the viewport to the left, if the viewport's width is smaller
	 * than the scroller's width.
	 */
	public static var HORIZONTAL_ALIGN_LEFT:String;//"left";
	
	/**
	 * Aligns the viewport to the center, if the viewport's width is smaller
	 * than the scroller's width.
	 */
	public static var HORIZONTAL_ALIGN_CENTER:String;//"center";
	
	/**
	 * Aligns the viewport to the right, if the viewport's width is smaller
	 * than the scroller's width.
	 */
	public static var HORIZONTAL_ALIGN_RIGHT:String;//"right";
	
	/**
	 * Aligns the viewport to the top, if the viewport's height is smaller
	 * than the scroller's height.
	 */
	public static var VERTICAL_ALIGN_TOP:String;//"top";
	
	/**
	 * Aligns the viewport to the middle, if the viewport's height is smaller
	 * than the scroller's height.
	 */
	public static var VERTICAL_ALIGN_MIDDLE:String;//"middle";
	
	/**
	 * Aligns the viewport to the bottom, if the viewport's height is smaller
	 * than the scroller's height.
	 */
	public static var VERTICAL_ALIGN_BOTTOM:String;//"bottom";

	/**
	 * The scroll bars appear above the scroller's view port, and fade out
	 * when not in use.
	 */
	public static var SCROLL_BAR_DISPLAY_MODE_FLOAT:String;//"float";

	/**
	 * The scroll bars are always visible and appear next to the scroller's
	 * view port, making the view port smaller than the scroller.
	 */
	public static var SCROLL_BAR_DISPLAY_MODE_FIXED:String;//"fixed";

	/**
	 * The scroll bars are never visible.
	 */
	public static var SCROLL_BAR_DISPLAY_MODE_NONE:String;//"none";

	/**
	 * The user may touch anywhere on the scroller and drag to scroll.
	 */
	public static var INTERACTION_MODE_TOUCH:String;//"touch";

	/**
	 * The user may interact with the scroll bars to scroll.
	 */
	public static var INTERACTION_MODE_MOUSE:String;//"mouse";
	
	/**
	 * Flag to indicate that the clipping has changed.
	 */
	private static var INVALIDATION_FLAG_CLIPPING:String;//"clipping";
	
	/**
	 * @private
	 * The minimum physical distance (in inches) that a touch must move
	 * before the scroller starts scrolling.
	 */
	private static var MINIMUM_DRAG_DISTANCE:Float;//0.04;

	/**
	 * @private
	 * The minimum physical velocity (in inches per second) that a touch
	 * must move before the scroller will "throw" to the next page.
	 * Otherwise, it will settle to the nearest page.
	 */
	private static var MINIMUM_PAGE_VELOCITY:Float;//5;

	/**
	 * @private
	 * The point where we stop calculating velocity changes because floating
	 * point issues can start to appear.
	 */
	private static var MINIMUM_VELOCITY:Float;//0.02;
	
	/**
	 * @private
	 * The friction applied every frame when the scroller is "thrown".
	 */
	private static var FRICTION:Float;//0.998;

	/**
	 * @private
	 * Extra friction applied when the scroller is beyond its bounds and
	 * needs to bounce back.
	 */
	private static var EXTRA_FRICTION:Float;//0.95;

	/**
	 * @private
	 * Older saved velocities are given less importance.
	 */
	private static var VELOCITY_WEIGHTS:Vector<Float>;//;//new <Float>[2, 1.66, 1.33, 1];

	/**
	 * @private
	 */
	private static var MAXIMUM_SAVED_VELOCITY_COUNT:Int;//4;

	/**
	 * @private
	 */
	private static var CHILDREN_ERROR:String;//"Scroller may not have children. Use viewPort property.";

	/**
	 * The default value added to the <code>nameList</code> of the
	 * horizontal scroll bar.
	 */
	public static var DEFAULT_CHILD_NAME_HORIZONTAL_SCROLL_BAR:String;//"feathers-scroller-horizontal-scroll-bar";

	/**
	 * The default value added to the <code>nameList</code> of the vertical
	 * scroll bar.
	 */
	public static var DEFAULT_CHILD_NAME_VERTICAL_SCROLL_BAR:String;//"feathers-scroller-vertical-scroll-bar";

	/**
	 * @private
	 */
	private static function defaultHorizontalScrollBarFactory():IScrollBar;

	/**
	 * @private
	 */
	private static function defaultVerticalScrollBarFactory():IScrollBar;
	
	/**
	 * Constructor.
	 */
	public function new():Void;
	
	/**
	 * The value added to the <code>nameList</code> of the horizontal scroll
	 * bar.
	 */
	private var horizontalScrollBarName:String;//;//DEFAULT_CHILD_NAME_HORIZONTAL_SCROLL_BAR;

	/**
	 * The value added to the <code>nameList</code> of the vertical scroll
	 * bar.
	 */
	private var verticalScrollBarName:String;// = DEFAULT_CHILD_NAME_VERTICAL_SCROLL_BAR;

	/**
	 * The horizontal scrollbar instance. May be null.
	 */
	private var horizontalScrollBar:IScrollBar;

	/**
	 * The vertical scrollbar instance. May be null.
	 */
	private var verticalScrollBar:IScrollBar;

	/**
	 * @private
	 */
	private var _horizontalScrollBarHeightOffset:Float;

	/**
	 * @private
	 */
	private var _verticalScrollBarWidthOffset:Float;

	/**
	 * @private
	 */
	private var _horizontalScrollBarTouchPointID:Int;//-1;

	/**
	 * @private
	 */
	private var _verticalScrollBarTouchPointID:Int;//-1;

	/**
	 * @private
	 */
	private var _touchPointID:Int;//-1;

	/**
	 * @private
	 */
	private var _startTouchX:Float;

	/**
	 * @private
	 */
	private var _startTouchY:Float;

	/**
	 * @private
	 */
	private var _startHorizontalScrollPosition:Float;

	/**
	 * @private
	 */
	private var _startVerticalScrollPosition:Float;

	/**
	 * @private
	 */
	private var _currentTouchX:Float;

	/**
	 * @private
	 */
	private var _currentTouchY:Float;

	/**
	 * @private
	 */
	private var _previousTouchTime:Int;

	/**
	 * @private
	 */
	private var _previousTouchX:Float;

	/**
	 * @private
	 */
	private var _previousTouchY:Float;

	/**
	 * @private
	 */
	private var _velocityX:Float;//0;

	/**
	 * @private
	 */
	private var _velocityY:Float;//0;

	/**
	 * @private
	 */
	private var _previousVelocityX:Vector<Float>;//;//new <Float>[];

	/**
	 * @private
	 */
	private var _previousVelocityY:Vector<Float>;//;//new <Float>[];

	/**
	 * @private
	 */
	private var _lastViewPortWidth:Float;//0;

	/**
	 * @private
	 */
	private var _lastViewPortHeight:Float;//0;

	/**
	 * @private
	 */
	private var _horizontalAutoScrollTween:Tween;

	/**
	 * @private
	 */
	private var _verticalAutoScrollTween:Tween;

	/**
	 * @private
	 */
	private var _isDraggingHorizontally:Bool;//false;

	/**
	 * @private
	 */
	private var _isDraggingVertically:Bool;//false;

	/**
	 * @private
	 */
	private var _viewPortWrapper:Sprite;

	/**
	 * @private
	 */
	private var ignoreViewPortResizing:Bool;//false;
	
	/**
	 * @private
	 */
	private var _viewPort:IViewPort;
	
	/**
	 * The display object displayed and scrolled within the Scroller.
	 */
	public var viewPort(default, default):IViewPort;
	
	/**
	 * @private
	 */
	private var _snapToPages:Bool;//false;

	/**
	 * Determines if scrolling will snap to the nearest page.
	 */
	public var snapToPages(default, default):Bool;
	
	/**
	 * @private
	 */
	private var _horizontalScrollBarFactory:Void->IScrollBar;//;//defaultHorizontalScrollBarFactory;

	/**
	 * Creates the horizontal scroll bar.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function():IScrollBar</pre>
	 */
	public var horizontalScrollBarFactory(default, default):Void->IScrollBar;

	/**
	 * @private
	 */
	private var _horizontalScrollBarProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to the scroller's
	 * horizontal scroll bar instance (if it exists). The scroll bar is an
	 * <code>IScrollBar</code> implementation.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * @see #horizontalScrollBarFactory
	 */
	public var horizontalScrollBarProperties(default, default):Dynamic;

	
	/**
	 * @private
	 */
	private var _verticalScrollBarFactory:Void->IScrollBar;// = defaultVerticalScrollBarFactory;

	/**
	 * Creates the vertical scroll bar.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function():IScrollBar</pre>
	 */
	public var verticalScrollBarFactory(default, default):Void->IScrollBar;

	
	/**
	 * @private
	 */
	private var _verticalScrollBarProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to the scroller's
	 * vertical scroll bar instance (if it exists). The scroll bar is an
	 * <code>IScrollBar</code> implementation.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * @see #verticalScrollBarFactory
	 */
	public var verticalScrollBarProperties(default, default):Dynamic;

	/**
	 * @private
	 */
	private var actualHorizontalScrollStep:Float;//1;

	/**
	 * @private
	 */
	private var explicitHorizontalScrollStep:Float;//

	/**
	 * The number of pixels the scroller can be stepped horizontally. Passed
	 * to the horizontal scroll bar, if one exists. Touch scrolling is not
	 * affected by the step value.
	 */
	public var horizontalScrollStep(default, default):Float;

	/**
	 * @private
	 */
	private var _horizontalScrollPosition:Float;//0;
	
	/**
	 * The number of pixels the scroller has been scrolled horizontally (on
	 * the x-axis).
	 */
	public var horizontalScrollPosition(default, default):Float;
	
	/**
	 * @private
	 */
	private var _maxHorizontalScrollPosition:Float;//0;
	
	/**
	 * The maximum number of pixels the scroller may be scrolled
	 * horizontally (on the x-axis). This value is automatically calculated
	 * based on the width of the viewport. The <code>horizontalScrollPosition</code>
	 * property may have a higher value than the maximum due to elastic
	 * edges. However, once the user stops interacting with the scroller,
	 * it will automatically animate back to the maximum (or minimum, if
	 * below 0).
	 */
	public var maxHorizontalScrollPosition(default, null):Float;

	/**
	 * @private
	 */
	private var _horizontalPageIndex:Int;//0;

	/**
	 * The index of the horizontal page, if snapping is enabled. If snapping
	 * is disabled, the index will always be <code>0</code>.
	 */
	public var horizontalPageIndex(default, null):Int;

	/**
	 * @private
	 */
	private var _horizontalScrollPolicy:String;// = SCROLL_POLICY_AUTO;

	@:meta(Inspectable(type="String",enumeration="auto,on,off"))
	/**
	 * Determines whether the scroller may scroll horizontally (on the
	 * x-axis) or not.
	 *
	 * @see #SCROLL_POLICY_AUTO
	 * @see #SCROLL_POLICY_ON
	 * @see #SCROLL_POLICY_OFF
	 */
	public var horizontalScrollPolicy(default, default):String;
	
	/**
	 * @private
	 */
	private var _horizontalAlign:String;// = HORIZONTAL_ALIGN_LEFT;

	@:meta(Inspectable(type="String",enumeration="left,center,right"))
	/**
	 * If the viewport's width is less than the scroller's width, it will
	 * be aligned to the left, center, or right of the scroller.
	 *
	 * @see #HORIZONTAL_ALIGN_LEFT
	 * @see #HORIZONTAL_ALIGN_CENTER
	 * @see #HORIZONTAL_ALIGN_RIGHT
	 */
	public var horizontalAlign(default, default):String;
	
	/**
	 * @private
	 */
	private var actualVerticalScrollStep:Float;//1;

	/**
	 * @private
	 */
	private var explicitVerticalScrollStep:Float;// = Math.NaN;

	/**
	 * The number of pixels the scroller can be stepped vertically. Passed
	 * to the vertical scroll bar, if it exists, and used for scrolling with
	 * the mouse wheel. Touch scrolling is not affected by the step value.
	 */
	public var verticalScrollStep(default, default):Float;
	
	
	/**
	 * @private
	 */
	private var _verticalScrollPosition:Float;//0;
	
	/**
	 * The number of pixels the scroller has been scrolled vertically (on
	 * the y-axis).
	 */
	public var verticalScrollPosition(default, default):Float;
	
	
	/**
	 * @private
	 */
	private var _maxVerticalScrollPosition:Float;//0;
	
	/**
	 * The maximum number of pixels the scroller may be scrolled vertically
	 * (on the y-axis). This value is automatically calculated based on the
	 * height of the viewport. The <code>verticalScrollPosition</code>
	 * property may have a higher value than the maximum due to elastic
	 * edges. However, once the user stops interacting with the scroller,
	 * it will automatically animate back to the maximum (or minimum, if
	 * below 0).
	 */
	public var maxVerticalScrollPosition(default, null):Float;

	/**
	 * @private
	 */
	private var _verticalPageIndex:Int;//0;

	/**
	 * The index of the vertical page, if snapping is enabled. If snapping
	 * is disabled, the index will always be <code>0</code>.
	 */
	public var verticalPageIndex(default, null):Int;
	
	/**
	 * @private
	 */
	private var _verticalScrollPolicy:String;// = SCROLL_POLICY_AUTO;

	@:meta(Inspectable(type="String",enumeration="auto,on,off"))
	/**
	 * Determines whether the scroller may scroll vertically (on the
	 * y-axis) or not.
	 *
	 * @see #SCROLL_POLICY_AUTO
	 * @see #SCROLL_POLICY_ON
	 * @see #SCROLL_POLICY_OFF
	 */
	public var verticalScrollPolicy(default, default):String;
	
	
	/**
	 * @private
	 */
	private var _verticalAlign:String;// = VERTICAL_ALIGN_TOP;

	@:meta(Inspectable(type="String",enumeration="top,middle,bottom"))
	/**
	 * If the viewport's height is less than the scroller's height, it will
	 * be aligned to the top, middle, or bottom of the scroller.
	 *
	 * @see #VERTICAL_ALIGN_TOP
	 * @see #VERTICAL_ALIGN_MIDDLE
	 * @see #VERTICAL_ALIGN_BOTTOM
	 */
	public var verticalAlign(default, default):String;
	
	
	/**
	 * @private
	 */
	private var _clipContent:Bool;//true;
	
	/**
	 * If true, the viewport will be clipped to the scroller's bounds. In
	 * other words, anything appearing outside the scroller's bounds will
	 * not be visible.
	 *
	 * <p>To improve performance, turn off clipping and place other display
	 * objects over the edges of the scroller to hide the content that
	 * bleeds outside of the scroller's bounds.</p>
	 */
	public var clipContent(default, default):Bool;
	
	
	/**
	 * @private
	 */
	private var _hasElasticEdges:Bool;//true;
	
	/**
	 * Determines if the scrolling can go beyond the edges of the viewport.
	 */
	public var hasElasticEdges(default, default):Bool;
	
	/**
	 * @private
	 */
	private var _elasticity:Float;//0.33;

	/**
	 * If the scroll position goes outside the minimum or maximum bounds,
	 * the scrolling will be constrained using this multiplier.
	 */
	public var elasticity(default, default):Float;
	
	

	/**
	 * @private
	 */
	private var _scrollBarDisplayMode:String;// = SCROLL_BAR_DISPLAY_MODE_FLOAT;

	@:meta(Inspectable(type="String",enumeration="float,fixed,none"))
	/**
	 * Determines how the scroll bars are displayed.
	 *
	 * @see #SCROLL_BAR_DISPLAY_MODE_FLOAT
	 * @see #SCROLL_BAR_DISPLAY_MODE_FIXED
	 * @see #SCROLL_BAR_DISPLAY_MODE_NONE
	 */
	public var scrollBarDisplayMode(default, default):String;

	/**
	 * @private
	 */
	private var _interactionMode:String;// = INTERACTION_MODE_TOUCH;

	@:meta(Inspectable(type="String",enumeration="touch,mouse"))
	/**
	 * Determines how the user may interact with the scroller.
	 *
	 * @see #INTERACTION_MODE_TOUCH
	 * @see #INTERACTION_MODE_MOUSE
	 */
	public var interactionMode(default, default):String;


	/**
	 * @private
	 */
	private var _horizontalScrollBarHideTween:Tween;

	/**
	 * @private
	 */
	private var _verticalScrollBarHideTween:Tween;

	/**
	 * @private
	 */
	private var _hideScrollBarAnimationDuration:Float;//0.2;

	/**
	 * The duration, in seconds, of the animation when a scroll bar fades
	 * out.
	 */
	public var hideScrollBarAnimationDuration(default, default):Float;


	/**
	 * @private
	 */
	private var _hideScrollBarAnimationEase:Dynamic;// = Transitions.EASE_OUT;

	/**
	 * The easing function used for hiding the scroll bars, if applicable.
	 */
	public var hideScrollBarAnimationEase(default, default):Dynamic;

	/**
	 * @private
	 */
	private var _elasticSnapDuration:Float;//0.24;

	/**
	 * The duration, in seconds, of the animation when a the scroller snaps
	 * back to the minimum or maximum position after going out of bounds.
	 */
	public var elasticSnapDuration(default, default):Float;

	/**
	 * @private
	 */
	private var _pageThrowDuration:Float;//0.5;

	/**
	 * The duration, in seconds, of the animation when a the scroller is
	 * thrown to a page.
	 */
	public var pageThrowDuration(default, default):Float;

	/**
	 * @private
	 */
	private var _throwEase:Dynamic;// = Transitions.EASE_OUT;

	/**
	 * The easing function used for "throw" animations.
	 */
	public var throwEase(default, default):Dynamic;

	
	/**
	 * @private
	 */
	private var _snapScrollPositionsToPixels:Bool;//false;

	/**
	 * If enabled, the scroll position will always be adjusted to whole
	 * pixels.
	 */
	public var snapScrollPositionsToPixels(default, default):Bool;


	/**
	 * @private
	 */
	private var _isScrollingStopped:Bool;//false;
	
	/**
	 * If the user is scrolling with touch or if the scrolling is animated,
	 * calling stopScrolling() will cause the scroller to ignore the drag
	 * and stop animations.
	 */
	public function stopScrolling():Void;
	
	/**
	 * Throws the scroller to the specified position. If you want to throw
	 * in one direction, pass in NaN or the current scroll position for the
	 * value that you do not want to change.
	 */
	public function throwTo(targetHorizontalScrollPosition:Float = 0, targetVerticalScrollPosition:Float = 0, duration:Float = 0.5):Void;

	/**
	 * Throws the scroller to the specified page index. If you want to throw
	 * in one direction, pass in -1 or the current page index for the
	 * value that you do not want to change.
	 */
	public function throwToPage(targetHorizontalPageIndex:Float = -1, targetVerticalPageIndex:Float = -1, duration:Float = 0.5):Void;


	/**
	 * @private
	 */
	private function autoSizeIfNeeded():Bool;
	/**
	 * @private
	 */
	private function createScrollBars():Void;

	/**
	 * @private
	 */
	private function refreshScrollBarStyles():Void;

	/**
	 * @private
	 */
	private function refreshEnabled():Void;

	/**
	 * @private
	 */
	private function refreshViewPortBoundsWithoutFixedScrollBars():Void;
	/**
	 * @private
	 */
	private function refreshViewPortBoundsWithFixedScrollBars():Void;

	/**
	 * @private
	 */
	private function refreshScrollValues(isScrollInvalid:Bool):Void;

	/**
	 * @private
	 */
	private function refreshScrollBarValues():Void;

	/**
	 * @private
	 */
	private function refreshInteractionModeEvents():Void;
	
	/**
	 * @private
	 */
	private function layout():Void;
	
	/**
	 * @private
	 */
	private function scrollContent():Void;
	
	/**
	 * @private
	 */
	private function updateHorizontalScrollFromTouchPosition(touchX:Float):Void;
	
	/**
	 * @private
	 */
	private function updateVerticalScrollFromTouchPosition(touchY:Float):Void;
	
	/**
	 * @private
	 */
	private function finishScrollingHorizontally():Void;
	
	/**
	 * @private
	 */
	private function finishScrollingVertically():Void;
	
	/**
	 * @private
	 */
	private function throwHorizontally(pixelsPerMS:Float):Void;
	
	/**
	 * @private
	 */
	private function throwVertically(pixelsPerMS:Float):Void;
	
	/**
	 * @private
	 */
	private function hideHorizontalScrollBar(delay:Float = 0):Void;
	
	/**
	 * @private
	 */
	private function hideVerticalScrollBar(delay:Float = 0):Void;
	
	/**
	 * @private
	 */
	private function viewPort_resizeHandler(event:Event):Void;
	
	/**
	 * @private
	 */
	private function childProperties_onChange(proxy:PropertyProxy, name:String):Void;
	
	/**
	 * @private
	 */
	private function verticalScrollBar_changeHandler(event:Event):Void;

	/**
	 * @private
	 */
	private function horizontalScrollBar_changeHandler(event:Event):Void;
	
	/**
	 * @private
	 */
	private function horizontalAutoScrollTween_onComplete():Void;
	
	/**
	 * @private
	 */
	private function verticalAutoScrollTween_onComplete():Void;
	/**
	 * @private
	 */
	private function horizontalScrollBarHideTween_onComplete():Void;
	/**
	 * @private
	 */
	private function verticalScrollBarHideTween_onComplete():Void;
	/**
	 * @private
	 */
	private function touchHandler(event:TouchEvent):Void;

	/**
	 * @private
	 */
	private function enterFrameHandler(event:Event):Void;
	
	/**
	 * @private
	 */
	private function stage_touchHandler(event:TouchEvent):Void;
	
	/**
	 * @private
	 */
	private function nativeStage_mouseWheelHandler(event:MouseEvent):Void;
	
	/**
	 * @private
	 */
	private function nativeStage_orientationChangeHandler(event:flash.events.Event):Void;

	/**
	 * @private
	 */
	private function horizontalScrollBar_touchHandler(event:TouchEvent):Void;
	
	/**
	 * @private
	 */
	private function verticalScrollBar_touchHandler(event:TouchEvent):Void;
		
	/**
	 * @private
	 */
	private function addedToStageHandler(event:Event):Void;
	/**
	 * @private
	 */
	private function removedFromStageHandler(event:Event):Void;
}