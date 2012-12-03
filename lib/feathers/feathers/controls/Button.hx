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
import feathers.core.IToggle;
import feathers.core.PropertyProxy;
import feathers.core.PropertyProxy;
import feathers.skins.StateWithToggleValueSelector;
import flash.Vector;

import flash.geom.Point;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

extern class Button extends FeathersControl, implements IToggle
{
	
	/**
	 * The default value added to the <code>nameList</code> of the label.
	 */
	public static var DEFAULT_CHILD_NAME_LABEL:String;
	
	/**
	 * @private
	 */
	public static var STATE_UP:String;
	
	/**
	 * @private
	 */
	public static var STATE_DOWN:String;

	/**
	 * @private
	 */
	public static var STATE_HOVER:String;
	
	/**
	 * @private
	 */
	public static var STATE_DISABLED:String;
	
	/**
	 * The icon will be positioned above the label.
	 */
	public static var ICON_POSITION_TOP:String;
	
	/**
	 * The icon will be positioned to the right of the label.
	 */
	public static var ICON_POSITION_RIGHT:String;
	
	/**
	 * The icon will be positioned below the label.
	 */
	public static var ICON_POSITION_BOTTOM:String;
	
	/**
	 * The icon will be positioned to the left of the label.
	 */
	public static var ICON_POSITION_LEFT:String;

	/**
	 * The icon will be positioned manually with no relation to the position
	 * of the label.
	 */
	public static var ICON_POSITION_MANUAL:String;
	
	/**
	 * The icon will be positioned to the left the label, and the bottom of
	 * the icon will be aligned to the baseline of the label text.
	 */
	public static var ICON_POSITION_LEFT_BASELINE:String;
	
	/**
	 * The icon will be positioned to the right the label, and the bottom of
	 * the icon will be aligned to the baseline of the label text.
	 */
	public static var ICON_POSITION_RIGHT_BASELINE:String;
	
	/**
	 * The icon and label will be aligned horizontally to the left edge of the button.
	 */
	public static var HORIZONTAL_ALIGN_LEFT:String;
	
	/**
	 * The icon and label will be aligned horizontally to the center of the button.
	 */
	public static var HORIZONTAL_ALIGN_CENTER:String;
	
	/**
	 * The icon and label will be aligned horizontally to the right edge of the button.
	 */
	public static var HORIZONTAL_ALIGN_RIGHT:String;
	
	/**
	 * The icon and label will be aligned vertically to the top edge of the button.
	 */
	public static var VERTICAL_ALIGN_TOP:String;
	
	/**
	 * The icon and label will be aligned vertically to the middle of the button.
	 */
	public static var VERTICAL_ALIGN_MIDDLE:String;
	
	/**
	 * The icon and label will be aligned vertically to the bottom edge of the button.
	 */
	public static var VERTICAL_ALIGN_BOTTOM:String;
	
	/**
	 * Constructor.
	 */
	public function new():Void;

	
	/**
	 * The text displayed on the button.
	 */
	public var label(default, default):String;
	
	
	/**
	 * Determines if the button may be selected or unselected when clicked.
	 */
	public var isToggle(default, default):Bool;
	

	/**
	 * Indicates if the button is selected or not. The button may be
	 * selected programmatically, even if <code>isToggle</code> is false.
	 *
	 * @see #isToggle
	 */
	public var isSelected(default, default):Bool;
	
	
	/**
	 * The location of the icon, relative to the label.
	 */
	public var iconPosition(default, default):String;
	
	/**
	 * The space, in pixels, between the icon and the label. Applies to
	 * either horizontal or vertical spacing, depending on the value of
	 * <code>iconPosition</code>.
	 *
	 * <p>If <code>gap</code> is set to <code>Float.POSITIVE_INFINITY</code>,
	 * the label and icon will be positioned as far apart as possible. In
	 * other words, they will be positioned at the edges of the button,
	 * adjusted for padding.</p>
	 *
	 * @see #iconPosition
	 */
	public var gap(default, default):Float;
	
	
	/**
	 * The location where the button's content is aligned horizontally (on
	 * the x-axis).
	 */
	public var horizontalAlign(default, default):String;
	
	/**
	 * The location where the button's content is aligned vertically (on
	 * the y-axis).
	 */
	public var verticalAlign(default, default):String;
	
	
	/**
	 * The minimum space, in pixels, between the button's top edge and the
	 * button's content.
	 */
	public var paddingTop(default, default):Float;
	
	/**
	 * The minimum space, in pixels, between the button's right edge and the
	 * button's content.
	 */
	public var paddingRight(default, default):Float;

	/**
	 * The minimum space, in pixels, between the button's bottom edge and
	 * the button's content.
	 */
	public var paddingBottom(default, default):Float;
	
	/**
	 * The minimum space, in pixels, between the button's left edge and the
	 * button's content.
	 */
	public var paddingLeft(default, default):Float;
	
	
	/**
	 * Offsets the x position of the icon by a certain number of pixels.
	 */
	public var iconOffsetX(default, default):Float;

	
	/**
	 * Offsets the y position of the icon by a certain number of pixels.
	 */
	public var iconOffsetY(default, default):Float;
	

	/**
	 * Determines if a pressed button should remain in the down state if a
	 * touch moves outside of the button's bounds. Useful for controls like
	 * <code>Slider</code> and <code>ToggleSwitch</code> to keep a thumb in
	 * the down state while it is dragged around.
	 */
	public var keepDownStateOnRollOut:Bool;

	/**
	 * Returns a skin for the current state.
	 *
	 * <p>The following function signature is expected:</p>
	 * <pre>function(target:Button, state:Dynamic, oldSkin:DisplayObject = null):DisplayObject</pre>
	 */
	public var stateToSkinFunction(default, default):Button->Dynamic->DisplayObject->DisplayObject;
	public var stateToIconFunction(default, default):Button->Dynamic->DisplayObject->DisplayObject;
	
	/**
	 * Returns a text format for the current state.
	 *
	 * <p>The following function signature is expected:</p>
	 * <pre>function(target:Button, state:Dynamic):Dynamic</pre>
	 */
	public var stateToLabelPropertiesFunction(default, default):Button->Dynamic->Dynamic;

	/**
	 * The skin used when no other skin is defined for the current state.
	 * Intended for use when multiple states should use the same skin.
	 *
	 * @see #upSkin
	 * @see #downSkin
	 * @see #hoverSkin
	 * @see #disabledSkin
	 * @see #defaultSelectedSkin
	 * @see #selectedUpSkin
	 * @see #selectedDownSkin
	 * @see #selectedHoverSkin
	 * @see #selectedDisabledSkin
	 */
	public var defaultSkin(default, default):DisplayObject;
	public var defaultSelectedSkin(default, default):DisplayObject;
	public var upSkin(default, default):DisplayObject;
	public var downSkin(default, default):DisplayObject;
	public var hoverSkin(default, default):DisplayObject;
	public var disabledSkin(default, default):DisplayObject;
	public var selectedUpSkin(default, default):DisplayObject;
	public var selectedDownSkin(default, default):DisplayObject;
	public var selectedHoverSkin(default, default):DisplayObject;
	public var selectedDisabledSkin(default, default):DisplayObject;
	
	
	/**
	 * A function used to instantiate the button's label subcomponent.
	 *
	 * <p>The factory should have the following function signature:</p>
	 * <pre>function():ITextRenderer</pre>
	 *
	 * @see feathers.core.ITextRenderer
	 */
	public var labelFactory(default, default):Void->ITextRenderer;
	
	/**
	 * The default label properties are a set of key/value pairs to be
	 * passed down ot the button's label instance, and it is used when no
	 * other properties are defined for the button's current state. Intended
	 * for use when multiple states should use the same properties.
	 *
	 * @see #defaultSelectedLabelProperties
	 * @see #upLabelProperties
	 * @see #downLabelProperties
	 * @see #hoverLabelProperties
	 * @see #disabledLabelProperties
	 * @see #selectedUpLabelProperties
	 * @see #selectedDownLabelProperties
	 * @see #selectedHoverLabelProperties
	 * @see #selectedDisabledLabelProperties
	 */
	public var defaultLabelProperties(default, default):Dynamic;
	public var upLabelProperties(default, default):Dynamic;
	public var downLabelProperties(default, default):Dynamic;
	public var hoverLabelProperties(default, default):Dynamic;
	public var disabledLabelProperties(default, default):Dynamic;
	
	public var defaultSelectedLabelProperties(default, default):Dynamic;
	public var selectedUpLabelProperties(default, default):Dynamic;
	public var selectedDownLabelProperties(default, default):Dynamic;
	public var selectedHoverLabelProperties(default, default):Dynamic;
	public var selectedDisabledLabelProperties(default, default):Dynamic;
	
	/**
	 * The icon used when no other icon is defined for the current state.
	 * Intended for use when multiple states should use the same icon.
	 *
	 * @see #upIcon
	 * @see #downIcon
	 * @see #hoverIcon
	 * @see #disabledIcon
	 * @see #defaultSelectedIcon
	 * @see #selectedUpIcon
	 * @see #selectedDownIcon
	 * @see #selectedHoverIcon
	 * @see #selectedDisabledIcon
	 */
	public var defaultIcon(default,default):DisplayObject;
	public var defaultSelectedIcon(default,default):DisplayObject;
	public var upIcon(default,default):DisplayObject;
	public var downIcon(default,default):DisplayObject;
	public var hoverIcon(default,default):DisplayObject;
	public var disabledIcon(default,default):DisplayObject;
	public var selectedUpIcon(default,default):DisplayObject;
	public var selectedDownIcon(default,default):DisplayObject;
	public var selectedHoverIcon(default,default):DisplayObject;
	public var selectedDisabledIcon(default,default):DisplayObject;
	
	/**
	 * @private
	 */
	public var autoFlatten(default, default):Bool;
}