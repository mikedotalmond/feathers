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
import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
import feathers.controls.renderers.DefaultGroupedListItemRenderer;
import feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer;
import feathers.controls.renderers.IGroupedListItemRenderer;
import feathers.controls.supportClasses.GroupedListDataViewPort;
import feathers.core.FeathersControl;
import feathers.core.PropertyProxy;
import feathers.data.HierarchicalCollection;
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
 * Displays a list of items divided into groups or sections. Takes a
 * hierarchical provider limited to two levels of hierarchy. This component
 * supports scrolling, custom item (and header and footer) renderers, and
 * custom layouts.
 *
 * <p>Layouts may be, and are highly encouraged to be, <em>virtual</em>,
 * meaning that the List is capable of creating a limited number of item
 * renderers to display a subset of the data provider instead of creating a
 * renderer for every single item. This allows for optimal performance with
 * very large data providers.</p>
 *
 * @see http://wiki.starling-framework.org/feathers/grouped-list
 */
extern class GroupedList extends FeathersControl
{
	/**
	 * @private
	 */
	private static var HELPER_POINT:Point;//new Point();

	/**
	 * The default value added to the <code>nameList</code> of the scroller.
	 */
	public static var DEFAULT_CHILD_NAME_SCROLLER:String;//"feathers-list-scroller";

	/**
	 * An alternate name to use with GroupedList to allow a theme to give it
	 * an inset style. If a theme does not provide a skin for this name, it
	 * will fall back to its default style instead of leaving the list
	 * unskinned.
	 */
	public static var ALTERNATE_NAME_INSET_GROUPED_LIST:String;//"feathers-inset-grouped-list";

	/**
	 * The default name to use with header renderers.
	 */
	public static var DEFAULT_CHILD_NAME_HEADER_RENDERER:String;//"feathers-grouped-list-header-renderer";

	/**
	 * An alternate name to use with header renderers to give them an inset
	 * style.
	 */
	public static var ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER:String;//"feathers-grouped-list-inset-header-renderer";

	/**
	 * The default name to use with footer renderers.
	 */
	public static var DEFAULT_CHILD_NAME_FOOTER_RENDERER:String;//"feathers-grouped-list-footer-renderer";

	/**
	 * An alternate name to use with footer renderers to give them an inset
	 * style.
	 */
	public static var ALTERNATE_CHILD_NAME_INSET_FOOTER_RENDERER:String;//"feathers-grouped-list-inset-footer-renderer";

	/**
	 * An alternate name to use with item renderers to give them an inset
	 * style.
	 */
	public static var ALTERNATE_CHILD_NAME_INSET_ITEM_RENDERER:String;//"feathers-grouped-list-inset-item-renderer";

	/**
	 * An alternate name to use for item renderers to give them an inset
	 * style. Typically meant to be used for the renderer of the first item
	 * in a group.
	 */
	public static var ALTERNATE_CHILD_NAME_INSET_FIRST_ITEM_RENDERER:String;//"feathers-grouped-list-inset-first-item-renderer";

	/**
	 * An alternate name to use for item renderers to give them an inset
	 * style. Typically meant to be used for the renderer of the last item
	 * in a group.
	 */
	public static var ALTERNATE_CHILD_NAME_INSET_LAST_ITEM_RENDERER:String;//"feathers-grouped-list-inset-last-item-renderer";

	/**
	 * An alternate name to use for item renderers to give them an inset
	 * style. Typically meant to be used for the renderer of an item in a
	 * group that has no other items.
	 */
	public static var ALTERNATE_CHILD_NAME_INSET_SINGLE_ITEM_RENDERER:String;//"feathers-grouped-list-inset-single-item-renderer";

	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * The value added to the <code>nameList</code> of the scroller.
	 */
	private var scrollerName:String;// = DEFAULT_CHILD_NAME_SCROLLER;

	/**
	 * The grouped list's scroller sub-component.
	 */
	private var scroller:Scroller;

	/**
	 * @private
	 * The guts of the List's functionality. Handles layout and selection.
	 */
	private var dataViewPort:GroupedListDataViewPort;

	/**
	 * @private
	 */
	private var _scrollToGroupIndex:Int;//-1;

	/**
	 * @private
	 */
	private var _scrollToItemIndex:Int;//-1;

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
	 * The layout algorithm used to position and, optionally, size the
	 * list's items.
	 */
	public var layout(default, default):ILayout;

	/**
	 * @private
	 */
	private var _horizontalScrollPosition:Float;//0;

	/**
	 * The number of pixels the list has been scrolled horizontally (on
	 * the x-axis).
	 */
	public var horizontalScrollPosition(default, default):Float;
	
	/**
	 * @private
	 */
	private var _maxHorizontalScrollPosition:Float;//0;

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
	 * The number of pixels the list has been scrolled vertically (on
	 * the y-axis).
	 */
	public var verticalScrollPosition(default, default):Float;

	/**
	 * @private
	 */
	private var _maxVerticalScrollPosition:Float;//0;

	/**
	 * The maximum number of pixels the list may be scrolled vertically (on
	 * the y-axis). This value is automatically calculated based on the
	 * total combined height of the list's item renderers. The
	 * <code>verticalScrollPosition</code> property may have a higher value
	 * than the maximum due to elastic edges. However, once the user stops
	 * interacting with the list, it will automatically animate back to the
	 * maximum (or minimum, if below 0).
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
	private var _dataProvider:HierarchicalCollection;

	/**
	 * The collection of data displayed by the list.
	 */
	public var dataProvider(default, default):HierarchicalCollection;

	/**
	 * @private
	 */
	private var _isSelectable:Bool;//true;

	/**
	 * Determines if an item in the list may be selected.
	 */
	public var isSelectable(default, default):Bool;

	/**
	 * @private
	 */
	private var _selectedGroupIndex:Int;//-1;

	/**
	 * The group index of the currently selected item. Returns -1 if no item
	 * is selected.
	 *
	 * @see #selectedItemIndex
	 */
	public var selectedGroupIndex(default, null):Int;

	/**
	 * @private
	 */
	private var _selectedItemIndex:Int;//-1;

	/**
	 * The item index of the currently selected item. Returns -1 if no item
	 * is selected.
	 *
	 * @see #selectedGroupIndex
	 */
	public var selectedItemIndex(default, null):Int;

	/**
	 * The currently selected item. Returns null if no item is selected.
	 */
	public var selectedItem(default, default):Dynamic;


	/**
	 * @private
	 */
	private var _scrollerProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to the list's scroller
	 * instance. The scroller is a <code>feathers.controls.Scroller</code> instace.
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
	private var _paddingTop:Float;//0;

	/**
	 * The minimum space, in pixels, between the list's top edge and the
	 * list's content.
	 */
	public var paddingTop(default, default):Float;

	/**
	 * @private
	 */
	private var _paddingRight:Float;//0;

	/**
	 * The minimum space, in pixels, between the list's right edge and the
	 * list's content.
	 */
	public var paddingRight(default, default):Float;

	/**
	 * @private
	 */
	private var _paddingBottom:Float;//0;

	/**
	 * The minimum space, in pixels, between the list's bottom edge and
	 * the list's content.
	 */
	public var paddingBottom(default, default):Float;

	/**
	 * @private
	 */
	private var _paddingLeft:Float;//0;

	/**
	 * The minimum space, in pixels, between the list's left edge and the
	 * list's content.
	 */
	public var paddingLeft(default, default):Float;

	/**
	 * @private
	 */
	private var _itemRendererType:Class<Dynamic>;//DefaultGroupedListItemRenderer;

	/**
	 * The class used to instantiate item renderers.
	 *
	 * @see #itemRendererFactory
	 * @see #firstItemRendererType
	 * @see #firstItemRendererFactory
	 * @see #lastItemRendererType
	 * @see #lastItemRendererFactory
	 * @see #singleItemRendererType
	 * @see #singleItemRendererFactory
	 */
	public var itemRendererType(default, default):Type;


	/**
	 * @private
	 */
	private var _itemRendererFactory:Void->IGroupedListItemRenderer;

	/**
	 * A function called that is expected to return a new item renderer. Has
	 * a higher priority than <code>itemRendererType</code>. Typically, you
	 * would use an <code>itemRendererFactory</code> instead of an
	 * <code>itemRendererType</code> if you wanted to initialize some
	 * properties on each separate item renderer, such as skins.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 *
	 * <pre>function():IGroupedListItemRenderer</pre>
	 *
	 * @see #itemRendererType
	 * @see #firstItemRendererType
	 * @see #firstItemRendererFactory
	 * @see #lastItemRendererType
	 * @see #lastItemRendererFactory
	 * @see #singleItemRendererType
	 * @see #singleItemRendererFactory
	 */
	public var itemRendererFactory(default, default):Void->IGroupedListItemRenderer;


	/**
	 * @private
	 */
	private var _typicalItem:Dynamic;//null;

	/**
	 * An item used to create a sample item renderer used for virtual layout
	 * measurement.
	 */
	public var typicalItem(default, default):Dynamic;


	/**
	 * @private
	 */
	private var _itemRendererName:String;

	/**
	 * A name to add to all item renderers in this list. Typically used by a
	 * theme to provide different skins to different lists.
	 *
	 * @see feathers.core.FeathersControl#nameList
	 * @see #firstItemRendererName
	 * @see #lastItemRendererName
	 * @see #singleItemRendererName
	 */
	public var itemRendererName(default, default):String;
	

	/**
	 * @private
	 */
	private var _itemRendererProperties:PropertyProxy;

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
	 */
	public var itemRendererProperties(default, default):Dynamic;
	
	/**
	 * @private
	 */
	private var _firstItemRendererType:Type;

	/**
	 * The class used to instantiate the item renderer for the first item in
	 * a group.
	 *
	 * @see #firstItemRendererFactory
	 * @see #itemRendererType
	 * @see #itemRendererFactory
	 * @see #lastItemRendererType
	 * @see #lastItemRendererFactory
	 * @see #singleItemRendererType
	 * @see #singleItemRendererFactory
	 */
	public var firstItemRendererType(default, default):Type;

	/**
	 * @private
	 */
	private var _firstItemRendererFactory:Void->IGroupedListItemRenderer;

	/**
	 * A function called that is expected to return a new item renderer for
	 * the first item in a group. Has a higher priority than
	 * <code>firstItemRendererType</code>. Typically, you would use an
	 * <code>firstItemRendererFactory</code> instead of an
	 * <code>firstItemRendererType</code> if you wanted to initialize some
	 * properties on each separate item renderer, such as skins.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 *
	 * <pre>function():IGroupedListItemRenderer</pre>
	 *
	 * @see #firstItemRendererType
	 * @see #itemRendererType
	 * @see #itemRendererFactory
	 * @see #lastItemRendererType
	 * @see #lastItemRendererFactory
	 * @see #singleItemRendererType
	 * @see #singleItemRendererFactory
	 */
	public var firstItemRendererFactory(default, default):Void->IGroupedListItemRenderer;


	/**
	 * @private
	 */
	private var _firstItemRendererName:String;

	/**
	 * A name to add to all item renderers in this list that are the first
	 * item in a group. Typically used by a theme to provide different skins
	 * to different lists, and to differentiate first items from regular
	 * items if they are created with the same class. If this value is null
	 * the regular <code>itemRendererName</code> will be used instead.
	 *
	 * @see feathers.core.FeathersControl#nameList
	 * @see #itemRendererName
	 * @see #lastItemRendererName
	 * @see #singleItemRendererName
	 */
	public var firstItemRendererName(default, default):String;
	

	/**
	 * @private
	 */
	private var _lastItemRendererType:Type;

	/**
	 * The class used to instantiate the item renderer for the last item in
	 * a group.
	 *
	 * @see #lastItemRendererFactory
	 * @see #itemRendererType
	 * @see #itemRendererFactory
	 * @see #firstItemRendererType
	 * @see #firstItemRendererFactory
	 * @see #singleItemRendererType
	 * @see #singleItemRendererFactory
	 */
	public var lastItemRendererType(default, default):Type;

	/**
	 * @private
	 */
	private var _lastItemRendererFactory:Void->IGroupedListItemRenderer;

	/**
	 * A function called that is expected to return a new item renderer for
	 * the last item in a group. Has a higher priority than
	 * <code>lastItemRendererType</code>. Typically, you would use an
	 * <code>lastItemRendererFactory</code> instead of an
	 * <code>lastItemRendererType</code> if you wanted to initialize some
	 * properties on each separate item renderer, such as skins.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 *
	 * <pre>function():IGroupedListItemRenderer</pre>
	 *
	 * @see #lastItemRendererType
	 * @see #itemRendererType
	 * @see #itemRendererFactory
	 * @see #firstItemRendererType
	 * @see #firstItemRendererFactory
	 * @see #singleItemRendererType
	 * @see #singleItemRendererFactory
	 */
	public var lastItemRendererFactory(default, default):Void->IGroupedListItemRenderer;
	

	/**
	 * @private
	 */
	private var _lastItemRendererName:String;

	/**
	 * A name to add to all item renderers in this list that are the last
	 * item in a group. Typically used by a theme to provide different skins
	 * to different lists, and to differentiate last items from regular
	 * items if they are created with the same class. If this value is null
	 * the regular <code>itemRendererName</code> will be used instead.
	 *
	 * @see feathers.core.FeathersControl#nameList
	 * @see #itemRendererName
	 * @see #firstItemRendererName
	 * @see #singleItemRendererName
	 */
	public var lastItemRendererName(default, default):String;


	/**
	 * @private
	 */
	private var _singleItemRendererType:Type;

	/**
	 * The class used to instantiate the item renderer for an item in a
	 * group with no other items.
	 *
	 * @see #singleItemRendererFactory
	 * @see #itemRendererType
	 * @see #itemRendererFactory
	 * @see #firstItemRendererType
	 * @see #firstItemRendererFactory
	 * @see #lastItemRendererType
	 * @see #lastItemRendererFactory
	 */
	public var singleItemRendererType(default, default):Type;

	/**
	 * @private
	 */
	private var _singleItemRendererFactory:Void->IGroupedListItemRenderer;

	/**
	 * A function called that is expected to return a new item renderer for
	 * an item in a group with no other items. Has a higher priority than
	 * <code>singleItemRendererType</code>. Typically, you would use an
	 * <code>singleItemRendererFactory</code> instead of an
	 * <code>singleItemRendererType</code> if you wanted to initialize some
	 * properties on each separate item renderer, such as skins.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 *
	 * <pre>function():IGroupedListItemRenderer</pre>
	 *
	 * @see #singleItemRendererType
	 * @see #itemRendererType
	 * @see #itemRendererFactory
	 * @see #firstItemRendererType
	 * @see #firstItemRendererFactory
	 * @see #lastItemRendererType
	 * @see #lastItemRendererFactory
	 */
	public var singleItemRendererFactory(default, default):Void->IGroupedListItemRenderer;


	/**
	 * @private
	 */
	private var _singleItemRendererName:String;

	/**
	 * A name to add to all item renderers in this list that are an item in
	 * a group with no other items. Typically used by a theme to provide
	 * different skins to different lists, and to differentiate single items
	 * from other items if they are created with the same class. If this
	 * value is null the regular <code>itemRendererName</code> will be used
	 * instead.
	 *
	 * @see feathers.core.FeathersControl#nameList
	 * @see #itemRendererName
	 * @see #firstItemRendererName
	 * @see #lastItemRendererName
	 */
	public var singleItemRendererName(default, default):String;

	/**
	 * @private
	 */
	private var _headerRendererType:Class<Dynamic>;//DefaultGroupedListHeaderOrFooterRenderer;

	/**
	 * The class used to instantiate header renderers.
	 *
	 * @see #headerRendererFactory
	 */
	public var headerRendererType(default, default):Class<Dynamic>;

	/**
	 * @private
	 */
	private var _headerRendererFactory:Void->IGroupedListHeaderOrFooterRenderer;

	/**
	 * A function called that is expected to return a new header renderer.
	 * Has a higher priority than <code>headerRendererType</code>.
	 * Typically, you would use an <code>headerRendererFactory</code>
	 * instead of a <code>headerRendererType</code> if you wanted to
	 * initialize some properties on each separate header renderer, such as
	 * skins.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 *
	 * <pre>function():IGroupedListHeaderOrFooterRenderer</pre>
	 *
	 * @see #headerRendererType
	 */
	public var headerRendererFactory(default, default):Void->IGroupedListHeaderOrFooterRenderer;
	
	/**
	 * @private
	 */
	private var _typicalHeader:Dynamic;//null;

	/**
	 * Used to auto-size the grouped list. If the list's width or height is
	 * NaN, the grouped list will try to automatically pick an ideal size.
	 * This data is used in that process to create a sample header renderer.
	 */
	public var typicalHeader(default, default):Dynamic;
	

	/**
	 * @private
	 */
	private var _headerRendererName:String;// = DEFAULT_CHILD_NAME_HEADER_RENDERER;

	/**
	 * A name to add to all header renderers in this grouped list. Typically
	 * used by a theme to provide different skins to different lists.
	 *
	 * @see feathers.core.FeathersControl#nameList
	 */
	public var headerRendererName(default, default):String;


	/**
	 * @private
	 */
	private var _headerRendererProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to all of the grouped
	 * list's header renderers. These values are shared by each header
	 * renderer, so values that cannot be shared (such as display objects
	 * that need to be added to the display list) should be passed to the
	 * header renderers using a <code>headerRendererFactory</code> or with a
	 * theme.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * @see #headerRendererFactory
	 */
	public var headerRendererProperties(default, default):Dynamic;


	/**
	 * @private
	 */
	private var _footerRendererType:Class<Dynamic>;//DefaultGroupedListHeaderOrFooterRenderer;

	/**
	 * The class used to instantiate footer renderers.
	 *
	 * @see #footerRendererFactory
	 */
	public var footerRendererType(default, default):Class<Dynamic>;

	/**
	 * @private
	 */
	private var _footerRendererFactory:Void->IGroupedListHeaderOrFooterRenderer;

	/**
	 * A function called that is expected to return a new footer renderer.
	 * Has a higher priority than <code>footerRendererType</code>.
	 * Typically, you would use an <code>footerRendererFactory</code>
	 * instead of a <code>footerRendererType</code> if you wanted to
	 * initialize some properties on each separate footer renderer, such as
	 * skins.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 *
	 * <pre>function():IGroupedListHeaderOrFooterRenderer</pre>
	 *
	 * @see #footerRendererType
	 */
	public var footerRendererFactory(default, default):Void->IGroupedListHeaderOrFooterRenderer;


	/**
	 * @private
	 */
	private var _typicalFooter:Dynamic;//null;

	/**
	 * Used to auto-size the grouped list. If the grouped list's width or
	 * height is NaN, the grouped list will try to automatically pick an
	 * ideal size. This data is used in that process to create a sample
	 * footer renderer.
	 */
	public var typicalFooter(default, default):Dynamic;

	/**
	 * @private
	 */
	private var _footerRendererName:String;// = DEFAULT_CHILD_NAME_FOOTER_RENDERER;

	/**
	 * A name to add to all footer renderers in this grouped list. Typically
	 * used by a theme to provide different skins to different lists.
	 *
	 * @see feathers.core.FeathersControl#nameList
	 */
	public var footerRendererName(default, default):String;
	

	/**
	 * @private
	 */
	private var _footerRendererProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to all of the grouped
	 * list's footer renderers. These values are shared by each footer
	 * renderer, so values that cannot be shared (such as display objects
	 * that need to be added to the display list) should be passed to the
	 * footer renderers using a <code>footerRendererFactory</code> or with
	 * a theme.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * @see #itemRendererFactory
	 */
	public var footerRendererProperties(default, default):Dynamic;
	

	/**
	 * @private
	 */
	private var _headerField:String;//"header";

	/**
	 * The field in a group that contains the data for a header. If the
	 * group does not have this field, and a <code>headerFunction</code> is
	 * not defined, then no header will be displayed for the group. In other
	 * words, a header is optional, and a group may not have one.
	 *
	 * <p>All of the header fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>headerFunction</code></li>
	 *     <li><code>headerField</code></li>
	 * </ol>
	 *
	 * @see #headerFunction
	 */
	public var headerField(default, default):String;

	/**
	 * @private
	 */
	private var _headerFunction:Dynamic;

	/**
	 * A function used to generate header data for a specific group. If this
	 * function is not null, then the <code>headerField</code> will be
	 * ignored.
	 *
	 * <p>All of the header fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>headerFunction</code></li>
	 *     <li><code>headerField</code></li>
	 * </ol>
	 *
	 * @see #headerField
	 */
	public var headerFunction(default, default):Dynamic;
	

	/**
	 * @private
	 */
	private var _footerField:String;//"footer";

	/**
	 * The field in a group that contains the data for a footer. If the
	 * group does not have this field, and a <code>footerFunction</code> is
	 * not defined, then no footer will be displayed for the group. In other
	 * words, a footer is optional, and a group may not have one.
	 *
	 * <p>All of the footer fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>footerFunction</code></li>
	 *     <li><code>footerField</code></li>
	 * </ol>
	 *
	 * @see #footerFunction
	 */
	public var footerField(default, default):String;
	
	/**
	 * @private
	 */
	private var _footerFunction:Dynamic;

	/**
	 * A function used to generate footer data for a specific group. If this
	 * function is not null, then the <code>footerField</code> will be
	 * ignored.
	 *
	 * <p>All of the footer fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>footerFunction</code></li>
	 *     <li><code>footerField</code></li>
	 * </ol>
	 *
	 * @see #footerField
	 */
	public var footerFunction(default, default):Dynamic;


	/**
	 * Scrolls the list so that the specified item is visible. If
	 * <code>animationDuration</code> is greater than zero, the scroll will
	 * animate. The duration is in seconds.
	 */
	public function scrollToDisplayIndex(groupIndex:Int, itemIndex:Int, animationDuration:Float = 0):Void;
	
	/**
	 * Scrolls the list to a specific page, horizontally and vertically. If
	 * <code>horizontalPageIndex</code> or <code>verticalPageIndex</code> is
	 * -1, it will be ignored
	 */
	public function scrollToPageIndex(horizontalPageIndex:Int, verticalPageIndex:Int, animationDuration:Float = 0):Void;

	/**
	 * @private
	 */
	public function setSelectedLocation(groupIndex:Int, itemIndex:Int):Void;

	/**
	 * If the user is dragging the scroll, calling stopScrolling() will
	 * cause the grouped list to ignore the drag. The children of the list
	 * will still receive touches, so it's useful to call this if the
	 * children need to support touches or dragging without the list
	 * also scrolling.
	 */
	public function stopScrolling():Void;

	/**
	 * Extracts header data from a group object.
	 */
	public function groupToHeaderData(group:Dynamic):Dynamic;

	/**
	 * Extracts footer data from a group object.
	 */
	public function groupToFooterData(group:Dynamic):Dynamic;

	/**
	 * @private
	 */
	private function autoSizeIfNeeded():Bool;
	
	/**
	 * @private
	 */
	private function refreshScrollerStyles():Void;

	/**
	 * @private
	 */
	private function refreshBackgroundSkin():Void;

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
	private function dataProvider_resetHandler(event:Event):Void;

	/**
	 * @private
	 */
	private function scroller_scrollHandler(event:Event):Void;

	/**
	 * @private
	 */
	private function scroller_scrollCompleteHandler(event:Event):Void;

	/**
	 * @private
	 */
	private function dataViewPort_changeHandler(event:Event):Void;
}
