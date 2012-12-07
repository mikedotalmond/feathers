/*
Copyright (c) 2012 Josh Tynjala

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package feathers.themes;

import feathers.controls.Button;
import feathers.controls.ButtonGroup;
import feathers.controls.Callout;
import feathers.controls.Check;
import feathers.controls.GroupedList;
import feathers.controls.Header;
import feathers.controls.ImageLoader;
import feathers.controls.Label;
import feathers.controls.List;
import feathers.controls.PageIndicator;
import feathers.controls.PickerList;
import feathers.controls.ProgressBar;
import feathers.controls.Radio;
import feathers.controls.Screen;
import feathers.controls.ScrollText;
import feathers.controls.Scroller;
import feathers.controls.SimpleScrollBar;
import feathers.controls.Slider;
import feathers.controls.TabBar;
import feathers.controls.TextInput;
import feathers.controls.ToggleSwitch;
import feathers.controls.popups.CalloutPopUpContentManager;
import feathers.controls.popups.VerticalCenteredPopUpContentManager;
import feathers.controls.renderers.BaseDefaultItemRenderer;
import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
import feathers.controls.renderers.DefaultGroupedListItemRenderer;
import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.controls.text.StageTextTextEditor;
import feathers.controls.text.TextFieldTextRenderer;
import feathers.core.DisplayListWatcher;
import feathers.core.FeathersControl;
import feathers.core.PopUpManager;
import feathers.display.Scale3Image;
import feathers.display.Scale9Image;
import feathers.display.TiledImage;
import feathers.layout.VerticalLayout;
import feathers.skins.ImageStateValueSelector;
import feathers.skins.Scale9ImageStateValueSelector;
import feathers.skins.StandardIcons;
import feathers.system.DeviceCapabilities;
import feathers.system.DeviceCapabilities;
import feathers.textures.Scale3Textures;
import feathers.textures.Scale9Textures;
import flash.Lib;
import flash.utils.ByteArray;
import flash.xml.XML;
import haxe.Resource;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.text.TextFormat;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.display.Quad;
import starling.events.Event;
import starling.events.ResizeEvent;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

@:bitmap("lib/MetalWorksMobileTheme/images/metalworks.png") @:final class ATLAS_IMAGE extends flash.display.BitmapData { }
@:file("lib/MetalWorksMobileTheme/images/metalworks.xml") @:final class ATLAS_XML extends ByteArray { }

class MetalWorksMobileTheme extends DisplayListWatcher {
	
	private static inline var LIGHT_TEXT_COLOR:UInt = 0xe5e5e5;
	private static inline var DARK_TEXT_COLOR:UInt = 0x1a1a1a;
	private static inline var SELECTED_TEXT_COLOR:UInt = 0xff9900;
	private static inline var DISABLED_TEXT_COLOR:UInt = 0x333333;

	private static inline var ORIGINAL_DPI_IPHONE_RETINA:Int = 326;
	private static inline var ORIGINAL_DPI_IPAD_RETINA:Int = 264;

	private static var DEFAULT_SCALE9_GRID:Rectangle = new Rectangle(5, 5, 22, 22);
	private static var BUTTON_SCALE9_GRID:Rectangle = new Rectangle(5, 5, 50, 50);
	private static var ITEM_RENDERER_SCALE9_GRID:Rectangle = new Rectangle(13, 0, 3, 82);
	private static var INSET_ITEM_RENDERER_MIDDLE_SCALE9_GRID:Rectangle = new Rectangle(13, 0, 2, 82);
	private static var INSET_ITEM_RENDERER_FIRST_SCALE9_GRID:Rectangle = new Rectangle(13, 13, 3, 70);
	private static var INSET_ITEM_RENDERER_LAST_SCALE9_GRID:Rectangle = new Rectangle(13, 0, 3, 75);
	private static var INSET_ITEM_RENDERER_SINGLE_SCALE9_GRID:Rectangle = new Rectangle(13, 13, 3, 62);
	private static var TAB_SCALE9_GRID:Rectangle = new Rectangle(19, 19, 50, 50);
	private static inline var SCROLL_BAR_THUMB_REGION1:Int = 5;
	private static inline var SCROLL_BAR_THUMB_REGION2:Int = 14;

	public static inline var COMPONENT_NAME_PICKER_LIST_ITEM_RENDERER:String = "feathers-mobile-picker-list-item-renderer";

	private static function textRendererFactory():TextFieldTextRenderer {
		return new TextFieldTextRenderer();
	}

	private static function textEditorFactory():StageTextTextEditor {
		return new StageTextTextEditor();
	}

	private static function popUpOverlayFactory():DisplayObject {
		var quad:Quad = new Quad(100, 100, 0x1a1a1a);
		quad.alpha = 0.85;
		return quad;
	}

	public function new(root:DisplayObjectContainer, scaleToDPI:Bool = true)
	{
		super(root);
		_scaleToDPI = scaleToDPI;
		initialize(root);
	}

	private var _originalDPI:Int;
	public var originalDPI(get_originalDPI, null):Int;
	private function get_originalDPI(){  return _originalDPI; }

	private var _scaleToDPI:Bool;
	public var scaleToDPI(get_scaleToDPI, null):Bool;
	private function get_scaleToDPI():Bool { return _scaleToDPI; }

	private var scale:Float = 1;

	private var primaryBackground:TiledImage;

	private var headerTextFormat:TextFormat;

	private var smallUIDarkTextFormat:TextFormat;
	private var smallUILightTextFormat:TextFormat;
	private var smallUISelectedTextFormat:TextFormat;
	private var smallUIDisabledTextFormat:TextFormat;

	private var largeUIDarkTextFormat:TextFormat;
	private var largeUILightTextFormat:TextFormat;
	private var largeUISelectedTextFormat:TextFormat;
	private var largeUIDisabledTextFormat:TextFormat;

	private var largeDarkTextFormat:TextFormat;
	private var largeLightTextFormat:TextFormat;
	private var largeDisabledTextFormat:TextFormat;

	private var smallDarkTextFormat:TextFormat;
	private var smallLightTextFormat:TextFormat;
	private var smallDisabledTextFormat:TextFormat;

	private var atlas:TextureAtlas;
	private var atlasBitmapData:BitmapData;
	private var primaryBackgroundTexture:Texture;
	private var backgroundSkinTextures:Scale9Textures;
	private var backgroundDisabledSkinTextures:Scale9Textures;
	private var backgroundFocusedSkinTextures:Scale9Textures;
	private var buttonUpSkinTextures:Scale9Textures;
	private var buttonDownSkinTextures:Scale9Textures;
	private var buttonDisabledSkinTextures:Scale9Textures;
	private var buttonSelectedUpSkinTextures:Scale9Textures;
	private var buttonSelectedDisabledSkinTextures:Scale9Textures;
	private var pickerListButtonIconTexture:Texture;
	private var tabDownSkinTextures:Scale9Textures;
	private var tabSelectedSkinTextures:Scale9Textures;
	private var pickerListItemSelectedIconTexture:Texture;
	private var radioUpIconTexture:Texture;
	private var radioDownIconTexture:Texture;
	private var radioDisabledIconTexture:Texture;
	private var radioSelectedUpIconTexture:Texture;
	private var radioSelectedDownIconTexture:Texture;
	private var radioSelectedDisabledIconTexture:Texture;
	private var checkUpIconTexture:Texture;
	private var checkDownIconTexture:Texture;
	private var checkDisabledIconTexture:Texture;
	private var checkSelectedUpIconTexture:Texture;
	private var checkSelectedDownIconTexture:Texture;
	private var checkSelectedDisabledIconTexture:Texture;
	private var pageIndicatorNormalSkinTexture:Texture;
	private var pageIndicatorSelectedSkinTexture:Texture;
	private var itemRendererUpSkinTextures:Scale9Textures;
	private var itemRendererSelectedSkinTextures:Scale9Textures;
	private var insetItemRendererMiddleUpSkinTextures:Scale9Textures;
	private var insetItemRendererMiddleSelectedSkinTextures:Scale9Textures;
	private var insetItemRendererFirstUpSkinTextures:Scale9Textures;
	private var insetItemRendererFirstSelectedSkinTextures:Scale9Textures;
	private var insetItemRendererLastUpSkinTextures:Scale9Textures;
	private var insetItemRendererLastSelectedSkinTextures:Scale9Textures;
	private var insetItemRendererSingleUpSkinTextures:Scale9Textures;
	private var insetItemRendererSingleSelectedSkinTextures:Scale9Textures;
	private var calloutTopArrowSkinTexture:Texture;
	private var calloutRightArrowSkinTexture:Texture;
	private var calloutBottomArrowSkinTexture:Texture;
	private var calloutLeftArrowSkinTexture:Texture;
	private var verticalScrollBarThumbSkinTextures:Scale3Textures;
	private var horizontalScrollBarThumbSkinTextures:Scale3Textures;

	override public function dispose():Void
	{
		if (root != null)
		{
			root.removeEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
			if(primaryBackground!=null)
			{
				root.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
				root.removeEventListener(Event.REMOVED_FROM_STAGE, root_removedFromStageHandler);
				root.removeChild(primaryBackground, true);
				primaryBackground = null;
			}
		}
		if(atlas  !=null)
		{
			atlas.dispose();
			atlas = null;
		}
		if(atlasBitmapData!=null)
		{
			atlasBitmapData.dispose();
			atlasBitmapData = null;
		}
		super.dispose();
	}

	private function initializeRoot():Void
	{
		primaryBackground = new TiledImage(primaryBackgroundTexture);
		primaryBackground.width = root.stage.stageWidth;
		primaryBackground.height = root.stage.stageHeight;
		root.addChildAt(primaryBackground, 0);
		root.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		root.addEventListener(Event.REMOVED_FROM_STAGE, root_removedFromStageHandler);
	}

	private function initialize(root:DisplayObjectContainer):Void
	{
		var scaledDPI:Int = cast DeviceCapabilities.dpi / Starling.contentScaleFactor;
		_originalDPI = scaledDPI;
		if(_scaleToDPI)
		{
			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				_originalDPI = ORIGINAL_DPI_IPAD_RETINA;
			}
			else
			{
				_originalDPI = ORIGINAL_DPI_IPHONE_RETINA;
			}
		}

		scale = scaledDPI / _originalDPI;

		FeathersControl.defaultTextRendererFactory = textRendererFactory;
		FeathersControl.defaultTextEditorFactory = textEditorFactory;

		var fontNames:String = "Helvetica Neue,Helvetica,Roboto,Arial,_sans";

		headerTextFormat = new TextFormat(fontNames, Math.round(36 * scale), LIGHT_TEXT_COLOR, true);

		smallUIDarkTextFormat = new TextFormat(fontNames, 24 * scale, DARK_TEXT_COLOR, true);
		smallUILightTextFormat = new TextFormat(fontNames, 24 * scale, LIGHT_TEXT_COLOR, true);
		smallUISelectedTextFormat = new TextFormat(fontNames, 24 * scale, SELECTED_TEXT_COLOR, true);
		smallUIDisabledTextFormat = new TextFormat(fontNames, 24 * scale, DISABLED_TEXT_COLOR, true);

		largeUIDarkTextFormat = new TextFormat(fontNames, 30 * scale, DARK_TEXT_COLOR, true);
		largeUILightTextFormat = new TextFormat(fontNames, 30 * scale, LIGHT_TEXT_COLOR, true);
		largeUISelectedTextFormat = new TextFormat(fontNames, 30 * scale, SELECTED_TEXT_COLOR, true);
		largeUIDisabledTextFormat = new TextFormat(fontNames, 30 * scale, DISABLED_TEXT_COLOR, true);

		smallDarkTextFormat = new TextFormat(fontNames, 24 * scale, DARK_TEXT_COLOR);
		smallLightTextFormat = new TextFormat(fontNames, 24 * scale, LIGHT_TEXT_COLOR);
		smallDisabledTextFormat = new TextFormat(fontNames, 24 * scale, DISABLED_TEXT_COLOR);

		largeDarkTextFormat = new TextFormat(fontNames, 30 * scale, DARK_TEXT_COLOR);
		largeLightTextFormat = new TextFormat(fontNames, 30 * scale, LIGHT_TEXT_COLOR);
		largeDisabledTextFormat = new TextFormat(fontNames, 30 * scale, DISABLED_TEXT_COLOR);

		PopUpManager.overlayFactory = popUpOverlayFactory;
		Callout.stagePaddingTop = Callout.stagePaddingRight = Callout.stagePaddingBottom =
			Callout.stagePaddingLeft = 16 * scale;

		var atlasBitmapData:BitmapData = new ATLAS_IMAGE(0, 0);
		var a = new ATLAS_XML();
		a.position = 0;
		atlas = new TextureAtlas(Texture.fromBitmapData(atlasBitmapData, false), new XML(a.readUTFBytes(a.length)));
		
		if(Starling.handleLostContext)
		{
			this.atlasBitmapData = atlasBitmapData;
		}
		else
		{
			atlasBitmapData.dispose();
		}

		primaryBackgroundTexture = atlas.getTexture("primary-background");

		var backgroundSkinTexture:Texture = atlas.getTexture("background-skin");
		var backgroundDownSkinTexture:Texture = atlas.getTexture("background-down-skin");
		var backgroundDisabledSkinTexture:Texture = atlas.getTexture("background-disabled-skin");
		var backgroundFocusedSkinTexture:Texture = atlas.getTexture("background-focused-skin");

		backgroundSkinTextures = new Scale9Textures(backgroundSkinTexture, DEFAULT_SCALE9_GRID);
		backgroundDisabledSkinTextures = new Scale9Textures(backgroundDisabledSkinTexture, DEFAULT_SCALE9_GRID);
		backgroundFocusedSkinTextures = new Scale9Textures(backgroundFocusedSkinTexture, DEFAULT_SCALE9_GRID);

		buttonUpSkinTextures = new Scale9Textures(atlas.getTexture("button-up-skin"), BUTTON_SCALE9_GRID);
		buttonDownSkinTextures = new Scale9Textures(atlas.getTexture("button-down-skin"), BUTTON_SCALE9_GRID);
		buttonDisabledSkinTextures = new Scale9Textures(atlas.getTexture("button-disabled-skin"), BUTTON_SCALE9_GRID);
		buttonSelectedUpSkinTextures = new Scale9Textures(atlas.getTexture("button-selected-up-skin"), BUTTON_SCALE9_GRID);
		buttonSelectedDisabledSkinTextures = new Scale9Textures(atlas.getTexture("button-selected-disabled-skin"), BUTTON_SCALE9_GRID);

		tabDownSkinTextures = new Scale9Textures(atlas.getTexture("tab-down-skin"), TAB_SCALE9_GRID);
		tabSelectedSkinTextures = new Scale9Textures(atlas.getTexture("tab-selected-skin"), TAB_SCALE9_GRID);

		pickerListButtonIconTexture = atlas.getTexture("picker-list-icon");
		pickerListItemSelectedIconTexture = atlas.getTexture("picker-list-item-selected-icon");

		radioUpIconTexture = backgroundSkinTexture;
		radioDownIconTexture = backgroundDownSkinTexture;
		radioDisabledIconTexture = backgroundDisabledSkinTexture;
		radioSelectedUpIconTexture = atlas.getTexture("radio-selected-up-icon");
		radioSelectedDownIconTexture = atlas.getTexture("radio-selected-down-icon");
		radioSelectedDisabledIconTexture = atlas.getTexture("radio-selected-disabled-icon");

		checkUpIconTexture = backgroundSkinTexture;
		checkDownIconTexture = backgroundDownSkinTexture;
		checkDisabledIconTexture = backgroundDisabledSkinTexture;
		checkSelectedUpIconTexture = atlas.getTexture("check-selected-up-icon");
		checkSelectedDownIconTexture = atlas.getTexture("check-selected-down-icon");
		checkSelectedDisabledIconTexture = atlas.getTexture("check-selected-disabled-icon");

		pageIndicatorSelectedSkinTexture = atlas.getTexture("page-indicator-selected-skin");
		pageIndicatorNormalSkinTexture = atlas.getTexture("page-indicator-normal-skin");

		itemRendererUpSkinTextures = new Scale9Textures(atlas.getTexture("list-item-up-skin"), ITEM_RENDERER_SCALE9_GRID);
		itemRendererSelectedSkinTextures = new Scale9Textures(atlas.getTexture("list-item-selected-skin"), ITEM_RENDERER_SCALE9_GRID);
		insetItemRendererMiddleUpSkinTextures = new Scale9Textures(atlas.getTexture("list-inset-item-middle-up-skin"), INSET_ITEM_RENDERER_MIDDLE_SCALE9_GRID);
		insetItemRendererMiddleSelectedSkinTextures = new Scale9Textures(atlas.getTexture("list-inset-item-middle-selected-skin"), INSET_ITEM_RENDERER_MIDDLE_SCALE9_GRID);
		insetItemRendererFirstUpSkinTextures = new Scale9Textures(atlas.getTexture("list-inset-item-first-up-skin"), INSET_ITEM_RENDERER_FIRST_SCALE9_GRID);
		insetItemRendererFirstSelectedSkinTextures = new Scale9Textures(atlas.getTexture("list-inset-item-first-selected-skin"), INSET_ITEM_RENDERER_FIRST_SCALE9_GRID);
		insetItemRendererLastUpSkinTextures = new Scale9Textures(atlas.getTexture("list-inset-item-last-up-skin"), INSET_ITEM_RENDERER_LAST_SCALE9_GRID);
		insetItemRendererLastSelectedSkinTextures = new Scale9Textures(atlas.getTexture("list-inset-item-last-selected-skin"), INSET_ITEM_RENDERER_LAST_SCALE9_GRID);
		insetItemRendererSingleUpSkinTextures = new Scale9Textures(atlas.getTexture("list-inset-item-single-up-skin"), INSET_ITEM_RENDERER_SINGLE_SCALE9_GRID);
		insetItemRendererSingleSelectedSkinTextures = new Scale9Textures(atlas.getTexture("list-inset-item-single-selected-skin"), INSET_ITEM_RENDERER_SINGLE_SCALE9_GRID);

		calloutTopArrowSkinTexture = atlas.getTexture("callout-arrow-top-skin");
		calloutRightArrowSkinTexture = atlas.getTexture("callout-arrow-right-skin");
		calloutBottomArrowSkinTexture = atlas.getTexture("callout-arrow-bottom-skin");
		calloutLeftArrowSkinTexture = atlas.getTexture("callout-arrow-left-skin");

		horizontalScrollBarThumbSkinTextures = new Scale3Textures(atlas.getTexture("horizontal-scroll-bar-thumb-skin"), SCROLL_BAR_THUMB_REGION1, SCROLL_BAR_THUMB_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);
		verticalScrollBarThumbSkinTextures = new Scale3Textures(atlas.getTexture("vertical-scroll-bar-thumb-skin"), SCROLL_BAR_THUMB_REGION1, SCROLL_BAR_THUMB_REGION2, Scale3Textures.DIRECTION_VERTICAL);

		StandardIcons.listDrillDownAccessoryTexture = atlas.getTexture("list-accessory-drill-down-icon");
		
		if(root.stage.parent!=null){
			initializeRoot();
		} else {
			root.addEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
		}

		setInitializerForClassAndSubclasses(Screen, screenInitializer);
		setInitializerForClass(Label, labelInitializer);
		setInitializerForClass(TextFieldTextRenderer, itemRendererAccessoryLabelInitializer, BaseDefaultItemRenderer.DEFAULT_CHILD_NAME_ACCESSORY_LABEL);
		setInitializerForClass(ScrollText, scrollTextInitializer);
		setInitializerForClass(Button, buttonInitializer);
		setInitializerForClass(Button, buttonGroupButtonInitializer, ButtonGroup.DEFAULT_CHILD_NAME_BUTTON);
		setInitializerForClass(Button, simpleButtonInitializer, ToggleSwitch.DEFAULT_CHILD_NAME_THUMB);
		setInitializerForClass(Button, simpleButtonInitializer, Slider.DEFAULT_CHILD_NAME_THUMB);
		setInitializerForClass(Button, pickerListButtonInitializer, PickerList.DEFAULT_CHILD_NAME_BUTTON);
		setInitializerForClass(Button, tabInitializer, TabBar.DEFAULT_CHILD_NAME_TAB);
		setInitializerForClass(Button, nothingInitializer, Slider.DEFAULT_CHILD_NAME_MINIMUM_TRACK);
		setInitializerForClass(Button, nothingInitializer, Slider.DEFAULT_CHILD_NAME_MAXIMUM_TRACK);
		setInitializerForClass(Button, toggleSwitchTrackInitializer, ToggleSwitch.DEFAULT_CHILD_NAME_ON_TRACK);
		setInitializerForClass(Button, nothingInitializer, SimpleScrollBar.DEFAULT_CHILD_NAME_THUMB);
		setInitializerForClass(ButtonGroup, buttonGroupInitializer);
		setInitializerForClass(DefaultListItemRenderer, itemRendererInitializer);
		setInitializerForClass(DefaultListItemRenderer, pickerListItemRendererInitializer, COMPONENT_NAME_PICKER_LIST_ITEM_RENDERER);
		setInitializerForClass(DefaultGroupedListItemRenderer, itemRendererInitializer);
		setInitializerForClass(DefaultGroupedListItemRenderer, insetMiddleItemRendererInitializer, GroupedList.ALTERNATE_CHILD_NAME_INSET_ITEM_RENDERER);
		setInitializerForClass(DefaultGroupedListItemRenderer, insetFirstItemRendererInitializer, GroupedList.ALTERNATE_CHILD_NAME_INSET_FIRST_ITEM_RENDERER);
		setInitializerForClass(DefaultGroupedListItemRenderer, insetLastItemRendererInitializer, GroupedList.ALTERNATE_CHILD_NAME_INSET_LAST_ITEM_RENDERER);
		setInitializerForClass(DefaultGroupedListItemRenderer, insetSingleItemRendererInitializer, GroupedList.ALTERNATE_CHILD_NAME_INSET_SINGLE_ITEM_RENDERER);
		setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, headerRendererInitializer);
		setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, footerRendererInitializer, GroupedList.DEFAULT_CHILD_NAME_FOOTER_RENDERER);
		setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, insetHeaderRendererInitializer, GroupedList.ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER);
		setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, insetFooterRendererInitializer, GroupedList.ALTERNATE_CHILD_NAME_INSET_FOOTER_RENDERER);
		setInitializerForClass(Radio, radioInitializer);
		setInitializerForClass(Check, checkInitializer);
		setInitializerForClass(Slider, sliderInitializer);
		setInitializerForClass(ToggleSwitch, toggleSwitchInitializer);
		setInitializerForClass(TextInput, textInputInitializer);
		setInitializerForClass(PageIndicator, pageIndicatorInitializer);
		setInitializerForClass(ProgressBar, progressBarInitializer);
		setInitializerForClass(PickerList, pickerListInitializer);
		setInitializerForClass(Header, headerInitializer);
		setInitializerForClass(Callout, calloutInitializer);
		setInitializerForClass(Scroller, scrollerInitializer);
		setInitializerForClass(List, nothingInitializer, PickerList.DEFAULT_CHILD_NAME_LIST);
		setInitializerForClass(GroupedList, insetGroupedListInitializer, GroupedList.ALTERNATE_NAME_INSET_GROUPED_LIST);
	}

	private function pageIndicatorNormalSymbolFactory():Image
	{
		return new Image(pageIndicatorNormalSkinTexture);
	}

	private function pageIndicatorSelectedSymbolFactory():Image
	{
		return new Image(pageIndicatorSelectedSkinTexture);
	}
	
	private function imageLoaderFactory():ImageLoader {
		var image:ImageLoader = new ImageLoader();
		image.textureScale = scale;
		return image;
	}

	private function horizontalScrollBarFactory():SimpleScrollBar
	{
		var scrollBar:SimpleScrollBar = new SimpleScrollBar();
		scrollBar.direction = SimpleScrollBar.DIRECTION_HORIZONTAL;
		var defaultSkin:Scale3Image = new Scale3Image(horizontalScrollBarThumbSkinTextures, scale);
		defaultSkin.width = 10 * scale;
		scrollBar.thumbProperties.defaultSkin = defaultSkin;
		scrollBar.paddingRight = scrollBar.paddingBottom = scrollBar.paddingLeft = 4 * scale;
		return scrollBar;
	}

	private function verticalScrollBarFactory():SimpleScrollBar
	{
		var scrollBar:SimpleScrollBar = new SimpleScrollBar();
		scrollBar.direction = SimpleScrollBar.DIRECTION_VERTICAL;
		var defaultSkin:Scale3Image = new Scale3Image(verticalScrollBarThumbSkinTextures, scale);
		defaultSkin.height = 10 * scale;
		scrollBar.thumbProperties.defaultSkin = defaultSkin;
		scrollBar.paddingTop = scrollBar.paddingRight = scrollBar.paddingBottom = 4 * scale;
		return scrollBar;
	}

	private function nothingInitializer(target:DisplayObject):Void {}

	private function screenInitializer(screen:Screen):Void
	{
		screen.originalDPI = _originalDPI;
	}

	private function simpleButtonInitializer(button:Button):Void
	{
		var skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
		skinSelector.defaultValue = buttonUpSkinTextures;
		skinSelector.setValueForState(buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.imageProperties =
		{
			width: 60 * scale,
			height: 60 * scale,
			textureScale: scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;

		button.minWidth = button.minHeight = 60 * scale;
		button.minTouchWidth = button.minTouchHeight = 88 * scale;
	}

	private function labelInitializer(label:Label):Void
	{
		label.textRendererProperties.textFormat = smallLightTextFormat;
	}

	private function itemRendererAccessoryLabelInitializer(renderer:TextFieldTextRenderer):Void
	{
		renderer.textFormat = smallLightTextFormat;
	}

	private function scrollTextInitializer(text:ScrollText):Void
	{
		text.textFormat = smallLightTextFormat;
		text.paddingTop = text.paddingBottom = text.paddingLeft = 32 * scale;
		text.paddingRight = 36 * scale;
	}

	private function buttonInitializer(button:Button):Void
	{
		var skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
		skinSelector.defaultValue = buttonUpSkinTextures;
		skinSelector.defaultSelectedValue = buttonSelectedUpSkinTextures;
		skinSelector.setValueForState(buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.setValueForState(buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
		skinSelector.imageProperties =
		{
			width: 60 * scale,
			height: 60 * scale,
			textureScale: scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;

		button.defaultLabelProperties.textFormat = smallUIDarkTextFormat;
		button.disabledLabelProperties.textFormat = smallUIDisabledTextFormat;
		button.selectedDisabledLabelProperties.textFormat = smallUIDisabledTextFormat;

		button.paddingTop = button.paddingBottom = 8 * scale;
		button.paddingLeft = button.paddingRight = 16 * scale;
		button.gap = 12 * scale;
		button.minWidth = button.minHeight = 60 * scale;
		button.minTouchWidth = button.minTouchHeight = 88 * scale;
	}

	private function buttonGroupButtonInitializer(button:Button):Void
	{
		var skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
		skinSelector.defaultValue = buttonUpSkinTextures;
		skinSelector.defaultSelectedValue = buttonSelectedUpSkinTextures;
		skinSelector.setValueForState(buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.setValueForState(buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
		skinSelector.imageProperties =
		{
			width: 76 * scale,
			height: 76 * scale,
			textureScale: scale
		};
		button.stateToSkinFunction = skinSelector.updateValue;

		button.defaultLabelProperties.textFormat = largeUIDarkTextFormat;
		button.disabledLabelProperties.textFormat = largeUIDisabledTextFormat;
		button.selectedDisabledLabelProperties.textFormat = largeUIDisabledTextFormat;

		button.paddingTop = button.paddingBottom = 8 * scale;
		button.paddingLeft = button.paddingRight = 16 * scale;
		button.gap = 12 * scale;
		button.minWidth = button.minHeight = 76 * scale;
		button.minTouchWidth = button.minTouchHeight = 88 * scale;
	}

	private function pickerListButtonInitializer(button:Button):Void
	{
		buttonInitializer(button);

		var defaultIcon:Image = new Image(pickerListButtonIconTexture);
		defaultIcon.scaleX = defaultIcon.scaleY = scale;
		button.defaultIcon = defaultIcon;

		button.gap = Math.POSITIVE_INFINITY;
		button.iconPosition = Button.ICON_POSITION_RIGHT;
	}

	private function toggleSwitchTrackInitializer(track:Button):Void
	{
		var skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
		skinSelector.defaultValue = backgroundSkinTextures;
		skinSelector.setValueForState(backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.imageProperties =
		{
			width: 150 * scale,
			height: 60 * scale,
			textureScale: scale
		};
		track.stateToSkinFunction = skinSelector.updateValue;
	}

	private function tabInitializer(tab:Button):Void
	{
		var defaultSkin:Quad = new Quad(88 * scale, 88 * scale, 0x1a1a1a);
		tab.defaultSkin = defaultSkin;

		var downSkin:Scale9Image = new Scale9Image(tabDownSkinTextures, scale);
		tab.downSkin = downSkin;

		var defaultSelectedSkin:Scale9Image = new Scale9Image(tabSelectedSkinTextures, scale);
		tab.defaultSelectedSkin = defaultSelectedSkin;

		tab.defaultLabelProperties.textFormat = smallUILightTextFormat;
		tab.defaultSelectedLabelProperties.textFormat = smallUIDarkTextFormat;
		tab.disabledLabelProperties.textFormat = smallUIDisabledTextFormat;
		tab.selectedDisabledLabelProperties.textFormat = smallUIDisabledTextFormat;

		tab.paddingTop = tab.paddingBottom = 8 * scale;
		tab.paddingLeft = tab.paddingRight = 16 * scale;
		tab.gap = 12 * scale;
		tab.minWidth = tab.minHeight = 88 * scale;
		tab.minTouchWidth = tab.minTouchHeight = 88 * scale;
	}

	private function buttonGroupInitializer(group:ButtonGroup):Void
	{
		group.minWidth = 560 * scale;
		group.gap = 18 * scale;
	}

	private function itemRendererInitializer(renderer:BaseDefaultItemRenderer):Void
	{
		var skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
		skinSelector.defaultValue = itemRendererUpSkinTextures;
		skinSelector.defaultSelectedValue = itemRendererSelectedSkinTextures;
		skinSelector.setValueForState(itemRendererSelectedSkinTextures, Button.STATE_DOWN, false);
		skinSelector.imageProperties =
		{
			width: 88 * scale,
			height: 88 * scale,
			textureScale: scale
		};
		renderer.stateToSkinFunction = skinSelector.updateValue;

		renderer.defaultLabelProperties.textFormat = largeLightTextFormat;
		renderer.downLabelProperties.textFormat = largeDarkTextFormat;
		renderer.defaultSelectedLabelProperties.textFormat = largeDarkTextFormat;

		renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
		renderer.paddingTop = renderer.paddingBottom = 8 * scale;
		renderer.paddingLeft = 32 * scale;
		renderer.paddingRight = 24 * scale;
		renderer.gap = 20 * scale;
		
		renderer.iconPosition = Button.ICON_POSITION_LEFT;
		renderer.accessoryGap = Math.POSITIVE_INFINITY;
		renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
		
		renderer.minWidth = renderer.minHeight = 88 * scale;
		renderer.minTouchWidth = renderer.minTouchHeight = 88 * scale;

		renderer.accessoryLoaderFactory = imageLoaderFactory;
		renderer.iconLoaderFactory = imageLoaderFactory;
	}

	private function pickerListItemRendererInitializer(renderer:BaseDefaultItemRenderer):Void
	{
		var skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
		skinSelector.defaultValue = itemRendererUpSkinTextures;
		skinSelector.setValueForState(itemRendererSelectedSkinTextures, Button.STATE_DOWN, false);
		skinSelector.imageProperties =
		{
			width: 88 * scale,
			height: 88 * scale,
			textureScale: scale
		};
		renderer.stateToSkinFunction = skinSelector.updateValue;

		var defaultSelectedIcon:Image = new Image(pickerListItemSelectedIconTexture);
		defaultSelectedIcon.scaleX = defaultSelectedIcon.scaleY = scale;
		renderer.defaultSelectedIcon = defaultSelectedIcon;

		var defaultIcon:Quad = new Quad(defaultSelectedIcon.width, defaultSelectedIcon.height, 0xff00ff);
		defaultIcon.alpha = 0;
		renderer.defaultIcon = defaultIcon;

		renderer.defaultLabelProperties.textFormat = largeLightTextFormat;
		renderer.downLabelProperties.textFormat = largeDarkTextFormat;

		renderer.itemHasIcon = false;
		renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
		renderer.paddingTop = renderer.paddingBottom = 8 * scale;
		renderer.paddingLeft = 32 * scale;
		renderer.paddingRight = 24 * scale;
		renderer.gap = 12 * scale;
		
		renderer.iconPosition = Button.ICON_POSITION_LEFT;
		renderer.accessoryGap = Math.POSITIVE_INFINITY;
		renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
		
		renderer.minWidth = renderer.minHeight = 88 * scale;
		renderer.minTouchWidth = renderer.minTouchHeight = 88 * scale;
	}

	private function insetItemRendererInitializer(renderer:DefaultGroupedListItemRenderer, defaultSkinTextures:Scale9Textures, selectedAndDownSkinTextures:Scale9Textures):Void
	{
		var skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
		skinSelector.defaultValue = defaultSkinTextures;
		skinSelector.defaultSelectedValue = selectedAndDownSkinTextures;
		skinSelector.setValueForState(selectedAndDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.imageProperties =
		{
			width: 88 * scale,
			height: 88 * scale,
			textureScale: scale
		};
		renderer.stateToSkinFunction = skinSelector.updateValue;

		renderer.defaultLabelProperties.textFormat = largeLightTextFormat;
		renderer.downLabelProperties.textFormat = largeDarkTextFormat;
		renderer.defaultSelectedLabelProperties.textFormat = largeDarkTextFormat;

		renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
		renderer.paddingTop = renderer.paddingBottom = 8 * scale;
		renderer.paddingLeft = 32 * scale;
		renderer.paddingRight = 24 * scale;
		renderer.gap = 20 * scale;
		
		renderer.iconPosition = Button.ICON_POSITION_LEFT;
		renderer.accessoryGap = Math.POSITIVE_INFINITY;
		renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;
			
		renderer.minWidth = renderer.minHeight = 88 * scale;
		renderer.minTouchWidth = renderer.minTouchHeight = 88 * scale;
	}

	private function insetMiddleItemRendererInitializer(renderer:DefaultGroupedListItemRenderer):Void
	{
		insetItemRendererInitializer(renderer, insetItemRendererMiddleUpSkinTextures, insetItemRendererMiddleSelectedSkinTextures);
	}

	private function insetFirstItemRendererInitializer(renderer:DefaultGroupedListItemRenderer):Void
	{
		insetItemRendererInitializer(renderer, insetItemRendererFirstUpSkinTextures, insetItemRendererFirstSelectedSkinTextures);
	}

	private function insetLastItemRendererInitializer(renderer:DefaultGroupedListItemRenderer):Void
	{
		insetItemRendererInitializer(renderer, insetItemRendererLastUpSkinTextures, insetItemRendererLastSelectedSkinTextures);
	}

	private function insetSingleItemRendererInitializer(renderer:DefaultGroupedListItemRenderer):Void
	{
		insetItemRendererInitializer(renderer, insetItemRendererSingleUpSkinTextures, insetItemRendererSingleSelectedSkinTextures);
	}

	private function headerRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):Void
	{
		var defaultSkin:Quad = new Quad(44 * scale, 44 * scale, 0x242424);
		renderer.backgroundSkin = defaultSkin;

		renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_LEFT;
		renderer.contentLabelProperties.textFormat = smallUILightTextFormat;
		renderer.paddingTop = renderer.paddingBottom = 4 * scale;
		renderer.paddingLeft = renderer.paddingRight = 16 * scale;
		renderer.minWidth = renderer.minHeight = 44 * scale;
		renderer.minTouchWidth = renderer.minTouchHeight = 44 * scale;
		
		renderer.contentLoaderFactory = imageLoaderFactory;
	}

	private function footerRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):Void
	{
		var defaultSkin:Quad = new Quad(44 * scale, 44 * scale, 0x242424);
		renderer.backgroundSkin = defaultSkin;

		renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_CENTER;
		renderer.contentLabelProperties.textFormat = smallLightTextFormat;
		renderer.paddingTop = renderer.paddingBottom = 4 * scale;
		renderer.paddingLeft = renderer.paddingRight = 16 * scale;
		renderer.minWidth = renderer.minHeight = 44 * scale;
		renderer.minTouchWidth = renderer.minTouchHeight = 44 * scale;
		
		renderer.contentLoaderFactory = imageLoaderFactory;
	}

	private function insetHeaderRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):Void
	{
		var defaultSkin:Quad = new Quad(66 * scale, 66 * scale, 0xff00ff);
		defaultSkin.alpha = 0;
		renderer.backgroundSkin = defaultSkin;

		renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_LEFT;
		renderer.contentLabelProperties.textFormat = smallUILightTextFormat;
		renderer.paddingTop = renderer.paddingBottom = 4 * scale;
		renderer.paddingLeft = renderer.paddingRight = 32 * scale;
		renderer.minWidth = renderer.minHeight = 66 * scale;
		renderer.minTouchWidth = renderer.minTouchHeight = 44 * scale;
		
		renderer.contentLoaderFactory = imageLoaderFactory;
	}

	private function insetFooterRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):Void
	{
		var defaultSkin:Quad = new Quad(66 * scale, 66 * scale, 0xff00ff);
		defaultSkin.alpha = 0;
		renderer.backgroundSkin = defaultSkin;

		renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_CENTER;
		renderer.contentLabelProperties.textFormat = smallLightTextFormat;
		renderer.paddingTop = renderer.paddingBottom = 4 * scale;
		renderer.paddingLeft = renderer.paddingRight = 32 * scale;
		renderer.minWidth = renderer.minHeight = 66 * scale;
		renderer.minTouchWidth = renderer.minTouchHeight = 44 * scale;
		
		renderer.contentLoaderFactory = imageLoaderFactory;
	}

	private function radioInitializer(radio:Radio):Void
	{
		var iconSelector:ImageStateValueSelector = new ImageStateValueSelector();
		iconSelector.defaultValue = radioUpIconTexture;
		iconSelector.defaultSelectedValue = radioSelectedUpIconTexture;
		iconSelector.setValueForState(radioDownIconTexture, Button.STATE_DOWN, false);
		iconSelector.setValueForState(radioDisabledIconTexture, Button.STATE_DISABLED, false);
		iconSelector.setValueForState(radioSelectedDownIconTexture, Button.STATE_DOWN, true);
		iconSelector.setValueForState(radioSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
		iconSelector.imageProperties =
		{
			scaleX: scale,
			scaleY: scale
		};
		radio.stateToIconFunction = iconSelector.updateValue;

		radio.defaultLabelProperties.textFormat = smallUILightTextFormat;
		radio.disabledLabelProperties.textFormat = smallUIDisabledTextFormat;
		radio.selectedDisabledLabelProperties.textFormat = smallUIDisabledTextFormat;

		radio.gap = 12 * scale;
		radio.minTouchWidth = radio.minTouchHeight = 88 * scale;
	}

	private function checkInitializer(check:Check):Void
	{
		var iconSelector:ImageStateValueSelector = new ImageStateValueSelector();
		iconSelector.defaultValue = checkUpIconTexture;
		iconSelector.defaultSelectedValue = checkSelectedUpIconTexture;
		iconSelector.setValueForState(checkDownIconTexture, Button.STATE_DOWN, false);
		iconSelector.setValueForState(checkDisabledIconTexture, Button.STATE_DISABLED, false);
		iconSelector.setValueForState(checkSelectedDownIconTexture, Button.STATE_DOWN, true);
		iconSelector.setValueForState(checkSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
		iconSelector.imageProperties =
		{
			scaleX: scale,
			scaleY: scale
		};
		check.stateToIconFunction = iconSelector.updateValue;

		check.defaultLabelProperties.textFormat = smallUILightTextFormat;
		check.disabledLabelProperties.textFormat = smallUIDisabledTextFormat;
		check.selectedDisabledLabelProperties.textFormat = smallUIDisabledTextFormat;

		check.gap = 12 * scale;
		check.minTouchWidth = check.minTouchHeight = 88 * scale;
	}

	private function sliderInitializer(slider:Slider):Void {
		slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;
		
		var skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
		skinSelector.defaultValue = backgroundSkinTextures;
		skinSelector.setValueForState(buttonDownSkinTextures, Button.STATE_DOWN, false);
		skinSelector.setValueForState(backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
		skinSelector.imageProperties = { textureScale: scale };
		if(slider.direction == Slider.DIRECTION_VERTICAL) {
			skinSelector.imageProperties.width = 60 * scale;
			skinSelector.imageProperties.height = 210 * scale;
		} else {
			skinSelector.imageProperties.width = 210 * scale;
			skinSelector.imageProperties.height = 60 * scale;
		}
		slider.minimumTrackProperties.stateToSkinFunction = skinSelector.updateValue;
		slider.maximumTrackProperties.stateToSkinFunction = skinSelector.updateValue;
	}

	private function toggleSwitchInitializer(toggle:ToggleSwitch):Void
	{
		toggle.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;

		toggle.defaultLabelProperties.textFormat = smallUILightTextFormat;
		toggle.onLabelProperties.textFormat = smallUISelectedTextFormat;
	}

	private function textInputInitializer(input:TextInput):Void
	{
		var backgroundSkin:Scale9Image = new Scale9Image(backgroundSkinTextures, scale);
		backgroundSkin.width = 264 * scale;
		backgroundSkin.height = 60 * scale;
		input.backgroundSkin = backgroundSkin;

		var backgroundDisabledSkin:Scale9Image = new Scale9Image(backgroundDisabledSkinTextures, scale);
		backgroundDisabledSkin.width = 264 * scale;
		backgroundDisabledSkin.height = 60 * scale;
		input.backgroundDisabledSkin = backgroundDisabledSkin;

		var backgroundFocusedSkin:Scale9Image = new Scale9Image(backgroundFocusedSkinTextures, scale);
		backgroundFocusedSkin.width = 264 * scale;
		backgroundFocusedSkin.height = 60 * scale;
		input.backgroundFocusedSkin = backgroundFocusedSkin;

		input.minWidth = input.minHeight = 60 * scale;
		input.minTouchWidth = input.minTouchHeight = 88 * scale;
		input.paddingTop = input.paddingBottom = 12 * scale;
		input.paddingLeft = input.paddingRight = 16 * scale;
		input.textEditorProperties.fontFamily = "Helvetica";
		input.textEditorProperties.fontSize = 30 * scale;
		input.textEditorProperties.color = LIGHT_TEXT_COLOR;
	}

	private function pageIndicatorInitializer(pageIndicator:PageIndicator):Void
	{
		pageIndicator.normalSymbolFactory = pageIndicatorNormalSymbolFactory;
		pageIndicator.selectedSymbolFactory = pageIndicatorSelectedSymbolFactory;
		pageIndicator.gap = 10 * scale;
		pageIndicator.paddingTop = pageIndicator.paddingRight = pageIndicator.paddingBottom =
			pageIndicator.paddingLeft = 6 * scale;
		pageIndicator.minTouchWidth = pageIndicator.minTouchHeight = 44 * scale;
	}

	private function progressBarInitializer(progress:ProgressBar):Void
	{
		var backgroundSkin:Scale9Image = new Scale9Image(backgroundSkinTextures, scale);
		backgroundSkin.width = 240 * scale;
		backgroundSkin.height = 22 * scale;
		progress.backgroundSkin = backgroundSkin;

		var backgroundDisabledSkin:Scale9Image = new Scale9Image(backgroundDisabledSkinTextures, scale);
		backgroundDisabledSkin.width = 240 * scale;
		backgroundDisabledSkin.height = 22 * scale;
		progress.backgroundDisabledSkin = backgroundDisabledSkin;

		var fillSkin:Scale9Image = new Scale9Image(buttonUpSkinTextures, scale);
		fillSkin.width = 8 * scale;
		fillSkin.height = 22 * scale;
		progress.fillSkin = fillSkin;

		var fillDisabledSkin:Scale9Image = new Scale9Image(buttonDisabledSkinTextures, scale);
		fillDisabledSkin.width = 8 * scale;
		fillDisabledSkin.height = 22 * scale;
		progress.fillDisabledSkin = fillDisabledSkin;
	}

	private function headerInitializer(header:Header):Void
	{
		header.minWidth = 88 * scale;
		header.minHeight = 88 * scale;
		header.paddingTop = header.paddingRight = header.paddingBottom =
			header.paddingLeft = 14 * scale;

		var backgroundSkin:Quad = new Quad(88 * scale, 88 * scale, 0x1a1a1a);
		header.backgroundSkin = backgroundSkin;
		header.titleProperties.textFormat = headerTextFormat;
	}

	private function pickerListInitializer(list:PickerList):Void
	{
		if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			list.popUpContentManager = new CalloutPopUpContentManager();
		}
		else
		{
			var centerStage:VerticalCenteredPopUpContentManager = new VerticalCenteredPopUpContentManager();
			centerStage.marginTop = centerStage.marginRight = centerStage.marginBottom =
				centerStage.marginLeft = 24 * scale;
			list.popUpContentManager = centerStage;
		}

		var layout:VerticalLayout = new VerticalLayout();
		layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_BOTTOM;
		layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
		layout.useVirtualLayout = true;
		layout.gap = 0;
		layout.paddingTop = layout.paddingRight = layout.paddingBottom =
		layout.paddingLeft = 0;
		list.listProperties.layout = layout;
		
		//untyped list.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
		
		if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			list.listProperties.minWidth = 560 * scale;
			list.listProperties.maxHeight = 528 * scale;
		}
		else
		{
			var backgroundSkin:Scale9Image = new Scale9Image(backgroundDisabledSkinTextures, scale);
			backgroundSkin.width = 20 * scale;
			backgroundSkin.height = 20 * scale;
			list.listProperties.backgroundSkin = backgroundSkin;
			list.listProperties.paddingTop = list.listProperties.paddingRight =
				list.listProperties.paddingBottom = list.listProperties.paddingLeft = 8 * scale;
		}

		list.listProperties.itemRendererName = COMPONENT_NAME_PICKER_LIST_ITEM_RENDERER;
	}

	private function calloutInitializer(callout:Callout):Void
	{
		var backgroundSkin:Scale9Image = new Scale9Image(backgroundDisabledSkinTextures, scale);
		callout.backgroundSkin = backgroundSkin;

		var topArrowSkin:Image = new Image(calloutTopArrowSkinTexture);
		topArrowSkin.scaleX = topArrowSkin.scaleY = scale;
		callout.topArrowSkin = topArrowSkin;

		var rightArrowSkin:Image = new Image(calloutRightArrowSkinTexture);
		rightArrowSkin.scaleX = rightArrowSkin.scaleY = scale;
		callout.rightArrowSkin = rightArrowSkin;

		var bottomArrowSkin:Image = new Image(calloutBottomArrowSkinTexture);
		bottomArrowSkin.scaleX = bottomArrowSkin.scaleY = scale;
		callout.bottomArrowSkin = bottomArrowSkin;

		var leftArrowSkin:Image = new Image(calloutLeftArrowSkinTexture);
		leftArrowSkin.scaleX = leftArrowSkin.scaleY = scale;
		callout.leftArrowSkin = leftArrowSkin;

		callout.paddingTop = callout.paddingRight = callout.paddingBottom =
			callout.paddingLeft = 8 * scale;
	}

	private function scrollerInitializer(scroller:Scroller):Void
	{
		scroller.verticalScrollBarFactory = verticalScrollBarFactory;
		scroller.horizontalScrollBarFactory = horizontalScrollBarFactory;
	}

	private function insetGroupedListInitializer(list:GroupedList):Void
	{
		list.itemRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_ITEM_RENDERER;
		list.firstItemRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_FIRST_ITEM_RENDERER;
		list.lastItemRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_LAST_ITEM_RENDERER;
		list.singleItemRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_SINGLE_ITEM_RENDERER;
		list.headerRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER;
		list.footerRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_FOOTER_RENDERER;

		var layout:VerticalLayout = new VerticalLayout();
		layout.useVirtualLayout = true;
		layout.paddingTop = layout.paddingRight = layout.paddingBottom =
			layout.paddingLeft = 18 * scale;
		layout.gap = 0;
		layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
		layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
		list.layout = layout;
	}

	private function stage_resizeHandler(event:ResizeEvent):Void
	{
		primaryBackground.width = event.width;
		primaryBackground.height = event.height;
	}

	private function root_addedToStageHandler(event:Event):Void
	{
		root.removeEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
		initializeRoot();
	}

	private function root_removedFromStageHandler(event:Event):Void
	{
		root.removeEventListener(Event.REMOVED_FROM_STAGE, root_removedFromStageHandler);
		root.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		root.removeChild(primaryBackground, true);
		primaryBackground = null;
	}
}
