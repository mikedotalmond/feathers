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
import feathers.core.PropertyProxy;
import feathers.core.ToggleGroup;
import feathers.data.ListCollection;
import feathers.events.CollectionEventType;
import flash.Vector;

import starling.events.Event;

/**
 * Dispatched when the selected tab changes.
 *
 * @eventType starling.events.Event.CHANGE
 */
@:meta(Event(name="change",type="starling.events.Event"))

@:meta(DefaultProperty("dataProvider"))
/**
 * A line of tabs (vertical or horizontal), where one may be selected at a
 * time.
 *
 * @see http://wiki.starling-framework.org/feathers/tab-bar
 */
extern class TabBar extends FeathersControl {
	
	/**
	 * @private
	 */
	private static var INVALIDATION_FLAG_TAB_FACTORY:String;//"tabFactory";

	/**
	 * @private
	 */
	private static var NOT_PENDING_INDEX:Int;//-2;

	/**
	 * @private
	 */
	private static var DEFAULT_TAB_FIELDS:Vector<String>;/* = Vector.ofArray(
	[
		"defaultIcon",
		"upIcon",
		"downIcon",
		"hoverIcon",
		"disabledIcon",
		"defaultSelectedIcon",
		"selectedUpIcon",
		"selectedDownIcon",
		"selectedHoverIcon",
		"selectedDisabledIcon"
	]);*/

	/**
	 * The tabs are displayed in order from left to right.
	 */
	public static var DIRECTION_HORIZONTAL:String;//"horizontal";

	/**
	 * The tabs are displayed in order from top to bottom.
	 */
	public static var DIRECTION_VERTICAL:String;//"vertical";

	/**
	 * The default value added to the <code>nameList</code> of the tabs.
	 */
	public static var DEFAULT_CHILD_NAME_TAB:String;//"feathers-tab-bar-tab";

	/**
	 * @private
	 */
	private static function defaultTabFactory():Button;

	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * The value added to the <code>nameList</code> of the tabs.
	 */
	private var tabName:String;// = DEFAULT_CHILD_NAME_TAB;

	/**
	 * The value added to the <code>nameList</code> of the first tab.
	 */
	private var firstTabName:String;// = DEFAULT_CHILD_NAME_TAB;

	/**
	 * The value added to the <code>nameList</code> of the last tab.
	 */
	private var lastTabName:String;// = DEFAULT_CHILD_NAME_TAB;

	/**
	 * The toggle group.
	 */
	private var toggleGroup:ToggleGroup;

	/**
	 * @private
	 */
	private var activeFirstTab:Button;

	/**
	 * @private
	 */
	private var inactiveFirstTab:Button;

	/**
	 * @private
	 */
	private var activeLastTab:Button;

	/**
	 * @private
	 */
	private var inactiveLastTab:Button;

	/**
	 * @private
	 */
	private var activeTabs:Vector<Button>;// = new <Button>[];

	/**
	 * @private
	 */
	private var inactiveTabs:Vector<Button>;// = new <Button>[];

	/**
	 * @private
	 */
	private var _dataProvider:ListCollection;

	/**
	 * The collection of data to be displayed with tabs.
	 *
	 * @see #tabInitializer
	 */
	public var dataProvider(default, default):ListCollection;

	
	/**
	 * @private
	 */
	private var _direction:String;// = DIRECTION_HORIZONTAL;

	@:meta(Inspectable(type="String",enumeration="horizontal,vertical"))
	/**
	 * The tab bar layout is either vertical or horizontal.
	 */
	public var direction(default, default):String;

	/**
	 * @private
	 */
	private var _gap:Float;//0;

	/**
	 * Space, in pixels, between tabs.
	 */
	public var gap(default, default):Float;

	/**
	 * @private
	 */
	private var _tabFactory:Void->Button;// = defaultTabFactory;

	/**
	 * Creates a new tab.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function():Button</pre>
	 *
	 * @see #firstTabFactory
	 * @see #lastTabFactory
	 */
	public var tabFactory(default, default):Void->Button;
	
	/**
	 * @private
	 */
	private var _firstTabFactory:Void->Button;

	/**
	 * Creates a new first tab. If the firstTabFactory is null, then the
	 * TabBar will use the tabFactory.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function():Button</pre>
	 *
	 * @see #tabFactory
	 * @see #lastTabFactory
	 */
	public var firstTabFactory(default, default):Void->Button;


	/**
	 * @private
	 */
	private var _lastTabFactory:Void->Button;

	/**
	 * Creates a new last tab. If the lastTabFactory is null, then the
	 * TabBar will use the tabFactory.
	 *
	 * <p>This function is expected to have the following signature:</p>
	 *
	 * <pre>function():Button</pre>
	 *
	 * @see #tabFactory
	 * @see #firstTabFactory
	 */
	public var lastTabFactory(default, default):Void->Button;

	/**
	 * @private
	 */
	private var _tabInitializer:Dynamic;// = defaultTabInitializer;

	/**
	 * Modifies a tab, perhaps by changing its label and icons, based on the
	 * item from the data provider that the tab is meant to represent. The
	 * default tabInitializer function can set the tab's label and icons if
	 * <code>label</code> and/or any of the <code>Button</code> icon fields
	 * (<code>defaultIcon</code>, <code>upIcon</code>, etc.) are present in
	 * the item.
	 */
	public var tabInitializer(default, default):Dynamic;

	/**
	 * @private
	 */
	private var _ignoreSelectionChanges:Bool;//false;

	/**
	 * @private
	 */
	private var _pendingSelectedIndex:Int;// = NOT_PENDING_INDEX;

	/**
	 * The index of the currently selected tab. Returns -1 if no tab is
	 * selected.
	 */
	public var selectedIndex(default, default):Int;


	/**
	 * The currently selected item from the data provider. Returns
	 * <code>null</code> if no item is selected.
	 */
	public var selectedItem(default, default):Dynamic;
	

	/**
	 * @private
	 */
	private var _customTabName:String;

	/**
	 * A name to add to all tabs in this tab bar. Typically used by a theme
	 * to provide different skins to different tab bars.
	 *
	 * @see feathers.core.FeathersControl#nameList
	 */
	public var customTabName(default, default):String;

	/**
	 * @private
	 */
	private var _customFirstTabName:String;

	/**
	 * A name to add to the first tab in this tab bar. Typically used by a
	 * theme to provide different skins to the first tab.
	 *
	 * @see feathers.core.FeathersControl#nameList
	 */
	public var customFirstTabName(default, default):String;
	

	/**
	 * @private
	 */
	private var _customLastTabName:String;

	/**
	 * A name to add to the last tab in this tab bar. Typically used by a
	 * theme to provide different skins to the last tab.
	 *
	 * @see feathers.core.FeathersControl#nameList
	 */
	public var customLastTabName(default, default):String;

	/**
	 * @private
	 */
	private var _tabProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to all of the tab bar's
	 * tabs. These values are shared by each tabs, so values that cannot be
	 * shared (such as display objects that need to be added to the display
	 * list) should be passed to tabs in another way (such as with an
	 * <code>AddedWatcher</code>).
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * @see AddedWatcher
	 */
	public var tabProperties(default, default):Dynamic;

	
	/**
	 * @private
	 */
	private function commitSelection():Void;

	/**
	 * @private
	 */
	private function commitEnabled():Void;

	/**
	 * @private
	 */
	private function refreshTabStyles():Void;
	
	/**
	 * @private
	 */
	private function defaultTabInitializer(tab:Button, item:Dynamic):Void;
	
	/**
	 * @private
	 */
	private function refreshTabs(isFactoryInvalid:Bool):Void;
	
	/**
	 * @private
	 */
	private function clearInactiveTabs():Void;
	
	/**
	 * @private
	 */
	private function createFirstTab(item:Dynamic):Button;
	
	/**
	 * @private
	 */
	private function createLastTab(item:Dynamic):Button;
	
	/**
	 * @private
	 */
	private function createTab(item:Dynamic):Button;
	
	/**
	 * @private
	 */
	private function destroyTab(tab:Button):Void;
	
	
	/**
	 * @private
	 */
	private function autoSizeIfNeeded():Bool;
	
	/**
	 * @private
	 */
	private function layoutTabs():Void;
	
	/**
	 * @private
	 */
	private function childProperties_onChange(proxy:PropertyProxy, name:String):Void;
	
	/**
	 * @private
	 */
	private function toggleGroup_changeHandler(event:Event):Void;
	
	/**
	 * @private
	 */
	private function dataProvider_addItemHandler(event:Event, index:Int):Void;
	
	/**
	 * @private
	 */
	private function dataProvider_removeItemHandler(event:Event, index:Int):Void;
	
	/**
	 * @private
	 */
	private function dataProvider_resetHandler(event:Event):Void;

	/**
	 * @private
	 */
	private function dataProvider_replaceItemHandler(event:Event, index:Int):Void;
	
	/**
	 * @private
	 */
	private function dataProvider_updateItemHandler(event:Event, index:Int):Void;
}
