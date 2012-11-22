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
package feathers.controls.supportClasses;

import feathers.controls.GroupedList;
import feathers.controls.Scroller;
import feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer;
import feathers.controls.renderers.IGroupedListItemRenderer;
import feathers.core.FeathersControl;
import feathers.core.IFeathersControl;
import feathers.core.PropertyProxy;
import feathers.data.HierarchicalCollection;
import feathers.events.CollectionEventType;
import feathers.events.FeathersEventType;
import feathers.layout.ILayout;
import feathers.layout.IVariableVirtualLayout;
import feathers.layout.IVirtualLayout;
import feathers.layout.LayoutBoundsResult;
import feathers.layout.ViewPortBounds;
import flash.Vector;

import flash.geom.Point;
import flash.utils.Dictionary;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * @private
 * Used internally by GroupedList. Not meant to be used on its own.
 */
extern class GroupedListDataViewPort extends FeathersControl, implements IViewPort
{
	private static var INVALIDATION_FLAG_ITEM_RENDERER_FACTORY:String;//"itemRendererFactory";

	private static var HELPER_POINT:Point;//new Point();
	private static var HELPER_BOUNDS:ViewPortBounds;//new ViewPortBounds();
	private static var HELPER_LAYOUT_RESULT:LayoutBoundsResult;//new LayoutBoundsResult();
	private static var HELPER_VECTOR:Vector<Int>;//Int>[];

	public function new():Void;

	private var touchPointID:Int;//-1;

	private var _minVisibleWidth:Float;//0;

	public var minVisibleWidth(default, default):Float;
	

	private var _maxVisibleWidth:Float;// = Float.POSITIVE_INFINITY;

	public var maxVisibleWidth(default, default):Float;
	

	private var actualVisibleWidth:Float;//

	private var explicitVisibleWidth:Float;//

	public var visibleWidth(default, default):Float;
	

	private var _minVisibleHeight:Float;//0;

	public var minVisibleHeight(default, default):Float;

	private var _maxVisibleHeight:Float;// = Float.POSITIVE_INFINITY;

	public var maxVisibleHeight(default, default):Float;

	private var actualVisibleHeight:Float;

	private var explicitVisibleHeight:Float;//

	public var visibleHeight(default, default):Float;
	

	public var horizontalScrollStep(default, null):Float;

	public var verticalScrollStep(default, null):Float;

	private var _typicalItemWidth:Float;//

	public var typicalItemWidth(default, null):Float;

	private var _typicalItemHeight:Float;//

	public var typicalItemHeight(default, null):Float;

	private var _typicalHeaderWidth:Float;//

	public var typicalHeaderWidth(default, null):Float;

	private var _typicalHeaderHeight:Float;//

	public var typicalHeaderHeight(default, null):Float;

	private var _typicalFooterWidth:Float;//

	public var typicalFooterWidth(default, null):Float;

	private var _typicalFooterHeight:Float;//

	public var typicalFooterHeight(default, null):Float;

	private var _layoutItems:Vector<DisplayObject>;//DisplayObject>[];

	private var _unrenderedItems:Vector<Int>;//Int>[];
	private var _inactiveItemRenderers:Vector<IGroupedListItemRenderer>;//IGroupedListItemRenderer>[];
	private var _activeItemRenderers:Vector<IGroupedListItemRenderer>;//IGroupedListItemRenderer>[];
	private var _itemRendererMap:Dictionary;// = new Dictionary(true);

	private var _unrenderedFirstItems:Vector<Int>;
	private var _inactiveFirstItemRenderers:Vector<IGroupedListItemRenderer>;
	private var _activeFirstItemRenderers:Vector<IGroupedListItemRenderer>;
	private var _firstItemRendererMap:Dictionary;// = new Dictionary(true);

	private var _unrenderedLastItems:Vector<Int>;
	private var _inactiveLastItemRenderers:Vector<IGroupedListItemRenderer>;
	private var _activeLastItemRenderers:Vector<IGroupedListItemRenderer>;
	private var _lastItemRendererMap:Dictionary;

	private var _unrenderedSingleItems:Vector<Int>;
	private var _inactiveSingleItemRenderers:Vector<IGroupedListItemRenderer>;
	private var _activeSingleItemRenderers:Vector<IGroupedListItemRenderer>;
	private var _singleItemRendererMap:Dictionary;

	private var _unrenderedHeaders:Vector<Int>;//Int>[];
	private var _inactiveHeaderRenderers:Vector<IGroupedListHeaderOrFooterRenderer>;//IGroupedListHeaderOrFooterRenderer>[];
	private var _activeHeaderRenderers:Vector<IGroupedListHeaderOrFooterRenderer>;//IGroupedListHeaderOrFooterRenderer>[];
	private var _headerRendererMap:Dictionary;// = new Dictionary(true);

	private var _unrenderedFooters:Vector<Int>;// = new <Int>[];
	private var _inactiveFooterRenderers:Vector<IGroupedListHeaderOrFooterRenderer>;//IGroupedListHeaderOrFooterRenderer>[];
	private var _activeFooterRenderers:Vector<IGroupedListHeaderOrFooterRenderer>;//IGroupedListHeaderOrFooterRenderer>[];
	private var _footerRendererMap:Dictionary;// = new Dictionary(true);

	private var _headerIndices:Vector<Int>;// = new <Int>[];
	private var _footerIndices:Vector<Int>;//;//new <Int>[];

	private var _isScrolling:Bool;//false;

	private var _owner:GroupedList;

	public var owner(default, default):GroupedList;

	private var _dataProvider:HierarchicalCollection;

	public var dataProvider(default, default):HierarchicalCollection;
	
	private var _isSelectable:Bool;//true;

	public var isSelectable(default, default):Bool;
	

	private var _selectedGroupIndex:Int;//-1;

	public var selectedGroupIndex(default, null):Int;

	private var _selectedItemIndex:Int;//-1;

	public var selectedItemIndex(default, null):Int;

	private var _itemRendererType:Dynamic;

	public var itemRendererType(default, default):Dynamic;
	

	private var _itemRendererFactory:Dynamic;

	public var itemRendererFactory(default, default):Dynamic;

	private var _itemRendererName:String;

	public var itemRendererName(default, default):String;
	

	private var _typicalItem:Dynamic;//null;

	public var typicalItem(default, default):Dynamic;

	private var _itemRendererProperties:PropertyProxy;

	public var itemRendererProperties(default, default):PropertyProxy;

	private var _firstItemRendererType:Dynamic;

	public var firstItemRendererType(default, default):Dynamic;

	private var _firstItemRendererFactory:Dynamic;

	public var firstItemRendererFactory(default, default):Dynamic;

	private var _firstItemRendererName:String;

	public var firstItemRendererName(default, default):String;
	

	private var _lastItemRendererType:Dynamic;

	public var lastItemRendererType(default, default):Dynamic;
	

	private var _lastItemRendererFactory:Dynamic;

	public var lastItemRendererFactory(default, default):Dynamic;
	
	
	private var _lastItemRendererName:String;

	public var lastItemRendererName(default, default):String;
	
	
	private var _singleItemRendererType:Dynamic;

	public var singleItemRendererType(default, default):Dynamic;
	

	private var _singleItemRendererFactory:Dynamic;

	public var singleItemRendererFactory(default, default):Dynamic;
	

	private var _singleItemRendererName:String;

	public var singleItemRendererName(default, default):String;
	

	private var _headerRendererType:Dynamic;

	public var headerRendererType(default, default):Dynamic;

	
	private var _headerRendererFactory:Dynamic;

	public var headerRendererFactory(default, default):Dynamic;
	

	private var _headerRendererName:String;

	public var headerRendererName(default, default):String;

	private var _typicalHeader:Dynamic;//null;

	public var typicalHeader(default, default):Dynamic;

	private var _headerRendererProperties:PropertyProxy;

	public var headerRendererProperties(default, default):PropertyProxy;

	private var _footerRendererType:Dynamic;

	public var footerRendererType(default, default):Dynamic;
	
	private var _footerRendererFactory:Dynamic;

	public var footerRendererFactory(default, default):Dynamic;
	
	private var _footerRendererName:String;

	public var footerRendererName(default, default):String;
	
	private var _typicalFooter:Dynamic;//null;

	public var typicalFooter(default, default):Dynamic;
	

	private var _footerRendererProperties:PropertyProxy;

	public var footerRendererProperties(default, default):PropertyProxy;
	
	private var _ignoreLayoutChanges:Bool;//false;
	private var _ignoreRendererResizing:Bool;//false;

	private var _layout:ILayout;

	public var layout(default, default):ILayout;

	private var _horizontalScrollPosition:Float;//0;

	public var horizontalScrollPosition(default, default):Float;

	private var _verticalScrollPosition:Float;//0;

	public var verticalScrollPosition(default, default):Float;

	private var _minimumItemCount:Int;
	private var _minimumHeaderCount:Int;
	private var _minimumFooterCount:Int;
	private var _minimumFirstAndLastItemCount:Int;
	private var _minimumSingleItemCount:Int;

	private var _ignoreSelectionChanges:Bool;//false;

	public function setSelectedLocation(groupIndex:Int, itemIndex:Int):Void;

	public function getScrollPositionForIndex(groupIndex:Int, itemIndex:Int, result:Point = null):Point;

	private function refreshEnabled():Void;
	
	private function validateRenderers():Void;
	
	private function invalidateParent():Void;
	
	private function calculateTypicalValues():Void;
	
	private function refreshItemRendererStyles():Void;
	
	private function refreshHeaderRendererStyles():Void;
	
	private function refreshFooterRendererStyles():Void;
	
	private function refreshOneItemRendererStyles(renderer:IGroupedListItemRenderer):Void;
	
	private function refreshOneHeaderRendererStyles(renderer:IGroupedListHeaderOrFooterRenderer):Void;
	
	private function refreshOneFooterRendererStyles(renderer:IGroupedListHeaderOrFooterRenderer):Void;
	
	private function refreshSelection():Void;
	
	private function refreshRenderers(itemRendererTypeIsInvalid:Bool):Void;
	
	private function findUnrenderedData():Void;
	
	private function findRendererForItem(item:Dynamic, groupIndex:Int, itemIndex:Int, layoutIndex:Int,
		rendererMap:Dictionary, inactiveRenderers:Vector<IGroupedListItemRenderer>,
		activeRenderers:Vector<IGroupedListItemRenderer>, unrenderedItems:Vector<Int>):Void;
		
	private function renderUnrenderedData():Void;
	
	private function recoverInactiveRenderers():Void;
	
	private function freeInactiveRenderers():Void;
	
	private function createItemRenderer(inactiveRenderers:Vector<IGroupedListItemRenderer>,
		activeRenderers:Vector<IGroupedListItemRenderer>, rendererMap:Dictionary,
		type:Dynamic, factory:Dynamic, name:String, item:Dynamic, groupIndex:Int, itemIndex:Int,
		layoutIndex:Int, isTemporary:Bool = false):IGroupedListItemRenderer;
		
	private function createHeaderRenderer(header:Dynamic, groupIndex:Int, layoutIndex:Int, isTemporary:Bool = false):IGroupedListHeaderOrFooterRenderer;
	
	private function createFooterRenderer(footer:Dynamic, groupIndex:Int, layoutIndex:Int, isTemporary:Bool = false):IGroupedListHeaderOrFooterRenderer;
	
	private function destroyItemRenderer(renderer:IGroupedListItemRenderer):Void;
	
	private function destroyHeaderRenderer(renderer:IGroupedListHeaderOrFooterRenderer):Void;
	
	private function destroyFooterRenderer(renderer:IGroupedListHeaderOrFooterRenderer):Void;
	
	private function locationToDisplayIndex(groupIndex:Int, itemIndex:Int):Int;
	
	private function childProperties_onChange(proxy:PropertyProxy, name:String):Void;
	
	private function owner_scrollHandler(event:Event):Void;
	
	private function dataProvider_changeHandler(event:Event):Void;
	
	private function dataProvider_updateItemHandler(event:Event, indices:Array<Int>):Void;
	
	private function layout_changeHandler(event:Event):Void;
	
	private function itemRenderer_resizeHandler(event:Event):Void;
	
	private function headerOrFooterRenderer_resizeHandler(event:Event):Void;
	
	private function renderer_changeHandler(event:Event):Void;

	private function removedFromStageHandler(event:Event):Void;
	
	private function touchHandler(event:TouchEvent):Void;	
}
