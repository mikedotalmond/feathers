package;

import flash.display.Stage;
import flash.display.Stage3D;

import flash.display3D.Context3D;
import flash.display3D.Context3DTriangleFace;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3DBlendFactor;
import flash.display3D.Context3DRenderMode;

import flash.errors.Error;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.FullScreenEvent;
import flash.geom.Rectangle;
import flash.system.Capabilities;

import hxs.Signal;
import hxs.Signal1;
import hxs.Signal2;

/**
 * ...
 * @author Mike Almond - https://github.com/mikedotalmond
 */


@:final class SharedStage3DContext {
	
	#if debug
		public static inline var Debug  = true;
		public static inline var AA 	= 0;
	#else
		public static inline var Debug 	= false;
		#if air
			public static inline var AA	= 0;
		#else
			public static inline var AA	= 8;
		#end
	#end
	public static var CPUArchitecture	:String = Capabilities.cpuArchitecture;
	public static var isMobile			:Bool 	= CPUArchitecture == "ARM";
	
	public var stage(default,null):Stage;
	public var stage3D(default,null):Stage3D;
	public var context3D(default,null):Context3D;
	public var contextReady(default, null):Bool;
	public var contextError(default, null):Signal1<ErrorEvent>;
	
	public var contextLost(default, null):Signal;
	public var ready(default,null):Signal;
	public var resize(default, null):Signal2<Int,Int>;
	public var requestDraw(default,null):Signal2<Float,Float>;
	
	public var stageWidth(default, null):Int;
	public var stageHeight(default, null):Int;
	
	public var halfStageWidth(default, null):Int;
	public var halfStageHeight(default, null):Int;
	
	public var fullViewport(default, null):Rectangle;
	
	
	public function new(stage:Stage, stage3D:Stage3D = null, renderMode:String="auto", profile:String="baseline") {
		
		contextReady	= false;
		ready 			= new Signal();
		contextLost		= new Signal();
		contextError	= new Signal1<ErrorEvent>();
		resize 			= new Signal2<Int,Int>();
		requestDraw 	= new Signal2<Float,Float>();
		fullViewport 	= new Rectangle();
		
		this.stage 	 	= stage;
		this.stage3D 	= (stage3D != null) ? stage3D : (stage.stage3Ds.length > 0 ? stage.stage3Ds[0] : null);
		
		if (this.stage3D == null) {
			throw "No stage3Ds available.";
		} else {
			this.stage.addEventListener(Event.FULLSCREEN, onFullScreen, false, 1000);
			this.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextReady, false, 1000);
			this.stage3D.addEventListener(ErrorEvent.ERROR, onContextError, false, 1000);
			this.stage3D.requestContext3D(renderMode, profile);
		}
	}
	
	private function onContextError(e:ErrorEvent):Void {
		contextReady = false;
		contextError.dispatch(e);
	}
	
	private function onContextReady( e:Event ) {
		
		if (contextReady) { // the previsously initialised context was lost and is now available again... handle it.
			
			if (context3D.driverInfo.toLowerCase() == "disposed") {
				trace("Context3D was disposed");
			} else {
				trace("Context3D was lost for reasons unknown...");
				trace("driverInfo: " + context3D.driverInfo);
			}
			
			context3D = null;
			
			// observe the contextLost signal to trigger disosal of your buffers before a new context is ready
			contextLost.dispatch();
		}
		
		context3D = stage3D.context3D;
		
		stage.addEventListener(Event.RESIZE, onResize);
		stage.addEventListener(FullScreenEvent.FULL_SCREEN, onResize);
		
		onResize(null);
		
		contextReady = true;
		
		ready.dispatch();
	}
	
	
	private function onResize(e:Event):Void {
		
		if (isMobile) {
			stageWidth 	= stage.fullScreenWidth;
			stageHeight = stage.fullScreenHeight;
		} else {
			stageWidth 	= stage.stageWidth;
			stageHeight = stage.stageHeight;
		}
		
		fullViewport.width  = stageWidth;
		fullViewport.height = stageHeight;
		halfStageWidth 		= Std.int(stageWidth * .5);
		halfStageHeight 	= Std.int(stageHeight * .5);
		
		// context3D.setScissorRectangle(new Rectangle(0,0,320,640)); .... Starling interference?
		
		// set the backbuffer size
		context3D.enableErrorChecking = Debug;
		context3D.configureBackBuffer(stageWidth, stageHeight, AA, false);
		
		// allow alpha blending
		#if !air
		context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
		#end
		
		context3D.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
		
		// don't draw back-faces
		context3D.setCulling(Context3DTriangleFace.BACK);
		
		if (e != null) resize.dispatch(stageWidth, stageHeight);
	}
	
	private function onFullScreen(e:Event):Void {
		onResize(null);
		resize.dispatch(stageWidth, stageHeight);
	}
	
	public function update(delta:Float, time:Float) {
		if (null == stage3D) return;
		
		context3D.clear();
		
		requestDraw.dispatch(delta, time);
		
		context3D.present();
	}
	
}