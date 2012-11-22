package feathers.examples.componentsExplorer.screens;

import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.List;
import feathers.controls.PickerList;
import feathers.controls.Screen;
import feathers.controls.Slider;
import feathers.controls.ToggleSwitch;
import feathers.data.ListCollection;
import feathers.examples.componentsExplorer.data.SliderSettings;
import flash.Vector;

import starling.display.DisplayObject;
import starling.events.Event;

@:meta(Event(name="complete",type="starling.events.Event"))

class SliderSettingsScreen extends Screen {
	
	public function new() {
		super();
	}

	public var settings:SliderSettings;

	private var _header:Header;
	private var _list:List;
	private var _backButton:Button;
	private var _directionPicker:PickerList;
	private var _liveDraggingToggle:ToggleSwitch;
	private var _stepSlider:Slider;
	private var _pageSlider:Slider;

	@:protected override function initialize():Void {
		_directionPicker = new PickerList();
		_directionPicker.typicalItem = Slider.DIRECTION_HORIZONTAL;
		_directionPicker.dataProvider = new ListCollection(Vector.ofArray(
		[
			Slider.DIRECTION_HORIZONTAL,
			Slider.DIRECTION_VERTICAL
		]));
		_directionPicker.listProperties.typicalItem = Slider.DIRECTION_HORIZONTAL;
		_directionPicker.selectedItem = settings.direction;
		_directionPicker.addEventListener(Event.CHANGE, directionPicker_changeHandler);

		_liveDraggingToggle = new ToggleSwitch();
		_liveDraggingToggle.isSelected = settings.liveDragging;
		_liveDraggingToggle.addEventListener(Event.CHANGE, liveDraggingToggle_changeHandler);

		_stepSlider = new Slider();
		_stepSlider.minimum = 1;
		_stepSlider.maximum = 20;
		_stepSlider.step = 1;
		_stepSlider.value = settings.step;
		_stepSlider.addEventListener(Event.CHANGE, stepSlider_changeHandler);

		_pageSlider = new Slider();
		_pageSlider.minimum = 1;
		_pageSlider.maximum = 20;
		_pageSlider.step = 1;
		_pageSlider.value = settings.page;
		_pageSlider.addEventListener(Event.CHANGE, pageSlider_changeHandler);

		_list = new List();
		_list.isSelectable = false;
		_list.dataProvider = new ListCollection(
		[
			{ label: "direction", accessory: _directionPicker },
			{ label: "liveDragging", accessory: _liveDraggingToggle },
			{ label: "step", accessory: _stepSlider },
			{ label: "page", accessory: _pageSlider },
		]);
		addChild(_list);

		_backButton = new Button();
		_backButton.label = "Back";
		_backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

		_header = new Header();
		_header.title = "Slider Settings";
		addChild(_header);
		_header.leftItems = Vector.ofArray(
		[
			cast _backButton
		]);

		backButtonHandler = onBackButton;
	}

	@:protected override function draw():Void
	{
		_header.width = width;
		_header.validate();

		_list.y = _header.height;
		_list.width = width;
		_list.height = height - _list.y;
	}

	private function onBackButton():Void
	{
		dispatchEventWith(Event.COMPLETE);
	}

	private function directionPicker_changeHandler(event:Event):Void
	{
		settings.direction = cast _directionPicker.selectedItem;
	}

	private function liveDraggingToggle_changeHandler(event:Event):Void
	{
		settings.liveDragging = _liveDraggingToggle.isSelected;
	}

	private function stepSlider_changeHandler(event:Event):Void
	{
		settings.step = _stepSlider.value;
	}

	private function pageSlider_changeHandler(event:Event):Void
	{
		settings.page = _pageSlider.value;
	}

	private function backButton_triggeredHandler(event:Event):Void
	{
		onBackButton();
	}
}
