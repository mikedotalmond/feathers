package feathers.system;
import flash.display.Stage;
import flash.system.Capabilities;

/**
 * Using values from the Stage and Capabilities classes, makes educated
 * guesses about the physical size of the device this code is running on.
 */
extern class DeviceCapabilities
{
	/**
	 * The minimum physical size, in inches, of the device's larger side to
	 * be considered a tablet.
	 */
	public static var tabletScreenMinimumInches:Float;// = 5;

	/**
	 * A custom width, in pixels, to use for calculations of the device's
	 * physical screen size. Set to NaN to use the actual width.
	 */
	public static var screenPixelWidth:Float;//;//

	/**
	 * A custom height, in pixels, to use for calculations of the device's
	 * physical screen size. Set to NaN to use the actual height.
	 */
	public static var screenPixelHeight:Float;//;//
	
	/**
	 * The DPI to be used by Feathers. Defaults to the value of
	 * <code>Capabilities.screenDPI</code>, but may be overridden. For
	 * example, if one wishes to demo a mobile app in the desktop browser,
	 * a custom DPI will override the real DPI of the desktop screen. 
	 */
	public static var dpi:Int;// = Capabilities.screenDPI;

	/**
	 * Determines if this device is probably a tablet, based on the physical
	 * width and height, in inches, calculated using the full-screen
	 * dimensions and the screen DPI.
	 */
	public static function isTablet(stage:Stage):Bool;

	/**
	 * Determines if this device is probably a phone, based on the physical
	 * width and height, in inches, calculated using the full-screen
	 * dimensions and the screen DPI.
	 */
	public static function isPhone(stage:Stage):Bool;

	/**
	 * The physical width of the device, in inches. Calculated using the
	 * full-screen width and the screen DPI.
	 */
	public static function screenInchesX(stage:Stage):Float;

	/**
	 * The physical height of the device, in inches. Calculated using the
	 * full-screen height and the screen DPI.
	 */
	public static function screenInchesY(stage:Stage):Float;
}
