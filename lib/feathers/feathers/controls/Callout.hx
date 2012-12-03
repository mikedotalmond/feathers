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
import feathers.core.PopUpManager;
import flash.Vector;

import flash.events.KeyboardEvent;
import flash.geom.Rectangle;
import flash.ui.Keyboard;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * Dispatched when the callout is closed.
 *
 * @eventType starling.events.Event.CLOSE
 */
@:meta(Event(name="close",type="starling.events.Event"))

/**
 * A pop-up container that points at (or calls out) a specific region of
 * the application (typically a specific control that triggered it).
 *
 * @see http://wiki.starling-framework.org/feathers/callout
 */
extern class Callout extends FeathersControl
{
	/**
	 * The callout may be positioned on any side of the origin region.
	 */
	public static var DIRECTION_ANY:String;//"any";

	/**
	 * The callout must be positioned above the origin region.
	 */
	public static var DIRECTION_UP:String;//"up";

	/**
	 * The callout must be positioned below the origin region.
	 */
	public static var DIRECTION_DOWN:String;//"down";

	/**
	 * The callout must be positioned to the left side of the origin region.
	 */
	public static var DIRECTION_LEFT:String;//"left";

	/**
	 * The callout must be positioned to the right side of the origin region.
	 */
	public static var DIRECTION_RIGHT:String;//"right";

	/**
	 * The arrow will appear on the top side of the callout.
	 */
	public static var ARROW_POSITION_TOP:String;//"top";

	/**
	 * The arrow will appear on the right side of the callout.
	 */
	public static var ARROW_POSITION_RIGHT:String;//"right";

	/**
	 * The arrow will appear on the bottom side of the callout.
	 */
	public static var ARROW_POSITION_BOTTOM:String;//"bottom";

	/**
	 * The arrow will appear on the left side of the callout.
	 */
	public static var ARROW_POSITION_LEFT:String;//"left";

	/**
	 * @private
	 */
	private static var helperRect:Rectangle;//new Rectangle();

	/**
	 * @private
	 */
	private static var DIRECTION_TO_FUNCTION:Dynamic;//{};

	/**
	 * @private
	 */
	private static var callouts:Vector<Callout>;//;//new Vector<Callout>();

	/**
	 * The padding between a callout and the top edge of the stage when the
	 * callout is positioned automatically. May be ignored if the callout
	 * is too big for the stage.
	 */
	public static var stagePaddingTop:Float;//0;

	/**
	 * The padding between a callout and the right edge of the stage when the
	 * callout is positioned automatically. May be ignored if the callout
	 * is too big for the stage.
	 */
	public static var stagePaddingRight:Float;//0;

	/**
	 * The padding between a callout and the bottom edge of the stage when the
	 * callout is positioned automatically. May be ignored if the callout
	 * is too big for the stage.
	 */
	public static var stagePaddingBottom:Float;//0;

	/**
	 * The margin between a callout and the top edge of the stage when the
	 * callout is positioned automatically. May be ignored if the callout
	 * is too big for the stage.
	 */
	public static var stagePaddingLeft:Float;//0;

	/**
	 * Returns a new <code>Callout</code> instance when <code>Callout.show()</code>
	 * is called with isModal set to true. If one wishes to skin the callout
	 * manually, a custom factory may be provided.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function():Callout</pre>
	 */
	public static var calloutFactory:Void->Callout;//defaultCalloutFactory;

	/**
	 * Returns an overlay to display with a callout that is modal.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 * <pre>function():DisplayObject</pre>
	 *
	 * @see feathers.core.PopUpManager#overlayFactory
	 */
	public static var calloutOverlayFactory:Void->DisplayObject;//PopUpManager.defaultOverlayFactory;

	/**
	 * Creates a callout, and then positions and sizes it automatically
	 * based on an origin rectangle and the specified direction relative to
	 * the original. The provided width and height values are optional, and
	 * these values may be ignored if the callout cannot be drawn at the
	 * specified dimensions.
	 */
	public static function show(content:DisplayObject, origin:DisplayObject, direction:String = "any",
		isModal:Bool = true, customCalloutFactory:Void->Callout = null):Callout;
		
	/**
	 * The default factory that creates callouts when <code>Callout.show()</code>
	 * is called. To use a different factory, you need to set
	 * <code>Callout.calloutFactory</code> to a <code>Function</code>
	 * instance.
	 */
	public static function defaultCalloutFactory():Callout;

	/**
	 * @private
	 */
	private static function positionCalloutByDirection(callout:Callout, globalOrigin:Rectangle, direction:String):Void;
	
	/**
	 * @private
	 */
	private static function positionCalloutAny(callout:Callout, globalOrigin:Rectangle):Void;
	
	/**
	 * @private
	 */
	private static function positionCalloutBelow(callout:Callout, globalOrigin:Rectangle):Void;
	
	/**
	 * @private
	 */
	private static function positionCalloutAbove(callout:Callout, globalOrigin:Rectangle):Void;

	/**
	 * @private
	 */
	private static function positionCalloutRightSide(callout:Callout, globalOrigin:Rectangle):Void;

	/**
	 * @private
	 */
	private static function positionCalloutLeftSide(callout:Callout, globalOrigin:Rectangle):Void;

	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * Determines if the callout is automatically closed if a touch in the
	 * <code>TouchPhase.BEGAN</code> phase happens outside of the callout's
	 * bounds.
	 */
	public var closeOnTouchBeganOutside:Bool;//false;

	/**
	 * Determines if the callout is automatically closed if a touch in the
	 * <code>TouchPhase.ENDED</code> phase happens outside of the callout's
	 * bounds.
	 */
	public var closeOnTouchEndedOutside:Bool;//false;

	/**
	 * The callout will be closed if any of these keys are pressed.
	 */
	public var closeOnKeys:Vector<UInt>;

	/**
	 * @private
	 */
	private var _isPopUp:Bool;//false;

	/**
	 * @private
	 */
	private var _isReadyToClose:Bool;//false;

	/**
	 * @private
	 */
	private var _originalContentWidth:Float;//

	/**
	 * @private
	 */
	private var _originalContentHeight:Float;//

	/**
	 * @private
	 */
	private var _content:DisplayObject;

	/**
	 * The display object that will be presented by the callout. This object
	 * may be resized to fit the callout's bounds. If the content needs to
	 * be scrolled if placed into a smaller region than its ideal size, it
	 * must provide its own scrolling capabilities because the callout does
	 * not offer scrolling.
	 */
	public var content(default, default):DisplayObject;
	
	/**
	 * @private
	 */
	private var _paddingTop:Float;//0;

	/**
	 * The minimum space, in pixels, between the callout's top edge and the
	 * callout's content.
	 */
	public var paddingTop(default, default):Float;
	/**
	 * @private
	 */
	private var _paddingRight:Float;//0;

	/**
	 * The minimum space, in pixels, between the callout's right edge and
	 * the callout's content.
	 */
	public var paddingRight(default, default):Float;

	/**
	 * @private
	 */
	private var _paddingBottom:Float;//0;

	/**
	 * The minimum space, in pixels, between the callout's bottom edge and
	 * the callout's content.
	 */
	public var paddingBottom(default, default):Float;
	/**
	 * @private
	 */
	private var _paddingLeft:Float;//0;

	/**
	 * The minimum space, in pixels, between the callout's left edge and the
	 * callout's content.
	 */
	public var paddingLeft(default, default):Float;

	/**
	 * @private
	 */
	private var _arrowPosition:String;//;//ARROW_POSITION_TOP;
//
	@:meta(Inspectable(type="String",enumeration="top,right,bottom,left"))
	/**
	 * The position of the callout's arrow relative to the background. Do
	 * not confuse this with the direction that the callout opens when using
	 * <code>Callout.create()</code>.
	 */
	public var arrowPosition(default, default):String;
	
	/**
	 * @private
	 */
	private var _originalBackgroundWidth:Float;//;//

	/**
	 * @private
	 */
	private var _originalBackgroundHeight:Float;//;//

	/**
	 * @private
	 */
	private var _backgroundSkin:DisplayObject;

	/**
	 * The primary background to display.
	 */
	public var backgroundSkin(default, default):DisplayObject;
	/**
	 * @private
	 */
	private var currentArrowSkin:DisplayObject;

	/**
	 * @private
	 */
	private var _bottomArrowSkin:DisplayObject;

	/**
	 * The arrow skin to display on the bottom edge of the callout. This
	 * arrow is displayed when the callout is displayed above the region it
	 * points at.
	 */
	public var bottomArrowSkin(default, default):DisplayObject;
	/**
	 * @private
	 */
	private var _topArrowSkin:DisplayObject;

	/**
	 * The arrow skin to display on the top edge of the callout. This arrow
	 * is displayed when the callout is displayed below the region it points
	 * at.
	 */
	public var topArrowSkin(default, default):DisplayObject;

	/**
	 * @private
	 */
	private var _leftArrowSkin:DisplayObject;

	/**
	 * The arrow skin to display on the left edge of the callout. This arrow
	 * is displayed when the callout is displayed to the right of the region
	 * it points at.
	 */
	public var leftArrowSkin(default, default):DisplayObject;

	/**
	 * @private
	 */
	private var _rightArrowSkin:DisplayObject;

	/**
	 * The arrow skin to display on the right edge of the callout. This
	 * arrow is displayed when the callout is displayed to the left of the
	 * region it points at.
	 */
	public var rightArrowSkin(default, default):DisplayObject;

	
	/**
	 * @private
	 */
	private var _topArrowGap:Float;//0;

	/**
	 * The space, in pixels, between the top arrow skin and the background
	 * skin. To have the arrow overlap the background, you may use a
	 * negative gap value.
	 */
	public var topArrowGap(default, default):Float;

	/**
	 * @private
	 */
	private var _bottomArrowGap:Float;//0;

	/**
	 * The space, in pixels, between the bottom arrow skin and the
	 * background skin. To have the arrow overlap the background, you may
	 * use a negative gap value.
	 */
	public var bottomArrowGap(default, default):Float;

	/**
	 * @private
	 */
	private var _rightArrowGap:Float;//0;

	/**
	 * The space, in pixels, between the right arrow skin and the background
	 * skin. To have the arrow overlap the background, you may use a
	 * negative gap value.
	 */
	public var rightArrowGap(default, default):Float;


	/**
	 * @private
	 */
	private var _leftArrowGap:Float;//0;

	/**
	 * The space, in pixels, between the right arrow skin and the background
	 * skin. To have the arrow overlap the background, you may use a
	 * negative gap value.
	 */
	public var leftArrowGap(default, default):Float;


	/**
	 * @private
	 */
	private var _arrowOffset:Float;//0;

	/**
	 * The offset, in pixels, of the arrow skin from the center or middle of
	 * the background skin. On the top and bottom edges, the arrow will
	 * move left for negative values and right for positive values. On the
	 * left and right edges, the arrow will move up for negative values
	 * and down for positive values.
	 */
	public var arrowOffset(default, default):Float;
	
	
	/**
	 * Closes the callout.
	 */
	public function close(dispose:Bool = false):Void;

	/**
	 * @private
	 */
	@:protected override function initialize():Void;

	/**
	 * @private
	 */
	@:protected override function draw():Void;
	
	/**
	 * @private
	 */
	private function autoSizeIfNeeded():Bool;
	
	/**
	 * @private
	 */
	private function refreshArrowSkin():Void;
	
	/**
	 * @private
	 */
	private function layout():Void;

	/**
	 * @private
	 */
	private function addedToStageHandler(event:Event):Void;

	/**
	 * @private
	 */
	private function removedFromStageHandler(event:Event):Void;

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
	private function stage_keyDownHandler(event:KeyboardEvent):Void;
}
