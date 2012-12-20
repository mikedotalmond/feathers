package ;

import feathers.controls.Button;
import feathers.system.DeviceCapabilities;
import flash.events.Event;

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

	private var _starling:Starling;
	private var sharedContext:SharedStage3DContext;
	
	public function new() {
		
		if (Capabilities.cpuArchitecture != "ARM") { // not mobile
			DeviceCapabilities.dpi = 132; // fake a higher dpi on desktop
		}
		
		sharedContext = new SharedStage3DContext(Lib.current.stage);
		sharedContext.ready.addOnce(startup);
		sharedContext.requestDraw.add(starlingRender);
		
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
		
	}
	private function startup() {		
		_starling = new Starling(feathers.examples.componentsExplorer.Main, sharedContext.stage, sharedContext.fullViewport, sharedContext.stage3D);
		_starling.start();
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, enterFrame);
	}
	
	private function enterFrame(e:Event):Void {
		sharedContext.update(0,0);
	}
	
	
	private function starlingRender(dt,t):Void {
		_starling.nextFrame();
	}
	
	
	
	static function main() {
		
		var stage 		= Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align 	= StageAlign.TOP_LEFT;
		stage.quality 	= StageQuality.LOW;
		
		var main 		= new Main();
	}
}