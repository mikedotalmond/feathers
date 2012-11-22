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
package feathers.skins;

import feathers.core.IToggle;

import flash.utils.Dictionary;

/**
 * Maps a component's states to values, perhaps for one of the component's
 * properties such as a skin or text format.
 */
extern class StateWithToggleValueSelector
{
	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * If there is no value for the specified state, a default value can
	 * be used as a fallback.
	 */
	public var defaultValue:Dynamic;

	/**
	 * If the target is a selected IToggle instance, and if there is no
	 * value for the specified state, a default value may be used as a
	 * fallback (with a higher priority than the regular default fallback).
	 *
	 * @see feathers.core.IToggle
	 */
	public var defaultSelectedValue:Dynamic;

	/**
	 * Stores a value for a specified state to be returned from
	 * getValueForState().
	 */
	public function setValueForState(value:Dynamic, state:Dynamic, isSelected:Bool = false):Void;

	/**
	 * Clears the value stored for a specific state.
	 */
	public function clearValueForState(state:Dynamic, isSelected:Bool = false):Dynamic;

	/**
	 * Returns the value stored for a specific state.
	 */
	public function getValueForState(state:Dynamic, isSelected:Bool = false):Dynamic;

	/**
	 * Returns the value stored for a specific state. May generate a value,
	 * if none is present.
	 *
	 * @param target		The object receiving the stored value. The manager may query properties on the target to customize the returned value.
	 * @param state			The current state.
	 * @param oldValue		The previous value. May be reused for the new value.
	 */
	public function updateValue(target:Dynamic, state:Dynamic, oldValue:Dynamic = null):Dynamic;
}
