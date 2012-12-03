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
package feathers.display;
import feathers.textures.Scale3Textures;
import starling.display.Sprite;

import flash.errors.IllegalOperationError;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import starling.core.RenderSupport;
import starling.display.DisplayObject;
import starling.display.QuadBatch;
import starling.events.Event;
import starling.textures.TextureSmoothing;
import starling.utils.MatrixUtil;

/**
 * Scales an image like a "pill" shape with three regions, either
 * horizontally or vertically. The edge regions scale while maintaining
 * aspect ratio, and the middle region stretches to fill the remaining
 * space.
 */
extern class Scale3Image extends Sprite
{
	/**
	 * Constructor.
	 */
	public function new(textures:Scale3Textures, textureScale:Float = 1):Void;
	
	/**
	 * The textures displayed by this image.
	 */
	public var textures(default, default):Scale3Textures;


	/**
	 * The amount to scale the texture. Useful for DPI changes.
	 */
	public var textureScale(default, default):Float;

	/**
	 * The smoothing value to pass to the images.
	 *
	 * @see starling.textures.TextureSmoothing
	 */
	public var smoothing(default, default):String;
	
	/**
	 * The color value to pass to the images.
	 */
	public var color(default, default):UInt;
	
	/**
	 * Readjusts the dimensions of the image according to its current
	 * textures. Call this method to synchronize image and texture size
	 * after assigning textures with a different size.
	 */
	public function readjustSize():Void;
}
