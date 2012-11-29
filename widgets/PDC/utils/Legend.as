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
	import flash.display.Sprite;
	import flash.events.Event;

	public class Legend extends Sprite {
		public static const CHANGE	: String = "Legend.CHANGE";

		public var legendInfo:Object;

		private var blocks:Array;
		private var master:*;

		public function Legend(master:*, legendInfo:Object):void {
			this.master = master;
			this.legendInfo = legendInfo;
			blocks = [];
		};

		public function addBlock(_type:String, id:int):void {
			var present:Boolean;
			for(var i:int=0;i<blocks.length;i++){
				if(blocks[i].type == _type){
					present = true;
					break;
				};
			};
			if(!present){
				var block:LegendBlock;
				if(_type == "Hazards"){
					block = new LegendBlock(master, _type, id, legendInfo[_type].description, legendInfo[_type].metadataURL, legendInfo[_type].items);
				}else{
					block = new LegendBlock(master, _type, id, legendInfo[_type].description, legendInfo[_type].metadataURL, legendInfo[_type].items);
				};

				switch(_type){
					case "Hazards":
						block = new LegendBlock(master, _type, id, "User-defined hazards created in the<br>Hazards and Products (H&P application)",
												this.legendInfo[_type].metadataURL,
														[	"Tsunami",
															"Equipment",
															"High Surf",
															"Storm",
															"High Wind",
															"Unit",
															"Wildfire",
															"Flood",
															"Incident",
															"Drought",
															"Earthquake",
															"Volcano",
															"Marine",
															"Cyclone",
															"Manmade"]);
					break;

					case "Recent Earthquakes":
						block = new LegendBlock(master, _type, id, "Earthquakes from the past 48 hours",
														this.legendInfo[_type].metadataURL,
														[	"Less than 4.0",
															"4.0 - 4.5",
															"4.5 - 5.0",
															"5.0 and greater"]);
					break;

					case "Active Volcanoes":
						block = new LegendBlock(master, _type, id, "Active volcanoes",
														this.legendInfo[_type].metadataURL,
														[	"Ongoing Activity",
															"New Activity"]);
					break;

					case "Recent Hotspots":
						block = new LegendBlock(master, _type, id, "Wildfires for the past week (MODIS)",
														this.legendInfo[_type].metadataURL,
														[	"Potential oil/gas field",
															"Potential volcanic activity",
															"Large fire/High intensity",
															"Large fire/Medium intensity",
															"Large fire/Low intensity",
															"Medium fire/High intensity",
															"Medium fire/Medium intensity",
															"Medium fire/Low intensity",
															"Small fire/High intensity",
															"Small fire/Medium intensity"]);
					break;

					case "GLIDE Events":
						block = new LegendBlock(master, _type, id, "Globally common Unique ID code for disasters",
														this.legendInfo[_type].metadataURL,
														["GLIDE Events "]);
					break;

					case "International Charter":
						block = new LegendBlock(master, _type, id, "International Charter Activations",
														this.legendInfo[_type].metadataURL,
														["Int'l Charter"]);
					break;

					case "Tsunami Travel Time":
						block = new LegendBlock(master, _type, id, "Tsunami Travel Time contours",
														this.legendInfo[_type].metadataURL,
														["Tsunami Travel Time contours"]);
					break;

					case "Current Storm Positions":
						block = new LegendBlock(master, _type, id, "Current tropical cyclones",
														this.legendInfo[_type].metadataURL,
														["Current Storm Positions "]);
					break;

					case "Forecast Storm Positions":
						block = new LegendBlock(master, _type, id, "Forecast positions of current tropical cyclones",
														this.legendInfo[_type].metadataURL,
														["Tropical Depression: < 63 KPH",
														 "Tropical Storm: 63 - 117 KPH",
														 "Hurricane/Typhoon: > 117 KPH",
														 "Hurricane/Typhoon: > 240 KPH"]);
					break;

					case "Previous Storm Positions":
						block = new LegendBlock(master, _type, id, "Previous positions of current tropical cyclones",
														this.legendInfo[_type].metadataURL,
														["Tropical Depression: < 63 KPH",
														 "Tropical Storm: 63 - 117 KPH",
														 "Hurricane/Typhoon: > 117 KPH",
														 "Hurricane/Typhoon: > 240 KPH"]);
					break;

					case "Potential Track Area":
						block = new LegendBlock(master, _type, id, "Potential Track Area",
														this.legendInfo[_type].metadataURL,
														["Potential Track Area"]);
					break;
				};


				addChild(block);
				blocks.push(block);
				sortBlocks();
			};
			dispatchEvent(new Event(Legend.CHANGE));
		};

		public function removeBlock(_type:String):void {
			for(var i:int=0;i<blocks.length;i++){
				if(blocks[i].type == _type){
					removeChild(blocks[i]);
					blocks.splice(i, 1);
					sortBlocks();
					break;
				};
			};
			dispatchEvent(new Event(Legend.CHANGE));
		};

		private function sortBlocks():void {
			blocks.sortOn("id");
			var _y:int = 0;
			for(var i:int=0;i<blocks.length;i++){
				blocks[i].y = _y;
				_y += blocks[i].height;
			};
		};
	};
};