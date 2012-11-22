package feathers.utils.display;
/**
 * Calculates a scale value to maintain aspect ratio and fit inside the
 * required bounds (with the possibility of a bit of empty space on the
 * edges).
 */

@:native("feathers.utils.display.calculateScaleRatioToFit")
extern public static function CalculateScaleRatioToFit(originalWidth:Float, originalHeight:Float, targetWidth:Float, targetHeight:Float):Float;