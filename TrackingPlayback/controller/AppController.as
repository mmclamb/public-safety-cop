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

import com.esri.ags.Graphic;
import com.esri.ags.Map;
import com.esri.ags.TimeExtent;
import com.esri.ags.events.DetailsEvent;
import com.esri.ags.events.QueryEvent;
import com.esri.ags.geometry.Extent;
import com.esri.ags.layers.supportClasses.TimeInfo;
import com.esri.ags.tasks.DetailsTask;
import com.esri.ags.tasks.QueryTask;
import com.esri.ags.tasks.supportClasses.Query;
import com.esri.ags.utils.GraphicUtil;
import com.esri.stl.ags.layers.supportClasses.FieldFormat;
import com.esri.stl.ags.utils.ExcelUtil;
import com.esri.stl.ags.utils.SortUtil;
import com.esri.stl.components.CheckBoxDataGridItemRenderer;
import com.esri.stl.events.FileOpenSaveEvent;
import com.esri.stl.utils.URLParamsUtil;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.ClassFactory;
import mx.core.FlexGlobals;
import mx.rpc.events.FaultEvent;
import mx.styles.CSSStyleDeclaration;
import mx.styles.IStyleManager2;

import widgets.TrackingPlayback.enum.StateEnum;
import widgets.TrackingPlayback.event.ConfigurationEvent;
import widgets.TrackingPlayback.event.PlaybackViewEvent;
import widgets.TrackingPlayback.event.ViewNavigationEvent;
import widgets.TrackingPlayback.model.AppModel;
import widgets.TrackingPlayback.model.ConfigModel;
import widgets.TrackingPlayback.presenter.HelpPresenter;
import widgets.TrackingPlayback.presenter.LoadingPresenter;
import widgets.TrackingPlayback.presenter.MainPresenter;
import widgets.TrackingPlayback.presenter.PlaybackPresenter;
import widgets.TrackingPlayback.service.EsriServiceHolder;






public class AppController extends EventDispatcher
{
    private var _appModel:AppModel;
    [Bindable]
    private var _configModel:ConfigModel;
    private var _esriServiceHolder:EsriServiceHolder;

    /**
     * Constructor
     */
    public function AppController()
    {
        _appModel = AppModel.getInstance();
        _configModel = ConfigModel.getInstance();
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
        _appModel.playbackPresenter = new PlaybackPresenter(this);
    }

    private function initializePresentationModelConfigurations():void
    {
        _appModel.helpPresenter.initalizeConfiguration();
        _appModel.mainPresenter.initializeConfiguration();
        _appModel.playbackPresenter.initializeConfiguration();
    }

    private function buildEsriService():void
    {
        _esriServiceHolder = new EsriServiceHolder();
        //<!-- DetailsTask for getting service layer information from the ArcGIS Server service -->
        _esriServiceHolder.serviceLayerDetailsTask.addEventListener(DetailsEvent.GET_DETAILS_COMPLETE, getServiceLayerDetailsCompleteHandler, false, 0, true);
        _esriServiceHolder.serviceLayerDetailsTask.addEventListener(FaultEvent.FAULT, esriServiceFaultHandler, false, 0, true);
        //<!-- DetailsTask for getting service table information from the ArcGIS Server service -->
        _esriServiceHolder.serviceTableDetailsTask.addEventListener(DetailsEvent.GET_DETAILS_COMPLETE, getServiceTableDetailsCompleteHandler, false, 0, true);
        _esriServiceHolder.serviceTableDetailsTask.addEventListener(FaultEvent.FAULT, esriServiceFaultHandler, false, 0, true);
        //<!-- QueryTask for getting tracking assets from the historical tracking service -->
        _esriServiceHolder.serviceQueryTask.addEventListener(QueryEvent.EXECUTE_COMPLETE, executeQueryCompleteHandler, false, 0, true);
        _esriServiceHolder.serviceQueryTask.addEventListener(FaultEvent.FAULT, esriServiceFaultHandler, false, 0, true);
    }

