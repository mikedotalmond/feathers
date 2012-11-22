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
import feathers.core.ITextRenderer;
import feathers.core.PropertyProxy;

import flash.geom.Point;

import starling.display.DisplayObject;

/**
 * Displays text.
 *
 * @see http://wiki.starling-framework.org/feathers/label
 */
extern class Label extends FeathersControl {

	/**
	 * @private
	 */
	private static var HELPER_POINT:Point;//new Point();

	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * The text renderer.
	 */
	private var textRenderer:ITextRenderer;

	/**
	 * @private
	 */
	private var _text:String;//"";

	/**
	 * The text displayed by the label.
	 */
	public var text(default, default):String;


	/**
	 * @private
	 */
	private var _textRendererFactory:Void->ITextRenderer;

	/**
	 * A function used to instantiate the text renderer. If null,
	 * <code>FeathersControl.defaultTextRendererFactory</code> is used
	 * instead.
	 *
	 * <p>The factory should have the following function signature:</p>
	 * <pre>function():ITextRenderer</pre>
	 *
	 * @see feathers.core.ITextRenderer
	 * @see feathers.core.FeathersControl#defaultTextRendererFactory
	 */
	public var textRendererFactory(default, default):Void->ITextRenderer;


	/**
	 * @private
	 */
	private var _textRendererProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to the text renderer.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 */
	public var textRendererProperties(default, default):Dynamic;

	
	/**
	 * @private
	 */
	private function autoSizeIfNeeded():Bool;

	/**
	 * @private
	 */
	private function createTextRenderer():Void;

	/**
	 * @private
	 */
	private function refreshEnabled():Void;

	/**
	 * @private
	 */
	private function refreshTextRendererData():Void;

	/**
	 * @private
	 */
	private function refreshTextRendererStyles():Void;

	/**
	 * @private
	 */
	private function layout():Void;

	/**
	 * @private
	 */
	private function textRendererProperties_onChange(proxy:PropertyProxy, propertyName:String):Void;
}
