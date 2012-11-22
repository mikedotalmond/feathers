package feathers.utils.display;
/**
 * Calculates a scale value to maintain aspect ratio and fill the required
 * bounds (with the possibility of cutting of the edges a bit).
 */

@:native("feathers.utils.display.calculateScaleRatioToFill")
extern public static function CalculateScaleRatioToFill(originalWidth:Float, originalHeight:Float, targetWidth:Float, targetHeight:Float):Float;