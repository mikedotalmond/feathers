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
package feathers.core;

import feathers.controls.text.BitmapFontTextRenderer;
import feathers.controls.text.StageTextTextEditor;
import feathers.events.FeathersEventType;
import feathers.events.FeathersEventType;
import starling.display.Sprite;

import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.utils.MatrixUtil;

extern class FeathersControl extends Sprite, implements IFeathersControl
{
	/**
	 * @private
	 */
	private static var HELPER_MATRIX:Matrix;

	/**
	 * @private
	 */
	private static var HELPER_POINT:Point;

	/**
	 * @private
	 * Meant to be constant, but the ValidationQueue needs access to
	 * Starling in its constructor, so it needs to be instantiated after
	 * Starling is initialized.
	 */
	private static var VALIDATION_QUEUE:ValidationQueue;

	/**
	 * Flag to indicate that everything is invalid and should be redrawn.
	 */
	public static var INVALIDATION_FLAG_ALL:String;

	/**
	 * Invalidation flag to indicate that the state has changed. Used by
	 * <code>isEnabled</code>, but may be used for other control states too.
	 *
	 * @see #isEnabled
	 */
	public static var INVALIDATION_FLAG_STATE:String;

	/**
	 * Invalidation flag to indicate that the dimensions of the UI control
	 * have changed.
	 */
	public static var INVALIDATION_FLAG_SIZE:String;

	/**
	 * Invalidation flag to indicate that the styles or visual appearance of
	 * the UI control has changed.
	 */
	public static var INVALIDATION_FLAG_STYLES:String;

	/**
	 * Invalidation flag to indicate that the skin of the UI control has changed.
	 */
	public static var INVALIDATION_FLAG_SKIN:String;

	/**
	 * Invalidation flag to indicate that the layout of the UI control has
	 * changed.
	 */
	public static var INVALIDATION_FLAG_LAYOUT:String;

	/**
	 * Invalidation flag to indicate that the primary data displayed by the
	 * UI control has changed.
	 */
	public static var INVALIDATION_FLAG_DATA:String;

	/**
	 * Invalidation flag to indicate that the scroll position of the UI
	 * control has changed.
	 */
	public static var INVALIDATION_FLAG_SCROLL:String;

	/**
	 * Invalidation flag to indicate that the selection of the UI control
	 * has changed.
	 */
	public static var INVALIDATION_FLAG_SELECTED:String;

	/**
	 * @private
	 */
	private static var INVALIDATION_FLAG_TEXT_RENDERER:String;

	/**
	 * @private
	 */
	private static var INVALIDATION_FLAG_TEXT_EDITOR:String;
	
	
	 /**
     * @private
     * Used for clipping.
	 * @see #clipRect
	 */
    @:protected private static var currentScissorRect:Rectangle;

	/**
	 * A function used by all UI controls that support text renderers to
	 * create an ITextRenderer instance. You may replace the default
	 * function with your own, if you prefer not to use the
	 * BitmapFontTextRenderer.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function():ITextRenderer</pre>
	 *
	 * @see http://wiki.starling-framework.org/feathers/text-renderers
	 * @see feathers.core.ITextRenderer
	 */
	public static var defaultTextRendererFactory:Void->ITextRenderer;

	/**
	 * A function used by all UI controls that support text editor to
	 * create an <code>ITextEditor</code> instance. You may replace the
	 * default function with your own, if you prefer not to use the
	 * <code>StageTextTextEditor</code>.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * <pre>function():ITextEditor</pre>
	 *
	 * @see http://wiki.starling-framework.org/feathers/text-editors
	 * @see feathers.core.ITextEditor
	 */
	public static var defaultTextEditorFactory:Void->ITextEditor;

	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * Contains a list of all "names" assigned to this control. Names are
	 * like classes in CSS selectors. They are a non-unique identifier that
	 * can differentiate multiple styles of the same type of UI control. A
	 * single control may have many names, and many controls can share a
	 * single name. Names may be added, removed, or toggled on the <code>nameList</code>.
	 *
	 * @see #name
	 */
	public var nameList:TokenList;
	

	/**
	 * The concatenated <code>nameList</code>, with each name separated by
	 * spaces. Names are like classes in CSS selectors. They are a
	 * non-unique identifier that can differentiate multiple styles of the
	 * same type of UI control. A single control may have many names, and
	 * many controls can share a single name.
	 *
	 * @see #nameList
	 */
	
	/**
	 * Similar to mouseChildren on the classic display list. If true,
	 * children cannot dispatch touch events, but hit tests will be much
	 * faster.
	 */
	public var isQuickHitAreaEnabled(default, default):Bool;

	/**
	 * Determines if the component has been initialized yet. The
	 * <code>initialize()</code> function is called one time only, when the
	 * Feathers UI control is added to the display list for the first time.
	 */
	public var isInitialized:Bool;

	/**
	 * Indicates whether the control is interactive or not.
	 */
	public var isEnabled:Bool;

	/**
	 * If using <code>isQuickHitAreaEnabled</code>, and the hit area's
	 * width is smaller than this value, it will be expanded.
	 */
	public var minTouchWidth:Float;
	
	/**
	 * If using <code>isQuickHitAreaEnabled</code>, and the hit area's
	 * height is smaller than this value, it will be expanded.
	 */
	public var minTouchHeight:Float;
	
	/**
	 * The minimum recommended width to be used for self-measurement and,
	 * optionally, by any code that is resizing this component. This value
	 * is not strictly enforced in all cases. An explicit width value that
	 * is smaller than <code>minWidth</code> may be set and will not be
	 * affected by the minimum.
	 */
	public var minWidth:Float;
	
	/**
	 * The minimum recommended height to be used for self-measurement and,
	 * optionally, by any code that is resizing this component. This value
	 * is not strictly enforced in all cases. An explicit height value that
	 * is smaller than <code>minHeight</code> may be set and will not be
	 * affected by the minimum.
	 */
	public var minHeight:Float;
	
	/**
	 * The maximum recommended width to be used for self-measurement and,
	 * optionally, by any code that is resizing this component. This value
	 * is not strictly enforced in all cases. An explicit width value that
	 * is larger than <code>maxWidth</code> may be set and will not be
	 * affected by the maximum.
	 */
	public var maxWidth:Float;
	
	/**
	 * The maximum recommended height to be used for self-measurement and,
	 * optionally, by any code that is resizing this component. This value
	 * is not strictly enforced in all cases. An explicit height value that
	 * is larger than <code>maxHeight</code> may be set and will not be
	 * affected by the maximum.
	 */
	public var maxHeight:Float;
	
	
	/**
	 * When called, the UI control will redraw within one frame.
	 * Invalidation limits processing so that multiple property changes only
	 * trigger a single redraw.
	 *
	 * <p>If the UI control isn't on the display list, it will never redraw.
	 * The control will automatically invalidate once it has been added.</p>
	 */
	public function invalidate(flag:String = INVALIDATION_FLAG_ALL):Void;

	/**
	 * Immediately validates the control, which triggers a redraw, if one
	 * is pending.
	 */
	public function validate():Void;

	/**
	 * Indicates whether the control is invalid or not. You may optionally
	 * pass in a specific flag to check if that particular flag is set. If
	 * the "all" flag is set, the result will always be true.
	 */
	public function isInvalid(flag:String = null):Bool;

	/**
	 * Sets both the width and the height of the control.
	 */
	public function setSize(width:Float, height:Float):Void;

	/**
	 * Sets the width and height of the control, with the option of
	 * invalidating or not. Intended to be used for automatic resizing.
	 */
	private function setSizeInternal(width:Float, height:Float, canInvalidate:Bool):Bool;

	/**
	 * Override to initialize the UI control. Should be used to create
	 * children and set up event listeners.
	 */
	@:protected function initialize():Void;

	/**
	 * Override to customize layout and to adjust properties of children.
	 */
	@:protected function draw():Void;
	
	
}