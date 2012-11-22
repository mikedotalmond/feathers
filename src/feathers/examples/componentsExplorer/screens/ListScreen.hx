package feathers.examples.componentsExplorer.screens;

import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.List;
import feathers.controls.Screen;
import feathers.data.ListCollection;
import feathers.examples.componentsExplorer.data.ListSettings;
import flash.Vector;

import starling.display.DisplayObject;
import starling.events.Event;

@:meta(Event(name="complete",type="starling.events.Event"))
@:meta(Event(name="showSettings",type="starling.events.Event"))

class ListScreen extends Screen {
	
	public static var SHOW_SETTINGS:String = "showSettings";

	public function new() {
		super();
	}

	public var settings:ListSettings;

	private var _list:List;
	private var _header:Header;
	private var _backButton:Button;
	private var _settingsButton:Button;
	
	@:protected override function initialize():Void {
		var items:Vector<Dynamic> = new Vector<Dynamic>();
		for(i in 0...150) {
			var item:Dynamic = {text: "Item " + (i + 1)};
			items.push(item);
		}
		items.fixed = true;
		
		_list = new List();
		_list.dataProvider = new ListCollection(items);
		_list.typicalItem = {text: "Item 1000"};
		_list.isSelectable = settings.isSelectable;
		_list.scrollerProperties.hasElasticEdges = settings.hasElasticEdges;
		_list.itemRendererProperties.labelField = "text";
		_list.addEventListener(Event.CHANGE, list_changeHandler);
		addChildAt(_list, 0);

		_backButton = new Button();
		_backButton.label = "Back";
		_backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

		_settingsButton = new Button();
		_settingsButton.label = "Settings";
		_settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);

		_header = new Header();
		_header.title = "List";
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

	private function settingsButton_triggeredHandler(event:Event):Void
	{
		dispatchEventWith(SHOW_SETTINGS);
	}

	private function list_changeHandler(event:Event):Void
	{
		trace("List onChange:", _list.selectedIndex);
	}
}