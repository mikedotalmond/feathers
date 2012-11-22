package feathers.examples.componentsExplorer.screens;

import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.List;
import feathers.controls.PickerList;
import feathers.controls.Screen;
import feathers.controls.Slider;
import feathers.controls.ToggleSwitch;
import feathers.data.ListCollection;
import feathers.examples.componentsExplorer.data.ButtonSettings;
import flash.Vector;

import starling.display.DisplayObject;
import starling.events.Event;

@:meta(Event(name="complete",type="starling.events.Event"))

class ButtonSettingsScreen extends Screen
{
	public function new() {
		super();
	}

	public var settings:ButtonSettings;

	private var _header:Header;
	private var _list:List;
	private var _backButton:Button;

	private var _isToggleToggle:ToggleSwitch;
	private var _horizontalAlignPicker:PickerList;
	private var _verticalAlignPicker:PickerList;
	private var _iconToggle:ToggleSwitch;
	private var _iconPositionPicker:PickerList;
	private var _iconOffsetXSlider:Slider;
	private var _iconOffsetYSlider:Slider;

	@:protected override function initialize():Void
	{
		_isToggleToggle = new ToggleSwitch();
		_isToggleToggle.isSelected = settings.isToggle;
		_isToggleToggle.addEventListener(Event.CHANGE, isToggleToggle_changeHandler);

		_horizontalAlignPicker = new PickerList();
		_horizontalAlignPicker.typicalItem = Button.HORIZONTAL_ALIGN_CENTER;
		_horizontalAlignPicker.dataProvider = new ListCollection(Vector.ofArray(
		[
			Button.HORIZONTAL_ALIGN_LEFT,
			Button.HORIZONTAL_ALIGN_CENTER,
			Button.HORIZONTAL_ALIGN_RIGHT
		]));
		_horizontalAlignPicker.listProperties.typicalItem = Button.HORIZONTAL_ALIGN_CENTER;
		_horizontalAlignPicker.selectedItem = settings.horizontalAlign;
		_horizontalAlignPicker.addEventListener(Event.CHANGE, horizontalAlignPicker_changeHandler);

		_verticalAlignPicker = new PickerList();
		_verticalAlignPicker.typicalItem = Button.VERTICAL_ALIGN_BOTTOM;
		_verticalAlignPicker.dataProvider = new ListCollection(Vector.ofArray(
		[
			Button.VERTICAL_ALIGN_TOP,
			Button.VERTICAL_ALIGN_MIDDLE,
			Button.VERTICAL_ALIGN_BOTTOM
		]));
		_verticalAlignPicker.listProperties.typicalItem = Button.VERTICAL_ALIGN_BOTTOM;
		_verticalAlignPicker.selectedItem = settings.verticalAlign;
		_verticalAlignPicker.addEventListener(Event.CHANGE, verticalAlignPicker_changeHandler);

		_iconToggle = new ToggleSwitch();
		_iconToggle.isSelected = true;
		_iconToggle.addEventListener(Event.CHANGE, iconToggle_changeHandler);

		_iconPositionPicker = new PickerList();
		_iconPositionPicker.typicalItem = Button.ICON_POSITION_RIGHT_BASELINE;
		_iconPositionPicker.dataProvider = new ListCollection(Vector.ofArray(
		[
			Button.ICON_POSITION_TOP,
			Button.ICON_POSITION_RIGHT,
			Button.ICON_POSITION_RIGHT_BASELINE,
			Button.ICON_POSITION_BOTTOM,
			Button.ICON_POSITION_LEFT,
			Button.ICON_POSITION_LEFT_BASELINE,
			Button.ICON_POSITION_MANUAL
		]));
		_iconPositionPicker.listProperties.typicalItem = Button.ICON_POSITION_RIGHT_BASELINE;
		_iconPositionPicker.selectedItem = settings.iconPosition;
		_iconPositionPicker.addEventListener(Event.CHANGE, iconPositionPicker_changeHandler);

		_iconOffsetXSlider = new Slider();
		//there is no actual limit. these are aribitrary.
		_iconOffsetXSlider.minimum = -50;
		_iconOffsetXSlider.maximum = 50;
		_iconOffsetXSlider.step = 1;
		_iconOffsetXSlider.value = settings.iconOffsetX;
		_iconOffsetXSlider.addEventListener(Event.CHANGE, iconOffsetXSlider_changeHandler);

		_iconOffsetYSlider = new Slider();
		_iconOffsetYSlider.minimum = -50;
		_iconOffsetYSlider.maximum = 50;
		_iconOffsetYSlider.step = 1;
		_iconOffsetYSlider.value = settings.iconOffsetY;
		_iconOffsetYSlider.addEventListener(Event.CHANGE, iconOffsetYSlider_changeHandler);

		_list = new List();
		_list.isSelectable = false;
		_list.dataProvider = new ListCollection(
		[
			{ label: "isToggle", accessory: _isToggleToggle },
			{ label: "horizontalAlign", accessory: _horizontalAlignPicker },
			{ label: "verticalAlign", accessory: _verticalAlignPicker },
			{ label: "icon", accessory: _iconToggle },
			{ label: "iconPosition", accessory: _iconPositionPicker },
			{ label: "iconOffsetX", accessory: _iconOffsetXSlider },
			{ label: "iconOffsetY", accessory: _iconOffsetYSlider }
		]);
		addChild(_list);

		_backButton = new Button();
		_backButton.label = "Back";
		_backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

		_header = new Header();
		_header.title = "Button Settings";
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

	private function backButton_triggeredHandler(event:Event):Void
	{
		onBackButton();
	}

	private function isToggleToggle_changeHandler(event:Event):Void
	{
		settings.isToggle = _isToggleToggle.isSelected;
	}

	private function horizontalAlignPicker_changeHandler(event:Event):Void
	{
		settings.horizontalAlign = cast _horizontalAlignPicker.selectedItem;
	}

	private function verticalAlignPicker_changeHandler(event:Event):Void
	{
		settings.verticalAlign = cast _verticalAlignPicker.selectedItem;
	}

	private function iconToggle_changeHandler(event:Event):Void
	{
		settings.hasIcon = _iconToggle.isSelected;
	}

	private function iconPositionPicker_changeHandler(event:Event):Void
	{
		settings.iconPosition = cast _iconPositionPicker.selectedItem ;
	}

	private function iconOffsetXSlider_changeHandler(event:Event):Void
	{
		settings.iconOffsetX = _iconOffsetXSlider.value;
	}

	private function iconOffsetYSlider_changeHandler(event:Event):Void
	{
		settings.iconOffsetY = _iconOffsetYSlider.value;
	}
}
