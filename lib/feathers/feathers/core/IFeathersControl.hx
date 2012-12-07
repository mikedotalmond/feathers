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
package feathers.core;
import starling.display.DisplayObjectContainer;
import starling.events.Event;

/**
 * Basic interface for Feathers UI controls.
 */
extern interface IFeathersControl
{
	var x(default, default):Float;
	var y(default, default):Float;
	var width(default, default):Float;
	var height(default, default):Float;
	var minWidth(default, default):Float;
	var minHeight(default, default):Float;
	var maxWidth(default, default):Float;
	var maxHeight(default, default):Float;
	
	var isEnabled(default, default):Bool;
	
	var isInitialized(default, null):Bool;
	
	var name(default, default):String;
	var nameList(default, null):TokenList;
	
	var touchable(default, default):Bool;
	var visible(default, default):Bool;
	var alpha(default, default):Float;
	var rotation(default, default):Float;
	var parent(default, null):DisplayObjectContainer;
	
	function addEventListener(type:String, listener:Event->Void):Void;
	function removeEventListener(type:String, listener:Event->Void):Void;
	function removeEventListeners(type:String = null):Void;
	function dispatchEvent(event:Event):Void;
	function dispatchEventWith(type:String, bubbles:Bool = false, data:Dynamic = null):Void;
	function hasEventListener(type:String):Bool;
	function setSize(width:Float, height:Float):Void;
	function validate():Void;
	function dispose():Void;
}