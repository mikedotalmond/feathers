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
import feathers.controls.supportClasses.LayoutViewPort;
import feathers.core.FeathersControl;
import feathers.core.IFeathersControl;
import feathers.core.PropertyProxy;
import feathers.events.FeathersEventType;
import feathers.layout.ILayout;
import feathers.layout.IVirtualLayout;

import starling.display.DisplayObject;
import starling.events.Event;

/**
 * Dispatched when the container is scrolled.
 *
 * @eventType starling.events.Event.SCROLL
 */
@:meta(Event(name="change",type="starling.events.Event"))

/**
 * Dispatched when the container is scrolled.
 *
 * @eventType starling.events.Event.SCROLL
 */
@:meta(Event(name="scroll",type="starling.events.Event"))

/**
 * Dispatched when the container finishes scrolling in either direction after
 * being thrown.
 *
 * @eventType feathers.events.FeathersEventType.SCROLL_COMPLETE
 */
@:meta(Event(name="scrollComplete",type="starling.events.Event"))

@:meta(DefaultProperty("mxmlContent")]
/**
 * A generic container that supports layout and scrolling.
 *
 * @see http://wiki.starling-framework.org/feathers/scroll-container
 */
extern class ScrollContainer extends FeathersControl
{
	/**
	 * The default value added to the <code>nameList</code> of the scroller.
	 */
	public static var DEFAULT_CHILD_NAME_SCROLLER:String;//"feathers-scroll-container-scroller";

	/**
	 * @private
	 */
	private static var INVALIDATION_FLAG_MXML_CONTENT:String;//"mxmlContent";

	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * The value added to the <code>nameList</code> of the scroller.
	 */
	private var scrollerName:String;// = DEFAULT_CHILD_NAME_SCROLLER;

	/**
	 * @private
	 */
	private var scroller:Scroller;

	/**
	 * @private
	 */
	private var viewPort:LayoutViewPort;

	/**
	 * @private
	 */
	private var _scrollToHorizontalPageIndex:Int;//-1;

	/**
	 * @private
	 */
	private var _scrollToVerticalPageIndex:Int;//-1;

	/**
	 * @private
	 */
	private var _scrollToIndexDuration:Float;

	/**
	 * @private
	 */
	private var _layout:ILayout;

	/**
	 * Controls the way that the container's children are positioned and
	 * sized.
	 */
	public var layout(default, default):ILayout;

	/**
	 * @private
	 */
	private var _horizontalScrollPosition:Float;//0;

	/**
	 * The number of pixels the container has been scrolled horizontally (on
	 * the x-axis).
	 */
	public var horizontalScrollPosition(default, default):Float;

	/**
	 * @private
	 */
	private var _maxHorizontalScrollPosition:Float;//0;

	/**
	 * The maximum number of pixels the container may be scrolled horizontally
	 * (on the x-axis). This value is automatically calculated by the
	 * supplied layout algorithm. The <code>horizontalScrollPosition</code>
	 * property may have a higher value than the maximum due to elastic
	 * edges. However, once the user stops interacting with the container,
	 * it will automatically animate back to the maximum (or minimum, if
	 * the scroll position is below 0).
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
	private var _verticalScrollPosition:Float;//0;

	/**
	 * The number of pixels the container has been scrolled vertically (on
	 * the y-axis).
	 */
	public var verticalScrollPosition(default, default):Float;
	
	/**
	 * @private
	 */
	private var _maxVerticalScrollPosition:Float;//0;

	/**
	 * The maximum number of pixels the container may be scrolled vertically
	 * (on the y-axis). This value is automatically calculated by the
	 * supplied layout algorithm. The <code>verticalScrollPosition</code>
	 * property may have a higher value than the maximum due to elastic
	 * edges. However, once the user stops interacting with the container,
	 * it will automatically animate back to the maximum (or minimum, if
	 * the scroll position is below 0).
	 */
	public var maxVerticalScrollPosition(default, null):Float;

	/**
	 * @private
	 */
	private var _verticalPageIndex:Int;//0;

	/**
	 * The index of the vertical page, if snapping is enabled. If snapping
	 * is disabled, the index will always be <code>0</code>.
	 *
	 * @default 0
	 */
	public var verticalPageIndex(default, null):Int;

	/**
	 * @private
	 */
	private var _mxmlContentIsReady:Bool;//false;

	/**
	 * @private
	 */
	private var _mxmlContent:Array;

	//[ArrayElementType("feathers.core.IFeathersControl")]
	/**
	 * @private
	 */
	public var mxmlContent(default, default):Array;

	/**
	 * @private
	 */
	private var currentBackgroundSkin:DisplayObject;

	/**
	 * @private
	 */
	private var _backgroundSkin:DisplayObject;

	/**
	 * A display object displayed behind the item renderers.
	 */
	public var backgroundSkin(default, default):DisplayObject;

	/**
	 * @private
	 */
	private var _backgroundDisabledSkin:DisplayObject;

	/**
	 * A background to display when the list is disabled.
	 */
	public var backgroundDisabledSkin(default, default):DisplayObject;

	/**
	 * @private
	 */
	private var _scrollerProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to the container's
	 * scroller sub-component. The scroller is a
	 * <code>feathers.controls.Scroller</code> instance.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 * 
	 * @see feathers.controls.Scroller
	 */
	public var scrollerProperties(default, default):Dynamic;

	
	/**
	 * If the user is dragging the scroll, calling stopScrolling() will
	 * cause the container to ignore the drag. The children of the container
	 * will still receive touches, so it's useful to call this if the
	 * children need to support touches or dragging without the container
	 * also scrolling.
	 */
	public function stopScrolling():Void;

	/**
	 * Scrolls the container to a specific page, horizontally and vertically.
	 * If <code>horizontalPageIndex</code> or <code>verticalPageIndex</code>
	 * is <code>-1</code>, it will be ignored
	 */
	public function scrollToPageIndex(horizontalPageIndex:Int, verticalPageIndex:Int, animationDuration:Float = 0):Void;

	/**
	 * @private
	 */
	private function autoSizeIfNeeded():Bool;
	
	/**
	 * @private
	 */
	private function refreshBackgroundSkin():Void;
	
	/**
	 * @private
	 */
	private function refreshScrollerStyles():Void;
	
	/**
	 * @private
	 */
	private function refreshMXMLContent():Void;

	/**
	 * @private
	 */
	private function scroll():Void;

	/**
	 * @private
	 */
	private function childProperties_onChange(proxy:PropertyProxy, name:String):Void;

	/**
	 * @private
	 */
	private function scroller_scrollCompleteHandler(event:Event):Void;

	/**
	 * @private
	 */
	private function scroller_scrollHandler(event:Event):Void;
}
