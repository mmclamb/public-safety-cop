/*
 | Version 10.2
 | Copyright 2013 Esri
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
package widgets.KPI.Utils
{
	import com.esri.ags.SpatialReference;
	import com.esri.ags.layers.supportClasses.Field;

	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;

	[Bindable]
	public class KPIParserUtil
	{

		private static var _instance:KPIParserUtil;

		private var i:int;

		public var arrLayers:Array;
		public var arrFields:Array;
		public var arrExcludeFields:Array;
		public var includeAllLayers:Boolean;
		public var includeAllFields:Boolean;
		public var layerAttribute:String;
		public var fieldAttribute:String;

		public var strOption:String;
		public var strGraph:String;


		public var lblLayerList:String;
		public var numLayerListGap:Number;
		public var numDdlLayersListWidth:Number;
		public var strLayerListPrompt:String;
		public var strLayerListLabelField:String;

		public var lblFieldList:String;
		public var numFieldListGap:Number;
		public var numDdlFieldListWidth:Number;
		public var strFieldListPrompt:String;
		public var strFieldListLabelField:String;

		public var numButtonPaddingLeft:Number;
		public var numButtonGap:Number;
		public var btnSearchLabel:String;
		public var btnClearLabel:String;

		public const TYPE_LAYERS:String = "layers";
		public const TYPE_SUBLAYERS:String = "subLayers";

		public var mapServerUrl:String;
		public var mapServerLabel:String;

		public var defaultLayerUrl:String
		public var defaultLayerLabel:String;
		public var defaultField:Array;
		public var defaultFieldType:Field;
		public var defaultFieldAlias:String;

		public var nullValue:String;

		public var refreshEnabled:Boolean;
		public var refreshTime:Number;

		public var tableColumn:Array;

		public var legendBackgroundColor:uint;

		public var glowColor:uint;
		public var glowQuality:Number;
		public var glowStrength:Number;

		public var lblPieChartHeader:String;
		public var lblTableHeader:String;

		public var alertConfigLoadFailHeader:String;
		public var alertConfigLoadFailMessage:String;

		public var alertDefaultQueryFailHeader:String;
		public var alertDefaultQueryFailMessage:String;

		public var alertQueryFaultHeader:String;
		public var alertQueryFaultMessage:String;

		public var alertNullDataHeader:String;
		public var alertNullDataMessage:String;

		public var alertTableColumnMismatchHeader:String;
		public var alertTableColumnMismatchMessage:String;


		public static function getKPIParserUtil():KPIParserUtil
		{
			if(_instance == null)
			{
				_instance = new KPIParserUtil();
			}
			return _instance;
		}

		public function parseConfigXML(configXML:XML):void
		{
			parseWidgetConfig(configXML);
		}

		private function parseWidgetConfig(configXML:XML):void
		{
			//MapServer
			mapServerLabel = configXML.layers.mapServerLayer.@label || "";
			mapServerUrl = configXML.layers.mapServerLayer.@url || "";

			//Widget tab
			strOption = configXML.layout.optionTabLabel.@label || "Option";
			strGraph = configXML.layout.chartTabLabel.@label || "Chart";

			//Layer list drop down layout
			lblLayerList = configXML.layout.layersDropDownList.@label || "Layers";
			numLayerListGap = configXML.layout.layersDropDownList.@gap || 10;
			numDdlLayersListWidth = configXML.layout.layersDropDownList.@width || 100;
			strLayerListPrompt = configXML.layout.layersDropDownList.@prompt || "-Please Select-";
			strLayerListLabelField = configXML.layout.layersDropDownList.@labelField || "name";

			//Field list drop down layout
			lblFieldList = configXML.layout.fieldsDropDownList.@label || "Field";
			numFieldListGap = configXML.layout.fieldsDropDownList.@gap || 10;
			numDdlFieldListWidth = configXML.layout.fieldsDropDownList.@width || 100;
			strFieldListPrompt = configXML.layout.fieldsDropDownList.@prompt || "-Please Select-";
			strFieldListLabelField = configXML.layout.fieldsDropDownList.@labelField || "alias";

			//Buttons layout
			numButtonPaddingLeft = configXML.layout.button.@shiftLeft || 84;
			numButtonGap = configXML.layout.button.@gap || 5;
			btnSearchLabel = configXML.layout.button.submitButtonLabel.@label || "Search";
			btnClearLabel = configXML.layout.button.cancelButtonLabel.@label || "Reset";

			//Default query data
			defaultLayerUrl = configXML.defaultQuery.defaultLayer.@url || "";
			defaultLayerLabel = configXML.defaultQuery.defaultLayer.@label || "";
			var strDefaultField:String = configXML.defaultQuery.defaultField.@field || "";
			defaultField =  strDefaultField.split(",");
			defaultFieldType = new Field();
			defaultFieldType.type = configXML.defaultQuery.defaultField.@type || Field.TYPE_STRING;
			defaultFieldAlias = configXML.defaultQuery.defaultField.@alias || "";

			//Null value string
			nullValue = configXML.table.nullValue.@label || "N/A";

			//Refresh Time
			var strBooleanValue:String = configXML.autoRefresh.@enabled.toString() || "false";
			refreshEnabled = (strBooleanValue.toLowerCase() == "true");
			refreshTime = Number(configXML.autoRefresh.@seconds) || 60;

			//Pie Chart Header
			lblPieChartHeader = configXML.chart.pieChart.@header || "";
			lblPieChartHeader = StringUtil.trim(lblPieChartHeader);

			//Table Column list
			lblTableHeader = configXML.table.tableHeader.@header || "";
			lblTableHeader = StringUtil.trim(lblTableHeader);

			var strTableColumn:String = configXML.table.tableColumn.@field || "";
			tableColumn = strTableColumn.split(",");

			if(tableColumn.length > 0)
				tableColumn = removeWhiteSpace(tableColumn);

			//Color
			legendBackgroundColor = configXML.chart.legendBackground.@color || 0xb0b7b2;

			glowColor = configXML.glowColor.@color || 0x66F2B1;
			glowQuality = configXML.glowColor.@quality || 20;
			glowStrength = configXML.glowColor.@strength || 10;

			//Alerts
			alertDefaultQueryFailHeader = configXML.alerts.defaultQueryAlert.@header || "Alert";
			alertDefaultQueryFailMessage = configXML.alerts.defaultQueryAlert.@message || "";

			alertQueryFaultHeader = configXML.alerts.queryFaultAlert.@header || "Alert";
			alertQueryFaultMessage = configXML.alerts.queryFaultAlert.@message || "";

			alertNullDataHeader = configXML.alerts.noResultAlert.@header || "Alert";
			alertNullDataMessage = configXML.alerts.noResultAlert.@message || "";

			alertTableColumnMismatchHeader = configXML.alerts.tableColumnMismatch.@header || "Alert";
			alertTableColumnMismatchMessage = configXML.alerts.tableColumnMismatch.@message || "";

			//Preparing layers index
			strBooleanValue = configXML.layers.mapServerLayer.includeLayers.@includeAllLayers.toString() || "false";
			includeAllLayers = (strBooleanValue.toLowerCase() == "true")
			if(!includeAllLayers)
			{
				var strLayers:String = configXML.layers.mapServerLayer.includeLayers.@index || "";
				arrLayers = strLayers.split(",");
			}
			else
			{
				arrLayers = new Array();
			}

			if(arrLayers.length > 0)
			{
				arrLayers = removeWhiteSpace(arrLayers);
				arrLayers = checkNumber(arrLayers);
			}

			layerAttribute = configXML.layers.mapServerLayer.includeLayers.@layerAttribute || "";


			// Preparing fields index
			strBooleanValue = configXML.layers.mapServerLayer.includeFields.@includeAllFields.toString() || "false";
			includeAllFields = (strBooleanValue.toLowerCase() == "true");
			if(!includeAllFields)
			{
				var strFields:String = configXML.layers.mapServerLayer.includeFields.@index || "";
				arrFields = strFields.split(",");
			}
			else
			{
				arrFields = new Array();
			}

			if(arrFields.length > 0)
			{
				arrFields = removeWhiteSpace(arrFields);
				arrFields = checkNumber(arrFields);
			}

			fieldAttribute = configXML.layers.mapServerLayer.includeFields.@fieldAttribute || "fields";

			var strExcludeFields:String = configXML.layers.mapServerLayer.excludeFields.@fieldName.toString() || "";
			arrExcludeFields = strExcludeFields.split(",");
			if(arrExcludeFields.length > 0)
			{
				arrExcludeFields = removeWhiteSpace(arrExcludeFields);
			}
		}

		private function removeWhiteSpace(records:Array):Array
		{
			var arrRecord:Array = new Array();
			for(i = 0; i < records.length; i++)
			{
				var strLabel:String = StringUtil.trim(records[i].toString());
				if(strLabel != "")
				{
					arrRecord.push(strLabel);
				}
			}
			return arrRecord;
		}

		private function checkNumber(checkArray:Array):Array
		{
			var numArray:Array = new Array();
			for(i = 0; i < checkArray.length; i++)
			{
				if(Number(checkArray[i]).toString() != "NaN")
				{
					numArray.push(checkArray[i]);
				}

			}
			return numArray;
		}
	}
}