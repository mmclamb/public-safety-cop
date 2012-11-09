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