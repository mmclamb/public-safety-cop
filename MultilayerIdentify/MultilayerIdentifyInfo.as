////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2010 ESRI
//
// All rights reserved under the copyright laws of the United States.
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  See use restrictions in the file:
// <install location>/License.txt
//
////////////////////////////////////////////////////////////////////////////////

// identifyLayers attribute (mkt)
package widgets.MultilayerIdentify
{
    import com.esri.ags.geometry.MapPoint;
    import com.esri.ags.layers.ArcGISDynamicMapServiceLayer;
    import com.esri.ags.layers.ArcGISTiledMapServiceLayer;
    import com.esri.ags.layers.FeatureLayer;
    import com.esri.ags.layers.Layer;
    import com.esri.ags.layers.supportClasses.LayerDetails;

    import flash.utils.Dictionary;

    import mx.core.UIComponent;
    import mx.modules.IModuleInfo;
    import mx.rpc.AsyncResponder;

    public class MultilayerIdentifyInfo
    {

        public function MultilayerIdentifyInfo(timestamp:Number,
            serviceLayer:Layer, mapLayerId:Number, mapLayerName:String, queryUrl:String,
            layerFormat:Object)
        {
            _timestamp = timestamp;
            _serviceLayer = serviceLayer;
            _mapLayerId = mapLayerId;
            _mapLayerName = mapLayerName;
            _queryUrl = queryUrl;
            _layerFormat = layerFormat;

            // Cache the map layer details if we have them
            if(serviceLayer is FeatureLayer)
            {
                _mapLayerDetails = (serviceLayer as FeatureLayer).layerDetails;
            }
            // Fetch them otherwise
            else if(serviceLayer is ArcGISDynamicMapServiceLayer)
            {
                (serviceLayer as ArcGISDynamicMapServiceLayer).getDetails(mapLayerId,
                    new AsyncResponder(detailsSuccessHandler, ignoreHandler, this));
            }
            else if(serviceLayer is ArcGISTiledMapServiceLayer)
            {
                (serviceLayer as ArcGISTiledMapServiceLayer).getDetails(mapLayerId,
                    new AsyncResponder(detailsSuccessHandler, ignoreHandler, this));
            }
        }

        protected function detailsSuccessHandler(details:LayerDetails,
            infoPacket:MultilayerIdentifyInfo):void
        {
            _mapLayerDetails = details;
        }

        protected function ignoreHandler(result:Object, data:Object=null):void
        {
        }

        //--------------------------------------------------------------------//

        private var _timestamp:Number;

        public function get timestamp():Number
        {
            return _timestamp;
        }

        //--------------------------------------------------------------------//

        private var _serviceLayer:Layer;

        public function get serviceLayer():Layer
        {
            return _serviceLayer;
        }

        public function set serviceLayer(serviceLayer:Layer):void
        {
            _serviceLayer = serviceLayer;
        }

        //--------------------------------------------------------------------//

        private var _mapLayerId:Number;

        public function get mapLayerId():Number
        {
            return _mapLayerId;
        }

        public function set mapLayerId(_mapLayerId:Number):void
        {
            _mapLayerId = _mapLayerId;
        }

        //--------------------------------------------------------------------//

        private var _mapLayerName:String;

        public function get mapLayerName():String
        {
            return _mapLayerName;
        }

        public function set mapLayerName(mapLayerName:String):void
        {
            _mapLayerName = mapLayerName;
        }

        //--------------------------------------------------------------------//

        private var _mapLayerDetails:LayerDetails;

        public function get mapLayerDetails():LayerDetails
        {
            return _mapLayerDetails;
        }

        public function set mapLayerDetails(mapLayerDetails:LayerDetails):void
        {
            _mapLayerDetails = mapLayerDetails;
        }

        //--------------------------------------------------------------------//

        private var _layerFormat:Object;

        public function get layerFormat():Object
        {
            return _layerFormat;
        }

        public function set layerFormat(layerFormat:Object):void
        {
            _layerFormat = layerFormat;
        }

        //--------------------------------------------------------------------//

        private var _queryUrl:String;

        public function get queryUrl():String
        {
            return _queryUrl;
        }

        public function set queryUrl(queryUrl:String):void
        {
            _queryUrl = queryUrl;
        }

        //--------------------------------------------------------------------//

        private var _features:Array;

        public function get features():Array
        {
            return _features;
        }

        public function set features(features:Array):void
        {
            _features = features;
        }

        //--------------------------------------------------------------------//

        private var _fields:Array;

        public function get fields():Array
        {
            if(null != _fields)
            {
                return _fields;
            }
            else if(null != _mapLayerDetails && null != _mapLayerDetails.fields)
            {
                return _mapLayerDetails.fields;
            }
            return null;
        }

        public function set fields(fields:Array):void
        {
            _fields = fields;
        }

        //--------------------------------------------------------------------//

        private var _fieldAliases:Object;

        public function get fieldAliases():Object
        {
            return _fieldAliases;
        }

        public function set fieldAliases(fieldAliases:Object):void
        {
            _fieldAliases = fieldAliases;
        }

        //--------------------------------------------------------------------//

        private var _info:String;

        public function get info():String
        {
            return _info;
        }

        public function set info(info:String):void
        {
            _info = info;
        }

    }
}