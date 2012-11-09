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
package widgets.TrackingPlayback.presenter
{

import com.esri.ags.Map;
import com.esri.ags.events.LayerEvent;
import com.esri.ags.geometry.Extent;
import com.esri.ags.layers.FeatureLayer;
import com.esri.ags.utils.GraphicUtil;

import flash.events.Event;
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;

import org.osmf.layout.AbsoluteLayoutFacet;

import widgets.TrackingPlayback.enum.StateEnum;
import widgets.TrackingPlayback.event.PlaybackViewEvent;
import widgets.TrackingPlayback.event.ViewNavigationEvent;
import widgets.TrackingPlayback.model.ConfigModel;
import widgets.TrackingPlayback.model.SymbolHolder;



public class MainPresenter extends EventDispatcher
{
    private var _dispatcher:EventDispatcher;
    private var _currentState:String = StateEnum.LOADING_STATE;
    private var _lastState:String;

    private var _map:Map;
    private var _featureLayerTrackingLayer:FeatureLayer;
    private var _symbolHolder:SymbolHolder;
    [Bindable]
    private var _configModel:ConfigModel;

    private var _featuresExtent:Extent;


    public function MainPresenter(dispatcher:EventDispatcher)
    {
        _dispatcher = dispatcher;
        _configModel = ConfigModel.getInstance();

    }

    //--------------------------------------------------------------------------
    //
    // Public methods 
    //
    //--------------------------------------------------------------------------
    public function initializeConfiguration():void
    {
        _symbolHolder = new SymbolHolder();
        _configModel.mapSpatialReference = map.spatialReference;
        addLayers();

    }

    public function goHelp():void
    {
        _dispatcher.dispatchEvent(new ViewNavigationEvent(ViewNavigationEvent.GO_HELP_EVENT));
    }

    public function zoomToExtent(extent:Extent):void
    {
        if (extent)
        {
            map.extent = extent;
        }
    }

    public function timeExtentChangeHandler(event:PlaybackViewEvent):void
    {
        map.timeExtent = _configModel.playbackViewTimeExtent;
    }

    public function setDefinitionExpression():void
    {
        _featureLayerTrackingLayer.definitionExpression = _configModel.layerTrackingLayerDefaultDefinitionExpression; //'"STOP_DURATION" = 0 AND "SPEED" <> 0 AND VEHICLE_LABEL = "snow612"';//
        if (_configModel.playbackViewDefinitionExpression != "")
        {
            _featureLayerTrackingLayer.definitionExpression = _configModel.layerTrackingLayerDefaultDefinitionExpression + " AND " + _configModel.playbackViewDefinitionExpression;
        }

    }

    protected function addLayers():void
    {
        _featureLayerTrackingLayer = new FeatureLayer();
        _featureLayerTrackingLayer.id = "snowPlowLayer";
        _featureLayerTrackingLayer.name = _configModel.layerTrackingLayerDetails.name;
        ;
        _featureLayerTrackingLayer.url = _configModel.serviceTrackingLayerUrl || "http://stlouis.esri.com/ArcGIS/rest/services/Regional/Massachusetts_Boston_SnowPlow/MapServer/0";
        _featureLayerTrackingLayer.mode = FeatureLayer.MODE_SNAPSHOT || "onDemand";
        _featureLayerTrackingLayer.outFields = _configModel.queryTrackingLayerOutFieldsArr || [ 'HEADING', 'VEHICLE_LABEL' ];
        _featureLayerTrackingLayer.renderer = _symbolHolder.snowPlowRenderer; // "{snowPlowRenderer}"	
        _featureLayerTrackingLayer.trackIdField = _configModel.layerTrackingLayerTrackIDField; // "VEHICLE_LABEL"
        _featureLayerTrackingLayer.useMapTime = true;
        _featureLayerTrackingLayer.useAMF = _configModel.serviceTrackingLayerUseAMF;

        //_featureLayerTrackingLayer.addEventListener(LayerEvent.UPDATE_END, featureLayerTrackingLayer_UpdateEndHandler, false, 0, true);

        map.addLayer(_featureLayerTrackingLayer);
        map.timeExtent = _configModel.playbackViewTimeExtent;
    }

    protected function featureLayerTrackingLayer_UpdateEndHandler(event:LayerEvent):void
    {
        var newFeaturesExtent:Extent;
        var graphics:ArrayCollection = FeatureLayer(event.layer).graphicProvider as ArrayCollection;
        if (graphics && graphics.length)
        {
            newFeaturesExtent = GraphicUtil.getGraphicsExtent(graphics.source) as Extent;
            map.extent = newFeaturesExtent;
            /* if (_featuresExtent)
             {
                 var extent:Extent = newFeaturesExtent.union(_featuresExtent);
                 _featuresExtent = extent;
             }
             else
             {
                 _featuresExtent = newFeaturesExtent;
             }
             var mapExtent:Extent = map.extent;
             var bool:Boolean = mapExtent.contains(_featuresExtent);
             var bool2:Boolean = _featuresExtent.contains(mapExtent);
             if (!bool2)
             {
                 map.level--;
             }*/
        }
    }

    //--------------------------------------------------------------------------
    //
    // minimizing layers 
    //
    //--------------------------------------------------------------------------
    public function openedHandler():void
    {
        //make layers visible
        if (_featureLayerTrackingLayer)
        {
            _featureLayerTrackingLayer.visible = true;
        }
        if (_configModel.layerTrackingLayerTimeExtent)
        {
            map.timeExtent = _configModel.layerTrackingLayerTimeExtent;
        }
    }

    public function closedHandler():void
    {
        //make layers invisible
        if (_featureLayerTrackingLayer)
        {
            _featureLayerTrackingLayer.visible = false;
        }
        if (map.timeExtent)
        {
            map.timeExtent = null;
        }
    }

    public function minimizedHandler():void
    {
        //make layers invisible
        if (_featureLayerTrackingLayer)
        {
            _featureLayerTrackingLayer.visible = false;
        }
        if (map.timeExtent)
        {
            map.timeExtent = null;
        }
    }


    //--------------------------------------------------------------------------
    //
    // Getters and setters 
    //
    //--------------------------------------------------------------------------
    [Bindable(event="currentStateChange")]
    public function get currentState():String
    {
        return _currentState;
    }

    public function set currentState(value:String):void
    {
        if (_currentState !== value)
        {
            _lastState = _currentState;
            _currentState = value;
            dispatchEvent(new Event("currentStateChange"));
        }
    }

    [Bindable(event="lastStateChange")]
    public function get lastState():String
    {
        return _lastState;
    }

    public function set lastState(value:String):void
    {
        if (_lastState !== value)
        {
            _lastState = value;
            dispatchEvent(new Event("lastStateChange"));
        }
    }

    public function get map():Map
    {
        return _map;
    }

    public function set map(value:Map):void
    {
        _map = value;
    }



} //end class
}
