package feathers.display;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import starling.display.DisplayObject;

/**
 * Utilities for working with display objects that have a <code>scrollRect</code>.
 *
 * @see IDisplayObjectWithScrollRect
 */
extern class ScrollRectManager
{
	/**
	 * @private
	 */
	public static var scrollRectOffsetX:Float;// = 0;

	/**
	 * @private
	 */
	public static var scrollRectOffsetY:Float;// = 0;

	/**
	 * @private
	 */
	public static var currentScissorRect:Rectangle;

	/**
	 * Adjusts the result of the <code>getLocation()</code> method on the
	 * <code>Touch</code> class to account for <code>scrollRect</code> on
	 * the target's parent or any other containing display object.
	 *
	 * @see starling.events.Touch#getLocation()
	 */
	public static function adjustTouchLocation(location:Point, target:DisplayObject):Void;
	
	/**
	 * Corrects a transformed point in the target coordinate system that has
	 * been affected by <code>scrollRect</code> to stage coordinates.
	 */
	public static function toStageCoordinates(location:Point, target:DisplayObject):Void;

	/**
	 * Enhances <code>getBounds()</code> with correction for <code>scrollRect</code>
	 * offsets.
	 */
	public static function getBounds(object:DisplayObject, targetSpace:DisplayObject, result:Rectangle = null):Rectangle;
}