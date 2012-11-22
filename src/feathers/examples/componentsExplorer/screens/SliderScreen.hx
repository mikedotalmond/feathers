package feathers.examples.componentsExplorer.screens;

import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.Label;
import feathers.controls.Screen;
import feathers.controls.Slider;
import feathers.examples.componentsExplorer.data.SliderSettings;
import flash.Vector;

import starling.display.DisplayObject;
import starling.events.Event;

@:meta(Event(name="complete",type="starling.events.Event"))
@:meta(Event(name="showSettings",type="starling.events.Event"))

class SliderScreen extends Screen {
	
	public static var SHOW_SETTINGS:String = "showSettings";

	public function new() {
		super();
	}

	public var settings:SliderSettings;

	private var _slider:Slider;
	private var _header:Header;
	private var _backButton:Button;
	private var _settingsButton:Button;
	private var _valueLabel:Label;
	
	@:protected override function initialize():Void
	{
		_slider = new Slider();
		_slider.minimum = 0;
		_slider.maximum = 100;
		_slider.value = 50;
		_slider.step = settings.step;
		_slider.page = settings.page;
		_slider.direction = settings.direction;
		_slider.liveDragging = settings.liveDragging;
		_slider.addEventListener(Event.CHANGE, slider_changeHandler);
		addChild(_slider);
		
		_valueLabel = new Label();
		_valueLabel.text = Std.string(_slider.value);
		addChild(cast _valueLabel);

		_backButton = new Button();
		_backButton.label = "Back";
		_backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

		_settingsButton = new Button();
		_settingsButton.label = "Settings";
		_settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);

		_header = new Header();
		_header.title = "Slider";
		addChild(_header);
		_header.leftItems = Vector.ofArray(
		[
			cast _backButton
		]);
		_header.rightItems = Vector.ofArray(
		[
			cast _settingsButton
		]);
		
		// handles the back hardware key on android
		backButtonHandler = onBackButton;
	}
	
	@:protected override function draw():Void
	{
		_header.width = width;
		_header.validate();

		var spacingX:Float = _header.height * 0.2;

		//auto-size the slider and label so that we can position them properly
		_slider.validate();

		_valueLabel.validate();

		var contentWidth:Float = _slider.width + spacingX + _valueLabel.width;
		_slider.x = (width - contentWidth) / 2;
		_slider.y = _header.height + (height - _header.height - _slider.height) / 2;
		_valueLabel.x = _slider.x + _slider.width + spacingX;
		_valueLabel.y = _slider.y + (_slider.height - _valueLabel.height) / 2;
	}
	
	private function onBackButton():Void
	{
		dispatchEventWith(Event.COMPLETE);
	}
	
	private function slider_changeHandler(event:Event):Void
	{
		_valueLabel.text = Std.string(_slider.value);
	}
	
	private function backButton_triggeredHandler(event:Event):Void
	{
		onBackButton();
	}

	private function settingsButton_triggeredHandler(event:Event):Void
	{
		dispatchEventWith(SHOW_SETTINGS);
	}
}