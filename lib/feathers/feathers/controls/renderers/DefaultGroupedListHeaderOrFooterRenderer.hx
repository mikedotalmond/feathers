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
import feathers.controls.GroupedList;
import feathers.controls.ImageLoader;
import feathers.controls.Label;
import feathers.core.FeathersControl;
import feathers.core.ITextRenderer;
import feathers.core.PropertyProxy;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.textures.Texture;

/**
 * The default renderer used for headers and footers in a GroupedList
 * control.
 */
extern class DefaultGroupedListHeaderOrFooterRenderer extends FeathersControl, implements IGroupedListHeaderOrFooterRenderer
{
	/**
	 * The content will be aligned horizontally to the left edge of the renderer.
	 */
	public static var HORIZONTAL_ALIGN_LEFT:String;//"left";

	/**
	 * The content will be aligned horizontally to the center of the renderer.
	 */
	public static var HORIZONTAL_ALIGN_CENTER:String;//"center";

	/**
	 * The content will be aligned horizontally to the right edge of the renderer.
	 */
	public static var HORIZONTAL_ALIGN_RIGHT:String;//"right";

	/**
	 * The content will be aligned vertically to the top edge of the renderer.
	 */
	public static var VERTICAL_ALIGN_TOP:String;//"top";

	/**
	 * The content will be aligned vertically to the middle of the renderer.
	 */
	public static var VERTICAL_ALIGN_MIDDLE:String;//"middle";

	/**
	 * The content will be aligned vertically to the bottom edge of the renderer.
	 */
	public static var VERTICAL_ALIGN_BOTTOM:String;//"bottom";

	/**
	 * The default value added to the <code>nameList</code> of the content
	 * label.
	 */
	public static var DEFAULT_CHILD_NAME_CONTENT_LABEL:String;//"feathers-header-footer-renderer-content-label";

	/**
	 * The value added to the <code>nameList</code> of the content label.
	 */
	private var contentLabelName:String;// = DEFAULT_CHILD_NAME_CONTENT_LABEL;

	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * @private
	 */
	private var contentImage:Image;

	/**
	 * @private
	 */
	private var contentLabel:ITextRenderer;

	/**
	 * @private
	 */
	private var content:DisplayObject;

	/**
	 * @private
	 */
	private var _data:Dynamic;

	/**
	 * @inheritDoc
	 */
	public var data(default, default):Dynamic;

	/**
	 * @private
	 */
	private var _groupIndex:Int;//-1;

	/**
	 * @inheritDoc
	 */
	public var groupIndex(default, default):Int;
	
	/**
	 * @private
	 */
	private var _layoutIndex:Int;//-1;

	/**
	 * @inheritDoc
	 */
	public var layoutIndex(default, default):Int;

	/**
	 * @private
	 */
	private var _owner:GroupedList;

	/**
	 * @inheritDoc
	 */
	public var owner(default, default):GroupedList;
	

	/**
	 * @private
	 */
	private var _horizontalAlign:String;// = HORIZONTAL_ALIGN_LEFT;

	/**
	 * The location where the renderer's content is aligned horizontally
	 * (on the x-axis).
	 */
	public var horizontalAlign(default, default):String;

	/**
	 * @private
	 */
	private var _verticalAlign:String;// = VERTICAL_ALIGN_MIDDLE;

	/**
	 * The location where the renderer's content is aligned vertically (on
	 * the y-axis).
	 */
	public var verticalAlign(default, default):String;


	/**
	 * @private
	 */
	private var _contentField:String;//"content";

	/**
	 * The field in the item that contains a display object to be positioned
	 * in the content position of the renderer. If you wish to display an
	 * <code>Image</code> in the content position, it's better for
	 * performance to use <code>contentTextureField</code> instead.
	 *
	 * <p>All of the content fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>contentTextureFunction</code></li>
	 *     <li><code>contentTextureField</code></li>
	 *     <li><code>contentLabelFunction</code></li>
	 *     <li><code>contentLabelField</code></li>
	 *     <li><code>contentFunction</code></li>
	 *     <li><code>contentField</code></li>
	 * </ol>
	 *
	 * @see #contentTextureField
	 * @see #contentFunction
	 * @see #contentTextureFunction
	 * @see #contentLabelField
	 * @see #contentLabelFunction
	 */
	public var contentField(default, default):String;
	

	/**
	 * @private
	 */
	private var _contentFunction:Dynamic->DisplayObject;

	/**
	 * A function that returns a display object to be positioned in the
	 * content position of the renderer. If you wish to display an
	 * <code>Image</code> in the content position, it's better for
	 * performance to use <code>contentTextureFunction</code> instead.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):DisplayObject</pre>
	 *
	 * <p>All of the content fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>contentTextureFunction</code></li>
	 *     <li><code>contentTextureField</code></li>
	 *     <li><code>contentLabelFunction</code></li>
	 *     <li><code>contentLabelField</code></li>
	 *     <li><code>contentFunction</code></li>
	 *     <li><code>contentField</code></li>
	 * </ol>
	 *
	 * @see #contentField
	 * @see #contentTextureField
	 * @see #contentTextureFunction
	 * @see #contentLabelField
	 * @see #contentLabelFunction
	 */
	public var contentFunction(default, default):Dynamic->DisplayObject;

	/**
	 * @private
	 */
	private var _contentTextureField:String;//"texture";

	/**
	 * The field in the item that contains a texture to be displayed in a
	 * renderer-managed <code>Image</code> in the content position of the
	 * renderer. The renderer will automatically reuse an internal
	 * <code>Image</code> and swap the texture when the renderer's data
	 * changes. This <code>Image</code> may be customized by
	 * changing the <code>contentImageFactory</code>.
	 *
	 * <p>Using an content texture will result in better performance than
	 * passing in an <code>Image</code> through a <code>contentField</code>
	 * or <code>contentFunction</code> because the renderer can aVoid
	 * costly display list manipulation.</p>
	 *
	 * <p>All of the content fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>contentTextureFunction</code></li>
	 *     <li><code>contentTextureField</code></li>
	 *     <li><code>contentLabelFunction</code></li>
	 *     <li><code>contentLabelField</code></li>
	 *     <li><code>contentFunction</code></li>
	 *     <li><code>contentField</code></li>
	 * </ol>
	 *
	 * @see #contentImageFactory
	 * @see #contentTextureFunction
	 * @see #contentField
	 * @see #contentFunction
	 * @see #contentLabelField
	 * @see #contentLabelFunction
	 */
	public var contentTextureField(default, default):String;

	/**
	 * @private
	 */
	private var _contentTextureFunction:Dynamic->Texture;

	/**
	 * A function that returns a texture to be displayed in a
	 * renderer-managed <code>Image</code> in the content position of the
	 * renderer. The renderer will automatically reuse an internal
	 * <code>Image</code> and swap the texture when the renderer's data
	 * changes. This <code>Image</code> may be customized by
	 * changing the <code>contentImageFactory</code>.
	 *
	 * <p>Using an content texture will result in better performance than
	 * passing in an <code>Image</code> through a <code>contentField</code>
	 * or <code>contentFunction</code> because the renderer can aVoid
	 * costly display list manipulation.</p>
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):Texture</pre>
	 *
	 * <p>All of the content fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>contentTextureFunction</code></li>
	 *     <li><code>contentTextureField</code></li>
	 *     <li><code>contentLabelFunction</code></li>
	 *     <li><code>contentLabelField</code></li>
	 *     <li><code>contentFunction</code></li>
	 *     <li><code>contentField</code></li>
	 * </ol>
	 *
	 * @see #contentImageFactory
	 * @see #contentTextureField
	 * @see #contentField
	 * @see #contentFunction
	 * @see #contentLabelField
	 * @see #contentLabelFunction
	 */
	public var contentTextureFunction(default, default):Dynamic->Texture;

	/**
	 * @private
	 */
	private var _contentLabelField:String;//"label";

	/**
	 * The field in the item that contains a string to be displayed in a
	 * renderer-managed <code>Label</code> in the content position of the
	 * renderer. The renderer will automatically reuse an internal
	 * <code>Label</code> and swap the text when the data changes. This
	 * <code>Label</code> may be skinned by changing the
	 * <code>contentLabelFactory</code>.
	 *
	 * <p>Using an content label will result in better performance than
	 * passing in a <code>Label</code> through a <code>contentField</code>
	 * or <code>contentFunction</code> because the renderer can aVoid
	 * costly display list manipulation.</p>
	 *
	 * <p>All of the content fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>contentTextureFunction</code></li>
	 *     <li><code>contentTextureField</code></li>
	 *     <li><code>contentLabelFunction</code></li>
	 *     <li><code>contentLabelField</code></li>
	 *     <li><code>contentFunction</code></li>
	 *     <li><code>contentField</code></li>
	 * </ol>
	 *
	 * @see #contentLabelFactory
	 * @see #contentLabelFunction
	 * @see #contentField
	 * @see #contentFunction
	 * @see #contentTextureField
	 * @see #contentTextureFunction
	 */
	public var contentLabelField(default, default):String;

	/**
	 * @private
	 */
	private var _contentLabelFunction:Dynamic->String;

	/**
	 * A function that returns a string to be displayed in a
	 * renderer-managed <code>Label</code> in the content position of the
	 * renderer. The renderer will automatically reuse an internal
	 * <code>Label</code> and swap the text when the data changes. This
	 * <code>Label</code> may be skinned by changing the
	 * <code>contentLabelFactory</code>.
	 *
	 * <p>Using an content label will result in better performance than
	 * passing in a <code>Label</code> through a <code>contentField</code>
	 * or <code>contentFunction</code> because the renderer can aVoid
	 * costly display list manipulation.</p>
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function( item:Dynamic ):String</pre>
	 *
	 * <p>All of the content fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>contentTextureFunction</code></li>
	 *     <li><code>contentTextureField</code></li>
	 *     <li><code>contentLabelFunction</code></li>
	 *     <li><code>contentLabelField</code></li>
	 *     <li><code>contentFunction</code></li>
	 *     <li><code>contentField</code></li>
	 * </ol>
	 *
	 * @see #contentLabelFactory
	 * @see #contentLabelField
	 * @see #contentField
	 * @see #contentFunction
	 * @see #contentTextureField
	 * @see #contentTextureFunction
	 */
	public var contentLabelFunction(default, default):Dynamic->String;


	/**
	 * Uses the content fields and functions to generate content for a
	 * specific group header or footer.
	 *
	 * <p>All of the content fields and functions, ordered by priority:</p>
	 * <ol>
	 *     <li><code>contentTextureFunction</code></li>
	 *     <li><code>contentTextureField</code></li>
	 *     <li><code>contentLabelFunction</code></li>
	 *     <li><code>contentLabelField</code></li>
	 *     <li><code>contentFunction</code></li>
	 *     <li><code>contentField</code></li>
	 * </ol>
	 */
	private function itemToContent(item:Dynamic):DisplayObject;
	
	/**
	 * @private
	 */
	@:protected private var _contentLoaderFactory:Void->ImageLoader;// = defaultImageFactory;

	/**
	 * A function that generates an <code>ImageLoader</code> that uses the result
	 * of <code>contentSourceField</code> or <code>contentSourceFunction</code>.
	 * Useful for transforming the <code>ImageLoader</code> in some way. For
	 * example, you might want to scale it for current DPI or apply pixel
	 * snapping.
	 *
	 * @see #contentSourceField
	 * @see #contentSourceFunction
	 */
	public var contentLoaderFactory(default, default):Void->ImageLoader;

	/**
	 * @private
	 */
	private var _contentLabelFactory:Void->Label;

	/**
	 * A function that generates <code>Label</code> that uses the result
	 * of <code>contentLabelField</code> or <code>contentLabelFunction</code>.
	 * Useful for skinning the <code>Label</code>.
	 *
	 * @see #contentLabelField;
	 * @see #contentLabelFunction;
	 */
	public var contentLabelFactory(default, default):Void->Label;
	

	/**
	 * @private
	 */
	private var _contentLabelProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to a content label.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * @see #contentLabelField
	 * @see #contentLabelFunction
	 */
	public var contentLabelProperties(default, default):Dynamic;
	
	/**
	 * @private
	 */
	private var originalBackgroundWidth:Float;//;//

	/**
	 * @private
	 */
	private var originalBackgroundHeight:Float;//;//

	/**
	 * @private
	 */
	private var currentBackgroundSkin:DisplayObject;

	/**
	 * @private
	 */
	private var _backgroundSkin:DisplayObject;

	/**
	 * A background to behind the component's content.
	 */
	public var backgroundSkin(default, default):DisplayObject;

	/**
	 * @private
	 */
	private var _backgroundDisabledSkin:DisplayObject;

	/**
	 * A background to display when the component is disabled.
	 */
	public var backgroundDisabledSkin(default, default):DisplayObject;

	/**
	 * @private
	 */
	private var _paddingTop:Float;//0;

	/**
	 * The minimum space, in pixels, between the component's top edge and
	 * the component's content.
	 */
	public var paddingTop(default, default):Float;


	/**
	 * @private
	 */
	private var _paddingRight:Float;//0;

	/**
	 * The minimum space, in pixels, between the component's right edge
	 * and the component's content.
	 */
	public var paddingRight(default, default):Float;

	/**
	 * @private
	 */
	private var _paddingBottom:Float;//0;

	/**
	 * The minimum space, in pixels, between the component's bottom edge
	 * and the component's content.
	 */
	public var paddingBottom(default, default):Float;

	/**
	 * @private
	 */
	private var _paddingLeft:Float;//0;

	/**
	 * The minimum space, in pixels, between the component's left edge
	 * and the component's content.
	 */
	public var paddingLeft(default, default):Float;

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
	private function commitData():Void;

	/**
	 * @private
	 */
	private function refreshContentTexture(texture:Texture):Void;

	/**
	 * @private
	 */
	private function refreshContentLabel(label:String):Void;

	/**
	 * @private
	 */
	private function refreshContentLabelStyles():Void;

	/**
	 * @private
	 */
	private function layout():Void;

	/**
	 * @private
	 */
	private function contentLabelProperties_onChange(proxy:PropertyProxy, name:String):Void;
}
