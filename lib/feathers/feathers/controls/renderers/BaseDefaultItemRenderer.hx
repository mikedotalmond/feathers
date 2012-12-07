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
package feathers.controls.renderers;
import feathers.controls.Button;
import feathers.controls.ImageLoader;
import feathers.controls.text.BitmapFontTextRenderer;
import feathers.core.FeathersControl;
import feathers.core.IFeathersControl;
import feathers.core.ITextRenderer;
import feathers.core.PropertyProxy;
import starling.events.Event;

import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.events.TouchEvent;
import starling.textures.Texture;

/**
 * An abstract class for item renderer implementations.
 */
extern class BaseDefaultItemRenderer extends Button
{
	/**
	 * The default value added to the <code>nameList</code> of the accessory
	 * label.
	 */
	public static var DEFAULT_CHILD_NAME_ACCESSORY_LABEL:String;//"feathers-item-renderer-accessory-label";

	/**
	 * The accessory will be positioned above its origin.
	 */
	public static var ACCESSORY_POSITION_TOP:String;//="top";

	/**
	 * The accessory will be positioned to the right of its origin.
	 */
	public static var ACCESSORY_POSITION_RIGHT:String;//="right";

	/**
	 * The accessory will be positioned below its origin.
	 */
	public static var ACCESSORY_POSITION_BOTTOM:String;//="bottom";

	/**
	 * The accessory will be positioned to the left of its origin.
	 */
	public static var ACCESSORY_POSITION_LEFT:String;//="left";

	/**
	 * The accessory will be positioned manually with no relation to another
	 * child. Use <code>accessoryOffsetX</code> and <code>accessoryOffsetY</code>
	 * to set the accessory position.
	 *
	 * <p>The <code>accessoryPositionOrigin</code> property will be ignored
	 * if <code>accessoryPosition</code> is set to <code>ACCESSORY_POSITION_MANUAL</code>.
	 *
	 * @see #accessoryOffsetX
	 * @see #accessoryOffsetY
	 */
	public static var ACCESSORY_POSITION_MANUAL:String;//="manual";

	/**
	 * The layout order will be the label first, then the accessory relative
	 * to the label, then the icon relative to both. Best used when the
	 * accessory should be between the label and the icon or when the icon
	 * position shouldn't be affected by the accessory.
	 */
	public static var LAYOUT_ORDER_LABEL_ACCESSORY_ICON:String;//="labelAccessoryIcon";

	/**
	 * The layout order will be the label first, then the icon relative to
	 * label, then the accessory relative to both.
	 */
	public static var LAYOUT_ORDER_LABEL_ICON_ACCESSORY:String;//="labelIconAccessory";
	
		
	/**
	 * @private
	 */
	@:protected private static var HELPER_POINT:Point;//new Point();

	/**
	 * @private
	 */
	@:protected private static var DOWN_STATE_DELAY_MS:Int;//250;

	/**
	 * @private
	 */
	@:protected private static function defaultLoaderFactory():ImageLoader;

	/**
	 * Constructor.
	 */
	public function new():Void;
	
	/**
	 * The value added to the <code>nameList</code> of the accessory label.
	 */
	@:protected private var accessoryLabelName:String;// = DEFAULT_CHILD_NAME_ACCESSORY_LABEL;

	/**
	 * @private
	 */
	@:protected private var iconImage:Image;

	/**
	 * @private
	 */
	@:protected private var accessoryImage:Image;

	/**
	 * @private
	 */
	@:protected private var accessoryLabel:ITextRenderer;

	/**
	 * @private
	 */
	@:protected private var accessory:DisplayObject;

	/**
	 * @private
	 */
	@:protected private var _data:Dynamic;

	/**
	 * The item displayed by this renderer.
	 */
	public var data(default, default):Dynamic;
	
	/**
	 * @private
	 */
	@:protected private var _owner:IFeathersControl;

	/**
	 * @private
	 */
	@:protected private var _delayedCurrentState:String;

	/**
	 * @private
	 */
	@:protected private var _stateDelayTimer:Timer;

	/**
	 * @private
	 */
	@:protected private var _useStateDelayTimer:Bool;//true;

	/**
	 * If true, the down state (and subsequent state changes) will be
	 * delayed to make scrolling look nicer.
	 */
	public var useStateDelayTimer(default, default):Bool;

	/**
	 * @private
	 */
	@:protected private var _itemHasLabel:Bool;//true;

	/**
	 * If true, the label will come from the renderer's item using the
	 * appropriate field or function for the label. If false, the label may
	 * be set externally.
	 */
	public var itemHasLabel(default, default):Bool;

	/**
	 * @private
	 */
	@:protected private var _itemHasIcon:Bool;//true;

	/**
	 * If true, the icon will come from the renderer's item using the
	 * appropriate field or function for the icon. If false, the icon may
	 * be skinned for each state externally.
	 */
	public var itemHasIcon(default, default):Bool;
	
	
	/**
	 * @private
	 */
	@:protected private var _accessoryPosition:String;// = ACCESSORY_POSITION_RIGHT;

	//@:Inspectable(type="String",enumeration="top,right,bottom,left,manual")]
	/**
	 * The location of the accessory, relative to one of the other children.
	 * Use <code>ACCESSORY_POSITION_MANUAL</code> to position the accessory
	 * from the top-left corner.
	 *
	 * @see #layoutOrder
	 */
	public var accessoryPosition(default, default):String;
	
	/**
	 * @private
	 */
	@:protected private var _layoutOrder:String;// = LAYOUT_ORDER_LABEL_ICON_ACCESSORY;
	
	//@:Inspectable(type="String",enumeration="labelIconAccessory,labelAccessoryIcon")
	/**
	 * The accessory's position will be based on which other child (the
	 * label or the icon) the accessory should be relative to.
	 *
	 * <p>The <code>accessoryPositionOrigin</code> property will be ignored
	 * if <code>accessoryPosition</code> is set to <code>ACCESSORY_POSITION_MANUAL</code>.
	 *
	 * @see #accessoryPosition
	 * @see #iconPosition
	 * @see LAYOUT_ORDER_LABEL_ICON_ACCESSORY
	 * @see LAYOUT_ORDER_LABEL_ACCESSORY_ICON
	 */
	public var layoutOrder(default, default):String;
	
	/**
	 * @private
	 */
	@:protected private var _accessoryOffsetX:Float;// = 0;
	
	/**
	 * Offsets the x position of the accessory by a certain number of pixels.
	 */
	public var accessoryOffsetX(default, default):Float;

	/**
	 * @private
	 */
	@:protected var _accessoryOffsetY:Float;// = 0;

	/**
	 * Offsets the y position of the accessory by a certain number of pixels.
	 */
	public var accessoryOffsetY(default, default):Float;

	/**
	 * @private
	 */
	@:protected private var _accessoryGap:Float;// = Number.POSITIVE_INFINITY;

	/**
	 * The space, in pixels, between the accessory and the other child it is
	 * positioned relative to. Applies to either horizontal or vertical
	 * spacing, depending on the value of <code>accessoryPosition</code>. If
	 * the value is <code>NaN</code>, the value of the <code>gap</code>
	 * property will be used instead.
	 *
	 * <p>If <code>accessoryGap</code> is set to <code>Number.POSITIVE_INFINITY</code>,
	 * the accessory and the component it is relative to will be positioned
	 * as far apart as possible.</p>
	 *
	 * @see #gap
	 * @see #accessoryPosition
	 */
	public var accessoryGap(default, default):Float;
	
	
	/**
	 * @private
	 */
	@:protected private var _labelField:String;//"label";

	/**
	 * The field in the item that contains the label text to be displayed by
	 * the renderer. If the item does not have this field, and a
	 * <code>labelFunction</code> is not defined, then the renderer will
	 * default to calling <code>toString()</code> on the item. To omit the
	 * label completely, either provide a custom item renderer without a
	 * label or define a <code>labelFunction</code> that returns an empty
	 * string.
	 *
	 * <p>All of the label fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>labelFunction</code></li>
	 *     <li><code>labelField</code></li>
	 * </ol>
	 *
	 * @see #labelFunction
	 */
	public var labelField(default, default):String;

	/**
	 * @private
	 */
	@:protected private var _labelFunction:Dynamic->String;

	/**
	 * A function used to generate label text for a specific item. If this
	 * function is not null, then the <code>labelField</code> will be
	 * ignored.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):String</pre>
	 *
	 * <p>All of the label fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>labelFunction</code></li>
	 *     <li><code>labelField</code></li>
	 * </ol>
	 *
	 * @see #labelField
	 */
	public var labelFunction(default, default):Dynamic->String;

	/**
	 * @private
	 */
	@:protected private var _iconField:String;//"icon";

	/**
	 * The field in the item that contains a display object to be displayed
	 * as an icon or other graphic next to the label in the renderer.
	 *
	 * <p>All of the icon fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>iconSourceFunction</code></li>
	 *     <li><code>iconSourceField</code></li>
	 *     <li><code>iconFunction</code></li>
	 *     <li><code>iconField</code></li>
	 * </ol>
	 *
	 * @see #iconFunction
	 * @see #iconSourceField
	 * @see #iconSourceFunction
	 */
	public var iconField(default, default):String;

	/**
	 * @private
	 */
	@:protected private var _iconFunction:Dynamic->DisplayObject;

	/**
	 * A function used to generate an icon for a specific item.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):DisplayObject</pre>
	 *
	 * <p>All of the icon fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>iconSourceFunction</code></li>
	 *     <li><code>iconSourceField</code></li>
	 *     <li><code>iconFunction</code></li>
	 *     <li><code>iconField</code></li>
	 * </ol>
	 *
	 * @see #iconField
	 * @see #iconSourceField
	 * @see #iconSourceFunction
	 */
	public var iconFunction(default, default):Dynamic->DisplayObject;

	/**
	 * @private
	 */
	@:protected private var _iconSourceField:String;//"iconTexture";

	/**
	 * The field in the item that contains a texture to be used for the
	 * renderer's icon. The renderer will automatically manage and reuse an
	 * internal <code>Image</code>. This <code>Image</code> may be
	 * customized by changing the <code>iconImageFactory</code>.
	 *
	 * <p>All of the icon fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>iconSourceFunction</code></li>
	 *     <li><code>iconSourceField</code></li>
	 *     <li><code>iconFunction</code></li>
	 *     <li><code>iconField</code></li>
	 * </ol>
	 *
	 * @see #iconImageFactory
	 * @see #iconSourceFunction
	 * @see #iconField
	 * @see #iconFunction
	 * @see starling.textures.Texture
	 */
	public var iconSourceField(default, default):String;

	/**
	 * @private
	 */
	private var _iconSourceFunction:Dynamic->Texture;

	/**
	 * A function used to generate a texture to be used for the renderer's
	 * icon. The renderer will automatically manage and reuse an internal
	 * <code>Image</code> and swap the texture when the renderer's data
	 * changes. This <code>Image</code> may be customized by changing the
	 * <code>iconImageFactory</code>.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):Texture</pre>
	 *
	 * <p>All of the icon fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>iconSourceFunction</code></li>
	 *     <li><code>iconSourceField</code></li>
	 *     <li><code>iconFunction</code></li>
	 *     <li><code>iconField</code></li>
	 * </ol>
	 *
	 * @see #iconImageFactory
	 * @see #iconSourceField
	 * @see #iconField
	 * @see #iconFunction
	 * @see starling.textures.Texture
	 */
	public var iconSourceFunction(default, default):Dynamic->Texture;

	/**
	 * @private
	 */
	@:protected private var _accessoryField:String;//"accessory";

	/**
	 * The field in the item that contains a display object to be positioned
	 * in the accessory position of the renderer. If you wish to display an
	 * <code>Image</code> in the accessory position, it's better for
	 * performance to use <code>accessoryTextureField</code> instead.
	 *
	 * <p>All of the accessory fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>accessoryTextureFunction</code></li>
	 *     <li><code>accessoryTextureField</code></li>
	 *     <li><code>accessoryLabelFunction</code></li>
	 *     <li><code>accessoryLabelField</code></li>
	 *     <li><code>accessoryFunction</code></li>
	 *     <li><code>accessoryField</code></li>
	 * </ol>
	 *
	 * @see #accessoryTextureField
	 * @see #accessoryFunction
	 * @see #accessoryTextureFunction
	 * @see #accessoryLabelField
	 * @see #accessoryLabelFunction
	 */
	public var accessoryField(default, default):String;
	
	/**
	 * @private
	 */
	private var _accessoryFunction:Dynamic->DisplayObject;

	/**
	 * A function that returns a display object to be positioned in the
	 * accessory position of the renderer. If you wish to display an
	 * <code>Image</code> in the accessory position, it's better for
	 * performance to use <code>accessoryTextureFunction</code> instead.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):DisplayObject</pre>
	 *
	 * <p>All of the accessory fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>accessoryTextureFunction</code></li>
	 *     <li><code>accessoryTextureField</code></li>
	 *     <li><code>accessoryLabelFunction</code></li>
	 *     <li><code>accessoryLabelField</code></li>
	 *     <li><code>accessoryFunction</code></li>
	 *     <li><code>accessoryField</code></li>
	 * </ol>
	 *
	 * @see #accessoryField
	 * @see #accessoryTextureField
	 * @see #accessoryTextureFunction
	 * @see #accessoryLabelField
	 * @see #accessoryLabelFunction
	 */
	public var accessoryFunction(default,default):Dynamic->DisplayObject;
	
	/**
	 * @private
	 */
	@:protected private var _accessorySourceField:String;//"accessoryTexture";

	/**
	 * The field in the item that contains a texture to be displayed in a
	 * renderer-managed <code>Image</code> in the accessory position of the
	 * renderer. The renderer will automatically reuse an internal
	 * <code>Image</code> and swap the texture when the renderer's data
	 * changes. This <code>Image</code> may be customized by
	 * changing the <code>accessoryImageFactory</code>.
	 *
	 * <p>Using an accessory texture will result in better performance than
	 * passing in an <code>Image</code> through a <code>accessoryField</code>
	 * or <code>accessoryFunction</code> because the renderer can aVoid
	 * costly display list manipulation.</p>
	 *
	 * <p>All of the accessory fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>accessoryTextureFunction</code></li>
	 *     <li><code>accessoryTextureField</code></li>
	 *     <li><code>accessoryLabelFunction</code></li>
	 *     <li><code>accessoryLabelField</code></li>
	 *     <li><code>accessoryFunction</code></li>
	 *     <li><code>accessoryField</code></li>
	 * </ol>
	 *
	 * @see #accessoryImageFactory
	 * @see #accessoryTextureFunction
	 * @see #accessoryField
	 * @see #accessoryFunction
	 * @see #accessoryLabelField
	 * @see #accessoryLabelFunction
	 */
	public var accessorySourceField(default,default):String;

	/**
	 * @private
	 */
	@:protected private var _accessorySourceFunction:Dynamic->Texture;

	/**
	 * A function that returns a texture to be displayed in a
	 * renderer-managed <code>Image</code> in the accessory position of the
	 * renderer. The renderer will automatically reuse an internal
	 * <code>Image</code> and swap the texture when the renderer's data
	 * changes. This <code>Image</code> may be customized by
	 * changing the <code>accessoryImageFactory</code>.
	 *
	 * <p>Using an accessory texture will result in better performance than
	 * passing in an <code>Image</code> through a <code>accessoryField</code>
	 * or <code>accessoryFunction</code> because the renderer can aVoid
	 * costly display list manipulation.</p>
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):Texture</pre>
	 *
	 * <p>All of the accessory fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>accessoryTextureFunction</code></li>
	 *     <li><code>accessoryTextureField</code></li>
	 *     <li><code>accessoryLabelFunction</code></li>
	 *     <li><code>accessoryLabelField</code></li>
	 *     <li><code>accessoryFunction</code></li>
	 *     <li><code>accessoryField</code></li>
	 * </ol>
	 *
	 * @see #accessoryImageFactory
	 * @see #accessoryTextureField
	 * @see #accessoryField
	 * @see #accessoryFunction
	 * @see #accessoryLabelField
	 * @see #accessoryLabelFunction
	 */
	public var accessorySourceFunction(default,default):Dynamic->Texture;
	/**
	 * @private
	 */
	@:protected private var _accessoryLabelField:String;//"accessoryLabel";

	/**
	 * The field in the item that contains a string to be displayed in a
	 * renderer-managed <code>Label</code> in the accessory position of the
	 * renderer. The renderer will automatically reuse an internal
	 * <code>Label</code> and swap the text when the data changes. This
	 * <code>Label</code> may be skinned by changing the
	 * <code>accessoryLabelFactory</code>.
	 *
	 * <p>Using an accessory label will result in better performance than
	 * passing in a <code>Label</code> through a <code>accessoryField</code>
	 * or <code>accessoryFunction</code> because the renderer can aVoid
	 * costly display list manipulation.</p>
	 *
	 * <p>All of the accessory fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>accessoryTextureFunction</code></li>
	 *     <li><code>accessoryTextureField</code></li>
	 *     <li><code>accessoryLabelFunction</code></li>
	 *     <li><code>accessoryLabelField</code></li>
	 *     <li><code>accessoryFunction</code></li>
	 *     <li><code>accessoryField</code></li>
	 * </ol>
	 *
	 * @see #accessoryLabelFactory
	 * @see #accessoryLabelFunction
	 * @see #accessoryField
	 * @see #accessoryFunction
	 * @see #accessoryTextureField
	 * @see #accessoryTextureFunction
	 */
	public var accessoryLabelField(default, default):String;
	/**
	 * @private
	 */
	@:protected private var _accessoryLabelFunction:Dynamic->String;

	/**
	 * A function that returns a string to be displayed in a
	 * renderer-managed <code>Label</code> in the accessory position of the
	 * renderer. The renderer will automatically reuse an internal
	 * <code>Label</code> and swap the text when the data changes. This
	 * <code>Label</code> may be skinned by changing the
	 * <code>accessoryLabelFactory</code>.
	 *
	 * <p>Using an accessory label will result in better performance than
	 * passing in a <code>Label</code> through a <code>accessoryField</code>
	 * or <code>accessoryFunction</code> because the renderer can aVoid
	 * costly display list manipulation.</p>
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):String</pre>
	 *
	 * <p>All of the accessory fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>accessoryTextureFunction</code></li>
	 *     <li><code>accessoryTextureField</code></li>
	 *     <li><code>accessoryLabelFunction</code></li>
	 *     <li><code>accessoryLabelField</code></li>
	 *     <li><code>accessoryFunction</code></li>
	 *     <li><code>accessoryField</code></li>
	 * </ol>
	 *
	 * @see #accessoryLabelFactory
	 * @see #accessoryLabelField
	 * @see #accessoryField
	 * @see #accessoryFunction
	 * @see #accessoryTextureField
	 * @see #accessoryTextureFunction
	 */
	public var accessoryLabelFunction(default,default):Dynamic->String;

	/**
	 * @private
	 */
	@:protected private var _iconLoaderFactory:Dynamic->Image;// = defaultImageFactory;

	/**
	 * A function that generates an <code>Image</code> that uses the result
	 * of <code>iconSourceField</code> or <code>iconSourceFunction</code>.
	 * Useful for transforming the <code>Image</code> in some way. For
	 * example, you might want to scale it for current DPI.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function():Image</pre>
	 * <pre>function():ImageLoader</pre>
	 *
	 * @see #iconSourceField;
	 * @see #iconSourceFunction;
	 */
	public var iconLoaderFactory(default, default):Void->ImageLoader;
	
	/**
	 * @private
	 */
	@:protected private var _accessoryLoaderFactory:Dynamic->Image;// = defaultImageFactory;
	
	/**
	 * A function that generates an <code>ImageLoader</code> that uses the result
     * of <code>accessorySourceField</code> or <code>accessorySourceFunction</code>.
     * Useful for transforming the <code>ImageLoader</code> in some way. For
     * example, you might want to scale the texture for current DPI or apply
     * pixel snapping.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function():Image</pre>
	 * <pre>function():ImageLoader</pre>
	 *
	 * @see feathers.controls.ImageLoader
     * @see #accessorySourceField;
     * @see #accessorySourceFunction;
	 */
	public var accessoryLoaderFactory(default, default):Void->ImageLoader;
	
	/**
	 * @private
	 */
	@:protected private var _accessoryLabelFactory:Void->ITextRenderer;

	/**
	 * A function that generates <code>ITextRenderer</code> that uses the result
	 * of <code>accessoryLabelField</code> or <code>accessoryLabelFunction</code>.
	 * Useful for skinning the <code>ITextRenderer</code>.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function():ITextRenderer</pre>
	 *
	 * @see #accessoryLabelField;
	 * @see #accessoryLabelFunction;
	 */
	public var accessoryLabelFactory(default, default):Void->ITextRenderer;
	
	/**
	 * A set of key/value pairs to be passed down to a label accessory.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * @see #accessoryLabelField
	 * @see #accessoryLabelFunction
	 */
	public var accessoryLabelProperties(default, default):Dynamic;
	/**
	 * @private
	 */
	/**
	 * Using <code>labelField</code> and <code>labelFunction</code>,
	 * generates a label from the item.
	 *
	 * <p>All of the label fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>labelFunction</code></li>
	 *     <li><code>labelField</code></li>
	 * </ol>
	 */
	public function itemToLabel(item:Dynamic):String;

	/**
	 * Uses the icon fields and functions to generate an icon for a specific
	 * item.
	 *
	 * <p>All of the icon fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>iconSourceFunction</code></li>
	 *     <li><code>iconSourceField</code></li>
	 *     <li><code>iconFunction</code></li>
	 *     <li><code>iconField</code></li>
	 * </ol>
	 */
	@:protected private function itemToIcon(item:Dynamic):DisplayObject;

	/**
	 * Uses the accessory fields and functions to generate an accessory for
	 * a specific item.
	 *
	 * <p>All of the accessory fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>accessoryTextureFunction</code></li>
	 *     <li><code>accessoryTextureField</code></li>
	 *     <li><code>accessoryLabelFunction</code></li>
	 *     <li><code>accessoryLabelField</code></li>
	 *     <li><code>accessoryFunction</code></li>
	 *     <li><code>accessoryField</code></li>
	 * </ol>
	 */
	@:protected private function itemToAccessory(item:Dynamic):DisplayObject;
	
	
	/**
	 * @private
	 */
	@:protected private function addIconWidth(width:Float, gap:Float):Float;
	
	/**
	 * @private
	 */
	@:protected private function addAccessoryWidth(width:Float, gap:Float):Float;
		
	/**
		 * @private
		 */
	@:protected private function addIconHeight(height:Float, gap:Float):Float;
		
	/**
	 * @private
	 */
	@:protected private function addAccessoryHeight(height:Float, gap:Float):Float;
		
	/**
	 * @private
	 */
	@:protected private function positionRelativeToOthers(object:DisplayObject, relativeTo:DisplayObject, relativeTo2:DisplayObject, position:String, gap:Float):Void;
	
	/**
	 * @private
	 */
	@:protected private function commitData():Void;
	
	/**
	 * @private
	 */
	@:protected private function replaceIcon(newIcon:DisplayObject):Void;
		
	/**
	 * @private
	 */
	@:protected private function replaceAccessory(newAccessory:DisplayObject):Void;
		
		
	/**
	 * @private
	 */
	@:protected private function refreshAccessoryLabelStyles():Void;

	/**
	 * @private
	 */
	@:protected private function refreshIconTexture(texture:Texture):Void;

	/**
	 * @private
	 */
	@:protected private function refreshAccessorySource(source:Dynamic):Void;
	
	/**
	 * @private
	 */
	@:protected private function refreshAccessoryLabel(label:String):Void;

	/**
	 * @private
	 */
	@:protected private function handleOwnerScroll():Void;

	/**
	 * @private
	 */
	@:protected private function accessoryLabelProperties_onChange(proxy:PropertyProxy, name:String):Void;

	/**
	 * @private
	 */
	@:protected private function stateDelayTimer_timerCompleteHandler(event:TimerEvent):Void;
	/**
	 * @private
	 */
	@:protected private function accessory_touchHandler(event:TouchEvent):Void;
	
	/**
	 * @private
	 */
	@:protected private function loader_completeOrErrorHandler(event:Event):Void;
		
}