    private function addListeners():void
    {
        addEventListener(ConfigurationEvent.PARSE_BEGIN, configEventBeginHandler, false, 0, true);
        addEventListener(ConfigurationEvent.PARSE_COMPLETE, configEventCompleteHandler, false, 0, true);
        addEventListener(ConfigurationEvent.LOADING_SERVICE_INFO, configEventLoadingServiceInfoHandler, false, 0, true);

        addEventListener(ViewNavigationEvent.GO_HELP_EVENT, goHelpHandler, false, 0, true);
        addEventListener(ViewNavigationEvent.GO_BACK_EVENT, goBackHandler, false, 0, true);

        addEventListener(PlaybackViewEvent.TIME_EXTENT_CHANGE, playbackTimeExtentChangeHandler, false, 0, true);
        addEventListener(PlaybackViewEvent.VEHICLE_SELECTION_CHANGE, playbackVehicleSelectionChangeHandler, false, 0, true);
    }



    public function initConfig(map:Map, config:XML):void
    {
        _appModel.mainPresenter.map = map;
        ConfigurationEvent.STEPS = 0;
        //PARSE THE CONFIGURATION
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

        _appModel.loadingPresenter.message = "Loading service info...";

        //get layer details
        var layerUrlParts:Array = URLParamsUtil.getBaseURLWithID(_configModel.serviceTrackingLayerUrl);
        if (layerUrlParts.length == 2)
        {
            _esriServiceHolder.serviceLayerDetailsTask.url = layerUrlParts[0];
            _esriServiceHolder.serviceLayerDetailsTask.proxyURL = _configModel.serviceTrackingLayerProxyURL;
            _esriServiceHolder.serviceLayerDetailsTask.token = _configModel.serviceTrackingLayerToken;

            _esriServiceHolder.serviceLayerDetailsTask.getDetails(layerUrlParts[1]);
        }
        //get table details
        var tableUrlParts:Array = URLParamsUtil.getBaseURLWithID(_configModel.serviceTrackingTableUrl);
        if (tableUrlParts.length == 2)
        {
            _esriServiceHolder.serviceTableDetailsTask.url = tableUrlParts[0];
            _esriServiceHolder.serviceTableDetailsTask.proxyURL = _configModel.serviceTrackingTableProxyURL;
            _esriServiceHolder.serviceTableDetailsTask.token = _configModel.serviceTrackingTableToken;

            _esriServiceHolder.serviceTableDetailsTask.getDetails(tableUrlParts[1]);
        }

        _esriServiceHolder.serviceQueryTask.url = _configModel.serviceTrackingTableUrl;
        _esriServiceHolder.serviceQueryTask.proxyURL = _configModel.serviceTrackingTableProxyURL;
        _esriServiceHolder.serviceQueryTask.useAMF = _configModel.serviceTrackingTableUseAMF;
        _esriServiceHolder.serviceQueryTask.token = _configModel.serviceTrackingTableToken;


        var query:Query = new Query();
        query.where = _configModel.queryTrackingTableDefaultQuery || "1=1";
        query.outFields = _configModel.queryTrackingTableOutFieldsArr;
        _esriServiceHolder.serviceQueryTask.execute(query);
    }

