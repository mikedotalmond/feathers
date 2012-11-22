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
import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.controls.renderers.IListItemRenderer;
import feathers.controls.supportClasses.ListDataViewPort;
import feathers.core.FeathersControl;
import feathers.core.PropertyProxy;
import feathers.data.ListCollection;
import feathers.events.CollectionEventType;
import feathers.events.FeathersEventType;
import feathers.layout.ILayout;
import feathers.layout.VerticalLayout;

import flash.geom.Point;

import starling.display.DisplayObject;
import starling.events.Event;

/**
 * Dispatched when the selected item changes.
 *
 * @eventType starling.events.Event.CHANGE
 */
@:meta(Event(name="change",type="starling.events.Event"))

/**
 * Dispatched when the list is scrolled.
 *
 * @eventType starling.events.Event.SCROLL
 */
@:meta(Event(name="scroll",type="starling.events.Event"))

/**
 * Dispatched when the list finishes scrolling in either direction after
 * being thrown.
 *
 * @eventType feathers.events.FeathersEventType.SCROLL_COMPLETE
 */
@:meta(Event(name="scrollComplete",type="starling.events.Event"))

@:meta(DefaultProperty("dataProvider"))
/**
 * Displays a one-dimensional list of items. Supports scrolling, custom
 * item renderers, and custom layouts.
 *
 * <p>Layouts may be, and are highly encouraged to be, <em>virtual</em>,
 * meaning that the List is capable of creating a limited number of item
 * renderers to display a subset of the data provider instead of creating a
 * renderer for every single item. This allows for optimal performance with
 * very large data providers.</p>
 *
 * @see http://wiki.starling-framework.org/feathers/list
 * @see GroupedList
 */
