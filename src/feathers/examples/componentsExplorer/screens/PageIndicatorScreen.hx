package feathers.examples.componentsExplorer.screens;

import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.PageIndicator;
import feathers.controls.Screen;
import flash.Vector;

import starling.display.DisplayObject;
import starling.events.Event;

@:meta(Event(name="complete",type="starling.events.Event"))

class PageIndicatorScreen extends Screen {
	
	public function new() {
		super();
	}

	private var _header:Header;
	private var _backButton:Button;
	private var _pageIndicator:PageIndicator;

	@:protected override function initialize():Void
	{
		_pageIndicator = new PageIndicator();
		_pageIndicator.pageCount = 5;
		_pageIndicator.addEventListener(Event.CHANGE, pageIndicator_changeHandler);
		addChild(_pageIndicator);

		_backButton = new Button();
		_backButton.label = "Back";
		_backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

		_header = new Header();
		_header.title = "Page Indicator";
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

		_pageIndicator.width = width;
		_pageIndicator.validate();
		_pageIndicator.y = _header.height + (height - _header.height - _pageIndicator.height) / 2;
	}

	private function onBackButton():Void
	{
		dispatchEventWith(Event.COMPLETE);
	}

	private function pageIndicator_changeHandler(event:Event):Void
	{
		trace("page indicator change:", _pageIndicator.selectedIndex);
	}

	private function backButton_triggeredHandler(event:Event):Void
	{
		onBackButton();
	}
}
