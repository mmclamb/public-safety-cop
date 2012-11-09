package widgets.PDC.utils{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	
	import org.pdc.flexviewer.widgets.About;
	
	import widgets.PDC.ui.checkbox.WidgetCheckBox;
	import widgets.PDC.ui.scrollarea.ScrollArea;
	import widgets.PDC.utils.AppearanceManagerNative;
	
	public class ActiveHazards extends Sprite {
		public var REST 	: String = "http://ags.pdc.org/rest/services/GHIN/PDC_Active_Hazards/MapServer/";
		public var layers	: Array =  [{title:"Hazards",					active:true,  restId:0, fields:["HAZARD_NAME", "TYPE", "STATUS", "SEVERITY", "CATEGORY"]},
										{title:"Recent Earthquakes",		active:false, restId:4, fields:["DATE_TIME", "MAGNITUDE", "DEPTH", "REGION"]},
										{title:"Active Volcanoes",			active:false, restId:3, fields:["NAME", "REGION", "ACTIVITY"]},
										{title:"Recent Hotspots",			active:false, restId:5, fields:["description", "date_of_first_obs", "date_of_last_obs"]},
										{title:"GLIDE Events",				active:false, restId:2, fields:["EVENT_DATE"]},
										{title:"International Charter",		active:false, restId:1, fields:["EVENT_NAME", "HAZARD_TYPE", "ACTIVATION_DATE"]},
										{title:"Tsunami Travel Time",		active:false, restId:6, fields:["CONTOUR_TYPE", "HOURS_TO_ARRIVAL"]},
										{title:"Current Storm Positions",	active:false, restId:7, fields:["HAZARD_NAME", "STORM_NAME", "ADVISORY_TIME", "ADVISORY_DATE"]},
										{title:"Forecast Storm Positions",	active:false, restId:8, fields:["HAZARD_NAME", "STORM_NAME", "DAY_HR", "WIND_SPEED_MPH"]},
										{title:"Previous Storm Positions",	active:false, restId:9, fields:["HAZARD_NAME", "STORM_NAME", "ADVISORY_TIME", "ADVISORY_DATE", "WIND_SPEED_MPH"]},
										{title:"Potential Track Area",		active:false, restId:16,fields:["HAZARD_NAME", "HAZARD_ID"]}];
			
		public var bindedImages	: HazardIconBinded = new HazardIconBinded();
		
		public var legendInfo	: Object;
		
		private var LAYER		: Object;
		private var _layerId	: int = 0;
		private var master		: Object;
		private var legend		: Legend;
		private var scrollArea	: ScrollArea;
		private var bg:Object;
		private var aboutPanel:AboutPanel;
		private var appearanceManagerNative:AppearanceManagerNative;

		public function ActiveHazards():void {
			bg = addChild(new widget_bg());
			
		};
		
		public function init(master:Object):void {
			legend = new Legend(this, legendInfo);
			
			scrollArea = new ScrollArea();
			scrollArea.x = 8;
			scrollArea.y = 260;
			scrollArea.init(legend, new Rectangle(0, 0, 320, 165));
			bg.addChild(scrollArea);
			
			appearanceManagerNative = new AppearanceManagerNative();
			for(var i:int=0;i<layers.length;i++){
				var checkBox:WidgetCheckBox = new WidgetCheckBox(i, layers[i].active, layers[i].title, 0xFFFFFF);
					checkBox.x = 8;
					checkBox.y = 25 + 20 * i;
					checkBox.addEventListener(WidgetCheckBox.STATUS, handleStatus, false, 0, true);
				bg.addChild(checkBox);
				if(layers[i].active){
					
					legend.addBlock(layers[i].title, i);
				}
			};
		
			this.master = master;
			
			aboutPanel = new AboutPanel();
			aboutPanel.x = 8;
			aboutPanel.y = 60;
			aboutPanel.visible = false;
			aboutPanel.addEventListener(About.STATUS, handleAboutStatus, false, 0, true);
			//addChild(aboutPanel);
		};
		
		public function showAbout():void {
			aboutPanel.revertStatus();
		};
		
		private function handleStatus(event:Event):void {
			_layerId = event.target.id;
			if(event.target.status){
				legend.addBlock(event.target.title, _layerId);
			}else{
				legend.removeBlock(event.target.title);
			};
			layers[_layerId].active = event.target.status;
			dispatchEvent(event);
		};
		
		private function handleAboutStatus(event:Event):void {
			aboutPanel.visible = event.target.status;
			if(event.target.status){
				bg.filters = [new BlurFilter(4, 4, 4)];
				bg.alpha = .8;
			}else{
				bg.filters = null;
				bg.alpha = 1;
			};
		};
		
		public function get layerID():int {
			return _layerId;
		};
	};
};