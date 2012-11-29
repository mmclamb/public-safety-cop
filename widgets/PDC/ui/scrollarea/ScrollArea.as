/*
 | Version 10.1.1
 | Copyright 2012 Esri
 |
 | Licensed under the Apache License, Version 2.0 (the "License");
 | you may not use this file except in compliance with the License.
 | You may obtain a copy of the License at
 |
 |    http://www.apache.org/licenses/LICENSE-2.0
 |
 | Unless required by applicable law or agreed to in writing, software
 | distributed under the License is distributed on an "AS IS" BASIS,
 | WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 | See the License for the specific language governing permissions and
 | limitations under the License.
 */
package widgets.PDC.ui.scrollarea {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import widgets.PDC.utils.Legend;

	public class ScrollArea extends Sprite {
		private var controls			: scrollAreaControl;
		private var scrollRectangle		: Rectangle;
		private var _heightDifference	: Number = 0;
		private var arrowDirection		: int = 0;
		private var content				: *;

		public function ScrollArea():void {
			controls = new scrollAreaControl();
			addChild(controls);
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage, false, 0, true);
		};

		public function init(_content:*, scrollRectangle:Rectangle):void {
			content = _content;
			content.addEventListener(Legend.CHANGE, handleContentChange, false, 0, true);

			addChild(content);
			var mask_mc:Sprite = new Sprite();
				mask_mc.graphics.beginFill(0xFF0000);
				mask_mc.graphics.drawRect(scrollRectangle.x, scrollRectangle.y, scrollRectangle.width, scrollRectangle.height);
				mask_mc.graphics.endFill();
			addChild(mask_mc);
			content.mask = mask_mc;

			controls.x = scrollRectangle.width;
			controls.down_btn.y = scrollRectangle.height;
			controls.hit_mc.height = scrollRectangle.height - controls.up_btn.height - controls.down_btn.height;

			makeScrollRectangle();

			controls.up_btn.buttonMode =
			controls.down_btn.buttonMode =
			controls.hit_mc.buttonMode =
			controls.scrubber.buttonMode = true;

			controls.up_btn.addEventListener(MouseEvent.MOUSE_DOWN, handleArrowMouseDown, false, 0, true);
			controls.up_btn.addEventListener(MouseEvent.MOUSE_UP, handleArrowMouseUp, false, 0, true);
			controls.down_btn.addEventListener(MouseEvent.MOUSE_DOWN, handleArrowMouseDown, false, 0, true);
			controls.down_btn.addEventListener(MouseEvent.MOUSE_UP, handleArrowMouseUp, false, 0, true);
			controls.hit_mc.addEventListener(MouseEvent.MOUSE_DOWN, handleHitDown, false, 0, true);
			controls.scrubber.addEventListener(MouseEvent.MOUSE_DOWN, handleScrubberDown, false, 0, true);
			controls.scrubber.addEventListener(MouseEvent.MOUSE_UP, handleScrubberUp, false, 0, true);

			heightDifference = content.height - controls.height;
		};

		private function makeScrollRectangle():void {
			scrollRectangle = new Rectangle(controls.scrubber.x, controls.hit_mc.y, 0, controls.hit_mc.height - controls.scrubber.height);
		};

		private function handleContentChange(event:Event):void {
			heightDifference = content.height - controls.height;		};

		private function handleHitDown(event:MouseEvent):void {
			var percentage:Number = event.localY / 70;
			controls.scrubber.y = scrollRectangle.y + percentage * scrollRectangle.height;
			handleEnterFrame(null);
		};

		private function handleScrubberDown(event:MouseEvent):void {
			addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
			controls.scrubber.startDrag(false, scrollRectangle);
		};

		private function handleScrubberUp(event:MouseEvent):void {
			controls.scrubber.stopDrag();
			removeEventListener(Event.ENTER_FRAME, handleEnterFrame, false);
		};

		private function handleMouseUp(event:MouseEvent):void {
			handleScrubberUp(null);
			handleArrowMouseUp(null);
		};

		private function handleArrowMouseDown(event:MouseEvent):void {
			arrowDirection = event.target == controls.up_btn ? -1 : 1;
			addEventListener(Event.ENTER_FRAME, handleArrowEnterFrame, false, 0, true);
		};

		private function handleArrowMouseUp(event:MouseEvent):void {
			removeEventListener(Event.ENTER_FRAME, handleArrowEnterFrame, false);
			arrowDirection = 0;
		};

		private function handleArrowEnterFrame(event:Event):void {
			var to_y:Number = controls.scrubber.y + arrowDirection;
				to_y = Math.min(Math.max(to_y, scrollRectangle.y),  scrollRectangle.y + scrollRectangle.height);
			controls.scrubber.y = to_y;
			handleEnterFrame(null);
		};

		private function handleEnterFrame(event:Event):void {
			var percentage:Number = (controls.scrubber.y - controls.hit_mc.y) / scrollRectangle.height;
			content.y = - _heightDifference * percentage;
		};

		private function handleAddedToStage(event:Event):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true);
		};

		private function set heightDifference(val:Number):void {
			_heightDifference = Math.max(0, val);
			controls.visible = _heightDifference > 0;
			handleEnterFrame(null);
		};
	};
};