extern class List extends FeathersControl
{
	
	/**
	 * The default value added to the <code>nameList</code> of the scroller.
	 */
	public static var DEFAULT_CHILD_NAME_SCROLLER:String;//"feathers-list-scroller";
	
	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * The value added to the <code>nameList</code> of the scroller.
	 */
	private var scrollerName:String;// = DEFAULT_CHILD_NAME_SCROLLER;

	/**
	 * The layout algorithm used to position and, optionally, size the
	 * list's items.
	 */
	public var layout(default, default):ILayout;
	
	/**
	 * The number of pixels the list has been scrolled horizontally (on
	 * the x-axis).
	 */
	public var horizontalScrollPosition(default, default):Float;

	/**
	 * The maximum number of pixels the list may be scrolled horizontally
	 * (on the x-axis). This value is automatically calculated using the
	 * layout algorithm. The <code>horizontalScrollPosition</code> property
	 * may have a higher value than the maximum due to elastic edges.
	 * However, once the user stops interacting with the list, it will
	 * automatically animate back to the maximum (or minimum, if below 0).
	 */
	public var maxHorizontalScrollPosition(default, null):Float;

	/**
	 * The index of the horizontal page, if snapping is enabled. If snapping
	 * is disabled, the index will always be <code>0</code>.
	 */
	public var horizontalPageIndex(default, null):Int;
	
	/**
	 * The number of pixels the list has been scrolled vertically (on
	 * the y-axis).
	 */
	public var verticalScrollPosition(default, default):Float;
	
	/**
	 * The maximum number of pixels the list may be scrolled vertically (on
	 * the y-axis). This value is automatically calculated based on the
	 * total combined height of the list's item renderers. The
	 * <code>verticalScrollPosition</code> property may have a higher value
	 * than the maximum due to elastic edges. However, once the user stops
	 * interacting with the list, it will automatically animate back to the
	 * maximum (or minimum, if below 0).
	 * 
	 * @default 0
	 */
	public var maxVerticalScrollPosition(default, null):Float;
	
	/**
	 * The index of the vertical page, if snapping is enabled. If snapping
	 * is disabled, the index will always be <code>0</code>.
	 *
	 * @default 0
	 */
	public var verticalPageIndex(default, null):Int;
	
	/**
	 * The collection of data displayed by the list.
	 */
	public var dataProvider(default, default):ListCollection;
	
	/**
	 * Determines if an item in the list may be selected.
	 * 
	 * @default true
	 */
	public var isSelectable(default, default):Bool;
	
	
	/**
	 * The index of the currently selected item. Returns -1 if no item is
	 * selected.
	 */
	public var selectedIndex(default, default):Int;
	
	/**
	 * The currently selected item. Returns null if no item is selected.
	 */
	public var selectedItem(default, default):Dynamic;
	
	/**
	 * A set of key/value pairs to be passed down to the list's scroller
	 * instance. The scroller is a <code>feathers.controls.Scroller</code>
	 * instance.
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
	 * A set of key/value pairs to be passed down to all of the list's item
	 * renderers. These values are shared by each item renderer, so values
	 * that cannot be shared (such as display objects that need to be added
	 * to the display list) should be passed to the item renderers using an
	 * <code>itemRendererFactory</code> or with a theme.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * @see #itemRendererFactory
	 * 
	 * @default <code>new PropertyProxy(childProperties_onChange)</code>
	 */
	public var itemRendererProperties(default, default):Dynamic;
	
	/**
	 * A display object displayed behind the item renderers.
	 * 
	 * @default null
	 */
	public var backgroundSkin(default, default):DisplayObject;
	
	/**
	 * A background to display when the list is disabled.
	 * 
	 * @default null
	 */
	public var backgroundDisabledSkin(default, default):DisplayObject;

	/**
	 * The minimum space, in pixels, between the list's top edge and the
	 * list's content.
	 */
	public var paddingTop(default, default):Float;

	/**
	 * The minimum space, in pixels, between the list's right edge and the
	 * list's content.
	 */
	public var paddingRight(default,default):Float;

	/**
	 * The minimum space, in pixels, between the list's bottom edge and
	 * the list's content.
	 */
	public var paddingBottom(default,default):Float;

	/**
	 * The minimum space, in pixels, between the list's left edge and the
	 * list's content.
	 */
	public var paddingLeft(default,default):Float;
	
	
	/**
	 * The class used to instantiate item renderers.
	 *
	 * @see #itemRendererFactory
	 */
	public var itemRendererType(default,default):Dynamic;//Class
	
	/**
	 * A function called that is expected to return a new item renderer. Has
	 * a higher priority than <code>itemRendererType</code>. Typically, you
	 * would use an <code>itemRendererFactory</code> instead of an
	 * <code>itemRendererType</code> if you wanted to initialize some
	 * properties on each separate item renderer, such as skins.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 *
	 * <pre>function():IListItemRenderer</pre>
	 * 
	 * @see #itemRendererType
	 */
	public var itemRendererFactory(default, default):Void->IListItemRenderer;
	
	/**
	 * Used to auto-size the list. If the list's width or height is NaN, the
	 * list will try to automatically pick an ideal size. This item is
	 * used in that process to create a sample item renderer.
	 */
	public var typicalItem(default, default):Dynamic;

	/**
	 * A name to add to all item renderers in this list. Typically used by a
	 * theme to provide different skins to different lists.
	 *
	 * @see feathers.core.FeathersControl#nameList
	 */
	public var itemRendererName(default,default):String;
	
	/**
	 * Scrolls the list so that the specified item is visible. If
	 * <code>animationDuration</code> is greater than zero, the scroll will
	 * animate. The duration is in seconds.
	 * 
	 * @param index The integer index of an item from the data provider.
	 * @param animationDuration The length of time, in seconds, of the animation. May be zero to scroll instantly.
	 */
	public function scrollToDisplayIndex(index:Int, animationDuration:Float = 0):Void;

	/**
	 * Scrolls the list to a specific page, horizontally and vertically. If
	 * <code>horizontalPageIndex</code> or <code>verticalPageIndex</code> is
	 * -1, it will be ignored
	 */
	public function scrollToPageIndex(horizontalPageIndex:Int, verticalPageIndex:Int, animationDuration:Float = 0):Void;
	
	/**
	 * If the user is scrolling with touch or if the scrolling is animated,
	 * calling stopScrolling() will cause the scroller to ignore the drag
	 * and stop animations. The children of the list will still receive
	 * touches, so it's useful to call this if the children need to support
	 * touches or dragging without the list also scrolling.
	 */
	public function stopScrolling():Void;
	

}