package feathers.examples.componentsExplorer.data;

import feathers.controls.Button;

class ButtonSettings
{
	public function new() {
		horizontalAlign = Button.HORIZONTAL_ALIGN_CENTER;
		verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
		iconPosition = Button.ICON_POSITION_LEFT;
	}

	public var isToggle:Bool = false;
	public var horizontalAlign:String;// = Button.HORIZONTAL_ALIGN_CENTER;
	public var verticalAlign:String;// = Button.VERTICAL_ALIGN_MIDDLE;
	public var hasIcon:Bool = true;
	public var iconPosition:String;// = Button.ICON_POSITION_LEFT;
	public var iconOffsetX:Float = 0;
	public var iconOffsetY:Float = 0;
}
