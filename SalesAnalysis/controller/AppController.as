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

import com.esri.ags.Graphic;
import com.esri.ags.Map;
import com.esri.ags.events.DetailsEvent;
import com.esri.ags.events.QueryEvent;
import com.esri.ags.geometry.Extent;
import com.esri.ags.layers.supportClasses.TimeInfo;
import com.esri.ags.tasks.DetailsTask;
import com.esri.ags.tasks.QueryTask;
import com.esri.ags.tasks.supportClasses.Query;
import com.esri.ags.utils.GraphicUtil;
import com.esri.stl.ags.utils.ExcelUtil;
import com.esri.stl.ags.utils.SortUtil;
import com.esri.stl.events.FileOpenSaveEvent;
import com.esri.stl.utils.URLParamsUtil;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.rpc.events.FaultEvent;

import widgets.SalesAnalysis.event.ChartViewEvent;
import widgets.SalesAnalysis.enum.StateEnum;
import widgets.SalesAnalysis.event.ConfigurationEvent;
import widgets.SalesAnalysis.event.MapSelectionEvent;
import widgets.SalesAnalysis.event.ResultViewEvent;
import widgets.SalesAnalysis.event.SearchViewEvent;
import widgets.SalesAnalysis.event.ViewNavigationEvent;
import widgets.SalesAnalysis.model.AppModel;
import widgets.SalesAnalysis.model.ConfigModel;
import widgets.SalesAnalysis.model.SalesAnalysisModel;
import widgets.SalesAnalysis.presenter.ChartPresenter;
import widgets.SalesAnalysis.presenter.HelpPresenter;
import widgets.SalesAnalysis.presenter.LoadingPresenter;
import widgets.SalesAnalysis.presenter.MainPresenter;
import widgets.SalesAnalysis.presenter.ResultsPresenter;
import widgets.SalesAnalysis.presenter.SearchPresenter;
import widgets.SalesAnalysis.service.EsriServiceHolder;





public class AppController extends EventDispatcher
{
    private var _appModel:AppModel;
    private var _configModel:ConfigModel;
    private var _salesAnalysisModel:SalesAnalysisModel;
    private var _esriServiceHolder:EsriServiceHolder;
    private var _excelUtil:ExcelUtil;

    /**
     * Constructor
     */
    public function AppController()
    {
        _appModel = AppModel.getInstance();
        _configModel = ConfigModel.getInstance();
        _salesAnalysisModel = SalesAnalysisModel.getInstance();
        buildPresentationModels();
        buildEsriService();
        addListeners();
        _appModel.widgetConfigParser = new WidgetConfigParser(this);

    }

    private function buildPresentationModels():void
    {
        _appModel.loadingPresenter = new LoadingPresenter(this);
        _appModel.helpPresenter = new HelpPresenter(this);
        _appModel.mainPresenter = new MainPresenter(this);
        _appModel.searchPresenter = new SearchPresenter(this);
        _appModel.resultsPresenter = new ResultsPresenter(this);
        _appModel.chartPresenter = new ChartPresenter(this);
    }

    private function initializePresentationModelConfigurations():void
    {
        _appModel.helpPresenter.initalizeConfiguration();
        _appModel.mainPresenter.initializeConfiguration();
        _appModel.searchPresenter.initializeConfiguration();
        _appModel.resultsPresenter.initializeConfiguration();
        _appModel.chartPresenter.initializeConfiguration();
    }

