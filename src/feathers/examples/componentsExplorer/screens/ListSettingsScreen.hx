package feathers.examples.componentsExplorer.screens;


import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.List;
import feathers.controls.Screen;
import feathers.controls.ToggleSwitch;
import feathers.data.ListCollection;
import feathers.examples.componentsExplorer.data.ListSettings;
import flash.Vector;

import starling.display.DisplayObject;
import starling.events.Event;

@:meta(Event(name="complete",type="starling.events.Event"))

class ListSettingsScreen extends Screen {

	public function new() {
		super();
	}

	public var settings:ListSettings;

	private var _header:Header;
	private var _list:List;
	private var _backButton:Button;

	private var _isSelectableToggle:ToggleSwitch;
	private var _hasElasticEdgesToggle:ToggleSwitch;

	@:protected override function initialize():Void
	{
		_isSelectableToggle = new ToggleSwitch();
		_isSelectableToggle.isSelected = settings.isSelectable;
		_isSelectableToggle.addEventListener(Event.CHANGE, isSelectableToggle_changeHandler);

		_hasElasticEdgesToggle = new ToggleSwitch();
		_hasElasticEdgesToggle.isSelected = settings.hasElasticEdges;
		_hasElasticEdgesToggle.addEventListener(Event.CHANGE, hasElasticEdgesToggle_changeHandler);

		_list = new List();
		_list.isSelectable = false;
		_list.dataProvider = new ListCollection(
		[
			{ label: "isSelectable", accessory: _isSelectableToggle },
			{ label: "hasElasticEdges", accessory: _hasElasticEdgesToggle },
		]);
		addChild(_list);

		_backButton = new Button();
		_backButton.label = "Back";
		_backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

		_header = new Header();
		_header.title = "List Settings";
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

	private function isSelectableToggle_changeHandler(event:Event):Void
	{
		settings.isSelectable = _isSelectableToggle.isSelected;
	}

	private function hasElasticEdgesToggle_changeHandler(event:Event):Void
	{
		settings.hasElasticEdges = _hasElasticEdgesToggle.isSelected;
	}
}
