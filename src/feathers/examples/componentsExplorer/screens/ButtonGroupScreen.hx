package feathers.examples.componentsExplorer.screens;
import feathers.controls.Button;
import feathers.controls.ButtonGroup;
import feathers.controls.Header;
import feathers.controls.Screen;
import feathers.data.ListCollection;
import flash.Vector;

import starling.display.DisplayObject;
import starling.events.Event;

@:meta(Event(name="complete",type="starling.events.Event"))

class ButtonGroupScreen extends Screen
{
	public function new() {
		super();
	}

	private var _header:Header;
	private var _backButton:Button;
	private var _buttonGroup:ButtonGroup;

	@:protected override function initialize():Void
	{
		_buttonGroup = new ButtonGroup();
		_buttonGroup.dataProvider = new ListCollection(
		[
			{ label: "One", triggered: button_triggeredHandler },
			{ label: "Two", triggered: button_triggeredHandler },
			{ label: "Three", triggered: button_triggeredHandler },
			{ label: "Four", triggered: button_triggeredHandler },
		]);
		addChild(_buttonGroup);

		_backButton = new Button();
		_backButton.label = "Back";
		_backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

		_header = new Header();
		_header.title = "Button Group";
		addChild(_header);
		_header.leftItems = Vector.ofArray(
		[
			cast _backButton
		]);

		// handles the back hardware key on android
		backButtonHandler = onBackButton;
	}

	@:protected override function draw():Void
	{
		_header.width = width;
		_header.validate();

		_buttonGroup.validate();
		_buttonGroup.x = (width - _buttonGroup.width) / 2;
		_buttonGroup.y = _header.height + (height - _header.height - _buttonGroup.height) / 2;
	}

	private function onBackButton():Void
	{
		dispatchEventWith(Event.COMPLETE);
	}

	private function backButton_triggeredHandler(event:Event):Void
	{
		onBackButton();
	}

	private function button_triggeredHandler(event:Event):Void
	{
		var button:Button = cast(event.currentTarget);
		trace(button.label + " triggered.");
	}
}