    private function buildEsriService():void
    {
        _esriServiceHolder = new EsriServiceHolder();
        //<!-- DetailsTask for getting service information from the ArcGIS Server service -->
        _esriServiceHolder.serviceDetailsTask.addEventListener(DetailsEvent.GET_DETAILS_COMPLETE, getServiceDetailsCompleteHandler, false, 0, true);
        _esriServiceHolder.serviceDetailsTask.addEventListener(FaultEvent.FAULT, esriServiceFaultHandler, false, 0, true);
        //<!-- QueryTask for populating Structure Type and Neighborhood drop down lists -->
        _esriServiceHolder.serviceViewQueryTask.addEventListener(QueryEvent.EXECUTE_COMPLETE, executeViewQueryForComboBoxCompleteHandler, false, 0, true);
        _esriServiceHolder.serviceViewQueryTask.addEventListener(FaultEvent.FAULT, esriServiceFaultHandler, false, 0, true);
        //<!-- QueryTask for getting spatial and attribute queries from the sales analysis service -->
        _esriServiceHolder.serviceQueryTask.addEventListener(QueryEvent.EXECUTE_COMPLETE, executeSalesQueryCompleteHandler, false, 0, true);
        _esriServiceHolder.serviceQueryTask.addEventListener(FaultEvent.FAULT, esriServiceFaultHandler, false, 0, true);
    }

    private function addListeners():void
    {
        addEventListener(ConfigurationEvent.PARSE_BEGIN, configEventBeginHandler, false, 0, true);
        addEventListener(ConfigurationEvent.PARSE_COMPLETE, configEventCompleteHandler, false, 0, true);
        addEventListener(ConfigurationEvent.LOADING_SERVICE_INFO, configEventLoadingServiceInfoHandler, false, 0, true);


        addEventListener(ViewNavigationEvent.GO_HELP_EVENT, goHelpHandler, false, 0, true);
        addEventListener(ViewNavigationEvent.GO_SEARCH_EVENT, goSearchHandler, false, 0, true);
        addEventListener(ViewNavigationEvent.GO_RESULTS_EVENT, goResultsHandler, false, 0, true);
        addEventListener(ViewNavigationEvent.GO_BACK_EVENT, goBackHandler, false, 0, true);

        addEventListener(SearchViewEvent.EXECUTE_SEARCH, searchViewExecuteSearchCompleteHandler, false, 0, true);
        addEventListener(SearchViewEvent.CHANGE_MAP_SELECTION, changeMapSelectionHandler, false, 0, true);

        addEventListener(MapSelectionEvent.DRAW_EVENT_COMPLETE, mapSelectionCompleteHandler, false, 0, true);
        addEventListener(MapSelectionEvent.SELECTED_GRAPHIC_EVENT, mapMouseOverGraphicHandler, false, 0, true);

        addEventListener(ResultViewEvent.RESULT_ITEM_SELECTED, resultViewResultItemSelectedHandler, false, 0, true);
        addEventListener(ResultViewEvent.CLEAR_SEARCH_RESULTS, resultViewClearSearchResultsHandler, false, 0, true);
        addEventListener(ResultViewEvent.SHOW_SALES_CHART, resultsViewShowSalesChartHandler, false, 0, true);
        addEventListener(ResultViewEvent.EXPORT_RESULTS_TO_EXCEL, resultsViewExportResultsToExcelHandler, false, 0, true);

        addEventListener(ChartViewEvent.CHART_ITEM_SELECTED, chartViewItemSelectedHandler, false, 0, true);
    }

    public function initConfig(map:Map, config:XML):void
    {
        _appModel.mainPresenter.map = map;
        ConfigurationEvent.STEPS = 0;
        _appModel.widgetConfigParser.parseConfiguration(config);
        _appModel.loadingPresenter.message = "Loading configuration...";
    }

    //--------------------------------------------------------------------------
    //
    // Widget State Event Handlers
    //
    //--------------------------------------------------------------------------
    public function minimized(event:Event):void
    {
        _appModel.mainPresenter.minimizedHandler();
    }

    public function closed(event:Event):void
    {
        _appModel.mainPresenter.closedHandler();
    }

    public function open(event:Event):void
    {
        _appModel.mainPresenter.openedHandler();
    }

    //--------------------------------------------------------------------------
    //
    // Configuration Event Handlers
    //
    //--------------------------------------------------------------------------
    protected function configEventBeginHandler(event:ConfigurationEvent):void
    {
        _appModel.loadingPresenter.message = "Reading configuration...";
    }

