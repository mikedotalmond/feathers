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

import flash.utils.Dictionary;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.events.Event;

/**
* Watches a container on the display list. As new display objects are
* added, if they match a specific type, they will be passed to initializer
* functions to set properties, call methods, or otherwise modify them.
* Useful for initializing skins and styles on UI controls.
* 
* <p>If a display object matches multiple types that have initializers, and
* <code>exactTypeMatching</code> is disabled, the initializers will be
* executed in order following the inheritance chain.</p>
*/
extern class DisplayListWatcher {

	/**
	 * Constructor.
	 *
	 * @param root		The root display object to watch (not necessarily Starling's root object)
	 */
	public function new(root:DisplayObjectContainer):Void;

	/**
	 * The minimum base class required before the AddedWatcher will check
	 * to see if a particular display object has any initializers.
	 */
	public var requiredBaseClass:Class<Dynamic>;

	/**
	 * Determines if only the object added should be processed or if its
	 * children should be processed recursively.
	 */
	public var processRecursively:Bool;

	/**
	 * @private
	 * Tracks the objects that have been initialized. Uses weak keys so that
	 * the tracked objects can be garbage collected.
	 */
	private var initializedObjects:Dictionary;

	/**
	 * Determines if objects added to the display list are initialized only
	 * once or every time that they are re-added.
	 */
	public var initializeOnce(default,default):Bool;

	/**
	 * The root of the display list that is watched for added children.
	 */
	private var root:DisplayObjectContainer;

	/**
	 * Stops listening to the root and cleans up anything else that needs to
	 * be disposed. If a <code>DisplayListWatcher</code> is extended for a
	 * theme, it should also dispose textures and other assets.
	 */
	public function dispose():Void;

	/**
	 * Sets the initializer for a specific class.
	 */
	public function setInitializerForClass(type:Class<Dynamic>, initializer:Dynamic, withName:String = null):Void;

	/**
	 * Sets an initializer for a specific class and any subclasses. This
	 * option can potentially hurt performance, so use sparingly.
	 */
	public function setInitializerForClassAndSubclasses(type:Class<Dynamic>, initializer:Dynamic):Void;

	/**
	 * If an initializer exists for a specific class, it will be returned.
	 */
	public function getInitializerForClass(type:Class<Dynamic>, withName:String = null):Dynamic;

	/**
	 * If an initializer exists for a specific class and its subclasses, the initializer will be returned.
	 */
	public function getInitializerForClassAndSubclasses(type:Class<Dynamic>):Dynamic;

	/**
	 * If an initializer exists for a specific class, it will be removed
	 * completely.
	 */
	public function clearInitializerForClass(type:Class<Dynamic>, withName:String = null):Void;

	/**
	 * If an initializer exists for a specific class and its subclasses, the
	 * initializer will be removed completely.
	 */
	public function clearInitializerForClassAndSubclasses(type:Class<Dynamic>):Void;

	/**
	 * @private
	 */
	private function processAllInitializers(target:DisplayObject):Void;

	/**
	 * @private
	 */
	private function applyAllStylesForTypeFromMaps(target:DisplayObject, type:Class<Dynamic>, map:Dictionary, nameMap:Dictionary = null):Void;

	/**
	 * @private
	 */
	private function addObject(target:DisplayObject):Void;

	/**
	 * @private
	 */
	private function addedHandler(event:Event):Void;
}