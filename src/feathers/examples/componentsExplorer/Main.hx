package feathers.examples.componentsExplorer;

import feathers.controls.Callout;
import feathers.controls.ScreenNavigator;
import feathers.controls.ScreenNavigatorItem;
import feathers.display.Scale9Image;
import feathers.examples.componentsExplorer.data.ButtonSettings;
import feathers.examples.componentsExplorer.data.GroupedListSettings;
import feathers.examples.componentsExplorer.data.ListSettings;
import feathers.examples.componentsExplorer.data.SliderSettings;
import feathers.examples.componentsExplorer.screens.ButtonGroupScreen;
import feathers.examples.componentsExplorer.screens.ButtonScreen;
import feathers.examples.componentsExplorer.screens.ButtonSettingsScreen;
import feathers.examples.componentsExplorer.screens.CalloutScreen;
import feathers.examples.componentsExplorer.screens.GroupedListScreen;
import feathers.examples.componentsExplorer.screens.GroupedListSettingsScreen;
import feathers.examples.componentsExplorer.screens.ListScreen;
import feathers.examples.componentsExplorer.screens.ListSettingsScreen;
import feathers.examples.componentsExplorer.screens.MainMenuScreen;
import feathers.examples.componentsExplorer.screens.PageIndicatorScreen;
import feathers.examples.componentsExplorer.screens.PickerListScreen;
import feathers.examples.componentsExplorer.screens.ProgressBarScreen;
import feathers.examples.componentsExplorer.screens.ScrollTextScreen;
import feathers.examples.componentsExplorer.screens.SliderScreen;
import feathers.examples.componentsExplorer.screens.SliderSettingsScreen;
import feathers.examples.componentsExplorer.screens.TabBarScreen;
import feathers.examples.componentsExplorer.screens.TextInputScreen;
import feathers.examples.componentsExplorer.screens.ToggleScreen;
import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
import feathers.themes.MetalWorksMobileTheme;
import flash.ui.Keyboard;
import flash.Vector;
import starling.core.Starling;

import starling.display.Sprite;
import starling.events.Event;

