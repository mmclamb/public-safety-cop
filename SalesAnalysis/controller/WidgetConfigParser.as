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
package widgets.SalesAnalysis.controller
{
	import com.esri.stl.utils.ColorUtil;
	import com.esri.stl.utils.NumberUtil;
	import com.esri.stl.utils.StringUtils;

	import flash.events.EventDispatcher;

	import mx.core.FlexGlobals;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleManager2;

	import widgets.SalesAnalysis.event.ConfigurationEvent;
	import widgets.SalesAnalysis.model.ConfigModel;



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
			parseMapConfiguration();
			parseServiceConfiguration();
			parseFieldsConfiguration();
			parseQueryConfiguration();
			parseSearchViewConfiguration();
			parseResultsViewConfiguration();
			parseResultsConfiguration();
			parseChartConfiguration();
			parseHelpConfiguration();
			parseCSSConfiguration();

			_dispatcher.dispatchEvent(new ConfigurationEvent(ConfigurationEvent.PARSE_COMPLETE));
		}

		private function parseMapConfiguration():void
		{
			_configModel.mapDrawToolType = _configXML.map.mapselectiontool || "polygon";
			if (Number(_configXML.map.zoomscale) > 0)
				_configModel.mapZoomScale = Number(_configXML.map.zoomscale);
			else
				_configModel.mapZoomScale = 10000;
		}
		private function parseServiceConfiguration():void
		{
			_configModel.serviceUrl = _configXML.service.url || "http://stlouis.esri.com/ArcGIS/rest/services/LocalGovernmentTemplates/AssessmentOperationsv10/MapServer/0";
			_configModel.serviceToken = _configXML.service.token || "";
			_configModel.serviceProxyURL = _configXML.service.proxyurl || "";
			_configModel.serviceUseAMF = StringUtils.stringToBoolean(_configXML.service.useamf) || false;

		}
		private function parseFieldsConfiguration():void
		{
			if(_configXML.fields.tablefields[0])
				_configModel.fieldsTableFieldsXML = _configXML.fields.tablefields[0];
			if(_configXML.fields.tooltipfields[0])
				_configModel.fieldsToolTipFieldsXML = _configXML.fields.tooltipfields[0];
			if(_configXML.fields.exportfields[0])
				_configModel.fieldsExportFieldsXML = _configXML.fields.exportfields[0];
			if(_configXML.fields.chartfields[0])
				_configModel.fieldsChartFieldsXML = _configXML.fields.chartfields[0];

		}
		private function parseQueryConfiguration():void
		{
			//validation
			_configModel.searchCurrencyMinValue = _configXML.view.search.currencyMinValue || "0";
			_configModel.searchCurrencyMaxValue = _configXML.view.search.currencyMaxValue || "200000";
			_configModel.searchYearMinValue = _configXML.view.search.yearMinValue || "2000";
			_configModel.searchYearMaxValue = _configXML.view.search.yearMaxValue || "2020";
			_configModel.searchAreaMinValue = _configXML.view.search.areaMinValue || "1000";
			_configModel.searchAreaMaxValue = _configXML.view.search.areaMaxValue || "6000";
			//query
			_configModel.queryDefaultQuery = _configXML.defaultquery || "1=1";
			var allOutFieldsString:String = _configXML.query.alloutfields;
			var allOutFieldsArr:Array = [];
			if(allOutFieldsString)
				allOutFieldsArr = allOutFieldsString.split(",");
			if(allOutFieldsArr.length > 0)
				_configModel.queryAllOutFieldsArr = allOutFieldsArr;
			else
				_configModel.queryAllOutFieldsArr = ['*'];
			//query for combobox population
			var cboOutFieldsString:String = _configXML.query.comboboxoutfields;
			var cboOutFieldsArr:Array = [];
			if(cboOutFieldsString)
				cboOutFieldsArr = cboOutFieldsString.split(",");
			if(cboOutFieldsArr.length > 0)
				_configModel.queryComboBoxesOutFieldsArr = cboOutFieldsArr;
			else
				_configModel.queryComboBoxesOutFieldsArr = ['*'];

			_configModel.querySaleAmountFieldName = _configXML.query.saleamountfieldname;
			_configModel.querySaleDateFieldName = _configXML.query.saledatefieldname;
			_configModel.queryAssessedValueFieldName = _configXML.query.assessedvaluefieldname;
			_configModel.queryStructureTypeFieldName = _configXML.query.structuretypefieldname;
			_configModel.queryYearBuiltFieldName = _configXML.query.yearbuiltfieldname;
			_configModel.queryFloorAreaFieldName = _configXML.query.floorareafieldname;
			_configModel.queryNeighborhoodFieldName = _configXML.query.neighborhoodfieldname;

		}

		private function parseResultsConfiguration():void
		{
			_configModel.resultsExportFileName = _configXML.results.exportfilename || "SalesAnalysisResults.csv";
			_configModel.resultsTableDateFieldFormat = _configXML.results.datefieldformat || "MM/DD/YY";
			_configModel.resultsSortField = _configXML.results.sortfield || "SALESRATIO";
		}
		private function parseChartConfiguration():void
		{

			_configModel.chartPlotSeriesXFieldName = _configXML.chart.plotSeriesXFieldName;//"CNTASSDVAL"
			_configModel.chartPlotSeriesYFieldName = _configXML.chart.plotSeriesYFieldName;//"SALESRATIO"
			_configModel.chartAxisFontColor = ColorUtil.convertHexStringToHexColor(_configXML.chart.axisFontColor);//0xFFFFFF
			_configModel.chartAxisStrokeColor = ColorUtil.convertHexStringToHexColor(_configXML.chart.axisStrokeColor);//0xBBCCDD
			_configModel.chartAxisFontSize = parseInt(_configXML.chart.axisFontSize);//12;
			_configModel.chartGridStrokeColor = ColorUtil.convertHexStringToHexColor(_configXML.chart.gridStrokeColor);//0xEEEEEE
			_configModel.chartMedianLineColor = ColorUtil.convertHexStringToHexColor(_configXML.chart.medianLineColor);//0x5197EC
			_configModel.chartMedianLineThickness = parseInt(_configXML.chart.medianLineThickness);//6
			_configModel.chartAboveMedianColor = ColorUtil.convertHexStringToHexColor(_configXML.chart.aboveMedianColor);//0x5FA351;//77C463,008000
			_configModel.chartBelowMedianColor = ColorUtil.convertHexStringToHexColor(_configXML.chart.belowMedianColor);//0xBF3F0A;//BB1F16,B42F0B
			_configModel.chartYAxisTitle = _configXML.chart.yAxisTitle;//"Sales Ratio";
			_configModel.chartYAxisShapeLabel = _configXML.chart.yAxisShapeLabel;//"Sales Ratio: ";
			_configModel.chartXAxisTitle = _configXML.chart.xAxisTitle;//"Assessed Value";
			_configModel.chartXAxisShapeLabel = _configXML.chart.xAxisShapeLabel;//"Assessed Value: ";
		}
		private function parseHelpConfiguration():void
		{
			_configModel.helpIcon = _configXML.help.helpicon || "i_help.png";
			_configModel.helpText = _configXML.help.helptext || "Insert help text here, check your config file(configuration.help.helptext).";
		}
		private function parseSearchViewConfiguration():void
		{

			_configModel.searchClearButtonLabel = _configXML.view.search.clearButtonLabel || "Clear";
			_configModel.searchClearButtonToolTip = _configXML.view.search.clearButtonToolTip || "Clear Tooltip";
			_configModel.searchMapToggleOnLabel = _configXML.view.search.mapToggleOnLabel || "On label";
			_configModel.searchMapToggleOnToolTip = _configXML.view.search.mapToggleOnToolTip || "On Tooltip";
			_configModel.searchMapToggleOffLabel = _configXML.view.search.mapToggleOffLabel || "Off label";
			_configModel.searchMapToggleOffToolTip = _configXML.view.search.mapToggleOffToolTip || "Off Tooltip";
			_configModel.searchSearchButtonLabel = _configXML.view.search.searchButtonLabel || "Search"
			_configModel.searchSearchButtonToolTip = _configXML.view.search.searchButtonToolTip || "Search Tooltip";
		}
		private function parseResultsViewConfiguration():void
		{

			//buttons
			_configModel.resultsBackButtonLabel = _configXML.view.results.backButtonLabel || "Back";
			_configModel.resultsBackButtonToolTip = _configXML.view.results.backButtonToolTip || "Back ToolTip";
			_configModel.resultsChartButtonLabel = _configXML.view.results.chartButtonLabel || "Chart";
			_configModel.resultsChartButtonToolTip = _configXML.view.results.chartButtonToolTip || "Chart ToolTip";
			_configModel.resultsExportButtonLabel = _configXML.view.results.exportButtonLabel || "Export";
			_configModel.resultsExportButtonToolTip = _configXML.view.results.exportButtonToolTip || "Export Tooltip";
		}
		private function parseCSSConfiguration():void
		{
			//load
			var previousColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.buttons.previousColor) || 0xBB1F16;
			var nextColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.buttons.nextColor) || 0xBB1F16;
			var goColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.buttons.goColor) || 0xBB1F16;
			var fontColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.buttons.fontColor) || 0xBB1F16;


			var tableSelectedColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.results.tableSelectedColor) || 0xFFFFFF;
			var tableSelectedTextColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.results.tableSelectedTextColor) || 0x333333;
			var tableRollOverColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.results.tableRollOverColor) || 0xFFD700;
			var tableRollOverTextColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.results.tableRollOverTextColor) || 0x333333;

			var graphicSelectedColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.map.graphicSelectedColor) || 0xFFFFFF;
			var graphicSelectedBorderColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.map.graphicSelectedBorderColor) || 0x333333;
			var graphicResultColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.map.graphicResultColor) || 0xFFD700;
			var graphicResultBorderColor:uint = ColorUtil.convertHexStringToHexColor(_configXML.view.map.graphicResultBorderColor) || 0x333333;
			//set
			//buttons and tooltips
			cssStyleDeclarationGlobal.setStyle("btnPreviousColor", previousColor);
			cssStyleDeclarationGlobal.setStyle("btnNextColor", nextColor);
			cssStyleDeclarationGlobal.setStyle("btnGoColor", goColor);
			cssStyleDeclarationGlobal.setStyle("btnFontColor", fontColor);
			//results view table
			cssStyleDeclarationGlobal.setStyle("tableSelectedColor", tableSelectedColor);
			cssStyleDeclarationGlobal.setStyle("tableSelectedTextColor", tableSelectedTextColor);
			cssStyleDeclarationGlobal.setStyle("tableRollOverColor", tableRollOverColor);
			cssStyleDeclarationGlobal.setStyle("tableRollOverTextColor", tableRollOverTextColor);
			//map graphics colors
			cssStyleDeclarationGlobal.setStyle("graphicSelectedColor", graphicSelectedColor);
			cssStyleDeclarationGlobal.setStyle("graphicSelectedBorderColor", graphicSelectedBorderColor);
			cssStyleDeclarationGlobal.setStyle("graphicResultColor", graphicResultColor);
			cssStyleDeclarationGlobal.setStyle("graphicResultBorderColor", graphicResultBorderColor);
			//update style manager
			topLevelStyleManager.setStyleDeclaration("global", cssStyleDeclarationGlobal, true);
		}
	}
}