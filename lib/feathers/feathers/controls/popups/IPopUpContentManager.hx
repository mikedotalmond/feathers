package feathers.controls.popups;
import starling.display.DisplayObject;


/**
 * Automatically manages pop-up content layout and positioning.
 */
extern interface IPopUpContentManager
{
	/**
	 * Displays the pop-up content.
	 *
	 * @param content		The content for the pop-up content manager to display.
	 * @param source		The source of the pop-up. May be used to position and/or size the pop-up. May be completely ignored instead.
	 */
	function open(content:DisplayObject, source:DisplayObject):Void;

	/**
	 * Closes the pop-up content. If it is not opened, nothing happens.
	 */
	function close():Void;

	/**
	 * Cleans up the manager.
	 */
	function dispose():Void;
}
