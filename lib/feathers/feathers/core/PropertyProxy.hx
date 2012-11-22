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
import flash.utils.Proxy;
//import flash.utils.flash_proxy;

/**
 * Detects when its own properties have changed and dispatches a signal
 * to notify listeners.
 *
 * <p>Supports nested <code>PropertyProxy</code> instances using attribute
 * <code>&#64;</code> notation. Placing an <code>&#64;</code> before a property name
 * is like saying, "If this nested <code>PropertyProxy</code> doesn't exist
 * yet, create one. If it does, use the existing one."</p>
 */
extern class PropertyProxy extends Proxy
{
	/**
	 * Creates a <code>PropertyProxy</code> from a regular old <code>Object</code>.
	 */
	public static function fromObject(source:Dynamic, onChangeCallback:Dynamic = null):PropertyProxy;

	/**
	 * Constructor.
	 */
	public function new(onChangeCallback:Dynamic = null):Void;

	/**
	 * Adds a callback to react to property changes.
	 */
	public function addOnChangeCallback(cb:Dynamic):Void;

	/**
	 * Removes a callback.
	 */
	public function removeOnChangeCallback(cb:Dynamic):Void;

}
