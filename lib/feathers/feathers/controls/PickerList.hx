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

import feathers.controls.popups.CalloutPopUpContentManager;
import feathers.controls.popups.IPopUpContentManager;
import feathers.controls.popups.VerticalCenteredPopUpContentManager;
import feathers.core.FeathersControl;
import feathers.core.PropertyProxy;
import feathers.data.ListCollection;
import feathers.system.DeviceCapabilities;

import starling.core.Starling;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * Dispatched when the selected item changes.
 *
 * @eventType starling.events.Event.CHANGE
 */
@:meta(Event(name="change",type="starling.events.Event"))

/**
 * A combo-box like list control. Displayed as a button. The list appears
 * on tap as a full-screen overlay.
 *
 * @see http://wiki.starling-framework.org/feathers/picker-list
 */
extern class PickerList extends FeathersControl {
	/**
	 * The default value added to the <code>nameList</code> of the button.
	 */
	public static var DEFAULT_CHILD_NAME_BUTTON:String;//"feathers-picker-list-button";

	/**
	 * The default value added to the <code>nameList</code> of the pop-up
	 * list.
	 */
	public static var DEFAULT_CHILD_NAME_LIST:String;//"feathers-picker-list-list";

	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * The value added to the <code>nameList</code> of the button.
	 */
	private var buttonName:String;// = DEFAULT_CHILD_NAME_BUTTON;

	/**
	 * The value added to the <code>nameList</code> of the pop-up list.
	 */
	private var listName:String;// = DEFAULT_CHILD_NAME_LIST;

	/**
	 * The button sub-component.
	 */
	private var button:Button;

	/**
	 * The list sub-component.
	 */
	private var list:List;

	/**
	 * @private
	 */
	private var _buttonTouchPointID:Int;//-1;

	/**
	 * @private
	 */
	private var _listTouchPointID:Int;//-1;

	/**
	 * @private
	 */
	private var _hasBeenScrolled:Bool;//false;
	
	/**
	 * @private
	 */
	private var _dataProvider:ListCollection;
	
	/**
	 * @copy List#dataProvider
	 */
	public var dataProvider(default, default):ListCollection;
	
	/**
	 * @private
	 */
	private var _selectedIndex:Int;//-1;
	
	/**
	 * @copy List#selectedIndex
	 */
	public var selectedIndex(default, default):Int;
	
	/**
	 * @copy List#selectedItem
	 */
	public var selectedItem(default, default):Dynamic;
	
	/**
	 * @private
	 */
	private var _labelField:String;//"label";
	
	/**
	 * The field in the selected item that contains the label text to be
	 * displayed by the picker list's button control. If the selected item
	 * does not have this field, and a <code>labelFunction</code> is not
	 * defined, then the picker list will default to calling
	 * <code>toString()</code> on the selected item. To omit the
	 * label completely, define a <code>labelFunction</code> that returns an
	 * empty string.
	 *
	 * <p><strong>Important:</strong> This value only affects the selected
	 * item displayed by the picker list's button control. It will <em>not</em>
	 * affect the label text of the pop-up list's item renderers.</p>
	 *
	 * @see #labelFunction
	 */
	public var labelField(default, default):String;
	/**
	 * @private
	 */
	private var _labelFunction:Dynamic;

	/**
	 * A function used to generate label text for the selected item
	 * displayed by the picker list's button control. If this
	 * function is not null, then the <code>labelField</code> will be
	 * ignored.
	 *
	 * <p><strong>Important:</strong> This value only affects the selected
	 * item displayed by the picker list's button control. It will <em>not</em>
	 * affect the label text of the pop-up list's item renderers.</p>
	 *
	 * @see #labelField
	 */
	public var labelFunction(default, default):Dynamic;
	
	/**
	 * @private
	 */
	private var _popUpContentManager:IPopUpContentManager;
	
	/**
	 * A manager that handles the details of how to display the pop-up list.
	 */
	public var popUpContentManager(default, default):IPopUpContentManager;


	/**
	 * @private
	 */
	private var _typicalItemWidth:Float;//;//

	/**
	 * @private
	 */
	private var _typicalItemHeight:Float;//;//
	
	/**
	 * @private
	 */
	private var _typicalItem:Dynamic;//null;
	
	/**
	 * Used to auto-size the list. If the list's width or height is NaN, the
	 * list will try to automatically pick an ideal size. This item is
	 * used in that process to create a sample item renderer.
	 */
	public var typicalItem(default, default):Dynamic;
	/**
	 * @private
	 */
	private var _buttonProperties:PropertyProxy;
	
	/**
	 * A set of key/value pairs to be passed down to the picker's button
	 * sub-component. It is a <code>feathers.controls.Button</code>
	 * instance.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 * 
	 * @see feathers.controls.Button
	 */
	public var buttonProperties(default, default):Dynamic;

	
	/**
	 * @private
	 */
	private var _listProperties:PropertyProxy;
	
	/**
	 * A set of key/value pairs to be passed down to the picker's pop-up
	 * list sub-component. The pop-up list is a
	 * <code>feathers.controls.List</code> instance.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 * 
	 * @see feathers.controls.List
	 */
	public var listProperties(default, default):Dynamic;
	
	/**
	 * Using <code>labelField</code> and <code>labelFunction</code>,
	 * generates a label from the selected item to be displayed by the
	 * picker list's button control.
	 *
	 * <p><strong>Important:</strong> This value only affects the selected
	 * item displayed by the picker list's button control. It will <em>not</em>
	 * affect the label text of the pop-up list's item renderers.</p>
	 */
	public function itemToLabel(item:Dynamic):String;
	

	/**
	 * @private
	 */
	private function autoSizeIfNeeded():Bool;
	
	/**
	 * @private
	 */
	private function refreshButtonLabel():Void;
	
	/**
	 * @private
	 */
	private function refreshButtonProperties():Void;
	
	/**
	 * @private
	 */
	private function refreshListProperties():Void;
	
	/**
	 * @private
	 */
	private function closePopUpList():Void;

	/**
	 * @private
	 */
	private function childProperties_onChange(proxy:PropertyProxy, name:String):Void;
	
	/**
	 * @private
	 */
	private function button_triggeredHandler(event:Event):Void;
	
	/**
	 * @private
	 */
	private function list_changeHandler(event:Event):Void; 
	
	/**
	 * @private
	 */
	private function list_scrollHandler(event:Event):Void;
	
	/**
	 * @private
	 */
	private function removedFromStageHandler(event:Event):Void;

	/**
	 * @private
	 */
	private function button_touchHandler(event:TouchEvent):Void;
	
	/**
	 * @private
	 */
	private function list_touchHandler(event:TouchEvent):Void;
}