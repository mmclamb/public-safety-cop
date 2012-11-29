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
package widgets.PDC.utils {
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;


	import flash.display.DisplayObject;

	final public class AppearanceManagerNative {
		public function showObject(object:DisplayObject):void {
			object.alpha = 1;
			object.visible = true;
		};

		public function hideObject(object:DisplayObject):void {
			object.alpha = 0;
			object.visible = false;
		};

		public function showObjectEase(object:DisplayObject, time:Number=.2):void {
			object.visible = true;
			var tween:Tween = new Tween(object, "alpha", Back.easeOut, object.alpha, 1, time, true);
		};

		public function hideObjectEase(object:DisplayObject, time:Number=.2):void {
			var tween:Tween = new Tween(object, "alpha", Back.easeOut, object.alpha, 0, time, true);
				tween.addEventListener(TweenEvent.MOTION_FINISH, handleTweenStop, false, 0, true);
		};

		private function handleTweenStop(event:TweenEvent):void {
			event.target.removeEventListener(TweenEvent.MOTION_FINISH, handleTweenStop, false);
			event.target.obj.visible = false;
		};
	};
};