package feathers.text;
import flash.display.BitmapData;
import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.engine.FontPosture;
import flash.text.engine.FontWeight;

/**
 * A StageText replacement for Flash Player with matching properties, since
 * StageText is only available in AIR.
 */
extern class StageTextField extends EventDispatcher
{
	/**
	 * Constructor.
	 */
	public function StageTextField(initOptions:Dynamic = null):Void;

	public var autoCapitalize(default, default):String;
	public var autoCorrect(default, default):Bool;
	public var color(default, default):UInt;
	
	public var displayAsPassword(default, default):Bool;
	public var editable(default, default):Bool;
	public var fontFamily(default, default):String;
	public var fontPosture(default, default):String;
	public var fontSize(default, default):Int;
	public var fontWeight(default, default):Int;
	public var locale(default, default):Int;
	public var maxChars(default, default):Int;
	public var multiline(default, default):Bool;
	public var restrict(default, default):String;
	public var returnKeyLabel(default, default):String;
	public var selectionActiveIndex(default, default):String;
	public var softKeyboardType(default, default):String;
	public var stage(default, default):Stage;
	public var text(default, default):String;
	public var textAlign(default, default):String;
	public var viewPort(default, default):Rectangle;
	public var visible(default, default):Bool;


	public function assignFocus():Void;

	public function dispose():Void;

	public function drawViewPortToBitmapData(bitmap:BitmapData):Void;

	public function selectRange(anchorIndex:Int, activeIndex:Int):Void;
	
}
