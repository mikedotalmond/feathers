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
import feathers.data.ListCollection;
import flash.Vector;

import starling.events.Event;

@:meta(DefaultProperty("dataProvider"))
/**
 * A set of related buttons with layout, customized using a data provider.
 *
 * @see http://wiki.starling-framework.org/feathers/button-group
 */
extern class ButtonGroup extends FeathersControl
{
	

	/**
	 * The buttons are displayed in order from left to right.
	 */
	public static var DIRECTION_HORIZONTAL:String;//"horizontal";

	/**
	 * The buttons are displayed in order from top to bottom.
	 */
	public static var DIRECTION_VERTICAL:String;//"vertical";

	/**
	 * The default value added to the <code>nameList</code> of the buttons.
	 */
	public static var DEFAULT_CHILD_NAME_BUTTON:String;//"feathers-button-group-button";

	/**
	 * Constructor.
	 */
	public function new():Void;

	
	/**
	 * The collection of data to be displayed with buttons.
	 *
	 * @see #buttonInitializer
	 */
	public var dataProvider(default, default):ListCollection;
	
	@:meta(Inspectable(type="String",enumeration="horizontal,vertical"))
	/**
	 * The button group layout is either vertical or horizontal.
	 */
	public var direction(default, default):String;

	/**
	 * Space, in pixels, between buttons.
	 */
	public var gap(default, default):Float;
	
	/**
	 * Space, in pixels, between the first two buttons. If NaN, the standard
	 * gap will be used.
	 *
	 * @see #gap
	 * @see #lastGap
	 */
	public var firstGap(default, default):Float;

	/**
	 * Space, in pixels, between the last two buttons. If NaN, the standard
	 * gap will be used.
	 *
	 * @see #gap
	 * @see #firstGap
	 */
	public var lastGap(default, default):Float;
	
	
	/**
	 * Creates a new button.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function():Button</pre>
	 *
	 * @see #firstButtonFactory
	 * @see #lastButtonFactory
	 */
	public var buttonFactory(default, default):Void->Button;
	

	/**
	 * Creates a new first button. If the firstButtonFactory is null, then the
	 * ButtonGroup will use the buttonFactory.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function():Button</pre>
	 *
	 * @see #buttonFactory
	 * @see #lastButtonFactory
	 */
	public var firstButtonFactory(default, default):Void->Button;
	
	/**
	 * Creates a new last button. If the lastButtonFactory is null, then the
	 * ButtonGroup will use the buttonFactory.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function():Button</pre>
	 *
	 * @see #buttonFactory
	 * @see #firstButtonFactory
	 */
	public var lastButtonFactory(default, default):Void->Button;
	
	/**
	 * Modifies a button, perhaps by changing its label and icons, based on the
	 * item from the data provider that the button is meant to represent. The
	 * default buttonInitializer function can set the button's label and icons if
	 * <code>label</code> and/or any of the <code>Button</code> icon fields
	 * (<code>defaultIcon</code>, <code>upIcon</code>, etc.) are present in
	 * the item. onPress and onRelease events can also be listened to by
	 * passing in functions for each.
	 */
	public var buttonInitializer(default, default):Dynamic;
	
	/**
	 * A name to add to all buttons in this button group. Typically used by
	 * a theme to provide different skins to different button groups.
	 *
	 * @see feathers.core.FeathersControl#nameList
	 */
	public var customButtonName(default, default):String;
	
	/**
	 * A name to add to the first button in this button group. Typically
	 * used by a theme to provide different skins to the first button.
	 *
	 * @see feathers.core.FeathersControl#nameList
	 */
	public var customFirstButtonName(default, default):String;
	
	
	/**
	 * A name to add to the last button in this button group. Typically used
	 * by a theme to provide different skins to the last button.
	 *
	 * @see feathers.core.FeathersControl#nameList
	 */
	public var customLastButtonName(default, default):String;
	
	/**
	 * A set of key/value pairs to be passed down to all of the button
	 * group's buttons. These values are shared by each button, so values
	 * that cannot be shared (such as display objects that need to be added
	 * to the display list) should be passed to buttons in another way (such
	 * as with an <code>AddedWatcher</code>).
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * @see AddedWatcher
	 */
	public var buttonProperties(default, default):Dynamic;
}
