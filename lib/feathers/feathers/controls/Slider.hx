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
import feathers.core.PropertyProxy;
import feathers.events.FeathersEventType;
//import feathers.utils.math.clamp;
//import feathers.utils.math.roundToNearest;

import flash.events.TimerEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Timer;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * Dispatched when the slider's value changes.
 *
 * @eventType starling.events.Event.CHANGE
 */
@:meta(Event(name="change",type="starling.events.Event"))

/**
 * Dispatched when the user starts dragging the slider's thumb or track.
 *
 * @eventType feathers.events.FeathersEventType.BEGIN_INTERACTION
 */
@:meta(Event(name="beginInteraction",type="starling.events.Event"))

/**
 * Dispatched when the user stops dragging the slider's thumb or track.
 *
 * @eventType feathers.events.FeathersEventType.END_INTERACTION
 */
@:meta(Event(name="endInteraction",type="starling.events.Event"))

/**
 * Select a value between a minimum and a maximum by dragging a thumb over
 * the bounds of a track. The slider's track is divided into two parts split
 * by the thumb.
 *
 * @see http://wiki.starling-framework.org/feathers/slider
 */
extern class Slider extends FeathersControl, implements IScrollBar
{
	/**
	 * The slider's thumb may be dragged horizontally (on the x-axis).
	 */
	public static var DIRECTION_HORIZONTAL:String;//"horizontal";
	
	/**
	 * The slider's thumb may be dragged vertically (on the y-axis).
	 */
	public static var DIRECTION_VERTICAL:String;//"vertical";

	/**
	 * The slider has only one track, that fills the full length of the
	 * slider. In this layout mode, the "minimum" track is displayed and
	 * fills the entire length of the slider. The maximum track will not
	 * exist.
	 */
	public static var TRACK_LAYOUT_MODE_SINGLE:String;//"single";

	/* The slider has two tracks, stretching to fill each side of the slider
	 * with the thumb in the middle. The tracks will be resized as the thumb
	 * moves. This layout mode is designed for sliders where the two sides
	 * of the track may be colored differently to show the value
	 * "filling up" as the slider is dragged.
	 *
	 * <p>Since the width and height of the tracks will change, consider
	 * sing a special display object such as a <code>Scale9Image</code>,
	 * <code>Scale3Image</code> or a <code>TiledImage</code> that is
	 * designed to be resized dynamically.</p>
	 *
	 * @see feathers.display.Scale9Image
	 * @see feathers.display.Scale3Image
	 * @see feathers.display.TiledImage
	 */
	public static var TRACK_LAYOUT_MODE_MIN_MAX:String;// = "minMax";

	/**
	 * The slider's minimum and maximum tracks will be resized and cropped
	 * using a scrollRect to ensure that the skins maintain a static
	 * appearance without altering the aspect ratio.
	 */
	public static var TRACK_LAYOUT_MODE_SCROLL:String;//"scroll";

	/**
	 * The default value added to the <code>nameList</code> of the minimum
	 * track.
	 */
	public static var DEFAULT_CHILD_NAME_MINIMUM_TRACK:String;//"feathers-slider-minimum-track";

	/**
	 * The default value added to the <code>nameList</code> of the maximum
	 * track.
	 */
	public static var DEFAULT_CHILD_NAME_MAXIMUM_TRACK:String;//"feathers-slider-maximum-track";

	/**
	 * The default value added to the <code>nameList</code> of the thumb.
	 */
	public static var DEFAULT_CHILD_NAME_THUMB:String;//"feathers-slider-thumb";
	
	/**
	 * Constructor.
	 */
	public function new():Void;

	
	
	@:meta(Inspectable(type="String",enumeration="horizontal,vertical"))
	/**
	 * Determines if the slider's thumb can be dragged horizontally or
	 * vertically. When this value changes, the slider's width and height
	 * values do not change automatically.
	 *
	 * @default DIRECTION_HORIZONTAL
	 * @see #DIRECTION_HORIZONTAL
	 * @see #DIRECTION_VERTICAL
	 */
	public var direction(default, default):String;
	
	public var value(default, default):Float;
	public var minimum(default, default):Float;
	public var maximum(default, default):Float;
	public var step(default, default):Float;
	
	/**
	 * If the slider's track is touched, and the thumb is shown, the slider
	 * value will be incremented or decremented by the page value. If the
	 * thumb is hidden, this value is ignored, and the track may be dragged
	 * instead.
	 *
	 * <p>If this value is <code>NaN</code>, the <code>step</code> value
	 * will be used instead. If the <code>step</code> value is zero, paging
	 * with the track is not possible.</p>
	 */
	public var page(default, default):Float;
	
	/**
	 * Determines if the slider dispatches the onChange signal every time
	 * the thumb moves, or only once it stops moving.
	 */
	public var liveDragging:Bool;//true;
	
	/**
	 * Determines if the thumb should be displayed.
	 */
	public var showThumb(default, default):Bool;
	
	
	/**
	 * The space, in pixels, between the minimum position of the thumb and
	 * the minimum edge of the track. May be negative to extend the range of
	 * the thumb.
	 */
	public var minimumPadding(default, default):Float;
	
	/**
	 * The space, in pixels, between the maximum position of the thumb and
	 * the maximum edge of the track. May be negative to extend the range
	 * of the thumb.
	 */
	public var maximumPadding(default, default):Float;
	
	//@:meta(Inspectable(type="String",enumeration="single,stretch,scroll"))
	/**
	 * Determines how the minimum and maximum track skins are positioned and
	 * sized.
	 *
	 * @default TRACK_LAYOUT_MODE_SINGLE
	 *
	 * @see #TRACK_LAYOUT_MODE_SINGLE
	 * @see #TRACK_LAYOUT_MODE_MIN_MAX
	 */
	public var trackLayoutMode(default, default):String;

	/**
	 * The time, in seconds, before actions are repeated. The first repeat
	 * happens after a delay that is five times longer than the following
	 * repeats.
	 */
	public var repeatDelay(default, default):Float;
	

	/**
	 * A set of key/value pairs to be passed down to the slider's minimum
	 * track sub-component. The minimum track is a
	 * <code>feathers.controls.Button</code> instance.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 * 
	 * @see feathers.controls.Button
	 */
	public var minimumTrackProperties(default, default):Dynamic;
	
	
	/**
	 * A set of key/value pairs to be passed down to the slider's maximum
	 * track sub-component. The maximum track is a
	 * <code>feathers.controls.Button</code> instance.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 * 
	 * @see feathers.controls.Button
	 */
	public var maximumTrackProperties(default, default):Dynamic;
	
	
	/**
	 * A set of key/value pairs to be passed down to the slider's thumb
	 * sub-component. The thumb is a <code>feathers.controls.Button</code>
	 * instance.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 * 
	 * @see feathers.controls.Button
	 */
	public var thumbProperties(default, default):Dynamic;
	
}