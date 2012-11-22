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
import feathers.controls.text.BitmapFontTextRenderer;
import feathers.core.FeathersControl;
import feathers.core.IFeathersControl;
import feathers.core.ITextRenderer;
import feathers.core.PropertyProxy;

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
	 * @private
	 */
	private static var HELPER_POINT:Point;//new Point();

	/**
	 * @private
	 */
	private static var DOWN_STATE_DELAY_MS:Int;//250;

	/**
	 * @private
	 */
	private static function defaultImageFactory(texture:Texture):Image
	{
		return new Image(texture);
	}

	/**
	 * Constructor.
	 */
	public function new():Void;
	
	/**
	 * The value added to the <code>nameList</code> of the accessory label.
	 */
	private var accessoryLabelName:String;// = DEFAULT_CHILD_NAME_ACCESSORY_LABEL;

	/**
	 * @private
	 */
	private var iconImage:Image;

	/**
	 * @private
	 */
	private var accessoryImage:Image;

	/**
	 * @private
	 */
	private var accessoryLabel:ITextRenderer;

	/**
	 * @private
	 */
	private var accessory:DisplayObject;

	/**
	 * @private
	 */
	private var _data:Dynamic;

	/**
	 * The item displayed by this renderer.
	 */
	public var data(default, default):Dynamic;
	
	/**
	 * @private
	 */
	private var _owner:IFeathersControl;

	/**
	 * @private
	 */
	private var _delayedCurrentState:String;

	/**
	 * @private
	 */
	private var _stateDelayTimer:Timer;

	/**
	 * @private
	 */
	private var _useStateDelayTimer:Bool;//true;

	/**
	 * If true, the down state (and subsequent state changes) will be
	 * delayed to make scrolling look nicer.
	 */
	public var useStateDelayTimer(default, default):Bool;

	/**
	 * @private
	 */
	private var _itemHasLabel:Bool;//true;

	/**
	 * If true, the label will come from the renderer's item using the
	 * appropriate field or function for the label. If false, the label may
	 * be set externally.
	 */
	public var itemHasLabel(default, default):Bool;

	/**
	 * @private
	 */
	private var _itemHasIcon:Bool;//true;

	/**
	 * If true, the icon will come from the renderer's item using the
	 * appropriate field or function for the icon. If false, the icon may
	 * be skinned for each state externally.
	 */
	public var itemHasIcon(default, default):Bool;
	
	/**
	 * @private
	 */
	private var _labelField:String;//"label";

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
	private var _labelFunction:Dynamic->String;

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
	private var _iconField:String;//"icon";

	/**
	 * The field in the item that contains a display object to be displayed
	 * as an icon or other graphic next to the label in the renderer.
	 *
	 * <p>All of the icon fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>iconTextureFunction</code></li>
	 *     <li><code>iconTextureField</code></li>
	 *     <li><code>iconFunction</code></li>
	 *     <li><code>iconField</code></li>
	 * </ol>
	 *
	 * @see #iconFunction
	 * @see #iconTextureField
	 * @see #iconTextureFunction
	 */
	public var iconField(default, default):String;

	/**
	 * @private
	 */
	private var _iconFunction:Dynamic->DisplayObject;

	/**
	 * A function used to generate an icon for a specific item.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):DisplayObject</pre>
	 *
	 * <p>All of the icon fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>iconTextureFunction</code></li>
	 *     <li><code>iconTextureField</code></li>
	 *     <li><code>iconFunction</code></li>
	 *     <li><code>iconField</code></li>
	 * </ol>
	 *
	 * @see #iconField
	 * @see #iconTextureField
	 * @see #iconTextureFunction
	 */
	public var iconFunction(default, default):Dynamic->DisplayObject;

	/**
	 * @private
	 */
	private var _iconTextureField:String;//"iconTexture";

	/**
	 * The field in the item that contains a texture to be used for the
	 * renderer's icon. The renderer will automatically manage and reuse an
	 * internal <code>Image</code>. This <code>Image</code> may be
	 * customized by changing the <code>iconImageFactory</code>.
	 *
	 * <p>All of the icon fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>iconTextureFunction</code></li>
	 *     <li><code>iconTextureField</code></li>
	 *     <li><code>iconFunction</code></li>
	 *     <li><code>iconField</code></li>
	 * </ol>
	 *
	 * @see #iconImageFactory
	 * @see #iconTextureFunction
	 * @see #iconField
	 * @see #iconFunction
	 * @see starling.textures.Texture
	 */
	public var iconTextureField(default, default):String;

	/**
	 * @private
	 */
	private var _iconTextureFunction:Dynamic->Texture;

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
	 *     <li><code>iconTextureFunction</code></li>
	 *     <li><code>iconTextureField</code></li>
	 *     <li><code>iconFunction</code></li>
	 *     <li><code>iconField</code></li>
	 * </ol>
	 *
	 * @see #iconImageFactory
	 * @see #iconTextureField
	 * @see #iconField
	 * @see #iconFunction
	 * @see starling.textures.Texture
	 */
	public var iconTextureFunction(default, default):Dynamic->Texture;

	/**
	 * @private
	 */
	private var _accessoryField:String;//"accessory";

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
	private var _accessoryTextureField:String;//"accessoryTexture";

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
	public var accessoryTextureField(default,default):String;

	/**
	 * @private
	 */
	private var _accessoryTextureFunction:Dynamic->Texture;

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
	public var accessoryTextureFunction(default,default):Dynamic->Texture;
	/**
	 * @private
	 */
	private var _accessoryLabelField:String;//"accessoryLabel";

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
	private var _accessoryLabelFunction:Dynamic->String;

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
	private var _iconImageFactory:Dynamic->Image;// = defaultImageFactory;

	/**
	 * A function that generates an <code>Image</code> that uses the result
	 * of <code>iconTextureField</code> or <code>iconTextureFunction</code>.
	 * Useful for transforming the <code>Image</code> in some way. For
	 * example, you might want to scale it for current DPI.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function():Image</pre>
	 *
	 * @see #iconTextureField;
	 * @see #iconTextureFunction;
	 */
	public var iconImageFactory(default, default):Dynamic->Image;

	/**
	 * @private
	 */
	private var _accessoryImageFactory:Dynamic->Image;// = defaultImageFactory;

	/**
	 * A function that generates an <code>Image</code> that uses the result
	 * of <code>accessoryTextureField</code> or <code>accessoryTextureFunction</code>.
	 * Useful for transforming the <code>Image</code> in some way. For
	 * example, you might want to scale it for current DPI.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function():Image</pre>
	 *
	 * @see #accessoryTextureField;
	 * @see #accessoryTextureFunction;
	 */
	public var accessoryImageFactory(default, default):Texture->Image;
	
	/**
	 * @private
	 */
	private var _accessoryLabelFactory:Void->ITextRenderer;

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
	 *     <li><code>iconTextureFunction</code></li>
	 *     <li><code>iconTextureField</code></li>
	 *     <li><code>iconFunction</code></li>
	 *     <li><code>iconField</code></li>
	 * </ol>
	 */
	private function itemToIcon(item:Dynamic):DisplayObject;

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
	private function itemToAccessory(item:Dynamic):DisplayObject;
	
	/**
	 * @private
	 */
	private function commitData():Void;
	
	/**
	 * @private
	 */
	private function refreshAccessoryLabelStyles():Void;

	/**
	 * @private
	 */
	private function refreshIconTexture(texture:Texture):Void;

	/**
	 * @private
	 */
	private function refreshAccessoryTexture(texture:Texture):Void;
	
	/**
	 * @private
	 */
	private function refreshAccessoryLabel(label:String):Void;

	/**
	 * @private
	 */
	private function handleOwnerScroll():Void;

	/**
	 * @private
	 */
	private function accessoryLabelProperties_onChange(proxy:PropertyProxy, name:String):Void;

	/**
	 * @private
	 */
	private function stateDelayTimer_timerCompleteHandler(event:TimerEvent):Void;
	/**
	 * @private
	 */
	private function accessory_touchHandler(event:TouchEvent):Void;
}