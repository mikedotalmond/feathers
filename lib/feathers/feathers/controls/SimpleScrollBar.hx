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
import flash.utils.Timer;

import starling.display.Quad;
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
 * Dispatched when the user starts dragging the scroll bar's thumb.
 *
 * @eventType feathers.events.FeathersEventType.BEGIN_INTERACTION
 */
@:meta(Event(name="beginInteraction",type="starling.events.Event"))

/**
 * Dispatched when the user stops dragging the scroll bar's thumb.
 *
 * @eventType feathers.events.FeathersEventType.END_INTERACTION
 */
@:meta(Event(name="endInteraction",type="starling.events.Event"))

/**
 * Select a value between a minimum and a maximum by dragging a thumb over
 * a physical range. This type of scroll bar does not have a visible track,
 * and it does not have increment and decrement buttons. It is ideal for
 * mobile applications where the scroll bar is often simply a visual element
 * to indicate the scroll position. For a more feature-rich scroll bar,
 * see the <code>ScrollBar</code> component.
 *
 * @see http://wiki.starling-framework.org/feathers/simple-scroll-bar
 * @see ScrollBar
 */
extern class SimpleScrollBar extends FeathersControl, implements IScrollBar {
	
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
	 * The default value added to the <code>nameList</code> of the thumb.
	 */
	public static var DEFAULT_CHILD_NAME_THUMB:String;//"feathers-simple-scroll-bar-thumb";

	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * The value added to the <code>nameList</code> of the thumb.
	 */
	private var thumbName:String;// = DEFAULT_CHILD_NAME_THUMB;

	/**
	 * @private
	 */
	private var thumbOriginalWidth:Float;//;//

	/**
	 * @private
	 */
	private var thumbOriginalHeight:Float;//;//

	/**
	 * The thumb sub-component.
	 */
	private var thumb:Button;

	/**
	 * @private
	 */
	private var track:Quad;

	/**
	 * @private
	 */
	private var _direction:String;//= DIRECTION_HORIZONTAL;

	@:meta(Inspectable(type="String",enumeration="horizontal,vertical"))
	/**
	 * Determines if the scroll bar's thumb can be dragged horizontally or
	 * vertically. When this value changes, the scroll bar's width and
	 * height values do not change automatically.
	 */
	public var direction(default, default):String;

	/**
	 * Determines if the value should be clamped to the range between the
	 * minimum and maximum. If false and the value is outside of the range,
	 * the thumb will shrink as if the range were increasing.
	 */
	public var clampToRange:Bool;//false;

	/**
	 * @private
	 */
	private var _value:Float;//0;

	/**
	 * @inheritDoc
	 */
	public var value(default, default):Float;

	/**
	 * @private
	 */
	private var _minimum:Float;//0;

	/**
	 * @inheritDoc
	 */
	public var minimum(default, default):Float;

	/**
	 * @private
	 */
	private var _maximum:Float;//0;

	/**
	 * @inheritDoc
	 */
	public var maximum(default, default):Float;

	/**
	 * @private
	 */
	private var _step:Float;//0;

	/**
	 * @inheritDoc
	 */
	public var step(default, default):Float;

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
	 * The minimum space, in pixels, above the thumb.
	 */
	public var paddingTop(default, default):Float;

	/**
	 * @private
	 */
	private var _paddingRight:Float;//0;

	/**
	 * The minimum space, in pixels, to the right of the thumb.
	 */
	public var paddingRight(default, default):Float;

	/**
	 * @private
	 */
	private var _paddingBottom:Float;//0;

	/**
	 * The minimum space, in pixels, below the thumb.
	 */
	public var paddingBottom(default, default):Float;


	/**
	 * @private
	 */
	private var _paddingLeft:Float;//0;

	/**
	 * The minimum space, in pixels, to the left of the thumb.
	 */
	public var paddingLeft(default, default):Float;
	
	/**
	 * @private
	 */
	private var currentRepeatAction:Dynamic;

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
	public var repeatDelay(default, default):Float;


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
	public var thumbProperties(default, default):Dynamic;
	

	/**
	 * @private
	 */
	private var _touchPointID:Int;//-1;

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
	private function layout():Void;
	
	/**
	 * @private
	 */
	private function locationToValue(location:Point):Float;
	
	/**
	 * @private
	 */
	private function adjustPage():Void;
	
	/**
	 * @private
	 */
	private function startRepeatTimer(action:Dynamic):Void;
	
	/**
	 * @private
	 */
	private function thumbProperties_onChange(proxy:PropertyProxy, name:Dynamic):Void;

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
	private function repeatTimer_timerHandler(event:TimerEvent):Void;
}
