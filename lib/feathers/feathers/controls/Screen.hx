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
import feathers.events.FeathersEventType;
import feathers.system.DeviceCapabilities;
//import feathers.utils.display.calculateScaleRatioToFit;

import flash.display.DisplayObjectContainer;
import flash.display.LoaderInfo;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import starling.core.Starling;
import starling.events.Event;
import starling.events.ResizeEvent;

/**
 * Provides useful capabilities for a menu screen displayed by
 * <code>ScreenNavigator</code>.
 *
 * @see http://wiki.starling-framework.org/feathers/screen
 * @see ScreenNavigator
 */
extern class Screen extends FeathersControl, implements IScreen
{
	/**
	 * Constructor.
	 */
	public function new():Void;
	
	private var backButtonHandler:Void->Void;
	
	/**
	 * The original intended width of the application. If not set manually,
	 * <code>loaderInfo.width</code> is automatically detected (to get
	 * width value from <code>[SWF]</code> metadata.
	 */
	public var originalWidth(default,default):Float;
	
	
	/**
	 * The original intended height of the application. If not set manually,
	 * <code>loaderInfo.height</code> is automatically detected (to get
	 * height value from <code>[SWF]</code> metadata.
	 */
	public var originalHeight(default,default):Float;
	
	/**
	 * The original intended DPI of the application. This value cannot be
	 * automatically detected and it must be set manually.
	 */
	public var originalDPI(default,default):Int;


	/**
	 * @inheritDoc
	 */
	public var screenID(default,default):String;


	/**
	 * @inheritDoc
	 */
	public var owner(default,default):ScreenNavigator;
}