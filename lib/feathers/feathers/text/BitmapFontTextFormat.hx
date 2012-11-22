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
package feathers.text;
import flash.text.TextFormatAlign;

import starling.text.BitmapFont;
import starling.text.TextField;

/**
 * Customizes a bitmap font for use by a <code>BitmapFontTextRenderer</code>.
 * 
 * @see feathers.controls.text.BitmapFontTextRenderer
 */
extern class BitmapFontTextFormat
{
	/**
	 * Constructor.
	 */
	public function new(font:Dynamic, size:Float = Math.NaN, color:UInt = 0xffffff, align:String = TextFormatAlign.LEFT):Void;

	public var fontName(default, null):String;
	
	/**
	 * The BitmapFont instance to use.
	 */
	public var font:BitmapFont;
	
	/**
	 * The multiply color.
	 */
	public var color:UInt;
	
	/**
	 * The size at which to display the bitmap font. Set to <code>NaN</code>
	 * to use the default size in the BitmapFont instance.
	 */
	public var size:Float;
	
	/**
	 * The number of extra pixels between characters. May be positive or
	 * negative.
	 */
	public var letterSpacing:Float;

	/**
	 * Determines the alignment of the text, either left, center, or right.
	 */
	public var align:String;
	
	/**
	 * Determines if the kerning values defined in the BitmapFont instance
	 * will be used for layout.
	 */
	public var isKerningEnabled:Bool;
}