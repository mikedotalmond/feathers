/*
Copyright (c) 2012 Josh Tynjala

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package feathers.controls;
import feathers.core.FeathersControl;
import feathers.core.ITextRenderer;
import feathers.core.IToggle;
import feathers.core.PropertyProxy;
import feathers.system.DeviceCapabilities;

import flash.geom.Point;
import flash.geom.Rectangle;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * @inheritDoc
 */
@:meta(Event(name="change",type="starling.events.Event"))

/**
 * Similar to a light switch with on and off states. Generally considered an
 * alternative to a check box.
 *
 * @see http://wiki.starling-framework.org/feathers/toggle-switch
 * @see Check
 */
extern class ToggleSwitch extends FeathersControl, implements IToggle
{
	/**
	 * @private
	 */
	private static var HELPER_POINT:Point;//new Point();

	/**
	 * @private
	 * The minimum physical distance (in inches) that a touch must move
	 * before the scroller starts scrolling.
	 */
	private static var MINIMUM_DRAG_DISTANCE:Float;//0.04;

	/**
	 * The ON and OFF labels will be aligned to the middle vertically,
	 * based on the full character height of the font.
	 */
	public static var LABEL_ALIGN_MIDDLE:String;//"middle";

	/**
	 * The ON and OFF labels will be aligned to the middle vertically,
	 * based on only the baseline value of the font.
	 */
	public static var LABEL_ALIGN_BASELINE:String;//"baseline";

	/**
	 * The toggle switch has only one track skin, stretching to fill the
	 * full length of switch. In this layout mode, the on track is
	 * displayed and fills the entire length of the slider. The off
	 * track will not exist.
	 */
	public static var TRACK_LAYOUT_MODE_SINGLE:String;//"single";

	/**
	 * The toggle switch has two tracks, stretching to fill each side of the
	 * scroll bar with the thumb in the middle. The tracks will be resized
	 * as the thumb moves. This layout mode is designed for toggle switches
	 * where the two sides of the track may be colored differently to better
	 * differentiate between the on state and the off state.
	 *
	 * <p>Since the width and height of the tracks will change, consider
	 * sing a special display object such as a <code>Scale9Image</code>,
	 * <code>Scale3Image</code> or a <code>TiledImage</code> that is
	 * designed to be resized dynamically.</p>
	 *
	 * @see feathers.display.Scale9Image
	 * @see feathers.display.Scale3Image
	 * @see feathers.display.TiledImage
	 */
	public static var TRACK_LAYOUT_MODE_ON_OFF:String;// = "onOff";


	/**
	 * The switch's on and off track skins will be resized and cropped
	 * using a scrollRect to ensure that the skins maintain a static
	 * appearance without altering the aspect ratio.
	 */
	public static var TRACK_LAYOUT_MODE_SCROLL:String;//"scroll";

	/**
	 * The default value added to the <code>nameList</code> of the off label.
	 */
	public static var DEFAULT_CHILD_NAME_OFF_LABEL:String;//"feathers-toggle-switch-off-label";

	/**
	 * The default value added to the <code>nameList</code> of the on label.
	 */
	public static var DEFAULT_CHILD_NAME_ON_LABEL:String;//"feathers-toggle-switch-on-label";

	/**
	 * The default value added to the <code>nameList</code> of the off track.
	 */
	public static var DEFAULT_CHILD_NAME_OFF_TRACK:String;//"feathers-toggle-switch-off-track";

	/**
	 * The default value added to the <code>nameList</code> of the on track.
	 */
	public static var DEFAULT_CHILD_NAME_ON_TRACK:String;//"feathers-toggle-switch-on-track";

	/**
	 * The default value added to the <code>nameList</code> of the thumb.
	 */
	public static var DEFAULT_CHILD_NAME_THUMB:String;//"feathers-toggle-switch-thumb";

	/**
	 * Constructor.
	 */
	public function new():Void;

	/**
	 * The value added to the <code>nameList</code> of the off label.
	 */
	private var onLabelName:String;// = DEFAULT_CHILD_NAME_ON_LABEL;

	/**
	 * The value added to the <code>nameList</code> of the on label.
	 */
	private var offLabelName:String;// = DEFAULT_CHILD_NAME_OFF_LABEL;

	/**
	 * The value added to the <code>nameList</code> of the on track.
	 */
	private var onTrackName:String;// = DEFAULT_CHILD_NAME_ON_TRACK;

	/**
	 * The value added to the <code>nameList</code> of the off track.
	 */
	private var offTrackName:String;// = DEFAULT_CHILD_NAME_OFF_TRACK;

	/**
	 * The value added to the <code>nameList</code> of the thumb.
	 */
	private var thumbName:String;// = DEFAULT_CHILD_NAME_THUMB;

	/**
	 * The thumb sub-component.
	 */
	private var thumb:Button;

	/**
	 * The "on" text renderer sub-component.
	 */
	private var onTextRenderer:ITextRenderer;

	/**
	 * The "off" text renderer sub-component.
	 */
	private var offTextRenderer:ITextRenderer;

	/**
	 * The "on" track sub-component.
	 */
	private var onTrack:Button;

	/**
	 * The "off" track sub-component.
	 */
	private var offTrack:Button;

	/**
	 * @private
	 */
	private var _paddingRight:Float;//0;

	/**
	 * The minimum space, in pixels, between the switch's right edge and the
	 * switch's content.
	 */
	public var paddingRight(default, default):Float;


	/**
	 * @private
	 */
	private var _paddingLeft:Float;//0;

	/**
	 * The minimum space, in pixels, between the switch's left edge and the
	 * switch's content.
	 */
	public var paddingLeft(default, default):Float;
	

	/**
	 * @private
	 */
	private var _showLabels:Bool;//true;

	/**
	 * Determines if the labels should be drawn. The onTrackSkin and
	 * offTrackSkin backgrounds may include the text instead.
	 */
	public var showLabels(default, default):Bool;
	

	/**
	 * @private
	 */
	private var _showThumb:Bool;//true;

	/**
	 * Determines if the thumb should be displayed. This stops interaction
	 * while still displaying the background.
	 */
	public var showThumb(default, default):Bool;

	
	/**
	 * @private
	 */
	private var _trackLayoutMode:String;// = TRACK_LAYOUT_MODE_SINGLE;

	@:meta(Inspectable(type="String",enumeration="single,stretch,scroll"))
	/**
	 * Determines how the on and off track skins are positioned and sized.
	 *
	 * @default TRACK_LAYOUT_MODE_SINGLE
	 * @see #TRACK_LAYOUT_MODE_SINGLE
	 * @see #TRACK_LAYOUT_MODE_ON_OFF
	 */
	public var trackLayoutMode(default, default):String;

	/**
	 * @private
	 */
	private var _defaultLabelProperties:PropertyProxy;

	/**
	 * The key/value pairs to pass to the labels, if no higher priority
	 * format is available. For the ON label, <code>onLabelProperties</code>
	 * takes priority. For the OFF label, <code>offLabelProperties</code>
	 * takes priority.
	 *
	 * @see #onLabelProperties
	 * @see #offLabelProperties
	 * @see #disabledLabelProperties
	 */
	public var defaultLabelProperties(default, default):Dynamic;
	
	
	/**
	 * @private
	 */
	private var _disabledLabelProperties:PropertyProxy;

	/**
	 * The key/value pairs to pass to the labels, if the toggle switch is
	 * disabled.
	 */
	public var disabledLabelProperties(default, default):Dynamic;

	/**
	 * @private
	 */
	private var _onLabelProperties:PropertyProxy;

	/**
	 * The key/value pairs passed to the ON label. If <code>null</code>,
	 * then <code>defaultLabelProperties</code> will be used instead.
	 */
	public var onLabelProperties(default, default):Dynamic;


	/**
	 * @private
	 */
	private var _offLabelProperties:PropertyProxy;

	/**
	 * The key/value pairs passed to the OFF label. If <code>null</code>,
	 * then <code>defaultLabelProperties</code> will be used instead.
	 */
	public var offLabelProperties(default, default):Dynamic;


	/**
	 * @private
	 */
	private var _labelAlign:String;// = LABEL_ALIGN_BASELINE;

	@:meta(Inspectable(type="String",enumeration="baseline,middle"))
	/**
	 * The vertical alignment of the label.
	 */
	public var labelAlign(default, default):String;


	/**
	 * @private
	 */
	private var _labelFactory:Void->ITextRenderer;

	/**
	 * A function used to instantiate the toggle switch's label subcomponents.
	 *
	 * <p>The factory should have the following function signature:</p>
	 * <pre>function():ITextRenderer</pre>
	 *
	 * @see feathers.core.ITextRenderer
	 */
	public var labelFactory(default, default):Void->ITextRenderer;

	/**
	 * @private
	 */
	private var onTrackSkinOriginalWidth:Float;//

	/**
	 * @private
	 */
	private var onTrackSkinOriginalHeight:Float;//

	/**
	 * @private
	 */
	private var offTrackSkinOriginalWidth:Float;//

	/**
	 * @private
	 */
	private var offTrackSkinOriginalHeight:Float;//

	/**
	 * @private
	 */
	private var _isSelected:Bool;//false;

	/**
	 * Indicates if the toggle switch is selected (ON) or not (OFF).
	 */
	public var isSelected(default, default):Bool;

	/**
	 * @private
	 */
	private var _toggleDuration:Float;//0.15;

	/**
	 * The duration, in seconds, of the animation when the toggle switch
	 * is toggled and animates the position of the thumb.
	 */
	public var toggleDuration(default, default):Float;


	/**
	 * @private
	 */
	private var _toggleEase:Dynamic;// = Transitions.EASE_OUT;

	/**
	 * The easing function used for toggle animations.
	 */
	public var toggleEase(default, default):Dynamic;

	/**
	 * @private
	 */
	private var _onText:String;//"ON";

	/**
	 * The text to display in the ON label.
	 */
	public var onText(default, default):String;


	/**
	 * @private
	 */
	private var _offText:String;//"OFF";

	/**
	 * The text to display in the OFF label.
	 */
	public var offText(default, default):String;
	
	/**
	 * @private
	 */
	private var _toggleTween:Tween;

	/**
	 * @private
	 */
	private var _ignoreTapHandler:Bool;//false;

	/**
	 * @private
	 */
	private var _touchPointID:Int;//-1;

	/**
	 * @private
	 */
	private var _thumbStartX:Float;

	/**
	 * @private
	 */
	private var _touchStartX:Float;

	/**
	 * @private
	 */
	private var _isSelectionChangedByUser:Bool;//false;

	/**
	 * @private
	 */
	private var _onTrackProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to the toggle switch's on
	 * track sub-component. The on track is a
	 * <code>feathers.controls.Button</code> instance.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * @see feathers.controls.Button
	 */
	public var onTrackProperties(default, default):Dynamic;


	/**
	 * @private
	 */
	private var _offTrackProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to the toggle switch's off
	 * track sub-component. The off track is a
	 * <code>feathers.controls.Button</code> instance.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * @see feathers.controls.Button
	 */
	public var offTrackProperties(default, default):Dynamic;


	/**
	 * @private
	 */
	private var _thumbProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to the toggle switch's
	 * thumb sub-component. The thumb is a
	 * <code>feathers.controls.Button</code> instance.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
	 * which is in a <code>Scroller</code> which is in a <code>List</code>,
	 * you can use the following syntax:</p>
	 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * @see feathers.controls.Button
	 */
	public var thumbProperties(default, default):Dynamic;
	

	
	
	/**
	 * @private
	 */
	private function autoSizeIfNeeded():Bool;
	
	/**
	 * @private
	 */
	private function createLabels():Void;
	
	/**
	 * @private
	 */
	private function updateSelection():Void;
	
	/**
	 * @private
	 */
	private function refreshOnLabelStyles():Void;
	
	/**
	 * @private
	 */
	private function refreshOffLabelStyles():Void;
	
	/**
	 * @private
	 */
	private function refreshThumbStyles():Void;
	
	/**
	 * @private
	 */
	private function refreshTrackStyles():Void;
	
	/**
	 * @private
	 */
	private function drawLabels():Void;

	/**
	 * @private
	 */
	private function layout():Void;

	/**
	 * @private
	 */
	private function layoutTrackWithStretch():Void;

	/**
	 * @private
	 */
	private function layoutTrackWithScrollRect():Void;
	
	/**
	 * @private
	 */
	private function layoutTrackWithSingle():Void;

	/**
	 * @private
	 */
	private function createOrDestroyOffTrackIfNeeded():Void;

	/**
	 * @private
	 */
	private function childProperties_onChange(proxy:PropertyProxy, name:Dynamic):Void;

	/**
	 * @private
	 */
	private function removedFromStageHandler(event:Event):Void;

	/**
	 * @private
	 */
	private function touchHandler(event:TouchEvent):Void;

	/**
	 * @private
	 */
	private function thumb_touchHandler(event:TouchEvent):Void;
	
	/**
	 * @private
	 */
	private function selectionTween_onUpdate():Void;

	/**
	 * @private
	 */
	private function selectionTween_onComplete():Void;
}