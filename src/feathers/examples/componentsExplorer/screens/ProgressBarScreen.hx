package feathers.examples.componentsExplorer.screens;

import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.ProgressBar;
import feathers.controls.Screen;
import flash.Vector;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;

@:meta(Event(name="complete",type="starling.events.Event"))

class ProgressBarScreen extends Screen {
	
	public function new() {
		super();
	}

	private var _header:Header;
	private var _backButton:Button;
	private var _progress:ProgressBar;

	private var _progressTween:Tween;

	@:protected override function initialize():Void {
		
		_progress = new ProgressBar();
		_progress.minimum = 0;
		_progress.maximum = 1;
		_progress.value = 0;
		addChild(_progress);

		_backButton = new Button();
		_backButton.label = "Back";
		_backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

		_header = new Header();
		_header.title = "Progress Bar";
		addChild(_header);
		_header.leftItems = Vector.ofArray(
		[
			cast _backButton
		]);

		// handles the back hardware key on android
		backButtonHandler = onBackButton;

		_progressTween = new Tween(_progress, 5);
		_progressTween.animate("value", 1);
		_progressTween.repeatCount = 0x7fffffff;
		Starling.juggler.add(_progressTween);
	}

	@:protected override function draw():Void {
		_header.width = width;
		_header.validate();

		_progress.validate();
		_progress.x = (width - _progress.width) / 2;
		_progress.y = _header.height + (height - _header.height - _progress.height) / 2;
	}

	private function onBackButton():Void {
		if (_progressTween != null)
		{
			Starling.juggler.remove(_progressTween);
			_progressTween = null;
		}
		dispatchEventWith(Event.COMPLETE);
	}

	private function backButton_triggeredHandler(event:Event):Void {
		onBackButton();
	}
}
