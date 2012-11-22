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
import flash.geom.Point;

/**
 * Handles the editing of text.
 *
 * @see http://wiki.starling-framework.org/feathers/text-editors
 */
extern interface ITextEditor implements IFeathersControl
{
	/**
	 * The text displayed by the editor.
	 */
	var text(default, null):String;
	
	/**
	 * Gives focus to the text editor. Includes an optional position which
	 * may be used by the text editor to determine the cursor position. The
	 * position may be outside of the editors bounds.
	 */
	function setFocus(position:Point = null):Void;

	/**
	 * Sets the range of selected characters. If both values are the same,
	 * the text insertion position is changed and nothing is selected.
	 */
	function selectRange(startIndex:Int, endIndex:Int):Void;
}