    protected function configEventCompleteHandler(event:ConfigurationEvent):void
    {
        initializePresentationModelConfigurations();
        _appModel.loadingPresenter.message = "Loading service info...";
        var url:String = _configModel.serviceUrl;
        var proxy:String = _configModel.serviceProxyURL;
        var token:String = _configModel.serviceToken;
        var useAMF:Boolean = _configModel.serviceUseAMF;
        var urlParts:Array = URLParamsUtil.getBaseURLWithID(url);
        if (urlParts.length == 2)
        {
            _esriServiceHolder.serviceDetailsTask.url = urlParts[0];
            _esriServiceHolder.serviceDetailsTask.proxyURL = proxy;
            _esriServiceHolder.serviceDetailsTask.token = token;

            _esriServiceHolder.serviceDetailsTask.getDetails(urlParts[1]);
        }

        _esriServiceHolder.serviceViewQueryTask.url = url;
        _esriServiceHolder.serviceViewQueryTask.proxyURL = proxy;
        _esriServiceHolder.serviceViewQueryTask.token = token;
        _esriServiceHolder.serviceViewQueryTask.useAMF = useAMF;
        //Query for creating unique,sorted comboboxes for Structure Type and Neighborhood
        var query:Query = new Query();
        query.where = "1=1";
        query.outFields = _configModel.queryComboBoxesOutFieldsArr;
        _esriServiceHolder.serviceViewQueryTask.execute(query);

        _esriServiceHolder.serviceQueryTask.url = url;
        _esriServiceHolder.serviceQueryTask.proxyURL = proxy;
        _esriServiceHolder.serviceQueryTask.useAMF = useAMF;
        _esriServiceHolder.serviceQueryTask.token = token;
    }

    protected function configEventLoadingServiceInfoHandler(event:ConfigurationEvent):void
    {
        ConfigurationEvent.STEPS++;
        if (ConfigurationEvent.STEPS == 2)
        {
            if (_appModel.mainPresenter.currentState != StateEnum.SEARCH_STATE)
            {
                _appModel.mainPresenter.currentState = StateEnum.SEARCH_STATE;
            }
        }

    }

    //--------------------------------------------------------------------------
    //
    // Search View Event Handlers
    //
    //--------------------------------------------------------------------------
    protected function changeMapSelectionHandler(event:SearchViewEvent):void
    {
        _appModel.mainPresenter.changeMapSelectionHandler(event);
    }

    protected function mapSelectionCompleteHandler(event:MapSelectionEvent):void
    {
        _appModel.searchPresenter.executeSearch(event.graphic);
    }

    protected function mapMouseOverGraphicHandler(event:MapSelectionEvent):void
    {
        _appModel.resultsPresenter.selectedItem = event.graphic;
    }

    protected function searchViewExecuteSearchCompleteHandler(event:SearchViewEvent):void
    {
        var query:Query = event.searchCriteria;
        _esriServiceHolder.serviceQueryTask.execute(query);
    }

    //--------------------------------------------------------------------------
    //
    // Results View Event Handlers
    //
    //--------------------------------------------------------------------------
    protected function resultViewResultItemSelectedHandler(event:ResultViewEvent):void
    {
        _appModel.mainPresenter.zoomToGraphic(event.graphic);
    }

    protected function resultViewClearSearchResultsHandler(event:ResultViewEvent):void
    {
        _salesAnalysisModel.resultsGraphicData = null;
        _salesAnalysisModel.chartGraphicData = null;
        _appModel.mainPresenter.clearGraphicsLayers();
        _appModel.mainPresenter.currentState = StateEnum.SEARCH_STATE;
        if (_appModel.mainPresenter.drawToolEnabled)
        {
            _appModel.mainPresenter.toggleDrawTool(true);
        }
    }

    protected function resultsViewShowSalesChartHandler(event:ResultViewEvent):void
    {
        _appModel.chartPresenter.dataProvider = _salesAnalysisModel.chartGraphicData;
        _appModel.mainPresenter.currentState = StateEnum.CHART_STATE;
    }

