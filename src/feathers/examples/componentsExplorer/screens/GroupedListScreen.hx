package feathers.examples.componentsExplorer.screens;

import feathers.controls.Button;
import feathers.controls.GroupedList;
import feathers.controls.Header;
import feathers.controls.Screen;
import feathers.data.HierarchicalCollection;
import feathers.examples.componentsExplorer.data.GroupedListSettings;
import flash.Vector;

import starling.display.DisplayObject;
import starling.events.Event;

@:meta(Event(name="complete",type="starling.events.Event"))
@:meta(Event(name="showSettings",type="starling.events.Event"))

class GroupedListScreen extends Screen {
	
	public static inline var SHOW_SETTINGS:String = "showSettings";

	public function new() {
		super();
	}

	public var settings:GroupedListSettings;
	
	private var _list:GroupedList;
	private var _header:Header;
	private var _backButton:Button;
	private var _settingsButton:Button;
	
	@:protected override function initialize():Void	{
		
		var groups:Array<Dynamic> = 
		[
			{
				header: "A",
				children:
				[
					{ text: "Aardvark" },
					{ text: "Alligator" },
					{ text: "Alpaca" },
					{ text: "Anteater" },
				]
			},
			{
				header: "B",
				children:
				[
					{ text: "Baboon" },
					{ text: "Bear" },
					{ text: "Beaver" },
				]
			},
			{
				header: "C",
				children:
				[
					{ text: "Canary" },
					{ text: "Cat" },
				]
			},
			{
				header: "D",
				children:
				[
					{ text: "Deer" },
					{ text: "Dingo" },
					{ text: "Dog" },
					{ text: "Dolphin" },
					{ text: "Donkey" },
					{ text: "Dragonfly" },
					{ text: "Duck" },
					{ text: "Dung Beetle" },
				]
			},
			{
				header: "E",
				children:
				[
					{ text: "Eagle" },
					{ text: "Earthworm" },
					{ text: "Eel" },
					{ text: "Elk" },
				]
			}
		];
		//groups.fixed = true;
		
		_list = new GroupedList();
		if(settings.style == GroupedListSettings.STYLE_INSET)
		{
			_list.nameList.add(GroupedList.ALTERNATE_NAME_INSET_GROUPED_LIST);
		}
		_list.dataProvider = new HierarchicalCollection(groups);
		_list.typicalItem = { text: "Item 1000" };
		_list.typicalHeader = "Group 10";
		_list.typicalFooter = "Footer 10";
		_list.isSelectable = settings.isSelectable;
		_list.scrollerProperties.hasElasticEdges = settings.hasElasticEdges;
		_list.itemRendererProperties.labelField = "text";
		_list.addEventListener(Event.CHANGE, list_changeHandler);
		addChildAt(_list, 0);

		_backButton = new Button();
		_backButton.label = "Back";
		_backButton.addEventListener(Event.TRIGGERED, backButtontriggeredHandler);

		_settingsButton = new Button();
		_settingsButton.label = "Settings";
		_settingsButton.addEventListener(Event.TRIGGERED, settingsButtontriggeredHandler);

		_header = new Header();
		_header.title = "Grouped List";
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
		_list.validate();
	}
	
	private function onBackButton():Void
	{
		dispatchEventWith(Event.COMPLETE);
	}
	
	private function backButtontriggeredHandler(event:Event):Void
	{
		onBackButton();
	}

	private function settingsButtontriggeredHandler(event:Event):Void
	{
		dispatchEventWith(SHOW_SETTINGS);
	}

	private function list_changeHandler(event:Event):Void
	{
		trace("GroupedList onChange:", _list.selectedGroupIndex, _list.selectedItemIndex);
	}
}