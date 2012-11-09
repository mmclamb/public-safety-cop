package widgets.PDC.ui.checkbox {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class WidgetCheckBox extends Sprite {
		public static const STATUS	: String = "WidgetCheckBox.STATUS";
		public var title	: String;
		private var _status	: Boolean = false;
		private var bg_mc	: Object;
		private var title_mc: Object;
		private var hit_mc	: Object;
		private var _id		: int;
		
		
		public function WidgetCheckBox(id:int, status:Boolean=false, title:String="", titleColor:int=0x000000, icon:MovieClip=null):void {
			bg_mc = addChild(new checkBoxBG());
			
			title_mc = addChild(new textContainer());
			title_mc.y = -2;
			title_mc.title_txt.autoSize = TextFieldAutoSize.LEFT;
			var format:TextFormat = new TextFormat();
				format.color = titleColor;
			title_mc.title_txt.defaultTextFormat = format;
			
			if(icon != null){
				var _icon:DisplayObject = addChild(icon);
					_icon.x = bg_mc.width + 6;
					_icon.y = -1;
				title_mc.title_txt.x = _icon.x + _icon.width + 5;
			}else{
				title_mc.title_txt.x = bg_mc.width + 6;
			};
			
			title_mc.title_txt.text = title;
			
			hit_mc = addChild(new trasser_mc());
			hit_mc.width = title_mc.title_txt.x + title_mc.title_txt.width;
			hit_mc.height = bg_mc.height;
			hit_mc.buttonMode = true;
			hit_mc.alpha = 0;
			hit_mc.addEventListener(MouseEvent.CLICK, handleClick, false, 0, true);
			
			_id = id;
			this.status = status;
			this.title = title;
		};
		
		private function handleClick(event:MouseEvent):void {
			status = !status;
		};
		
		public function get id():int {
			return _id;
		};
		
		public function get status():Boolean {
			return _status;
		};
		
		public function set status(val:Boolean):void {
			_status = val;
			bg_mc.gotoAndStop(_status ? 2 : 1);
			dispatchEvent(new Event(WidgetCheckBox.STATUS));
		};
	};
};	