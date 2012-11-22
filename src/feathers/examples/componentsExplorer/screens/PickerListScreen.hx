package feathers.examples.componentsExplorer.screens;

import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.PickerList;
import feathers.controls.Screen;
import feathers.data.ListCollection;
import flash.Vector;

import starling.display.DisplayObject;
import starling.events.Event;

@:meta(Event(name="complete",type="starling.events.Event"))

class PickerListScreen extends Screen {
	
	public function new() {
		super();
	}
	
	private var _header:Header;
	private var _backButton:Button;
	private var _list:PickerList;
	
	@:protected override function initialize():Void {
		
		var items:Vector<Dynamic> = new Vector<Dynamic>();
		
		for(i in 0...150) {
			var item:Dynamic = {text: "Item " + (i + 1)};
			items.push(item);
		}
		items.fixed = true;

		_list = new PickerList();
		_list.dataProvider = new ListCollection(items);
		addChildAt(_list, 0);

		_list.typicalItem = {text: "Item 1000"};
		_list.labelField = "text";

		//notice that we're setting typicalItem on the list separately. we
		//may want to have the list measure at a different width, so it
		//might need a different typical item than the picker list's button.
		_list.listProperties.typicalItem = {text: "Item 1000"};

		//notice that we're setting labelField on the item renderers
		//separately. the default item renderer has a labelField property,
		//but a custom item renderer may not even have a label, so
		//PickerList cannot simply pass its labelField down to item
		//renderers automatically
		//_list.listProperties.itemRendererProperties.labelField = "text";

		_backButton = new Button();
		_backButton.label = "Back";
		_backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

		_header = new Header();
		_header.title = "Picker List";
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
		
		_list.validate();
		_list.x = (width - _list.width) / 2;
		_list.y = _header.height + (height - _header.height - _list.height) / 2;
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