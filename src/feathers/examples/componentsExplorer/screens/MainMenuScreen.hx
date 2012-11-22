package feathers.examples.componentsExplorer.screens;
//{
import feathers.controls.Header;
import feathers.controls.List;
import feathers.controls.Screen;
import feathers.data.ListCollection;
import feathers.skins.StandardIcons;

import starling.events.Event;

@:meta(Event(name="test",type="Foo"))
@:meta(Event(name="complete",type="starling.events.Event"))
@:meta(Event(name="showButton",type="starling.events.Event"))
@:meta(Event(name="showButtonGroup",type="starling.events.Event"))
@:meta(Event(name="showCallout",type="starling.events.Event"))
@:meta(Event(name="showGroupedList",type="starling.events.Event"))
@:meta(Event(name="showList",type="starling.events.Event"))
@:meta(Event(name="showPageIndicator",type="starling.events.Event"))
@:meta(Event(name="showPickerList",type="starling.events.Event"))
@:meta(Event(name="showProgressBar",type="starling.events.Event"))
@:meta(Event(name="showScrollText",type="starling.events.Event"))
@:meta(Event(name="showSlider",type="starling.events.Event"))
@:meta(Event(name="showTabBar",type="starling.events.Event"))
@:meta(Event(name="showTextInput",type="starling.events.Event"))
@:meta(Event(name="showToggles",type="starling.events.Event"))

class MainMenuScreen extends Screen {
	
	public static inline var SHOW_BUTTON:String = "showButton";
	public static inline var SHOW_BUTTON_GROUP:String = "showButtonGroup";
	public static inline var SHOW_CALLOUT:String = "showCallout";
	public static inline var SHOW_GROUPED_LIST:String = "showGroupedList";
	public static inline var SHOW_LIST:String = "showList";
	public static inline var SHOW_PAGE_INDICATOR:String = "showPageIndicator";
	public static inline var SHOW_PICKER_LIST:String = "showPickerList";
	public static inline var SHOW_PROGRESS_BAR:String = "showProgressBar";
	public static inline var SHOW_SCROLL_TEXT:String = "showScrollText";
	public static inline var SHOW_SLIDER:String = "showSlider";
	public static inline var SHOW_TAB_BAR:String = "showTabBar";
	public static inline var SHOW_TEXT_INPUT:String = "showTextInput";
	public static inline var SHOW_TOGGLES:String = "showToggles";
	
	public function new() {
		super();
	}

	private var _header:Header;
	private var _list:List;
	
	@:protected override function initialize():Void	{
		_header = new Header();
		_header.title = "Feathers";
		addChild(_header);

		_list = new List();
		_list.dataProvider = new ListCollection(
		[
			{ label: "Button", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, event: SHOW_BUTTON },
			{ label: "Button Group", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, event: SHOW_BUTTON_GROUP },
			{ label: "Callout", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, event: SHOW_CALLOUT },
			{ label: "Grouped List", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, event: SHOW_GROUPED_LIST },
			{ label: "List", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, event: SHOW_LIST },
			{ label: "Page Indicator", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, event: SHOW_PAGE_INDICATOR },
			{ label: "Picker List", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, event: SHOW_PICKER_LIST },
			{ label: "Progress Bar", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, event: SHOW_PROGRESS_BAR },
			{ label: "Scroll Text", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, event: SHOW_SCROLL_TEXT },
			{ label: "Slider", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, event: SHOW_SLIDER},
			{ label: "Tab Bar", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, event: SHOW_TAB_BAR },
			{ label: "Text Input", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, event: SHOW_TEXT_INPUT },
			{ label: "Toggles", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, event: SHOW_TOGGLES },
		]);
		_list.itemRendererProperties.labelField = "label";
		_list.itemRendererProperties.accessoryTextureField = "accessoryTexture";
		_list.addEventListener(Event.CHANGE, list_changeHandler);
		addChild(_list);
	}
	
	@:protected override function draw():Void
	{
		_header.width = width;
		_header.validate();

		_list.y = _header.height;
		_list.width = width;
		_list.height = height - _list.y;
	}
	
	private function list_changeHandler(event:Event):Void
	{
		var eventType:String = cast _list.selectedItem.event;
		dispatchEventWith(eventType);
	}
}