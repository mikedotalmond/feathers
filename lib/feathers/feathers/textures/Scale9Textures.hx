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
package feathers.textures;
import flash.geom.Rectangle;

import starling.textures.Texture;

/**
 * A set of nine textures used by <code>Scale9Image</code>.
 *
 * @see org.josht.starling.display.Scale9Image
 */
extern class Scale9Textures
{
	/**
	 * Constructor.
	 */
	public function new(texture:Texture, scale9Grid:Rectangle):Void;

	/**
	 * The original texture.
	 */
	public var texture(default, null):Texture;

	/**
	 * The grid representing the nine sub-regions of the texture.
	 */
	public var scale9Grid(default, null):Rectangle;
	
	/**
	 * The texture for the region in the top Left.
	 */
	public var topLeft(default, null):Texture;

	/**
	 * The texture for the region in the top center.
	 */
	public var topCenter(default, null):Texture;

	/**
	 * The texture for the region in the top right.
	 */
	public var topRight(default, null):Texture;

	/**
	 * The texture for the region in the middle left.
	 */
	public var middleLeft(default, null):Texture;

	/**
	 * The texture for the region in the middle center.
	 */
	public var middleCenter(default, null):Texture;

	/**
	 * The texture for the region in the middle right.
	 */
	public var middleRight(default, null):Texture;
	
	/**
	 * The texture for the region in the bottom left.
	 */
	public var bottomLeft(default, null):Texture;
	
	/**
	 * The texture for the region in the bottom center.
	 */
	public var bottomCenter(default, null):Texture;
	
	/**
	 * The texture for the region in the bottom right.
	 */
	public var bottomRight(default, null):Texture;
}
