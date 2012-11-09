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
package widgets.SalesAnalysis.model
{
	import com.esri.ags.SpatialReference;
	import com.esri.ags.TimeExtent;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.layers.supportClasses.LayerDetails;
	import com.esri.stl.ags.utils.FieldsConfigUtil;

	import mx.collections.ArrayCollection;

	public class ConfigModel
	{
		public var helpIcon:String;
		public var helpText:String;

		//--------------------------------------------------------------------------
		// Fields configuration
		//--------------------------------------------------------------------------
		public var fieldsToolTipFieldsXML:XML;
		public var fieldsTableFieldsXML:XML;
		public var fieldsExportFieldsXML:XML;
		public var fieldsChartFieldsXML:XML;

		public var fieldsToolTipFieldsUtil:FieldsConfigUtil = new FieldsConfigUtil();
		public var fieldsTableFieldsUtil:FieldsConfigUtil = new FieldsConfigUtil();
		public var fieldsExportFieldsUtil:FieldsConfigUtil = new FieldsConfigUtil();
		public var fieldsChartFieldsUtil:FieldsConfigUtil = new FieldsConfigUtil();

		//--------------------------------------------------------------------------
		// Service configuration
		//--------------------------------------------------------------------------
		public var serviceUrl:String;
		public var serviceUseAMF:Boolean;
		public var serviceToken:String;
		public var serviceProxyURL:String;

		public var queryDefaultQuery:String;
		public var queryAllOutFieldsArr:Array;
		public var queryComboBoxesOutFieldsArr:Array;

		public var querySaleAmountFieldName:String;
		public var querySaleDateFieldName:String;
		public var queryAssessedValueFieldName:String;
		public var queryStructureTypeFieldName:String;
		public var queryYearBuiltFieldName:String;
		public var queryFloorAreaFieldName:String;
		public var queryNeighborhoodFieldName:String;

		public var mapDrawToolType:String;
		public var mapZoomScale:Number;
		public var mapSpatialReference:SpatialReference;

		public var layerDetails:LayerDetails;
		public var layerTimeExtent:TimeExtent;
		public var layerExtent:Extent;

		//--------------------------------------------------------------------------
		// Search View configuration
		//--------------------------------------------------------------------------
		public var searchCurrencyMinValue:String;
		public var searchCurrencyMaxValue:String;
		public var searchYearMinValue:String;
		public var searchYearMaxValue:String;
		public var searchAreaMinValue:String;
		public var searchAreaMaxValue:String

		public var searchClearButtonLabel:String;
		public var searchClearButtonToolTip:String;
		public var searchMapToggleOnLabel:String;
		public var searchMapToggleOnToolTip:String;
		public var searchMapToggleOffLabel:String;
		public var searchMapToggleOffToolTip:String;
		public var searchSearchButtonLabel:String;
		public var searchSearchButtonToolTip:String;

		//--------------------------------------------------------------------------
		// Results View configuration
		//--------------------------------------------------------------------------
		public var resultsExportFileName:String;
		public var resultsTableDateFieldFormat:String;
		public var resultsSortField:String;
		//buttons and tooltips
		public var resultsBackButtonLabel:String;
		public var resultsBackButtonToolTip:String;
		public var resultsChartButtonLabel:String;
		public var resultsChartButtonToolTip:String;
		public var resultsExportButtonLabel:String;
		public var resultsExportButtonToolTip:String;
		//--------------------------------------------------------------------------
		// Chart View configuration
		//--------------------------------------------------------------------------
		public var chartPlotSeriesXFieldName:String;
		public var chartPlotSeriesYFieldName:String;
		public var chartAxisFontColor:uint;
		public var chartAxisStrokeColor:uint;
		public var chartAxisFontSize:Number;
		public var chartGridStrokeColor:uint;
		public var chartMedianLineColor:uint;
		public var chartMedianLineThickness:Number;
		public var chartAboveMedianColor:uint;
		public var chartBelowMedianColor:uint;
		public var chartYAxisTitle:String;
		public var chartYAxisShapeLabel:String;
		public var chartXAxisTitle:String;
		public var chartXAxisShapeLabel:String;

		private static var instance:ConfigModel;

		public function ConfigModel()
		{
			if (instance)
			{
				throw new Error("Please call ConfigModel.getInstance() instead of new.");
			}
		}
		public static function getInstance():ConfigModel
		{
			if (!instance)
			{
				instance = new ConfigModel();
			}
			return instance;
		}
	}
}