    protected function configEventLoadingServiceInfoHandler(event:ConfigurationEvent):void
    {
        ConfigurationEvent.STEPS++;
        if (ConfigurationEvent.STEPS == 3)
        {
            initializePresentationModelConfigurations();
            if (_appModel.mainPresenter.currentState != StateEnum.PLAYBACK_STATE)
            {
                _appModel.mainPresenter.currentState = StateEnum.PLAYBACK_STATE;
            }
        }

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

    //--------------------------------------------------------------------------
    //
    // Playback View Event Handlers 
    //
    //--------------------------------------------------------------------------
    protected function playbackTimeExtentChangeHandler(event:PlaybackViewEvent):void
    {
        _appModel.mainPresenter.timeExtentChangeHandler(event);
    }

    protected function playbackVehicleSelectionChangeHandler(event:Event):void
    {
        _appModel.mainPresenter.setDefinitionExpression();
    }

    //--------------------------------------------------------------------------
    //
    // Esri Service Event Handlers 
    //
    //--------------------------------------------------------------------------
    protected function executeQueryCompleteHandler(event:QueryEvent):void
    {
        var trackingTableFieldsOrderArr:Array = _configModel.fieldsTrackingTableFieldsUtil.fieldsOrder;
        var trackingTableFieldsDictionary:Dictionary = _configModel.fieldsTrackingTableFieldsUtil.fieldsDictionary;

        var preAttributes:Array = event.featureSet.features;
        for (var i:int = 0; i < preAttributes.length; i++)
        {
            preAttributes[i].attributes['CHECKBOX'] = true;
        }

        _configModel.playbackViewTrackingTableDataGridColumns = [];

        if (trackingTableFieldsOrderArr && trackingTableFieldsDictionary)
        {
            //do the stuff to create datagridcolumns and populate dataprovider for table in the filter UI
            for (var j:int = 0; j < trackingTableFieldsOrderArr.length; j++)
            {
                var dgc:DataGridColumn;
                var ff:FieldFormat = trackingTableFieldsDictionary[trackingTableFieldsOrderArr[j]] as FieldFormat;

                if (String(trackingTableFieldsOrderArr[j]).toLowerCase() == "checkbox")
                {
                    dgc = new DataGridColumn();
                    dgc.sortable = false;
                    dgc.editable = true;
                    dgc.width = 20;
                    dgc.headerText = "";
                    dgc.dataField = "CHECKBOX";
                    dgc.editorDataField = "selected";
                    dgc.rendererIsEditor = true;
                    dgc.itemRenderer = new ClassFactory(com.esri.stl.components.CheckBoxDataGridItemRenderer);
                        //dgc.itemRenderer = new ClassFactory(CenteredCheckBoxItemRenderer);
                }
                else
                {
                    dgc = new DataGridColumn(trackingTableFieldsOrderArr[j]);
                    dgc.headerText = ff.alias;
                    dgc.dataField = "attributes." + trackingTableFieldsOrderArr[j];
                }
                _configModel.playbackViewTrackingTableDataGridColumns.push(dgc);
            } //end for


            _configModel.playbackViewTrackingTableDataProvider = new ArrayCollection(preAttributes);

        } //end if
        dispatchEvent(new ConfigurationEvent(ConfigurationEvent.LOADING_SERVICE_INFO));
    }

    protected function getServiceLayerDetailsCompleteHandler(event:DetailsEvent):void
    {
        if (event.layerDetails)
        {
            _configModel.layerTrackingLayerDetails = event.layerDetails;
            _configModel.layerTrackingLayerExtent = event.layerDetails.extent;
            _configModel.layerTrackingLayerTimeExtent = event.layerDetails.timeInfo.timeExtent;
            _configModel.layerTrackingLayerDefaultDefinitionExpression = event.layerDetails.definitionExpression;
            _configModel.playbackViewDateRange = { rangeStart: event.layerDetails.timeInfo.timeExtent.startTime, rangeEnd: event.layerDetails.timeInfo.timeExtent.endTime };
            _configModel.playbackViewTimeExtent = new TimeExtent(_configModel.playbackViewStartDateTime, _configModel.playbackViewEndDateTime);
        }

        dispatchEvent(new ConfigurationEvent(ConfigurationEvent.LOADING_SERVICE_INFO));

    }

    protected function getServiceTableDetailsCompleteHandler(event:DetailsEvent):void
    {
        if (event.tableDetails)
        {
            _configModel.tableTrackingTableDetails = event.tableDetails;
            _configModel.fieldsTrackingTableFieldsUtil.parseConfig(_configModel.fieldsTrackingTableFieldsXML, _configModel.tableTrackingTableDetails.fields);
        }

        dispatchEvent(new ConfigurationEvent(ConfigurationEvent.LOADING_SERVICE_INFO));

    }

    protected function esriServiceFaultHandler(event:FaultEvent):void
    {
        _appModel.mainPresenter.currentState = StateEnum.PLAYBACK_STATE;
        _appModel.playbackPresenter.showErrorMessage("Search error: " + event.message + " " + event.fault.faultDetail);
    }
} //end class
}
