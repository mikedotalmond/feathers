package ;

import feathers.controls.Button;
import feathers.system.DeviceCapabilities;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display.StageQuality;
import flash.geom.Rectangle;
import flash.system.Capabilities;
import flash.system.System;
import haxe.Log;

import flash.Lib;

import starling.core.Starling;

/**
 * ...
 * @author Mike Almond - @mikedotalmond
 * https://github.com/mikedotalmond/
 */

@:final class Main {

	public static var viewport(default, null):Rectangle;
	
	private var _starling:Starling;
	
	public function new() {
		
		if (Capabilities.cpuArchitecture == "ARM") { // mobile - fullscreen
			viewport = new Rectangle(0, 0, Lib.current.stage.fullScreenWidth, Lib.current.stage.fullScreenHeight);
		} else {
			DeviceCapabilities.dpi = 132; // fake a higher dpi on desktop
			viewport = new Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		}
		
		/*
		 * The feathers Haxe extern library can be found in lib/feathers
		 * (it might end up on haxelib later)
		 * 
		 * To use this, you also need the starling library, a copy of which is included in lib/starling.
		 * Feathers requires a newer version of starling than the current haxelib starling library has, 
		 * so in lib/starling I've updated the externs with the latest changes and a rebuilt library swf.
		 * 
		 * The original starling lib: 
		 * https://github.com/jgranick/starling / haxelib
		 * 
		 * My fork with updates: 
		 * https://github.com/mikedotalmond/starling
		 * 
		 * 
		 * NOTE: Check the additional compiler options in the project settings, there's a macro command
		 * that needs to be run to get the starling extern working.
		 * */
		
		 /*
		 * 
		 * The example below is a port of the feathers components explorer example - to test these externs..
		 * http://feathersui.com/examples/components-explorer/
		 * http://feathersui.com/examples/
		 * 
		 * I also ported the MetalWorksMobileTheme as part of this example - lib/MetalWorksMobileTheme
		 * */
		
		_starling = new Starling(feathers.examples.componentsExplorer.Main, Lib.current.stage, viewport);
		_starling.start();
	}
	
	static function main() {
		
		var stage 		= Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align 	= StageAlign.TOP_LEFT;
		stage.quality 	= StageQuality.LOW;
		
		var main 		= new Main();
	}
}