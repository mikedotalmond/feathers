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
import feathers.core.FeathersControl;
import feathers.core.IFeathersControl;
import feathers.events.FeathersEventType;
import feathers.layout.ILayout;
import feathers.layout.IVirtualLayout;
import feathers.layout.LayoutBoundsResult;
import feathers.layout.ViewPortBounds;
import flash.Vector;

import flash.geom.Point;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.EventDispatcher;

/**
 * @private
 * Used internally by ScrollContainer. Not meant to be used on its own.
 */
extern class LayoutViewPort extends FeathersControl implements IViewPort
{
	private static var HELPER_POINT:Point;//new Point();
	private static var HELPER_BOUNDS:ViewPortBounds;//new ViewPortBounds();
	private static var HELPER_LAYOUT_RESULT:LayoutBoundsResult;//new LayoutBoundsResult();

	public function new():Void;

	private var _minVisibleWidth:Float;//0;

	public var minVisibleWidth(default, default):Float;

	private var _maxVisibleWidth:Float;//Float.POSITIVE_INFINITY;

	public var maxVisibleWidth(default, default):Float;

	private var _visibleWidth:Float;//

	public var visibleWidth(default, default):Float;

	private var _minVisibleHeight:Float;//0;

	public var minVisibleHeight(default, default):Float;

	private var _maxVisibleHeight:Float;//Float.POSITIVE_INFINITY;

	public var maxVisibleHeight(default, default):Float;

	private var _visibleHeight:Float;//

	public var visibleHeight(default, default):Float;

	public var horizontalScrollStep(default, null):Float;

	public var verticalScrollStep(default, null):Float;

	private var _horizontalScrollPosition:Float;//0;

	public var horizontalScrollPosition(default, default):Float;

	private var _verticalScrollPosition:Float;//0;

	public var verticalScrollPosition(default, default):Float;

	private var _ignoreChildResizing:Bool;//false;

	private var items:Vector<DisplayObject>;//new <DisplayObject>[];

	private var _layout:ILayout;

	public var layout(default, default):ILayout;

	private function layout_changeHandler(event:Event):Void;

	private function child_resizeHandler(event:Event):Void;

	private function addedHandler(event:Event):Void;

	private function removedHandler(event:Event):Void;
}
