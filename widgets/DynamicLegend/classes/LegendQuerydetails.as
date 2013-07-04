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
package widgets.DynamicLegend.classes
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Multipoint;
	import com.esri.ags.layers.ArcGISDynamicMapServiceLayer;
	import com.esri.ags.layers.ArcGISTiledMapServiceLayer;
	import com.esri.ags.layers.FeatureLayer;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	import com.esri.ags.utils.JSONUtil;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequestMethod;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.managers.CursorManager;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.StringUtil;

	import spark.filters.GlowFilter;

	import widgets.DynamicLegend.event.LegendEvent;
	import widgets.DynamicLegend.util.NewDynamicLegendUtil;
	import widgets.DynamicLegend.vo.LegendData;


	public class LegendQuerydetails extends EventDispatcher
	{
		private var legendIndexCount:int=0;
		private var _legendDetails:Object;
		private var _map:Map;
		private var _newLegendUtil:NewDynamicLegendUtil = NewDynamicLegendUtil.getNewInstance();

		private var index:int;

		private var _legenData:LegendData;
		private var fieldValue:String = "";
		private var layerUrl:String = "";

		private var arrData:ArrayCollection = new ArrayCollection();


		public function doLegendQuery(legendDetails:Object,legendMap:Map,selectedItemId:String):void
		{


			if(legendDetails != null && legendMap != null)
			{
				var httpServ:HTTPService=new HTTPService();
				arrData = new ArrayCollection();
				_legendDetails = legendDetails;
				_map = legendMap;
				index = 0;
				var queryUrl:String;
				if(selectedItemId == "all" || selectedItemId == "onChange")
				{

					if(_map.getLayer(_legendDetails.lname) is FeatureLayer )
					{
						if((_map.getLayer(_legendDetails.lname) as FeatureLayer).visible==true)
						{
						queryUrl=(_map.getLayer(_legendDetails.lname) as FeatureLayer).url
						}
						else
						{
							_newLegendUtil.legendIndex--;
						}
					}
					else if(_map.getLayer(_legendDetails.lname) is ArcGISDynamicMapServiceLayer)
					{
						if((_map.getLayer(_legendDetails.lname) as ArcGISDynamicMapServiceLayer).visible===true)
						{
					queryUrl = (_map.getLayer(_legendDetails.lname) as ArcGISDynamicMapServiceLayer).url + "/" + _legendDetails.id;


						}
						else
						{
							_newLegendUtil.legendIndex--;
						}
					}

				else if(_map.getLayer(_legendDetails.lname) is ArcGISTiledMapServiceLayer)
						{
							if((_map.getLayer(_legendDetails.lname) as ArcGISTiledMapServiceLayer).visible===true)
							{
								queryUrl = (_map.getLayer(_legendDetails.lname) as ArcGISTiledMapServiceLayer).url + "/" + _legendDetails.id;
							}
							else
							{
								_newLegendUtil.legendIndex--;
							}
						}
				}
				else if(_legendDetails.url != null)
				{
					queryUrl = _legendDetails.url;
				}

				if(queryUrl!=null)
				{
					httpServ.url=queryUrl+"?f=json";

					httpServ.addEventListener(ResultEvent.RESULT,onResult)
					httpServ.addEventListener(FaultEvent.FAULT,onFault);
					var token:AsyncToken = httpServ.send();
					token.details = _legendDetails as Object;
					 function onResult(event:ResultEvent):void
					{
						 var str:String=new String();
						 var rawData:String = String(event.result);
						 var data:Object = JSONUtil.decode(rawData);
						 if(data.drawingInfo)
						 {
						 if(data.drawingInfo.renderer.type=="uniqueValue")
						 {
							 str=(data.drawingInfo.renderer.field1 as String);
						 }


						 var queryTask:QueryTask = new QueryTask(queryUrl);
						 queryTask.useAMF = false;
						 var query:Query = new Query();
						 query.where = "1=1";
						 query.outFields = ["*"];
						 query.geometry = _map.extent;
						 query.outSpatialReference = _map.spatialReference;
						 query.returnGeometry = false;
						 queryTask.showBusyCursor = true;

						 queryTask.execute(query, new AsyncResponder(onResultHandler, onFaultHandler,{"legendDetails":event.token.details,"RendereFieldValue":str,"selectedItemId":selectedItemId}));
						 }
						 else
						 {
							 _newLegendUtil.legendIndex--;
						 }

					}
					  function onFault(event:FaultEvent):void
					 {
						  _newLegendUtil.legendIndex--;
					 }
					}
				//_newLegendUtil.legendLayerData.addItem(this)
			}
		}


		private function onResultHandler(featureSet:FeatureSet, token:Object = null):void
		{




			_newLegendUtil.legendIndex--;
			index++;
			var str:String = "";
			_newLegendUtil.legendCollection = new ArrayCollection();
			for each (var featureGraphic:Graphic in featureSet.features)
			{
				for each(var objRenderer:Object in _newLegendUtil.fieldArr[token.legendDetails.label].source)
				{

					if(objRenderer.rendererType == "uniqueValue")
					{
						if(featureGraphic.attributes[token.RendereFieldValue] == objRenderer.value)
						{
							if(!_newLegendUtil.legendCollection.contains(objRenderer))
								_newLegendUtil.legendCollection.addItem(objRenderer);
							break;
						}
						else if((featureGraphic.attributes[(token.RendereFieldValue as String).toLowerCase()] == objRenderer.value))
						{
							if(!_newLegendUtil.legendCollection.contains(objRenderer))
								_newLegendUtil.legendCollection.addItem(objRenderer);
							break;
						}
						else if((featureGraphic.attributes[(token.RendereFieldValue as String).toUpperCase()] == objRenderer.value))
						{
							if(!_newLegendUtil.legendCollection.contains(objRenderer))
								_newLegendUtil.legendCollection.addItem(objRenderer);
							break;
						}
					}
					else if(objRenderer.rendererType=="temporal")
					{
						if(!_newLegendUtil.legendCollection.contains(objRenderer))
							_newLegendUtil.legendCollection.addItem(objRenderer);
						break;
					}
					else if(objRenderer.rendererType == "simple")
					{
						if(!_newLegendUtil.legendCollection.contains(objRenderer))
							_newLegendUtil.legendCollection.addItem(objRenderer);
						break;
					}
					else if(objRenderer.rendererType == "classBreaks")
					{
						if(featureGraphic.attributes[_newLegendUtil.classBreakRend]  > objRenderer.minValue && featureGraphic.attributes[_newLegendUtil.classBreakRend] < objRenderer.maxValue)
						{
							if(!_newLegendUtil.legendCollection.contains(objRenderer))
								_newLegendUtil.legendCollection.addItem(objRenderer);
								break;
						}
					}

				}
			}
			if(token.selectedItemId == "all")
			{

				if(_newLegendUtil.legendCollection.length > 0)
				{

					_newLegendUtil.arrColl.addItem(token.legendDetails);
					for each(var obj:Object in _newLegendUtil.legendCollection)
					{
						_newLegendUtil.arrColl.addItem(obj);
					}
				}

					if(_newLegendUtil.arrColl.length > 0)
					{
						_legenData = new LegendData();
						_legenData.legendCollection = _newLegendUtil.arrColl;
						_legenData.selectedName = token.selectedItemId;
						_legenData.legendCollection.refresh();
						dispatchEvent(new LegendEvent(LegendEvent.LIST_UPDATE,_legenData));
					}
					else
					{
						_legenData = new LegendData();
						_legenData.selectedName = token.selectedItemId;
						_legenData.legendCollection = _newLegendUtil.arrColl;
						dispatchEvent(new LegendEvent(LegendEvent.NO_RESULT_FOUND,_legenData));
					}


			}
			else if(token.selectedItemId == "onChange")
			{
				if(_newLegendUtil.legendCollection.length > 0)
				{

					_legenData = new LegendData();
					_legenData.legendCollection = _newLegendUtil.legendCollection;
					_legenData.data = token.legendDetails;
					_legenData.selectedName = token.legendDetails.label;
					_legenData.onChangeListUpdate = true;
					dispatchEvent(new LegendEvent(LegendEvent.CHECK_BOX_LIST_UPDATE,_legenData));
				}
				else
				{
					_legenData = new LegendData();
					_legenData.data = token.legendDetails;
					_legenData.legendCollection = _newLegendUtil.legendCollection;
					_legenData.selectedName = token.legendDetails.label;
					dispatchEvent(new LegendEvent(LegendEvent.NO_RESULT_FOUND,_legenData));
				}
			}
			else
			{
				if(_newLegendUtil.legendCollection.length > 0)
				{
					_legenData = new LegendData();
					_legenData.legendCollection = _newLegendUtil.legendCollection;
					_legenData.selectedName = token.legendDetails.label;
					dispatchEvent(new LegendEvent(LegendEvent.LIST_UPDATE,_legenData));
				}
				else
				{
					_legenData = new LegendData();
					_legenData.data = token.legendDetails;
					_legenData.selectedName = token.legendDetails.label;
					dispatchEvent(new LegendEvent(LegendEvent.NO_RESULT_FOUND,_legenData));
				}
			}

		}

		private function onFaultHandler(info:Object, token:Object = null):void
		{

			_newLegendUtil.isFault=true;
			_newLegendUtil.legendIndex--;
			if(_newLegendUtil.legendIndex==0 && _newLegendUtil.isFault==true)
			{
				_newLegendUtil.isFault=false;
			Alert.show(_newLegendUtil.alertMsg.faultError.alertmessage,_newLegendUtil.alertMsg.faultError.alertheader);
			}
			CursorManager.removeBusyCursor();
		}

		public function legendHandler(data:Object):void
		{
			var str:String="";
			for(var i:int=0;i<_newLegendUtil.arrColl.length;i++)
			{
				if(_newLegendUtil.arrColl[i].lname)
				{
					str=_newLegendUtil.arrColl[i].lname;
				}
				if(data.label==_newLegendUtil.arrColl[i].label && _newLegendUtil.arrColl[i].imageData!=null)
				{

					break;
				}

			}
			CursorManager.setBusyCursor();
			fieldValue=data.value;
			if(_map.getLayer(str) is ArcGISDynamicMapServiceLayer){
				layerUrl=((_map.getLayer(str)) as ArcGISDynamicMapServiceLayer).url+"/"+ data.id+"?f=json";

			}
			if(_map.getLayer(str)is FeatureLayer)
			{
				layerUrl=((_map.getLayer(str)) as FeatureLayer).url+"?f=json";
				CursorManager.removeBusyCursor();

			}
			var httpService:HTTPService = new HTTPService();
			httpService.url = layerUrl.toString();
			httpService.addEventListener(ResultEvent.RESULT, onHttpResultHandler);
			httpService.addEventListener(FaultEvent.FAULT,onHttpFaultHandler);
			httpService.send();



		}

		private function onHttpResultHandler(event:ResultEvent):void
		{
			var queryTask:QueryTask = new QueryTask();
			var query:Query = new Query();
			queryTask.useAMF= false;
			queryTask.url=layerUrl;
			queryTask.method = URLRequestMethod.POST;
			query.outSpatialReference = _map.spatialReference;
			query.returnGeometry = true;
			query.outFields=_newLegendUtil.arrOutField;
			query.geometry = _map.extent;
			var fieldName:String = new String();
			var rawData:String = String(event.result);
			var data:Object = JSONUtil.decode(rawData);


			if(data.drawingInfo.renderer.type =="uniqueValue")
			{
				fieldName =data.drawingInfo.renderer.field1;
				query.where = fieldName+"='"+fieldValue+"'";
			}

			if(data.drawingInfo.renderer.type =="simple")
			{
				query.where="1=1"
			}
			if(data.drawingInfo.renderer.type == "classBreaks")
			{
				var initialValue:String = new String();
				fieldName =data.drawingInfo.renderer.field;
				var i:int = fieldValue.search("-");
				initialValue = fieldValue.substring(0,i-1);
				fieldValue = fieldValue.substr(i+1,fieldValue.length);
				fieldValue = StringUtil.trim(fieldValue);
				if(i >= 0)
				{
					query.where = fieldName+">"+initialValue+" AND "+fieldName+"<"+fieldValue;
				}
				else
				{
					query.where = fieldName+"="+fieldValue;
				}
			}
			query.outFields=["*"];
			queryTask.requestTimeout=60;
			queryTask.execute(query,new AsyncResponder(onQueryResult, OnQueryFault));
		}

		private function onHttpFaultHandler(event:FaultEvent):void
		{

			Alert.show(_newLegendUtil.alertMsg.faultError.alertmessage,_newLegendUtil.alertMsg.faultError.alertheader);
			dispatchEvent(new Event(LegendEvent.DATAGRID_UPDATE_FAULT,true));
			CursorManager.removeBusyCursor();
		}

		private function onQueryResult(featureSet:FeatureSet, token:Object = null):void
		{
			var resultGrid:ArrayCollection = new ArrayCollection();

			if(featureSet.features.length > 0)
			{
				_newLegendUtil.arrOutField=new Array();
				_newLegendUtil.graphicSelectionLayer.clear();
				var custExtent:Multipoint = new Multipoint();
				var tempGrap:Graphic;
				var glowFilter:GlowFilter = new GlowFilter();
				glowFilter.color = _newLegendUtil.numColor;
				glowFilter.alpha = _newLegendUtil.numAlpha;
				glowFilter.quality = 10;
				glowFilter.strength = 20;
				for each(var gra:Graphic in featureSet.features)
				{
					var objFeature:Object = new Object();
					for(var i:int = 0; i < featureSet.fields.length; i++)
					{


						if(featureSet.fields[i].alias != "OBJECTID"&&featureSet.fields[i].alias != "objectid" && gra.attributes[featureSet.fields[i].name]!=null)
						{
							objFeature[featureSet.fields[i].alias] = gra.attributes[featureSet.fields[i].name];
							_newLegendUtil.arrOutField[i]=featureSet.fields[i].alias;

						}
						if (i==_newLegendUtil.outFieldCount)
							break;
					}
					objFeature.graphic = gra;
					objFeature.geometry = gra.geometry;
					resultGrid.addItem(objFeature);

					var point:MapPoint;
					var geometry:Geometry = gra.geometry;

					if (geometry && _newLegendUtil.isWIdgetClosed == false)
					{
						switch (geometry.type)
						{
							case Geometry.MAPPOINT:
							{
								tempGrap = new Graphic();
								tempGrap.geometry = gra.geometry;
								tempGrap.alpha=0.5;
								custExtent.addPoint((geometry) as MapPoint);

								_newLegendUtil.graphicSelectionLayer.add(tempGrap);

								_newLegendUtil.graphicSelectionLayer.refresh();
								break;
							}

							case Geometry.POLYLINE:
							{
								tempGrap = new Graphic();
								tempGrap.alpha=0.5;
								tempGrap.geometry = gra.geometry;

								_newLegendUtil.graphicSelectionLayer.add(tempGrap);
								custExtent.addPoint((geometry.extent.center) as MapPoint);

								break;
							}
							case Geometry.POLYGON:
							{
								tempGrap = new Graphic();
								tempGrap.alpha=0.5;
								tempGrap.geometry = gra.geometry;

								_newLegendUtil.graphicSelectionLayer.add(tempGrap);

								break;
							}
						}
					}
				}
				_legenData = new LegendData();
				_legenData.resultDataGrid = resultGrid;
				dispatchEvent(new LegendEvent(LegendEvent.DATAGRID_UPDATE,_legenData));
			}
			else
			{
				_legenData = new LegendData();
				_legenData.resultDataGrid = null;
				dispatchEvent(new LegendEvent(LegendEvent.DATAGRID_UPDATE,_legenData));
			}

		}

		private function OnQueryFault(fault:Object, token:Object = null):void
		{
			//place3
			Alert.show(_newLegendUtil.alertMsg.faultError.alertmessage,_newLegendUtil.alertMsg.faultError.alertheader);
			dispatchEvent(new Event(LegendEvent.DATAGRID_UPDATE_FAULT,true));
			CursorManager.removeBusyCursor();
		}


		public function doQueryForCheck(legendDetails:Object,legendMap:Map,selectedItemId:String):void
		{
			if(legendDetails != null && legendMap != null)
			{
				arrData = new ArrayCollection();
				_legendDetails = legendDetails;
				_map = legendMap;
				index = 0;
				var queryUrl:String;
				if(selectedItemId == "unCheck")
					queryUrl = (_map.getLayer(_legendDetails.lname) as ArcGISDynamicMapServiceLayer).url + "/" + _legendDetails.id;
				var queryTask:QueryTask = new QueryTask(queryUrl);
				queryTask.useAMF = false;
				var query:Query = new Query();
				query.where = "1=1";
				query.outFields = ["*"];
				query.geometry = _map.extent;
				query.outSpatialReference = _map.spatialReference;
				query.returnGeometry = false;
				queryTask.showBusyCursor = true;

				queryTask.execute(query, new AsyncResponder(onCheckResultHandler, onFaultHandler,{"legendDetails":_legendDetails,"selectedItemId":selectedItemId}));

			}
		}

		private function onCheckResultHandler(featureSet:FeatureSet, token:Object = null):void
		{
			index++;
			var str:String = "";
			_newLegendUtil.legendCollection = new ArrayCollection();
			for each (var featureGraphic:Graphic in featureSet.features)
			{
				for each(var objRenderer:Object in _newLegendUtil.fieldArr[token.legendDetails.label].source)
				{
					if(objRenderer.rendererType == "uniqueValue")
					{
						if(featureGraphic.attributes[_newLegendUtil.strEventField] == objRenderer.value)
						{
							if(!_newLegendUtil.legendCollection.contains(objRenderer))
								_newLegendUtil.legendCollection.addItem(objRenderer);
							break;
						}
					}
					else if(objRenderer.rendererType == "simple")
					{
						if(!_newLegendUtil.legendCollection.contains(objRenderer))
							_newLegendUtil.legendCollection.addItem(objRenderer);
						break;
					}
					else if(objRenderer.rendererType == "classBreaks")
					{
						if(featureGraphic.attributes[_newLegendUtil.classBreakRend]  > objRenderer.minValue && featureGraphic.attributes[_newLegendUtil.classBreakRend] < objRenderer.maxValue)
						{
							if(!_newLegendUtil.legendCollection.contains(objRenderer))
								_newLegendUtil.legendCollection.addItem(objRenderer);
							break;
						}
					}

				}
			}
			if(token.selectedItemId == "unCheck")
			{
				if(_newLegendUtil.legendCollection.length > 0)
				{
					_legenData = new LegendData();
					_legenData.legendCollection = _newLegendUtil.legendCollection;
					_legenData.selectedName = token.legendDetails.label;
					dispatchEvent(new LegendEvent(LegendEvent.CHECK_BOX_LIST_UPDATE,_legenData));
				}
				else
				{
					_legenData = new LegendData();
					_legenData.data = token.legendDetails;
					_legenData.selectedName = token.legendDetails.label;
					dispatchEvent(new LegendEvent(LegendEvent.NO_RESULT_FOUND,_legenData));
				}
			}
		}
	}
}