package feathers.examples.componentsExplorer.screens;

import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.Label;
import feathers.controls.Screen;
import feathers.controls.TabBar;
import feathers.data.ListCollection;
import flash.Vector;

import starling.display.DisplayObject;
import starling.events.Event;

@:meta(Event(name="complete",type="starling.events.Event"))

class TabBarScreen extends Screen {
	
	public function new() {
		super();
	}

	private var _header:Header;
	private var _backButton:Button;
	private var _tabBar:TabBar;
	private var _label:Label;

	@:protected override function initialize():Void {
		_tabBar = new TabBar();
		_tabBar.dataProvider = new ListCollection(
		[
			{ label: "One" },
			{ label: "Two" },
			{ label: "Three" },
		]);
		_tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
		addChild(_tabBar);

		_label = new Label();
		_label.text = "selectedIndex: " + _tabBar.selectedIndex;
		addChild(cast _label);

		_backButton = new Button();
		_backButton.label = "Back";
		_backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

		_header = new Header();
		_header.title = "Tab Bar";
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

		_tabBar.width = width;
		_tabBar.validate();
		_tabBar.y = height - _tabBar.height;

		_label.validate();
		_label.x = (width - _label.width) / 2;
		_label.y = _header.height + (height - _header.height - _tabBar.height - _label.height) / 2;
	}

	private function onBackButton():Void
	{
		dispatchEventWith(Event.COMPLETE);
	}

	private function backButton_triggeredHandler(event:Event):Void
	{
		onBackButton();
	}

	private function tabBar_changeHandler(event:Event):Void
	{
		_label.text = "selectedIndex: " + _tabBar.selectedIndex;
		invalidate();
	}
}
