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
package widgets.Ushahidi.Tools
{
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.utils.JSONUtil;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import mx.charts.CategoryAxis;
	import mx.collections.ArrayCollection;
	import mx.events.MetadataEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	import widgets.Ushahidi.events.ResultsReadyEvent;
	import widgets.Ushahidi.events.SocialMediaType;



	public class UshahidiTool implements IEventDispatcher
	{
		private var eventDispatcher:EventDispatcher;
		private var _dataUtil:UshahidiUtils = UshahidiUtils.getInstance();

		public function UshahidiTool()
		{
			eventDispatcher = new EventDispatcher(this);
		}

		private var proxyUrl:String = _dataUtil.proxyUrl;
		public function SearchByLocation(keyword:String,limit:Number):void {
			var UshahidiUrl:String =_dataUtil.apiUrl+"/api?task=incidents&limit="+limit+"&sort="+_dataUtil.sortByValue+"&id="+_dataUtil.idValue+"&orderfield="+_dataUtil.orderField;
			if(proxyUrl!="")
			{
				UshahidiUrl=proxyUrl + "?" +_dataUtil.apiUrl+"/api?task=incidents&limit="+limit+"&sort="+_dataUtil.sortByValue+"&id="+_dataUtil.idValue+"&orderfield="+_dataUtil.orderField;;
			}
			 var params:String = _dataUtil.parameterName + keyword ;
			var UshahidiService:HTTPService = new HTTPService();
			UshahidiService.useProxy = false;
			if(keyword ==_dataUtil.categoryDropDownFirstLabel)
			{
				UshahidiService.url = UshahidiUrl;
			}else
			{
			UshahidiService.url = UshahidiUrl+params ;
			}
			UshahidiService.resultFormat = "e4x";
			UshahidiService.addEventListener(ResultEvent.RESULT, HttpServiceResult);
			UshahidiService.addEventListener(FaultEvent.FAULT, HttpServiceFault);
			UshahidiService.send();
		}



		//config fault
		private function HttpServiceFault(event:mx.rpc.events.FaultEvent):void
		{
			var sInfo:String = "Error: ";
			sInfo += "Event Target: " + event.target + "\n\n";
			sInfo += "Event Type: " + event.type + "\n\n";
			sInfo += "Fault Code: " + event.fault.faultCode + "\n\n";
			sInfo += "Fault Info: " + event.fault.faultString;
			dispatchEvent(new ResultsReadyEvent(SocialMediaType.Ushahidi, null, sInfo));
		}

		//config result
		private function HttpServiceResult(event:ResultEvent):void
		{
			var Ushahidi:ArrayCollection = new ArrayCollection();

			try
			{
				var resultString:String = String(event.result);
				var attributes:Object = JSONUtil.decode(resultString);

				if (attributes.payload.incidents.length>0)
				{


					for (var i:int=0;i<attributes.payload.incidents.length;i++)
					{

						var item:UshahidiItem=new UshahidiItem();
						for(var j:int=0;j<attributes.payload.incidents[i].categories.length;j++)
						{
							item.categoryTitle = attributes.payload.incidents[i].categories[j].category.title;
						}
						item.incidentdescription =attributes.payload.incidents[i].incident.incidentdescription;
						item.incidentid =attributes.payload.incidents[i].incident.incidentid;
						item.incidenttitle = attributes.payload.incidents[i].incident.incidenttitle;
						item.incidentdate = attributes.payload.incidents[i].incident.incidentdate;
						item.locationname = attributes.payload.incidents[i].incident.locationname;

						item.point = new MapPoint(Number(attributes.payload.incidents[i].incident.locationlongitude), Number(attributes.payload.incidents[i].incident.locationlatitude), new SpatialReference(4326));

						Ushahidi.addItem(item);
					}

					dispatchEvent(new ResultsReadyEvent(SocialMediaType.Ushahidi, Ushahidi, ""));
				}
				else  {
					dispatchEvent(new ResultsReadyEvent(SocialMediaType.Ushahidi, null, null));
				}
			}
			catch (error:Error)
			{
				dispatchEvent(new ResultsReadyEvent(SocialMediaType.Ushahidi, null, "An error occurred while parsing the Ushahidi results. " + error.message));
			}


		}

		// Impements IEventDispatcher
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		public function dispatchEvent(event:Event):Boolean {
			return eventDispatcher.dispatchEvent(event);
		}

		public function hasEventListener(type:String):Boolean {
			return eventDispatcher.hasEventListener(type);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		public function willTrigger(type:String):Boolean {
			return eventDispatcher.willTrigger(type);
		}
	}
}