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
//import feathers.utils.math.clamp;

import starling.display.DisplayObject;

/**
 * Displays the progress of a task over time. Non-interactive.
 *
 * @see http://wiki.starling-framework.org/feathers/progress-bar
 */
extern class ProgressBar extends FeathersControl {
	/**
	 * The progress bar fills horizontally (on the x-axis).
	 */
	public static var DIRECTION_HORIZONTAL:String;//"horizontal";

	/**
	 * The progress bar fills vertically (on the y-axis).
	 */
	public static var DIRECTION_VERTICAL:String;//"vertical";

	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * @private
	 */
	private var _direction:String;// = DIRECTION_HORIZONTAL;

	@:meta(Inspectable(type="String",enumeration="horizontal,vertical"))
	/**
	 * Determines the direction that the progress bar fills. When this value
	 * changes, the progress bar's width and height values do not change
	 * automatically.
	 */
	public var direction(default, default):String;


	/**
	 * @private
	 */
	private var _value:Float;//0;

	/**
	 * The value of the progress bar, between the minimum and maximum.
	 */
	public var value(default, default):Float;


	/**
	 * @private
	 */
	private var _minimum:Float;//0;

	/**
	 * The progress bar's value will not go lower than the minimum.
	 */
	public var minimum(default, default):Float;

	/**
	 * @private
	 */
	private var _maximum:Float;//1;

	/**
	 * The progress bar's value will not go higher than the maximum.
	 */
	public var maximum(default, default):Float;


	/**
	 * @private
	 */
	private var _originalBackgroundWidth:Float;//;//

	/**
	 * @private
	 */
	private var _originalBackgroundHeight:Float;//;//

	/**
	 * @private
	 */
	private var currentBackground:DisplayObject;

	/**
	 * @private
	 */
	private var _backgroundSkin:DisplayObject;

	/**
	 * The primary background to display.
	 */
	public var backgroundSkin(default, default):DisplayObject;
	
	/**
	 * @private
	 */
	private var _backgroundDisabledSkin:DisplayObject;

	/**
	 * A background to display when the progress bar is disabled.
	 */
	public var backgroundDisabledSkin(default, default):DisplayObject;

	/**
	 * @private
	 */
	private var _originalFillWidth:Float;//

	/**
	 * @private
	 */
	private var _originalFillHeight:Float;//

	/**
	 * @private
	 */
	private var currentFill:DisplayObject;

	/**
	 * @private
	 */
	private var _fillSkin:DisplayObject;

	/**
	 * The primary fill to display.
	 *
	 * <p>Note: The size of the <code>fillSkin</code>, at the time that it
	 * is passed to the setter, will be used used as the size of the fill
	 * when the progress bar is set to the minimum value. In other words,
	 * if the fill of a horizontal progress bar with a value from 0 to 100
	 * should be virtually invisible when the value is 0, then the
	 * <code>fillSkin</code> should have a width of 0 when you pass it in.
	 * On the other hand, if you're using a <code>Scale9Image</code> as the
	 * skin, it may require a minimum width before the image parts begin to
	 * overlap. In that case, the <code>Scale9Image</code> instance passed
	 * to the <code>fillSkin</code> setter should have a <code>width</code>
	 * value that is the same as that minimum width value where the image
	 * parts do not overlap.</p>
	 */
	public var fillSkin(default, default):DisplayObject;

	/**
	 * @private
	 */
	private var _fillDisabledSkin:DisplayObject;

	/**
	 * A fill to display when the progress bar is disabled.
	 */
	public var fillDisabledSkin(default, default):DisplayObject;

	/**
	 * @private
	 */
	private var _paddingTop:Float;//0;

	/**
	 * The minimum space, in pixels, between the progress bar's top edge and
	 * the progress bar's content.
	 */
	public var paddingTop(default, default):Float;

	/**
	 * @private
	 */
	private var _paddingRight:Float;//0;

	/**
	 * The minimum space, in pixels, between the progress bar's right edge
	 * and the progress bar's content.
	 */
	public var paddingRight(default, default):Float;

	/**
	 * @private
	 */
	private var _paddingBottom:Float;//0;

	/**
	 * The minimum space, in pixels, between the progress bar's bottom edge
	 * and the progress bar's content.
	 */
	public var paddingBottom(default, default):Float;

	/**
	 * @private
	 */
	private var _paddingLeft:Float;//0;

	/**
	 * The minimum space, in pixels, between the progress bar's left edge
	 * and the progress bar's content.
	 */
	public var paddingLeft(default, default):Float;

	
	/**
	 * @private
	 */
	private function autoSizeIfNeeded():Bool;

	/**
	 * @private
	 */
	private function refreshBackground():Void;

	/**
	 * @private
	 */
	private function refreshFill():Void;

}
