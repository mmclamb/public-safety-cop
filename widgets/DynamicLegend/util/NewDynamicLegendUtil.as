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
package widgets.DynamicLegend.util
{
	import com.esri.ags.layers.GraphicsLayer;

	import flash.xml.XMLDocument;

	import mx.collections.ArrayCollection;
	import mx.rpc.xml.SimpleXMLDecoder;

	[Bindable]
	public class NewDynamicLegendUtil
	{
		public var isQueryFault:Boolean=new Boolean();
		private var isReadyToQuery:Boolean=false;
		private static var _instance:NewDynamicLegendUtil;
		public var legendLayerData:ArrayCollection=new ArrayCollection();//used to store data about layer in legend query details

		public var excludeLayers:ArrayCollection = new ArrayCollection();
		public var numAlpha:Number;
		public var numColor:Number;
		public var strLegendLabel:String;
		public var strOptionLabel:String;
		public var strClearLabel:String;

		public var strOutField:String;
		public var arrOutField:Array = new Array();
		public var strEventField:String;
		public var classBreakRend:String;
		public var alertMsg:Object = new Object();
		public var titleBarImagePath:Object = new Object();

		public var fieldArr:Array = new Array();
		public var legendCollection:ArrayCollection = new ArrayCollection();
		public var arrColl:ArrayCollection = new ArrayCollection();
		public var legendIndex:int = 0;
		public var layerName:String = "";
		public var isWIdgetClosed:Boolean = false;

		public var graphicSelectionLayer:GraphicsLayer = new GraphicsLayer();
		public var graphicLayer:GraphicsLayer = new GraphicsLayer();

		public var selectedObject:Object = null;
		public var arrCollSelected:ArrayCollection = new ArrayCollection();
		public var isFault:Boolean=false;
		public var legendList:Number;
		public var outFieldCount:Number;

		public static function getNewInstance():NewDynamicLegendUtil
		{
			if(_instance == null)
			{
				_instance = new NewDynamicLegendUtil();
			}
			return _instance;
		}

		public function parseConfigFile(configXML:XML):void
		{
			excludeLayers = new ArrayCollection;
			numAlpha = configXML.selectionLayout.alpha.@number.toString() || 0.5;
			numColor = configXML.selectionLayout.color.@code.toString() || 0x00B840;
			strLegendLabel = configXML.optionLayout.legendTab.@label || "Select Layer";
			strOptionLabel = configXML.optionLayout.optionTab.@label || "Legend List";
			strClearLabel=configXML.optionLayout.clearSelectionTab.@label || "Clear";

			strOutField = configXML.outFields.@fields;
			arrOutField=strOutField.split(",");

			strEventField = configXML.uniqueRendrerFieldName.toString();
			classBreakRend = configXML.classBreakRendererFieldName.toString();
			var excludeList:XMLList = configXML..excludeLayer;
			for (var i:Number = 0; i < excludeList.length(); i++)
			{
				var name:String = excludeList[i].@mapservice;
				var ids:String = excludeList[i];
				var idsArray:Array = ids.split(",");
				if(idsArray[0] == "")
					idsArray = null;
				var excludes:Object ={name: name,ids: idsArray}
				excludeLayers.addItem(excludes);
			}

			var xmlAlert:XML = (configXML.alerts[0]);
			var xmlDoc:XMLDocument = new XMLDocument(xmlAlert.toString());
			var decoder:SimpleXMLDecoder = new SimpleXMLDecoder(true);
			var resultObj:Object = decoder.decodeXML(xmlDoc);
			alertMsg = resultObj.alerts;

			var xmlImagePath:XML = (configXML.titlebarimagepath[0]);
			var xmlImageDoc:XMLDocument = new XMLDocument(xmlImagePath.toString());
			var resultImageObj:Object = decoder.decodeXML(xmlImageDoc);
			titleBarImagePath = resultImageObj.titlebarimagepath;
			outFieldCount=Number(configXML.outFieldCount);
		}
	}
}