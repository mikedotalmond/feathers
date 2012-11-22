package feathers.examples.componentsExplorer.screens;

import feathers.controls.Button;
import feathers.controls.Check;
import feathers.controls.Header;
import feathers.controls.Radio;
import feathers.controls.Screen;
import feathers.controls.ToggleSwitch;
import feathers.core.ToggleGroup;
import flash.Vector;

import starling.display.DisplayObject;
import starling.events.Event;

@:meta(Event(name="complete",type="starling.events.Event"))

class ToggleScreen extends Screen {
	
	public function new() {
		super();
	}
	
	private var _header:Header;
	private var _toggleSwitch:ToggleSwitch;
	private var _check1:Check;
	private var _check2:Check;
	private var _check3:Check;
	private var _radio1:Radio;
	private var _radio2:Radio;
	private var _radio3:Radio;
	private var _radioGroup:ToggleGroup;
	private var _backButton:Button;
	
	@:protected override function initialize():Void
	{
		_toggleSwitch = new ToggleSwitch();
		_toggleSwitch.isSelected = false;
		_toggleSwitch.addEventListener(Event.CHANGE, toggleSwitch_changeHandler);
		addChild(_toggleSwitch);

		_check1 = new Check();
		_check1.isSelected = false;
		_check1.label = "Check 1";
		addChild(_check1);

		_check2 = new Check();
		_check2.isSelected = false;
		_check2.label = "Check 2";
		addChild(_check2);

		_check3 = new Check();
		_check3.isSelected = false;
		_check3.label = "Check 3";
		addChild(_check3);

		_radioGroup = new ToggleGroup();
		_radioGroup.addEventListener(Event.CHANGE, radioGroup_changeHandler);

		_radio1 = new Radio();
		_radio1.label = "Radio 1";
		//_radio1.toggleGroup = _radioGroup;
		_radioGroup.addItem(_radio1);
		addChild(_radio1);

		_radio2 = new Radio();
		_radio2.label = "Radio 2";
		//_radio2.toggleGroup = _radioGroup;
		_radioGroup.addItem(_radio2);
		addChild(_radio2);

		_radio3 = new Radio();
		_radio3.label = "Radio 3";
		//_radio3.toggleGroup = _radioGroup;
		_radioGroup.addItem(_radio3);
		addChild(_radio3);

		_backButton = new Button();
		_backButton.label = "Back";
		_backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

		_header = new Header();
		_header.title = "Toggles";
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

		var spacingX:Float = _header.height * 0.2;
		var spacingY:Float = _header.height * 0.4;

		//auto-size the toggle switch and label to position them properly
		_toggleSwitch.validate();
		_check1.validate();
		_check2.validate();
		_check3.validate();
		_radio1.validate();
		_radio2.validate();
		_radio3.validate();

		var contentHeight:Float = _toggleSwitch.height + _check1.height + _radio1.height + 2 * spacingY;
		_toggleSwitch.x = (width - _toggleSwitch.width) / 2;
		_toggleSwitch.y = (height - contentHeight) / 2;

		var checkWidth:Float = _check1.width + _check2.width + _check3.width + 2 * spacingX;
		_check1.x = (width - checkWidth) / 2;
		_check1.y = _toggleSwitch.y + _toggleSwitch.height + spacingY;
		_check2.x = _check1.x + _check1.width + spacingX;
		_check2.y = _check1.y;
		_check3.x = _check2.x + _check2.width + spacingX;
		_check3.y = _check1.y;

		var radioWidth:Float = _radio1.width + _radio2.width + _radio3.width + 2 * spacingX;
		_radio1.x = (width - radioWidth) / 2;
		_radio1.y = _check1.y + _check1.height + spacingY;
		_radio2.x = _radio1.x + _radio1.width + spacingX;
		_radio2.y = _radio1.y;
		_radio3.x = _radio2.x + _radio2.width + spacingX;
		_radio3.y = _radio1.y;
	}

	private function onBackButton():Void
	{
		dispatchEventWith(Event.COMPLETE);
	}
	
	private function toggleSwitch_changeHandler(event:Event):Void
	{
		trace("toggle switch isSelected:", _toggleSwitch.isSelected);
	}

	private function radioGroup_changeHandler(event:Event):Void
	{
		trace("radio group change:", _radioGroup.selectedIndex);
	}
	
	private function backButton_triggeredHandler(event:Event):Void
	{
		onBackButton();
	}
}