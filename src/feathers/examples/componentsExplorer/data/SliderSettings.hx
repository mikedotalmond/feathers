package feathers.examples.componentsExplorer.data;

import feathers.controls.Slider;

class SliderSettings
{
	public function new() {
		direction = Slider.DIRECTION_HORIZONTAL;
	}

	public var direction:String;// = Slider.DIRECTION_HORIZONTAL;
	public var step:Float = 1;
	public var page:Float = 10;
	public var liveDragging:Bool = true;
}
