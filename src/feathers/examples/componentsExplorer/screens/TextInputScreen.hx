package feathers.examples.componentsExplorer.screens;

import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.Screen;
import feathers.controls.TextInput;
import flash.Vector;

import starling.display.DisplayObject;
import starling.events.Event;

@:meta(Event(name="complete",type="starling.events.Event"))

class TextInputScreen extends Screen {
	
	public function new() {
		super();
	}

	private var _header:Header;
	private var _backButton:Button;
	private var _input:TextInput;

	@:protected override function initialize():Void
	{
		_input = new TextInput();
		addChild(_input);

		_backButton = new Button();
		_backButton.label = "Back";
		_backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

		_header = new Header();
		_header.title = "Text Input";
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

		_input.validate();
		_input.x = (width - _input.width) / 2;
		_input.y = _header.height + (height - _header.height - _input.height) / 2;
	}

	private function onBackButton():Void
	{
		dispatchEventWith(Event.COMPLETE);
	}

	private function backButton_triggeredHandler(event:Event):Void
	{
		onBackButton();
	}
}