    protected function resultsViewExportResultsToExcelHandler(event:ResultViewEvent):void
    {
        var _resultsArray:Array = _salesAnalysisModel.resultsGraphicData.source;
        if (_resultsArray)
        {
            _excelUtil = new ExcelUtil();
            _excelUtil.addEventListener(FileOpenSaveEvent.FILESAVE_COMPLETE, excelUtilSaveCompleteHandler, false, 0, true);
            _excelUtil.addEventListener(FileOpenSaveEvent.FILESAVE_CANCEL, excelUtilCancelCompleteHandler, false, 0, true);
            var exportFieldsOrderArr:Array = _configModel.fieldsExportFieldsUtil.fieldsOrder;
            var exportFieldsDictionary:Dictionary = _configModel.fieldsExportFieldsUtil.fieldsDictionary;
            if (exportFieldsOrderArr && exportFieldsDictionary)
            {
                var exportFieldColumns:Array = [];
                for (var i:int = 0; i < exportFieldsOrderArr.length; i++)
                {
                    exportFieldColumns.push(exportFieldsDictionary[exportFieldsOrderArr[i]]);
                }
                _excelUtil.saveGraphicsToFile(exportFieldColumns, _resultsArray, _configModel.resultsExportFileName);
                _appModel.resultsPresenter.currentState = ResultsPresenter.MAIN_WITH_MESSAGE_STATE;
                _appModel.resultsPresenter.showMessage("Saving your file...");
            }
        }
    }

    protected function excelUtilSaveCompleteHandler(event:FileOpenSaveEvent):void
    {
        _appModel.resultsPresenter.clearMessage();
        _appModel.resultsPresenter.currentState = ResultsPresenter.MAIN_STATE;
    }

    protected function excelUtilCancelCompleteHandler(event:FileOpenSaveEvent):void
    {
        _appModel.resultsPresenter.clearMessage();
        _appModel.resultsPresenter.currentState = ResultsPresenter.MAIN_STATE;
    }

    //--------------------------------------------------------------------------
    //
    // Chart View Event Handlers
    //
    //--------------------------------------------------------------------------
    protected function chartViewItemSelectedHandler(event:ChartViewEvent):void
    {
        _appModel.mainPresenter.zoomToGraphic(event.graphic);
        _appModel.resultsPresenter.selectedItem = event.graphic;
    }

    //--------------------------------------------------------------------------
    //
    // Navigation Event Handlers
    //
    //--------------------------------------------------------------------------
    protected function goHelpHandler(event:ViewNavigationEvent):void
    {
        _appModel.mainPresenter.currentState = StateEnum.HELP_STATE;
    }

    protected function goBackHandler(event:ViewNavigationEvent):void
    {
        _appModel.mainPresenter.currentState = _appModel.mainPresenter.lastState;
    }

    protected function goSearchHandler(event:ViewNavigationEvent):void
    {
        _appModel.mainPresenter.currentState = StateEnum.SEARCH_STATE;
    }

    protected function goResultsHandler(event:ViewNavigationEvent):void
    {
        _appModel.mainPresenter.currentState = StateEnum.RESULTS_STATE;
    }

    //--------------------------------------------------------------------------
    //
    // Esri Service Event Handlers
    //
    //--------------------------------------------------------------------------
    protected function getServiceDetailsCompleteHandler(event:DetailsEvent):void
    {
        _appModel.loadingPresenter.message = "Finished loading service info...";
        _configModel.layerDetails = event.layerDetails;
        _configModel.layerExtent = event.layerDetails.extent;

        _appModel.mainPresenter.zoomToExtent(_configModel.layerExtent);

        var timeInfo:TimeInfo = event.layerDetails.timeInfo;
        _configModel.layerTimeExtent = timeInfo.timeExtent;

        _appModel.searchPresenter.startEndDateRange(_configModel.layerTimeExtent.startTime, _configModel.layerTimeExtent.endTime);

        _configModel.fieldsTableFieldsUtil.parseConfig(_configModel.fieldsTableFieldsXML, _configModel.layerDetails.fields);
        _configModel.fieldsExportFieldsUtil.parseConfig(_configModel.fieldsExportFieldsXML, _configModel.layerDetails.fields);
        _configModel.fieldsChartFieldsUtil.parseConfig(_configModel.fieldsChartFieldsXML, _configModel.layerDetails.fields);
        _configModel.fieldsToolTipFieldsUtil.parseConfig(_configModel.fieldsToolTipFieldsXML, _configModel.layerDetails.fields);

        dispatchEvent(new ConfigurationEvent(ConfigurationEvent.LOADING_SERVICE_INFO));

    }

