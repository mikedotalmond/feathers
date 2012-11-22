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
 * Dispatched when the scroll bar's value changes.
 *
 * @eventType starling.events.Event.CHANGE
 */
@:meta(Event(name="change",type="starling.events.Event"))

/**
 * Dispatched when the user starts interacting with the scroll bar's thumb,
 * track, or buttons.
 *
 * @eventType feathers.events.FeathersEventType.BEGIN_INTERACTION
 */
@:meta(Event(name="beginInteraction",type="starling.events.Event"))

/**
 * Dispatched when the user stops interacting with the scroll bar's thumb,
 * track, or buttons.
 *
 * @eventType feathers.events.FeathersEventType.END_INTERACTION
 */
@:meta(Event(name="endInteraction",type="starling.events.Event"))

/**
 * Select a value between a minimum and a maximum by dragging a thumb over
 * a physical range or by using step buttons. This is a desktop-centric
 * scroll bar with many skinnable parts. For mobile, the
 * <code>SimpleScrollBar</code> is probably a better choice as it provides
 * only the thumb to indicate position without all the extra chrome.
 *
 * @see http://wiki.starling-framework.org/feathers/scroll-bar
 * @see SimpleScrollBar
 */
extern class ScrollBar extends FeathersControl, implements IScrollBar
{
	/**
	 * @private
	 */
	private static var HELPER_POINT:Point;//new Point();

	/**
	 * The scroll bar's thumb may be dragged horizontally (on the x-axis).
	 */
	public static var DIRECTION_HORIZONTAL:String;//"horizontal";

	/**
	 * The scroll bar's thumb may be dragged vertically (on the y-axis).
	 */
	public static var DIRECTION_VERTICAL:String;//"vertical";

	/**
	 * The scroll bar has only one track, stretching to fill the full length
	 * of the scroll bar. In this layout mode, the minimum track is
	 * displayed and fills the entire length of the scroll bar. The maximum
	 * track will not exist.
	 */
	public static var TRACK_LAYOUT_MODE_SINGLE:String;//"single";

	/**
	 * The scroll bar's minimum and maximum track will by resized by
	 * changing their width and height values. Consider using a special
	 * display object such as a Scale9Image, Scale3Image or a TiledImage if
	 * the skins should be resizable.
	 */
	public static var TRACK_LAYOUT_MODE_STRETCH:String;//"stretch";

	/**
	 * The scroll bar's minimum and maximum tracks will be resized and
	 * cropped using a scrollRect to ensure that the skins maintain a static
	 * appearance without altering the aspect ratio.
	 */
	public static var TRACK_LAYOUT_MODE_SCROLL:String;//"scroll";

	/**
	 * The default value added to the <code>nameList</code> of the minimum
	 * track.
	 */
	public static var DEFAULT_CHILD_NAME_MINIMUM_TRACK:String;//"feathers-scroll-bar-minimum-track";

	/**
	 * The default value added to the <code>nameList</code> of the maximum
	 * track.
	 */
	public static var DEFAULT_CHILD_NAME_MAXIMUM_TRACK:String;//"feathers-scroll-bar-maximum-track";

	/**
	 * The default value added to the <code>nameList</code> of the thumb.
	 */
	public static var DEFAULT_CHILD_NAME_THUMB:String;//"feathers-scroll-bar-thumb";

	/**
	 * The default value added to the <code>nameList</code> of the decrement
	 * button.
	 */
	public static var DEFAULT_CHILD_NAME_DECREMENT_BUTTON:String;//"feathers-scroll-bar-decrement-button";

	/**
	 * The default value added to the <code>nameList</code> of the increment
	 * button.
	 */
	public static var DEFAULT_CHILD_NAME_INCREMENT_BUTTON:String;//"feathers-scroll-bar-increment-button";

	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * The value added to the <code>nameList</code> of the minimum track.
	 */
	private var minimumTrackName:String;//DEFAULT_CHILD_NAME_MINIMUM_TRACK;

	/**
	 * The value added to the <code>nameList</code> of the maximum track.
	 */
	private var maximumTrackName:String;//DEFAULT_CHILD_NAME_MAXIMUM_TRACK;

	/**
	 * The value added to the <code>nameList</code> of the thumb.
	 */
	private var thumbName:String;//DEFAULT_CHILD_NAME_THUMB;

	/**
	 * The value added to the <code>nameList</code> of the decrement button.
	 */
	private var decrementButtonName:String;//DEFAULT_CHILD_NAME_DECREMENT_BUTTON;

	/**
	 * The value added to the <code>nameList</code> of the increment button.
	 */
	private var incrementButtonName:String;//DEFAULT_CHILD_NAME_INCREMENT_BUTTON;

	/**
	 * @private
	 */
	private var thumbOriginalWidth:Float;//

	/**
	 * @private
	 */
	private var thumbOriginalHeight:Float;//

	/**
	 * @private
	 */
	private var minimumTrackOriginalWidth:Float;//

	/**
	 * @private
	 */
	private var minimumTrackOriginalHeight:Float;//

	/**
	 * @private
	 */
	private var maximumTrackOriginalWidth:Float;//

	/**
	 * @private
	 */
	private var maximumTrackOriginalHeight:Float;//

	/**
	 * The scroll bar's decrement button sub-component.
	 */
	private var decrementButton:Button;

	/**
	 * The scroll bar's increment button sub-component.
	 */
	private var incrementButton:Button;

	/**
	 * The scroll bar's thumb sub-component.
	 */
	private var thumb:Button;

	/**
	 * The scroll bar's minimum track sub-component.
	 */
	private var minimumTrack:Button;

	/**
	 * The scroll bar's maximum track sub-component.
	 */
	private var maximumTrack:Button;

	/**
	 * @private
	 */
	private var _direction:String;//DIRECTION_HORIZONTAL;

	@:meta(Inspectable(type="String",enumeration="horizontal,vertical"))
	/**
	 * Determines if the scroll bar's thumb can be dragged horizontally or
	 * vertically. When this value changes, the scroll bar's width and
	 * height values do not change automatically.
	 */
	public var direction(default,default):String;

	/**
	 * @private
	 */
	private var _value:Float;//0;

	/**
	 * @inheritDoc
	 */
	public var value(default,default):Float;

	/**
	 * @private
	 */
	private var _minimum:Float;//0;

	/**
	 * @inheritDoc
	 */
	public var minimum(default,default):Float;

	/**
	 * @private
	 */
	private var _maximum:Float;//0;

	/**
	 * @inheritDoc
	 */
	public var maximum(default,default):Float;

	/**
	 * @private
	 */
	private var _step:Float;//0;

	/**
	 * @inheritDoc
	 */
	public var step(default,default):Float;

	/**
	 * @private
	 */
	private var _page:Float;//0;

	/**
	 * @inheritDoc
	 */
	public var page(default, default):Float;
	
	
	/**
	 * @private
	 */
	private var _paddingTop:Float;//0;

	/**
	 * The minimum space, in pixels, above the content, not
	 * including the track(s).
	 */
	public var paddingTop(default,default):Float;
	
	/**
	 * @private
	 */
	private var _paddingRight:Float;//0;

	/**
	 * The minimum space, in pixels, to the right of the content, not
	 * including the track(s).
	 */
	public var paddingRight(default,default):Float;
	
	/**
	 * @private
	 */
	private var _paddingBottom:Float;//0;

	/**
	 * The minimum space, in pixels, below the content, not
	 * including the track(s).
	 */
	public var paddingBottom(default,default):Float;

	/**
	 * @private
	 */
	private var _paddingLeft:Float;//0;

	/**
	 * The minimum space, in pixels, to the left of the content, not
	 * including the track(s).
	 */
	public var paddingLeft(default,default):Float;

	/**
	 * @private
	 */
	private var currentRepeatAction:Function;

	/**
	 * @private
	 */
	private var _repeatTimer:Timer;

	/**
	 * @private
	 */
	private var _repeatDelay:Float;//0.05;

	/**
	 * The time, in seconds, before actions are repeated. The first repeat
	 * happens after a delay that is five times longer than the following
	 * repeats.
	 */
	public var repeatDelay(default,default):Float;

	/**
	 * @private
	 */
	private var isDragging:Bool;//false;

	/**
	 * Determines if the scroll bar dispatches the <code>onChange</code>
	 * signal every time the thumb moves, or only once it stops moving.
	 */
	public var liveDragging:Bool;//true;

	/**
	 * @private
	 */
	private var _trackLayoutMode:String;//TRACK_LAYOUT_MODE_SINGLE;

	@:meta(Inspectable(type="String",enumeration="single,stretch,scroll"))
	/**
	 * Determines how the minimum and maximum track skins are positioned and
	 * sized.
	 */
	public var trackLayoutMode(default,default):String;

	/**
	 * @private
	 */
	private var _minimumTrackProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to the scroll bar's
	 * minimum track sub-component. The minimum track is a
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
	public var minimumTrackProperties(default,default):Dynamic;
	
	/**
	 * @private
	 */
	private var _maximumTrackProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to the scroll bar's
	 * maximum track sub-component. The maximum track is a
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
	public var maximumTrackProperties(default,default):Dynamic;
	
	/**
	 * @private
	 */
	private var _thumbProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to the scroll bar's thumb
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
	public var thumbProperties(default,default):Dynamic;


	/**
	 * @private
	 */
	private var _decrementButtonProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to the scroll bar's
	 * decrement button sub-component. The decrement button is a
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
	public var decrementButtonProperties(default, default):Dynamic;
	
	/**
	 * @private
	 */
	private var _incrementButtonProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to the scroll bar's
	 * increment button sub-component. The increment button is a
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
	public var incrementButtonProperties(default,default):Dynamic;
	
	/**
	 * @private
	 */
	private var _touchPointID:Int;// = -1;

	/**
	 * @private
	 */
	private var _touchStartX:Float;//

	/**
	 * @private
	 */
	private var _touchStartY:Float;//

	/**
	 * @private
	 */
	private var _thumbStartX:Float;//

	/**
	 * @private
	 */
	private var _thumbStartY:Float;//

	/**
	 * @private
	 */
	private var _touchValue:Float;

	
	/**
	 * @private
	 */
	private function autoSizeIfNeeded():Bool;

	/**
	 * @private
	 */
	private function refreshThumbStyles():Void;

	/**
	 * @private
	 */
	private function refreshMinimumTrackStyles():Void;

	/**
	 * @private
	 */
	private function refreshMaximumTrackStyles():Void;

	/**
	 * @private
	 */
	private function refreshDecrementButtonStyles():Void;

	/**
	 * @private
	 */
	private function refreshIncrementButtonStyles():Void;
	
	/**
	 * @private
	 */
	private function createOrDestroyMaximumTrackIfNeeded():Void;
	
	/**
	 * @private
	 */
	private function layout():Void;

	/**
	 * @private
	 */
	private function layoutStepButtons():Void;
	
	/**
	 * @private
	 */
	private function layoutThumb():Void;
	
	/**
	 * @private
	 */
	private function layoutTrackWithScrollRect():Void;
	
	/**
	 * @private
	 */
	private function layoutTrackWithStretch():Void;
	
	/**
	 * @private
	 */
	private function layoutTrackWithSingle():Void;
	
	/**
	 * @private
	 */
	private function locationToValue(location:Point):Float;
	
	/**
	 * @private
	 */
	private function decrement():Void;

	/**
	 * @private
	 */
	private function increment():Void;

	/**
	 * @private
	 */
	private function adjustPage():Void;
	/**
	 * @private
	 */
	private function startRepeatTimer(action:Function):Void;

	/**
	 * @private
	 */
	private function thumbProperties_onChange(proxy:PropertyProxy, name:Dynamic):Void;

	/**
	 * @private
	 */
	private function minimumTrackProperties_onChange(proxy:PropertyProxy, name:Dynamic):Void;

	/**
	 * @private
	 */
	private function maximumTrackProperties_onChange(proxy:PropertyProxy, name:Dynamic):Void;

	/**
	 * @private
	 */
	private function decrementButtonProperties_onChange(proxy:PropertyProxy, name:Dynamic):Void;

	/**
	 * @private
	 */
	private function incrementButtonProperties_onChange(proxy:PropertyProxy, name:Dynamic):Void;

	/**
	 * @private
	 */
	private function removedFromStageHandler(event:Event):Void;

	/**
	 * @private
	 */
	private function track_touchHandler(event:TouchEvent):Void;
	/**
	 * @private
	 */
	private function thumb_touchHandler(event:TouchEvent):Void;

	/**
	 * @private
	 */
	private function decrementButton_touchHandler(event:TouchEvent):Void;
	
	/**
	 * @private
	 */
	private function decrementButton_triggeredHandler(event:Event):Void;

	/**
	 * @private
	 */
	private function incrementButton_touchHandler(event:TouchEvent):Void;

	/**
	 * @private
	 */
	private function incrementButton_triggeredHandler(event:Event):Void;

	/**
	 * @private
	 */
	private function repeatTimer_timerHandler(event:TimerEvent):Void;
}
