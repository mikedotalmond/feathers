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
import feathers.core.IFeathersControl;
import feathers.core.ITextRenderer;
import feathers.core.PropertyProxy;
import feathers.layout.HorizontalLayout;
import feathers.layout.LayoutBoundsResult;
import feathers.layout.ViewPortBounds;
import flash.Vector;

import flash.geom.Point;

import starling.display.DisplayObject;

/**
 * A header that displays an optional title along with a horizontal regions
 * on the sides for additional UI controls. The left side is typically for
 * navigation (to display a back button, for example) and the right for
 * additional actions. The title is displayed in the center by default,
 * but it may be aligned to the left or right if there are no items on the
 * desired side.
 *
 * @see http://wiki.starling-framework.org/feathers/header
 */
extern class Header extends FeathersControl
{
	/**
	 * The title will appear in the center of the header.
	 */
	public static var TITLE_ALIGN_CENTER:String;//"center";

	/**
	 * The title will appear on the left of the header, if there is no other
	 * content on that side. If there is content, the title will appear in
	 * the center.
	 */
	public static var TITLE_ALIGN_PREFER_LEFT:String;//"preferLeft";

	/**
	 * The title will appear on the right of the header, if there is no
	 * other content on that side. If there is content, the title will
	 * appear in the center.
	 */
	public static var TITLE_ALIGN_PREFER_RIGHT:String;//"preferRight";

	/**
	 * The items will be aligned to the top of the bounds.
	 */
	public static var VERTICAL_ALIGN_TOP:String;//"top";

	/**
	 * The items will be aligned to the middle of the bounds.
	 */
	public static var VERTICAL_ALIGN_MIDDLE:String;//"middle";

	/**
	 * The items will be aligned to the bottom of the bounds.
	 */
	public static var VERTICAL_ALIGN_BOTTOM:String;//"bottom";

	/**
	 * The default value added to the <code>nameList</code> of the header's
	 * items.
	 */
	public static var DEFAULT_CHILD_NAME_ITEM:String;//"feathers-header-item";

	/**
	 * The default value added to the <code>nameList</code> of the header's
	 * title.
	 */
	public static var DEFAULT_CHILD_NAME_TITLE:String;//"feathers-header-title";

	
	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * The text displayed for the header's title.
	 */
	public var title(default,default):String;
	
	/**
	 * A function used to instantiate the header's title subcomponent.
	 *
	 * <p>The factory should have the following function signature:</p>
	 * <pre>function():ITextRenderer</pre>
	 *
	 * @see feathers.core.ITextRenderer
	 */
	public var titleFactory(default,default):Void->ITextRenderer;

	/**
	 * The UI controls that appear in the left region of the header.
	 */
	public var leftItems(default,default):Vector<DisplayObject>;

	/**
	 * The UI controls that appear in the right region of the header.
	 */
	public var rightItems(default,default):Vector<DisplayObject>;
	
	/**
	 * The minimum space, in pixels, between the header's top edge and the
	 * header's content.
	 */
	public var paddingTop(default,default):Float;
	
	
	/**
	 * The minimum space, in pixels, between the header's right edge and the
	 * header's content.
	 */
	public var paddingRight(default,default):Float;

	/**
	 * The minimum space, in pixels, between the header's bottom edge and
	 * the header's content.
	 */
	public var paddingBottom(default,default):Float;

	/**
	 * The minimum space, in pixels, between the header's left edge and the
	 * header's content.
	 */
	public var paddingLeft(default,default):Float;

	/**
	 * Space, in pixels, between items.
	 */
	public var gap(default,default):Float;

	@:meta(Inspectable(type="String",enumeration="top,middle,bottom"))
	/**
	 * The alignment of the items vertically, on the y-axis.
	 */
	public var verticalAlign(default,default):String;

	/**
	 * A display object displayed behind the header's content.
	 */
	public var backgroundSkin(default,default):DisplayObject;

	/**
	 * A background to display when the header is disabled.
	 */
	public var backgroundDisabledSkin(default,default):DisplayObject;

	/**
	 * A set of key/value pairs to be passed down to the headers's title
	 * instance.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 */
	public var titleProperties(default,default):Dynamic;

	@:meta(Inspectable(type="String",enumeration="center,preferLeft,preferRight"))
	/**
	 * The preferred position of the title. If leftItems and/or rightItems
	 * is defined, the title may be forced to the center even if the
	 * preferred position is on the left or right.
	 */
	public var titleAlign(default,default):String;
}
