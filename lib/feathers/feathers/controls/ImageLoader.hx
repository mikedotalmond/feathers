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
package feathers.controls;

import feathers.core.FeathersControl;
import flash.display.Loader;
import flash.events.ErrorEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.textures.Texture;
import starling.utils.MatrixUtil;

/**
* Displays an image, either from a <code>Texture</code> or loaded from a
* URL.
*/
extern class ImageLoader extends FeathersControl {

/**
 * Constructor.
 */
public function new():Void;


	/**
	 * The internal <code>starling.display.Image</code> child.
	 */
	@:protected private var image:Image;

	
	/**
	 * The internal <code>flash.display.Loader</code> used to load textures
	 * from URLs.
	 */
	@:protected private var loader:Loader;
	
	
	/**
	 * @private
	 */
	@:protected private var _texture:Texture;
	
	
	/**
	 * @private
	 */
	@:protected private var _source:Dynamic;
	public var source(default, default):Bool;// = false;
	
	
	/**
	 * @private
	 */
	@:protected private var _isLoaded:Bool;// = false;
	public var isLoaded(default, null):Bool;

	
	/**
	 * Determines if the image should be snapped to the nearest global whole
	 * pixel when rendered. Turning this on helps to avoid blurring.
	 */
	public var snapToPixels(default, default):Bool;
	private var _snapToPixels:Bool;// = false;
	
	
	/**
	 * @private
	 */
	/**
	 * Determines if the aspect ratio of the texture is maintained when the
	 * aspect ratio of the component is different.
	 */
	//private var _maintainAspectRatio:Bool;// = true;
	public var maintainAspectRatio(default, default):Bool;
	


	/**
	 * @private
	 */
	@:protected private function autoSizeIfNeeded():Bool;
	
	/**
	 * @private
	 */
	@:protected private function commitData():Void;

	/**
	 * @private
	 */
	@:protected private function layout():Void;
	
	/**
	 * @private
	 */
	@:protected private function commitTexture():Void;
	
	/**
	 * @private
	 */
	@:protected private function loader_completeHandler(event:flash.events.Event):Void;

	/**
	 * @private
	 */
	@:protected private function loader_errorHandler(event:ErrorEvent):Void;
}