@:final class Main extends Sprite
{
	private static inline var MAIN_MENU:String = "mainMenu";
	private static inline var BUTTON:String = "button";
	private static inline var BUTTON_SETTINGS:String = "buttonSettings";
	private static inline var BUTTON_GROUP:String = "buttonGroup";
	private static inline var CALLOUT:String = "callout";
	private static inline var GROUPED_LIST:String = "groupedList";
	private static inline var GROUPED_LIST_SETTINGS:String = "groupedListSettings";
	private static inline var LIST:String = "list";
	private static inline var LIST_SETTINGS:String = "listSettings";
	private static inline var PAGE_INDICATOR:String = "pageIndicator";
	private static inline var PICKER_LIST:String = "pickerList";
	private static inline var PROGRESS_BAR:String = "progressBar";
	private static inline var SCROLL_TEXT:String = "scrollText";
	private static inline var SLIDER:String = "slider";
	private static inline var SLIDER_SETTINGS:String = "sliderSettings";
	private static inline var TAB_BAR:String = "tabBar";
	private static inline var TEXT_INPUT:String = "textInput";
	private static inline var TOGGLES:String = "toggles";
	
	public function new()
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}
	
	private var _theme:MetalWorksMobileTheme;
	private var _navigator:ScreenNavigator;
	private var _transitionManager:ScreenSlidingStackTransitionManager;
	
	private function addedToStageHandler(event:Event):Void
	{
		_theme = new MetalWorksMobileTheme(Starling.current.stage);
		
		_navigator = new ScreenNavigator();
		addChild(_navigator);
		
		_navigator.addScreen(MAIN_MENU, new ScreenNavigatorItem(MainMenuScreen,
		{
			showButton: BUTTON,
			showButtonGroup: BUTTON_GROUP,
			showCallout: CALLOUT,
			showGroupedList: GROUPED_LIST,
			showList: LIST,
			showPageIndicator: PAGE_INDICATOR,
			showPickerList: PICKER_LIST,
			showProgressBar: PROGRESS_BAR,
			showScrollText: SCROLL_TEXT,
			showSlider: SLIDER,
			showTabBar: TAB_BAR,
			showTextInput: TEXT_INPUT,
			showToggles: TOGGLES
		}));
		
		
		var buttonSettings:ButtonSettings = new ButtonSettings();
		_navigator.addScreen(BUTTON, new ScreenNavigatorItem(ButtonScreen,
		{
			complete: MAIN_MENU,
			showSettings: BUTTON_SETTINGS
		},
		{
			settings: buttonSettings
		}));

		_navigator.addScreen(BUTTON_SETTINGS, new ScreenNavigatorItem(ButtonSettingsScreen,
		{
			complete: BUTTON
		},
		{
			settings: buttonSettings
		}));

		_navigator.addScreen(BUTTON_GROUP, new ScreenNavigatorItem(ButtonGroupScreen,
		{
			complete: MAIN_MENU
		}));

		_navigator.addScreen(CALLOUT, new ScreenNavigatorItem(CalloutScreen,
		{
			complete: MAIN_MENU
		}));

		_navigator.addScreen(SCROLL_TEXT, new ScreenNavigatorItem(ScrollTextScreen,
		{
			complete: MAIN_MENU
		}));

		var sliderSettings:SliderSettings = new SliderSettings();
		_navigator.addScreen(SLIDER, new ScreenNavigatorItem(SliderScreen,
		{
			complete: MAIN_MENU,
			showSettings: SLIDER_SETTINGS
		},
		{
			settings: sliderSettings
		}));

		_navigator.addScreen(SLIDER_SETTINGS, new ScreenNavigatorItem(SliderSettingsScreen,
		{
			complete: SLIDER
		},
		{
			settings: sliderSettings
		}));
		
		_navigator.addScreen(TOGGLES, new ScreenNavigatorItem(ToggleScreen,
		{
			complete: MAIN_MENU
		}));

		var groupedListSettings:GroupedListSettings = new GroupedListSettings();
		_navigator.addScreen(GROUPED_LIST, new ScreenNavigatorItem(GroupedListScreen,
		{
			complete: MAIN_MENU,
			showSettings: GROUPED_LIST_SETTINGS
		},
		{
			settings: groupedListSettings
		}));

		_navigator.addScreen(GROUPED_LIST_SETTINGS, new ScreenNavigatorItem(GroupedListSettingsScreen,
		{
			complete: GROUPED_LIST
		},
		{
			settings: groupedListSettings
		}));

		var listSettings:ListSettings = new ListSettings();
		_navigator.addScreen(LIST, new ScreenNavigatorItem(ListScreen,
		{
			complete: MAIN_MENU,
			showSettings: LIST_SETTINGS
		},
		{
			settings: listSettings
		}));

		_navigator.addScreen(LIST_SETTINGS, new ScreenNavigatorItem(ListSettingsScreen,
		{
			complete: LIST
		},
		{
			settings: listSettings
		}));

		_navigator.addScreen(PAGE_INDICATOR, new ScreenNavigatorItem(PageIndicatorScreen,
		{
			complete: MAIN_MENU
		}));
		
		_navigator.addScreen(PICKER_LIST, new ScreenNavigatorItem(PickerListScreen,
		{
			complete: MAIN_MENU
		}));

		_navigator.addScreen(TAB_BAR, new ScreenNavigatorItem(TabBarScreen,
		{
			complete: MAIN_MENU
		}));

		_navigator.addScreen(TEXT_INPUT, new ScreenNavigatorItem(TextInputScreen,
		{
			complete: MAIN_MENU
		}));

		_navigator.addScreen(PROGRESS_BAR, new ScreenNavigatorItem(ProgressBarScreen,
		{
			complete: MAIN_MENU
		}));
		
		_navigator.showScreen(MAIN_MENU);
		
		_transitionManager = new ScreenSlidingStackTransitionManager(_navigator);
		_transitionManager.duration = 0.4;
	}
}