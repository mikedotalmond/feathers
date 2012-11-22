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
import flash.Vector;
/**
 * A list of space-delimited tokens.
 */
extern class TokenList
{
	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * @private
	 * Storage for the tokens.
	 */
	private var names:Vector<String>;// = new <String>[];

	/**
	 * The tokens formated with space delimiters.
	 */
	public var value(default, default):String;
	public var length(default, never):Int;
	
	/**
	 * Returns the token at the specified index, or null, if there is no
	 * token at that index.
	 */
	public function item(index:Int):String;
	
	/**
	 * Adds a token to the list. If the token already appears in the list,
	 * it will not be added again.
	 */
	public function add(name:String):Void;
	
	/**
	 * Removes a token from the list, if the token is in the list. If the
	 * token doesn't appear in the list, this call does nothing.
	 */
	public function remove(name:String):Void;
	
	/**
	 * The token is added to the list if it doesn't appear in the list, or
	 * it is removed from the list if it is already in the list.
	 */
	public function toggle(name:String):Void;

	/**
	 * Determines if the specified token is in the list.
	 */
	public function contains(name:String):Bool;

}
