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
	final public class HazardIconBinded{
		[Embed(source = "widgets/PDC/assets/images/layer_icons/hazards_tsunami.png")]
		private var hazards_tsunami:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hazards_equipment.png")]
		private var hazards_equipment:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hazards_highsurf.png")]
		private var hazards_highsurf:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hazards_storm.png")]
		private var hazards_storm:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hazards_highwind.png")]
		private var hazards_highwind:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hazards_unit.png")]
		private var hazards_unit:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hazards_wildfire.png")]
		private var hazards_wildfire:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hazards_flood.png")]
		private var hazards_flood:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hazards_incident.png")]
		private var hazards_incident:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hazards_drought.png")]
		private var hazards_drought:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hazards_earthquake.png")]
		private var hazards_earthquake:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hazards_volcano.png")]
		private var hazards_volcano:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hazards_marine.png")]
		private var hazards_marine:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hazards_cyclone.png")]
		private var hazards_cyclone:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hazards_manmade.png")]
		private var hazards_manmade:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/earthquake_0.png")]
		private var earthquake_0:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/earthquake_1.png")]
		private var earthquake_1:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/earthquake_2.png")]
		private var earthquake_2:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/earthquake_3.png")]
		private var earthquake_3:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/volcano_0.png")]
		private var volcano_0:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/volcano_1.png")]
		private var volcano_1:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hotspots_oil_gas.png")]
		private var hotspots_oil_gas:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hotspots_potential_volcano.png")]
		private var hotspots_potential_volcano:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hotspots_largefire_high.png")]
		private var hotspots_largefire_high:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hotspots_largefire_medium.png")]
		private var hotspots_largefire_medium:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hotspots_largefire_low.png")]
		private var hotspots_largefire_low:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hotspots_mediumfire_high.png")]
		private var hotspots_mediumfire_high:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hotspots_mediumfire_medium.png")]
		private var hotspots_mediumfire_medium:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hotspots_mediumfire_low.png")]
		private var hotspots_mediumfire_low:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hotspots_smallfire_high.png")]
		private var hotspots_smallfire_high:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/hotspots_smallfire_medium.png")]
		private var hotspots_smallfire_medium:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/glide.png")]
		private var glide:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/intl_charter.png")]
		private var intl_charter:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/tsunami_contour.png")]
		private var tsunami_contour:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/storm_point_0_current.png")]
		private var storm_point_0_current:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/storm_point_1_current.png")]
		private var storm_point_1_current:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/storm_point_2_current.png")]
		private var storm_point_2_current:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/storm_point_3_current.png")]
		private var storm_point_3_current:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/storm_point_0_previous.png")]
		private var storm_point_0_previous:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/storm_point_1_previous.png")]
		private var storm_point_1_previous:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/storm_point_2_previous.png")]
		private var storm_point_2_previous:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/storm_point_3_previous.png")]
		private var storm_point_3_previous:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/storm_point_0_forecast.png")]
		private var storm_point_0_forecast:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/storm_point_1_forecast.png")]
		private var storm_point_1_forecast:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/storm_point_2_forecast.png")]
		private var storm_point_2_forecast:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/storm_point_3_forecast.png")]
		private var storm_point_3_forecast:Class;

		[Embed(source = "widgets/PDC/assets/images/layer_icons/potential_track_area.png")]
		private var potential_track_area:Class;

		public function getIcon(layerID:int, hazardInfo:Object):Object {
			var tooltip : String;
			var icon	: *;
			var km		: int;

			switch(layerID){
				case 0:
					tooltip =	"HAZARDS"		+ "\n\n" +
								"HAZARD NAME	" + hazardInfo.HAZARD_NAME + "\n" +
								"STATUS			" + hazardInfo.STATUS;

					switch(hazardInfo.TYPE){
						case "TSUNAMI"	: return {icon:hazards_tsunami,		tooltip:tooltip};
						case "EQUIPMENT": return {icon:hazards_equipment,	tooltip:tooltip};
						case "HIGHSURF"	: return {icon:hazards_highsurf,	tooltip:tooltip};
						case "STORM"	: return {icon:hazards_storm,		tooltip:tooltip};
						case "HIGHWIND"	: return {icon:hazards_highwind,	tooltip:tooltip};
						case "UNIT"		: return {icon:hazards_unit,		tooltip:tooltip};
						case "WILDFIRE"	: return {icon:hazards_wildfire,	tooltip:tooltip};
						case "FLOOD"	: return {icon:hazards_flood,		tooltip:tooltip};
						case "INCIDENT"	: return {icon:hazards_incident,	tooltip:tooltip};
						case "DROUGHT"	: return {icon:hazards_drought,		tooltip:tooltip};
						case "EARTHQUAKE":return {icon:hazards_earthquake,	tooltip:tooltip};
						case "VOLCANO"	: return {icon:hazards_volcano,		tooltip:tooltip};
						case "MARINE"	: return {icon:hazards_marine,		tooltip:tooltip};
						case "CYCLONE"	: return {icon:hazards_cyclone,		tooltip:tooltip};
						case "MANMADE"	: return {icon:hazards_manmade,		tooltip:tooltip};
					};
				break;

				case 3:
					tooltip =	"ACTIVE VOLCANOES" + "\n\n" +
								"NAME		" + hazardInfo.NAME + "\n" +
								"REGION	" + hazardInfo.REGION + "\n" +
								"ACTIVITY	" + hazardInfo.ACTIVITY;

					return {icon:(hazardInfo.ACTIVITY == "Ongoing Activity" ? volcano_0 : volcano_1), tooltip:tooltip};
				break;

				case 4:
					tooltip =	"RECENT EARTHQUAKES" + "\n\n" +
								"DATE_TIME	" + hazardInfo.DATE_TIME + "\n" +
								"MAGNITUDE	" + parseInt(hazardInfo.MAGNITUDE).toFixed(3) + "\n" +
								"DEPTH			" + hazardInfo.DEPTH + "\n" +
								"REGION		" + hazardInfo.REGION;
					icon = hazardInfo.MAGNITUDE < 4 ? earthquake_0 : (hazardInfo.MAGNITUDE < 4.5 ? earthquake_1 : (hazardInfo.MAGNITUDE < 5 ? earthquake_2 : earthquake_3));
					return {icon:icon, tooltip:tooltip};
				break;


				case 2:
					tooltip =	"GLIDE EVENTS" + "\n\n" +
								"EVENT_DATE		" + DateParser.parseToString(hazardInfo.EVENT_DATE);
					return {icon:glide, tooltip:tooltip};
				break;

				case 1:
					tooltip =	"INT'L CHARTER ACTIVATIONS" + "\n\n" +
								"EVENT_NAME			" + hazardInfo.EVENT_NAME + "\n" +
								"HAZARD_TYPE		" + hazardInfo.HAZARD_TYPE + "\n" +
								"ACTIVATION_DATE	" + DateParser.parseToString(hazardInfo.ACTIVATION_DATE);
					return {icon:intl_charter, tooltip:tooltip};
				break;

				case 6:
					tooltip =	"TSUNAMI TRAVEL TIME CONTOURS" + "\n\n" +
								"CONTOUR_TYPE		" + hazardInfo.CONTOUR_TYPE + "\n" +
								"HOURS_TO_ARRIVAL	" + hazardInfo.HOURS_TO_ARRIVAL;
					return {icon:tsunami_contour, tooltip:tooltip};
				break;

				case 7:
					var prefix:String = hazardInfo.SYMBOL_CODE.charAt(0);
						prefix = prefix == "F" ? "FORECAST " : (prefix == "C" ? "CURRENT " : "PREVIOUS ");
					tooltip =	prefix + "STORM POSITION" + "\n\n" +
								"HAZARD_NAME	" + hazardInfo.HAZARD_NAME + "\n" +
								"STORM_NAME		" + hazardInfo.STORM_NAME + "\n" +
								"ADVISORY_TIME	" + hazardInfo.ADVISORY_TIME + "\n" +
								"ADVISORY_DATE	" + hazardInfo.ADVISORY_DATE;
					switch(hazardInfo.SYMBOL_CODE){
						case "FST"	: return {icon:storm_point_3_forecast, tooltip:tooltip};
						case "FTY"	: return {icon:storm_point_2_forecast, tooltip:tooltip};
						case "FTS"	: return {icon:storm_point_1_forecast, tooltip:tooltip};
						case "FTD"	: return {icon:storm_point_0_forecast, tooltip:tooltip};
						case "CST"	: return {icon:storm_point_3_current, tooltip:tooltip};
						case "CTY"	: return {icon:storm_point_2_current, tooltip:tooltip};
						case "CTS"	: return {icon:storm_point_1_current, tooltip:tooltip};
						case "CTD"	: return {icon:storm_point_0_current, tooltip:tooltip};
						case "PST"	: return {icon:storm_point_3_previous, tooltip:tooltip};
						case "PTY"	: return {icon:storm_point_2_previous, tooltip:tooltip};
						case "PTS"	: return {icon:storm_point_1_previous, tooltip:tooltip};
						case "PTD"	: return {icon:storm_point_0_previous, tooltip:tooltip};
					};
				break;

				case 5:
					tooltip =	"RECENT HOTSPOTS" + "\n\n" +
								"DESCRIPTION		" + hazardInfo.description + "\n" +
								"DATE OF FIRST OBS	" + hazardInfo.date_of_first_obs + "\n" +
								"DATE OF LAST OBS	" + hazardInfo.date_of_last_obs;
					switch(hazardInfo.description){
						case "Potential oil/gas field":
							icon = hotspots_oil_gas;
						break;

						case "Potential volcanic activity":
							icon = hotspots_potential_volcano;
						break;

						case "Large fire/High intensity":
							icon = hotspots_largefire_high;
						break;

						case "Large fire/Medium intensity":
							icon = hotspots_largefire_medium;
						break;

						case "Large fire/Low intensity":
							icon = hotspots_largefire_low;
						break;

						case "Medium fire/High intensity":
							icon = hotspots_mediumfire_high;
						break;

						case "Medium fire/Medium intensity":
							icon = hotspots_mediumfire_medium;
						break;

						case "Medium fire/Low intensity":
							icon = hotspots_mediumfire_low;
						break;

						case "Small fire/High intensity":
							icon = hotspots_smallfire_high;
						break;

						case "Small fire/Medium intensity":
							icon = hotspots_smallfire_medium;
						break;
					};
					return {icon:icon, tooltip:tooltip};
				break;

				case 19:
				break;
			};

			return {icon:potential_track_area, tooltip:"Undefined"};
		};

		public function getLegendIcon(_type:String):* {
			switch(_type){
				case "Tsunami"						: return new hazards_tsunami();
				case "Equipment"					: return new hazards_equipment();
				case "High Surf"					: return new hazards_highsurf();
				case "Storm"						: return new hazards_storm();
				case "High Wind"					: return new hazards_highwind();
				case "Unit"							: return new hazards_unit();
				case "Wildfire"						: return new hazards_wildfire();
				case "Flood"						: return new hazards_flood();
				case "Incident"						: return new hazards_incident();
				case "Drought"						: return new hazards_drought();
				case "Earthquake"					: return new hazards_earthquake();
				case "Volcano"						: return new hazards_volcano();
				case "Marine"						: return new hazards_marine();
				case "Cyclone"						: return new hazards_cyclone();
				case "Manmade"						: return new hazards_manmade();

				//---------------------
				case "Less than 4.0"				: return new earthquake_0();
				case "4.0 - 4.5"					: return new earthquake_1();
				case "4.5 - 5.0"					: return new earthquake_2();
				case "5.0 and greater"				: return new earthquake_3();

				//---------------------
				case "Ongoing Activity"				: return new volcano_0();
				case "New Activity"					: return new volcano_1();

				//---------------------
				case "Potential oil/gas field"		: return new hotspots_oil_gas();
				case "Potential volcanic activity"	: return new hotspots_potential_volcano();
				case "Large fire/High intensity"	: return new hotspots_largefire_high();
				case "Large fire/Medium intensity"	: return new hotspots_largefire_medium();
				case "Large fire/Low intensity"		: return new hotspots_largefire_low();
				case "Medium fire/High intensity"	: return new hotspots_mediumfire_high();
				case "Medium fire/Medium intensity"	: return new hotspots_mediumfire_medium();
				case "Medium fire/Low intensity"	: return new hotspots_mediumfire_low();
				case "Small fire/High intensity"	: return new hotspots_smallfire_high();
				case "Small fire/Medium intensity"	: return new hotspots_smallfire_medium();

				//---------------------
				case "GLIDE Events "				: return new glide();

				//---------------------
				case "Int'l Charter"				: return new intl_charter();

				//---------------------
				case "Tsunami Travel Time contours"	: return new tsunami_contour();

				//---------------------
				case "Forecast Hurricane/Typhoon > 150 mph"	: return new storm_point_3_forecast();
				case "Forecast Hurricane/Typhoon > 74 mph"	: return new storm_point_2_forecast();
				case "Forecast Tropical Storm"				: return new storm_point_1_forecast();
				case "Forecast Tropical Depression"			: return new storm_point_0_forecast();
				case "Current Hurricane/Typhoon > 150 mph"	: return new storm_point_3_current();
				case "Current Hurricane/Typhoon > 74 mph"	: return new storm_point_2_current();
				case "Current Tropical Storm"				: return new storm_point_1_current();
				case "Current Tropical Depression"			: return new storm_point_0_current();
				case "Previous Hurricane/Typhoon > 150 mph"	: return new storm_point_3_previous();
				case "Previous Hurricane/Typhoon > 74 mph"	: return new storm_point_2_previous();
				case "Previous Tropical Storm"				: return new storm_point_1_previous();
				case "Previous Tropical Depression"			: return new storm_point_0_previous();

				//---------------------
				case "Potential Track Area"					: return new potential_track_area();

				case "Hurricane/Typhoon"					: return new square_red();
				case "Tropical Storm"						: return new square_yellow();
				case "Tropical Depression"					: return new square_green();


				case "Segments - Forecast Hurricane/Super Typhoon": return new square_red_dash();
				case "Segments - Forecast Hurricane/Typhoon"		: return new square_orange_dash();
				case "Segments - Forecast Tropical Storm"			: return new square_green_dash();
				case "Segments - Forecast Tropical Depression"	: return new potential_track_area_dash();
				case "Segments - Previous Hurricane/Super Typhoon": return new square_red();
				case "Segments - Previous Hurricane/Typhoon"		: return new square_orange();
				case "Segments - Previous Tropical Storm"			: return new square_green();
				case "Segments - Previous Tropical Depression"	: return new potential_track_area();
			};
			return new undefined_icon();
		};
	};
};