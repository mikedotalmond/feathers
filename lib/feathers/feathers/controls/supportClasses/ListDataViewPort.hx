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
import feathers.controls.List;
import feathers.controls.Scroller;
import feathers.controls.renderers.IListItemRenderer;
import feathers.core.FeathersControl;
import feathers.core.IFeathersControl;
import feathers.core.PropertyProxy;
import feathers.data.ListCollection;
import feathers.events.CollectionEventType;
import feathers.events.FeathersEventType;
import feathers.layout.ILayout;
import feathers.layout.IVariableVirtualLayout;
import feathers.layout.IVirtualLayout;
import feathers.layout.LayoutBoundsResult;
import feathers.layout.ViewPortBounds;
import flash.errors.ArgumentError;
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
 * Used internally by List. Not meant to be used on its own.
 */
extern class ListDataViewPort extends FeathersControl, implements IViewPort {
	
	private static var INVALIDATION_FLAG_ITEM_RENDERER_FACTORY:String;//"itemRendererFactory";

	private static var HELPER_POINT:Point;//new Point();
	private static var HELPER_BOUNDS:ViewPortBounds;//new ViewPortBounds();
	private static var HELPER_LAYOUT_RESULT:LayoutBoundsResult;//new LayoutBoundsResult();
	private static var HELPER_VECTOR:Vector<Int>;//Vector.ofArray([]);

	public function new():Void;

	private var touchPointID:Int;//-1;

	public var minVisibleWidth(default, default):Float;
	public var maxVisibleWidth(default,default):Float;
	private var _minVisibleWidth:Float;//0;
	private var actualVisibleWidth:Float;//0;
	private var explicitVisibleWidth:Float;// = Math.NaN;

	public var visibleWidth(default, default):Float;

	private var _minVisibleHeight:Float;//0;

	public var minVisibleHeight(default, default):Float;

	public var maxVisibleHeight(default, default):Float;

	private var actualVisibleHeight:Float;//0;

	private var explicitVisibleHeight:Float;//;//

	public var visibleHeight(default, default):Float;
	
	private var _unrenderedData:Array<Dynamic>;// = [];
	private var _layoutItems:Vector<DisplayObject>;// = new Vector<DisplayObject>();
	private var _inactiveRenderers:Vector<IListItemRenderer>;// = new Vector<IListItemRenderer>();
	private var _activeRenderers:Vector<IListItemRenderer>;// = new Vector<IListItemRenderer>();
	private var _rendererMap:Dictionary;// = new Dictionary(true);

	private var _isScrolling:Bool;//false;

	private var _owner:List;
	public var owner(default, default):Float;
	

	private var _dataProvider:ListCollection;
	public var dataProvider(default, default):Float;
	
	public var itemRendererType(default, default):Dynamic;
	private var _itemRendererType:Dynamic;

	private var _itemRendererFactory:Dynamic;
	public var itemRendererFactory(default, default):Dynamic;
	
	public var itemRendererName(default, default):Dynamic;
	private var _itemRendererName:String;
	
	public var typicalItemWidth(default, null):Dynamic;
	private var _typicalItemWidth:Float;// = Math.NaN;
	public var typicalItemHeight(default, null):Dynamic;
	private var _typicalItemHeight:Float;// = Math.NaN;

	private var _typicalItem:Dynamic;//null;
	public var typicalItem(default, default):Dynamic;
	
	private var _itemRendererProperties:PropertyProxy;
	public var itemRendererProperties(default, default):PropertyProxy;
	
	private var _ignoreLayoutChanges:Bool;//false;
	private var _ignoreRendererResizing:Bool;//false;

	private var _layout:ILayout;
	public var layout(default, default):ILayout;

	public var horizontalScrollStep(default, null):Float;
	public var verticalScrollStep(default, null):Float;
	
	private var _horizontalScrollPosition:Float;//0;
	private var _verticalScrollPosition:Float;//0;
	public var horizontalScrollPosition(default, default):Float;
	public var verticalScrollPosition(default, default):Float;//0;


	private var _ignoreSelectionChanges:Bool;//false;

	private var isSelectable(default, default):Bool;//true;

	public var selectedIndex(default, default):Int;


	public function getScrollPositionForIndex(index:Int, result:Point = null):Point;
	
	private function invalidateParent():Void;

	private function calculateTypicalValues():Void;
	
	private function refreshItemRendererStyles():Void;
	
	private function refreshOneItemRendererStyles(renderer:IListItemRenderer):Void;
	
	private function refreshSelection():Void;
	
	private function refreshRenderers(itemRendererTypeIsInvalid:Bool):Void;

	private function findUnrenderedData():Void;

	private function renderUnrenderedData():Void;

	private function recoverInactiveRenderers():Void;

	private function freeInactiveRenderers():Void;
	
	private function createRenderer(item:Dynamic, index:Int, isTemporary:Bool = false):IListItemRenderer;

	private function destroyRenderer(renderer:IListItemRenderer):Void;
	
	private function childProperties_onChange(proxy:PropertyProxy, name:String):Void;
	
	private function owner_scrollHandler(event:Event):Void;

	private function dataProvider_changeHandler(event:Event):Void;
	
	private function dataProvider_updateItemHandler(event:Event, index:Int):Void;
	
	private function layout_changeHandler(event:Event):Void;
	
	private function renderer_resizeHandler(event:Event):Void;

	private function renderer_changeHandler(event:Event):Void;

	private function removedFromStageHandler(event:Event):Void;

	private function touchHandler(event:TouchEvent):Void;
}