    protected function executeViewQueryForComboBoxCompleteHandler(event:QueryEvent):void
    {
        var _structureTypeFieldName:String = _configModel.queryStructureTypeFieldName;
        var _neighborhoodFieldName:String = _configModel.queryNeighborhoodFieldName;

        var attributesAC:ArrayCollection = new ArrayCollection(event.featureSet.attributes);
        var resFilterAC:ArrayCollection;
        var neiFilterAC:ArrayCollection;

        resFilterAC = SortUtil.uniqueFilterAttributes(attributesAC, _structureTypeFieldName);
        neiFilterAC = SortUtil.uniqueFilterAttributes(attributesAC, _neighborhoodFieldName);

        var resSortedAC:ArrayCollection;
        var neiSortedAC:ArrayCollection;

        resSortedAC = SortUtil.sortAttributes(resFilterAC, _structureTypeFieldName);
        for (var i:int = 0; i < resSortedAC.length; i++)
        {
            if (resSortedAC[i][_structureTypeFieldName] != null && resSortedAC[i][_structureTypeFieldName] != "")
            {
                _appModel.searchPresenter.structureTypes.addItem({ data: resSortedAC[i][_structureTypeFieldName], label: resSortedAC[i][_structureTypeFieldName]});
            }
        }
        neiSortedAC = SortUtil.sortAttributes(neiFilterAC, _neighborhoodFieldName);
        for (var j:int = 0; j < neiSortedAC.length; j++)
        {
            if (neiSortedAC[j][_neighborhoodFieldName] != null && neiSortedAC[j][_neighborhoodFieldName] != "")
            {
                _appModel.searchPresenter.neighborhoods.addItem({ data: neiSortedAC[j][_neighborhoodFieldName], label: neiSortedAC[j][_neighborhoodFieldName]});
            }
        }

        dispatchEvent(new ConfigurationEvent(ConfigurationEvent.LOADING_SERVICE_INFO));
    } //end function

    protected function executeSalesQueryCompleteHandler(event:QueryEvent):void
    {
        var _resultsArray:Array = event.featureSet.features;
        var modifiedResults:ArrayCollection = new ArrayCollection();
        _appModel.searchPresenter.clearMessage();

        if (_resultsArray && _resultsArray.length > 0)
        {
            var gExtent:Extent = GraphicUtil.getGraphicsExtent(_resultsArray);
            if (gExtent && _resultsArray.length > 1)
            {
                _appModel.mainPresenter.zoomToExtent(gExtent);
            }

            for (var i:int = 0; i < _resultsArray.length; i++)
            {
                var rGraphic:Graphic = _resultsArray[i] as Graphic;
                rGraphic.attributes["CHECKBOX"] = true;
                modifiedResults.addItem(rGraphic);
            }

            var sortedResultsAC:ArrayCollection = SortUtil.sortFeatureSet(modifiedResults, _configModel.resultsSortField);

            //load results into Model
            _salesAnalysisModel.resultsGraphicData = sortedResultsAC;
            _appModel.resultsPresenter.dataProvider = sortedResultsAC;
            _appModel.mainPresenter.clearGraphicsLayers();
            _appModel.mainPresenter.addGraphics(sortedResultsAC.source);
            _appModel.mainPresenter.currentState = StateEnum.RESULTS_STATE;
            if (_appModel.mainPresenter.drawToolEnabled)
            {
                _appModel.mainPresenter.toggleDrawTool(false);
            }
        }
        else
        {
            _appModel.searchPresenter.showErrorMessage("No results for your search.");
            _appModel.mainPresenter.clearGraphicsLayers();
        }
    } //end function

    protected function esriServiceFaultHandler(event:FaultEvent):void
    {
        _appModel.searchPresenter.showErrorMessage("Search error: " + event.message + " " + event.fault.faultDetail);
    }
} //end class
}
