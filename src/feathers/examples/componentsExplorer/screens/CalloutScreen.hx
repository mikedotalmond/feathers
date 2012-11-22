package feathers.examples.componentsExplorer.screens;

import feathers.controls.Button;
import feathers.controls.Callout;
import feathers.controls.Header;
import feathers.controls.Label;
import feathers.controls.Screen;
import flash.Vector;

import starling.display.DisplayObject;
import starling.events.Event;

@:meta(Event(name="complete",type="starling.events.Event"))

class CalloutScreen extends Screen {
	
	private static var CONTENT_TEXT:String = "Thank you for trying Feathers.\nHappy coding.";

	public function new() {
		super();
	}

	private var _rightButton:Button;
	private var _downButton:Button;
	private var _upButton:Button;
	private var _leftButton:Button;
	private var _header:Header;
	private var _backButton:Button;

	@:protected override function initialize():Void	{
		_rightButton = new Button();
		_rightButton.label = "Right";
		_rightButton.addEventListener(Event.TRIGGERED, rightButton_triggeredHandler);
		addChild(_rightButton);

		_downButton = new Button();
		_downButton.label = "Down";
		_downButton.addEventListener(Event.TRIGGERED, downButton_triggeredHandler);
		addChild(_downButton);

		_upButton = new Button();
		_upButton.label = "Up";
		_upButton.addEventListener(Event.TRIGGERED, upButton_triggeredHandler);
		addChild(_upButton);

		_leftButton = new Button();
		_leftButton.label = "Left";
		_leftButton.addEventListener(Event.TRIGGERED, leftButton_triggeredHandler);
		addChild(_leftButton);

		_backButton = new Button();
		_backButton.label = "Back";
		_backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

		_header = new Header();
		_header.title = "Callout";
		addChild(_header);
		_header.leftItems = Vector.ofArray(
		[
			cast _backButton
		]);

		// handles the back hardware key on android
		backButtonHandler = onBackButton;
	}

	@:protected override function draw():Void {
		_header.width = width;
		_header.validate();

		var margin:Float = _header.height * 0.25;

		_rightButton.validate();
		_rightButton.x = margin;
		_rightButton.y = _header.height + margin;

		_downButton.validate();
		_downButton.x = width - _downButton.width - margin;
		_downButton.y = _header.height + margin;

		_upButton.validate();
		_upButton.x = margin;
		_upButton.y = height - _upButton.height - margin;

		_leftButton.validate();
		_leftButton.x = width - _leftButton.width - margin;
		_leftButton.y = height - _leftButton.height - margin;
	}

	private function onBackButton():Void
	{
		dispatchEventWith(Event.COMPLETE);
	}

	private function backButton_triggeredHandler(event:Event):Void
	{
		onBackButton();
	}

	private function rightButton_triggeredHandler(event:Event):Void
	{
		var content:Label = new Label();
		content.text = CONTENT_TEXT;
		var c = content;
		var cc = cast content;
		Callout.show(cc, _rightButton, Callout.DIRECTION_RIGHT);
	}

	private function downButton_triggeredHandler(event:Event):Void
	{
		var content:Label = new Label();
		content.text = CONTENT_TEXT;
		Callout.show(cast content, _downButton, Callout.DIRECTION_DOWN);
	}

	private function upButton_triggeredHandler(event:Event):Void
	{
		var content:Label = new Label();
		content.text = CONTENT_TEXT;
		Callout.show(cast content, _upButton, Callout.DIRECTION_UP);
	}

	private function leftButton_triggeredHandler(event:Event):Void
	{
		var content:Label = new Label();
		content.text = CONTENT_TEXT;
		Callout.show(cast content, _leftButton, Callout.DIRECTION_LEFT);
	}
}
