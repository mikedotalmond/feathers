package feathers.examples.componentsExplorer.screens;

import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.Screen;
import starling.display.Image;

import feathers.examples.componentsExplorer.data.ButtonSettings;
import flash.display.BitmapData;
import flash.system.Capabilities;
import flash.Vector;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.textures.Texture;

@:meta(Event(name="complete",type="starling.events.Event"))
@:meta(Event(name="showSettings",type="starling.events.Event"))

@:bitmap("lib/MetalWorksMobileTheme/images/skull.png") @:final class Skull extends flash.display.BitmapData { }

class ButtonScreen extends Screen {
	
	public static inline var SHOW_SETTINGS:String = "showSettings";
	
	public function new() {
		super();
	}

	public var settings:ButtonSettings;

	private var _button:Button;
	private var _header:Header;
	private var _backButton:Button;
	private var _settingsButton:Button;
	
	private var _icon:Image;
	
	@:protected override function initialize():Void	{
		
		var dpiScale = 1;
		
		_icon = new Image(Texture.fromBitmapData(new Skull(0,0)));
		_icon.scaleX = _icon.scaleY = dpiScale;
		
		_button = new Button();
		_button.label = "Click Me";
		_button.isToggle = settings.isToggle;
		if(settings.hasIcon)
		{
			_button.defaultIcon = _icon;
		}
		_button.horizontalAlign = settings.horizontalAlign;
		_button.verticalAlign = settings.verticalAlign;
		_button.iconPosition = settings.iconPosition;
		_button.iconOffsetX = settings.iconOffsetX;
		_button.iconOffsetY = settings.iconOffsetY;
		_button.width = 264 * dpiScale;
		_button.height = 264 * dpiScale;
		_button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
		addChild(_button);

		_backButton = new Button();
		_backButton.label = "Back";
		_backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

		_settingsButton = new Button();
		_settingsButton.label = "Settings";
		_settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);

		_header = new Header();
		_header.title = "Button";
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

		_button.validate();
		_button.x = (width - _button.width) / 2;
		_button.y = _header.height + (height - _header.height - _button.height) / 2;
	}
	
	private function onBackButton():Void
	{
		dispatchEventWith(Event.COMPLETE);
	}

	private function button_triggeredHandler(event:Event):Void
	{
		trace("button triggered.");
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