////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2008-2011 Esri
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  See use restrictions in the file:
// License.txt and/or use_restrictions.txt.
//
////////////////////////////////////////////////////////////////////////////////
package widgets.TrackingPlayback.controller
{
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.stl.utils.ColorUtil;
	import com.esri.stl.utils.NumberUtil;
	import com.esri.stl.utils.StringUtils;
	
	import flash.events.EventDispatcher;
	
	import mx.core.FlexGlobals;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleManager2;
	
	import widgets.TrackingPlayback.event.ConfigurationEvent;
	import widgets.TrackingPlayback.model.ConfigModel;
	
	public class WidgetConfigParser extends EventDispatcher
	{
		private var _dispatcher:EventDispatcher;
		private var _configModel:ConfigModel;
		private var _configXML:XML;
		private var topLevelStyleManager:IStyleManager2 = FlexGlobals.topLevelApplication.styleManager;
		private var cssStyleDeclarationGlobal:CSSStyleDeclaration = topLevelStyleManager.getStyleDeclaration("global");
		
		public function WidgetConfigParser(dispatcher:EventDispatcher)
		{
			_dispatcher = dispatcher;
			_configModel = ConfigModel.getInstance();
			
		}
		
		public function parseConfiguration(config:XML):void
		{
			_configXML = config;
			_dispatcher.dispatchEvent(new ConfigurationEvent(ConfigurationEvent.PARSE_BEGIN));
			
			//parse config files
			parseServiceConfiguration();
			parseFieldsConfiguration();
			parseTrackingConfiguration();
			parsePlaybackViewConfiguration();
			parseQueryConfiguration();
			parseHelpConfiguration();
			parseCSSConfiguration();
			
			_dispatcher.dispatchEvent(new ConfigurationEvent(ConfigurationEvent.PARSE_COMPLETE));
		}
		
		private function parseServiceConfiguration():void
		{
			//layer
			_configModel.serviceTrackingLayerUrl = _configXML.service.trackingLayerHistory.url || "http://yourserver/ArcGIS/rest/services/Folder/Service/MapServer/0";
			_configModel.serviceTrackingLayerToken = _configXML.service.trackingLayerHistory.token || "";
			_configModel.serviceTrackingLayerProxyURL = _configXML.service.trackingLayerHistory.proxyurl || "";
			_configModel.serviceTrackingLayerUseAMF = StringUtils.stringToBoolean(_configXML.service.trackingLayerHistory.useamf) || false;
			
			_configModel.layerTrackingLayerTrackIDField = _configXML.service.trackingLayerHistory.trackIdField;
			
			//table
			_configModel.serviceTrackingTableUrl = _configXML.service.trackingTableAssets.url || "http://yourserver/ArcGIS/rest/services/Folder/Service/MapServer/0";
			_configModel.serviceTrackingTableToken = _configXML.service.trackingTableAssets.token || "";
			_configModel.serviceTrackingTableProxyURL = _configXML.service.trackingTableAssets.proxyurl || "";
			_configModel.serviceTrackingTableUseAMF = StringUtils.stringToBoolean(_configXML.service.trackingTableAssets.useamf) || false;

		}
		private function parseFieldsConfiguration():void
		{
			if(_configXML.view.playback.tableFields.fields[0])
				_configModel.fieldsTrackingTableFieldsXML = _configXML.view.playback.tableFields.fields[0];
		}
		private function parseQueryConfiguration():void
		{

			//query info for layer
			_configModel.queryTrackingLayerDefaultQuery = _configXML.service.trackingLayerHistory.defaultQuery || "1=1";
			
				
			var layerOutFieldsString:String = _configXML.service.trackingLayerHistory.trackOutFields;
			var layerOutFieldsArr:Array = [];
			if(layerOutFieldsString)
				layerOutFieldsArr = layerOutFieldsString.split(",");
			if(layerOutFieldsArr.length > 0)
				_configModel.queryTrackingLayerOutFieldsArr = layerOutFieldsArr;
			else
				_configModel.queryTrackingLayerOutFieldsArr = ['*'];
		
				
			//query info for table
			_configModel.queryTrackingTableDefaultQuery = _configXML.service.trackingTableAssets.defaultQuery || "1=1";

			var tableOutFieldsString:String = _configXML.service.trackingTableAssets.trackOutFields;
			var tableOutFieldsArr:Array = [];
			if(tableOutFieldsString)
				tableOutFieldsArr = tableOutFieldsString.split(",");
			if(tableOutFieldsArr.length > 0)
				_configModel.queryTrackingTableOutFieldsArr = tableOutFieldsArr;
			else
				_configModel.queryTrackingLayerOutFieldsArr = ['*'];
		}
		private function parseTrackingConfiguration():void
		{
			_configModel.layerTrackingLayerTrackIDField = _configXML.service.trackingLayerHistory.trackIdField;
			_configModel.layerTrackingLayerSymbolDirectionAttribute = _configXML.service.trackingLayerHistory.trackingSymbolDirectionAttribute;
			_configModel.layerTrackingLayerLabelSymbolLabelAttribute = _configXML.service.trackingLayerHistory.trackingLabelSymbolLabelAttribute;

			_configModel.layerTrackingLayerForeignKey = _configXML.service.trackingLayerHistory.foreignKey || "VEHICLE_LABEL";
			_configModel.tableTrackingTablePrimaryKey = _configXML.service.trackingTableAssets.primaryKey || "eqno";
			
			_configModel.symbolTimeRampSymbolAgerFromAlpha = Number(_configXML.view.symbol.trackingTimeRampSymbolAgerFromAlpha) || 0.5;
			_configModel.symbolTimeRampSymbolAgerToAlpha = Number(_configXML.view.symbol.trackingTimeRampSymbolAgerToAlpha) || 0.8;
			_configModel.symbolTimeRampSymbolAgerFromColor = ColorUtil.convertHexStringToHexColor(_configXML.view.symbol.trackingTimeRampSymbolAgerFromColor) || 0xFFC900;
			_configModel.symbolTimeRampSymbolAgerToColor = ColorUtil.convertHexStringToHexColor(_configXML.view.symbol.trackingTimeRampSymbolAgerToColor) || 0xFFC900;
			
			_configModel.symbolObservationSMSAlpha = Number(_configXML.view.symbol.trackingObservationSMSAlpha) || 1.0;
			_configModel.symbolObservationSMSOutlineWidth = Number(_configXML.view.symbol.trackingObservationSMSOutlineWidth) || 1.2;
			_configModel.symbolObservationSMSSize = Number(_configXML.view.symbol.trackingObservationSMSSize) || 13;
			_configModel.symbolObservationSMSStyle = _configXML.view.symbol.trackingObservationSMSStyle || SimpleMarkerSymbol.STYLE_CIRCLE;
					
		}
		
		private function parsePlaybackViewConfiguration():void
		{
			_configModel.playbackViewDefaultStartDateTime = _configXML.view.playback.defaultStartDateTime; 
			_configModel.playbackViewDefaultEndDateTime = _configXML.view.playback.defaultEndDateTime;
			
			_configModel.playbackViewStartDateTime = new Date();
			_configModel.playbackViewEndDateTime = new Date();
			_configModel.playbackViewStartDateTime.setTime(Date.parse(_configXML.view.playback.defaultStartDateTime));//"01/25/2011 10:00:0 GMT-0600"
			_configModel.playbackViewEndDateTime.setTime(Date.parse(_configXML.view.playback.defaultEndDateTime));//"01/25/2011 14:00:0 GMT-0600"
		}
		
		private function parseHelpConfiguration():void
		{
			_configModel.helpIcon = _configXML.help.helpicon || "i_help.png";
			_configModel.helpText = _configXML.help.helptext || "Insert help text here, check your config file(configuration.help.helptext).";
		}
		
		private function parseCSSConfiguration():void
		{
			//load
			var previousColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.help.previousColor) || 0xBB1F16;
	
			//view.playback
			var tableSelectedColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.playback.tableSelectedColor) || 0xFFFFFF;
			var tableSelectedTextColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.playback.tableSelectedTextColor) || 0x333333;
			var tableRollOverColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.playback.tableRollOverColor) || 0xFFD700;
			var tableRollOverTextColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.playback.tableRollOverTextColor) || 0x333333;

			var selectionButtonColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.playback.selectionButtonColor) || 0x4C90F3;
			var startButtonColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.playback.startColor) || 0x54B254;
			var endButtonColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.playback.stopColor) || 0xD40000;
			
			//view.symbol
			var symbolLabelTextColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.symbol.trackingLabelSymbolLabelTextColor) || 0x000000;
			var symbolLabelTextBackgroundColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.symbol.trackingLabelSymbolLabelTextBackgroundColor) || 0xF3D831;
			var symbolLabelTextBackgroundBorderColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.symbol.trackingLabelSymbolLabelTextBackgroundBorderColor) || 0x797062;
			
			var symbolObservationSMSColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.symbol.trackingObservationSMSColor) || 0xFFC900;
			var symbolObservationSMSOutlineColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.symbol.trackingObservationSMSOutlineColor) || 0x765516;
			
			
			//set
			cssStyleDeclarationGlobal.setStyle("btnPreviousColor", previousColor);

			//view table
			cssStyleDeclarationGlobal.setStyle("tableSelectedColor", tableSelectedColor);
			cssStyleDeclarationGlobal.setStyle("tableSelectedTextColor", tableSelectedTextColor);
			cssStyleDeclarationGlobal.setStyle("tableRollOverColor", tableRollOverColor);
			cssStyleDeclarationGlobal.setStyle("tableRollOverTextColor", tableRollOverTextColor);
			
			cssStyleDeclarationGlobal.setStyle("buttonSelectAllNoneColor", selectionButtonColor);
			cssStyleDeclarationGlobal.setStyle("playbackViewStartColor", startButtonColor);
			cssStyleDeclarationGlobal.setStyle("playbackViewStopColor", endButtonColor);
			//symbol
			cssStyleDeclarationGlobal.setStyle("trackingLabelSymbolLabelTextColor", symbolLabelTextColor);
			cssStyleDeclarationGlobal.setStyle("trackingLabelSymbolLabelTextBackgroundColor", symbolLabelTextBackgroundColor);
			cssStyleDeclarationGlobal.setStyle("trackingLabelSymbolLabelTextBackgroundBorderColor", symbolLabelTextBackgroundBorderColor);
			
			cssStyleDeclarationGlobal.setStyle("trackingObservationSMSColor", symbolObservationSMSColor);
			cssStyleDeclarationGlobal.setStyle("trackingObservationSMSOutlineColor", symbolObservationSMSOutlineColor);
			
			//update style manager
			topLevelStyleManager.setStyleDeclaration("global", cssStyleDeclarationGlobal, true);
		}
	}
}