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
package widgets.SocialMedia.Tools
{
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.utils.WebMercatorUtil;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import mx.collections.ArrayCollection;
	import mx.events.MetadataEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	import widgets.SocialMedia.Events.ResultsReadyEvent;
	import widgets.SocialMedia.Events.SocialMediaType;

	[Event(type="widgets.SocialMedia.Events.ResultsReadyEvent")]
	public class FlickrTool implements IEventDispatcher
	{
		private var eventDispatcher:EventDispatcher;

		public function FlickrTool()
		{
			eventDispatcher = new EventDispatcher(this);
		}

		public function SearchByLocation(keyword:String, dateFrom:String, dateTo:String, location:MapPoint, radius:int, units:String="km", numPerPage:Number=250, page:Number=1):void {
			var flickrUrl:String = "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=6a7a86d0b0bc214b0ed80dffc1471313";
			var params:String = "&tags=" + keyword + "&tag_mode=all&accuracy=6&has_geo=1&license=0,1,2,3&page" + page + "&per_page=" + numPerPage;
			var extras:String =	"&extras=date_taken,all_extras,geo,owner_name,license,o_dims";

			if (location != null) params += "&lat=" + location.y + "&lon=" + location.x + "&radius=" + radius + "&radius_units=" + units;
			if (dateFrom != null && dateFrom != "") params += "&min_upload_date=" + dateFrom;
			if (dateTo != null && dateTo != "") params += "&max_upload_date=" + dateTo;

			var flickrService:HTTPService = new HTTPService();
			flickrService.useProxy = false;
			flickrService.url = flickrUrl + params + extras;
			flickrService.resultFormat = "e4x";
			flickrService.addEventListener(ResultEvent.RESULT, HttpServiceResult);
			flickrService.addEventListener(FaultEvent.FAULT, HttpServiceFault);
			flickrService.send();
		}

		public function SearchByExtent(keyword:String, dateFrom:String, dateTo:String, extent:Extent, numPerPage:Number=250, page:Number=1):void {
			var flickrUrl:String = "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=fe7e074f8dad46678841c585f38620b7";
			var params:String = "&tags=" + keyword + "&tag_mode=all&accuracy=6&has_geo=1&license=0,1,2,3&page" + page + "&per_page=" + numPerPage;
			var extras:String =	"&extras=date_taken,all_extras,geo,owner_name,license,o_dims";

			if (extent != null) params += "&bbox=" + extent.xmin + "," + extent.ymin + "," + extent.xmax + "," + + extent.ymax;
			if (dateFrom != null && dateFrom != "") params += "&min_upload_date=" + dateFrom;
			if (dateTo != null && dateTo != "") params += "&max_upload_date=" + dateTo;

			var flickrService:HTTPService = new HTTPService();
			flickrService.useProxy = false;
			flickrService.url = flickrUrl + params + extras;
			flickrService.resultFormat = "e4x";
			flickrService.addEventListener(ResultEvent.RESULT, HttpServiceResult);
			flickrService.addEventListener(FaultEvent.FAULT, HttpServiceFault);
			flickrService.send();
		}

		//config fault
		private function HttpServiceFault(event:mx.rpc.events.FaultEvent):void
		{
			var sInfo:String = "Error: ";
			sInfo += "Event Target: " + event.target + "\n\n";
			sInfo += "Event Type: " + event.type + "\n\n";
			sInfo += "Fault Code: " + event.fault.faultCode + "\n\n";
			sInfo += "Fault Info: " + event.fault.faultString;
		    dispatchEvent(new ResultsReadyEvent(SocialMediaType.Flickr, null, sInfo));
		}

		//config result
		private function HttpServiceResult(event:ResultEvent):ArrayCollection
		{
			var flickrs:ArrayCollection = new ArrayCollection();

			try
			{
				var xmlResult:XML = XML(event.result);
				var stat:String = xmlResult.@stat;
				if (stat == "ok") {
					var results:XMLList = xmlResult.child(0).children();

					for each (var result:XML in results)
					{
						var item:FlickrItem = new FlickrItem();
						item.title = result.@title;
						item.imageUrl = "http://farm" + result.@farm + ".static.flickr.com/" + result.@server + "/" + result.@id + "_" + result.@secret+ ".jpg";
						item.ownerName = result.@ownername;
						item.dateTaken = result.@datetaken;
						//item.height = result.@o_height;
						//item.width = result.@o_width;
						item.point = (WebMercatorUtil.geographicToWebMercator(new MapPoint(Number(result.@longitude),Number(result.@latitude),new SpatialReference(102100)) as Geometry) as MapPoint)



						flickrs.addItem(item);
					}

					dispatchEvent(new ResultsReadyEvent(SocialMediaType.Flickr, flickrs, ""));
				}
				else if (stat == "fail") {
					dispatchEvent(new ResultsReadyEvent(SocialMediaType.Flickr, null, xmlResult.err.@msg));
				}
			}
			catch (error:Error)
			{
				dispatchEvent(new ResultsReadyEvent(SocialMediaType.Flickr, null, "An error occurred while parsing the Flickr results. " + error.message));
			}

			return flickrs;
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