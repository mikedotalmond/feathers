package feathers.controls;
import feathers.core.IFeathersControl;


/**
 * Minimum requirements for a scroll bar to be usable with a <code>Scroller</code>
 * component.
 *
 * @see Scroller
 */
extern interface IScrollBar implements IFeathersControl
{
	/**
	 * The minimum value of the scroll bar.
	 */
	var minimum(default, default):Float;

	/**
	 * The maximum value of the scroll bar.
	 */
	var maximum(default, default):Float;
	
	/**
	 * The current value of the scroll bar.
	 */
	var value(default, default):Float;
	
	/**
	 * The amount the scroll bar value must change to increment or
	 * decrement.
	 */
	var step(default, default):Float;
	
	/**
	 * The amount the scroll bar value must change to get from one "page" to
	 * the next.
	 */
	var page(default, default):Float;
}
