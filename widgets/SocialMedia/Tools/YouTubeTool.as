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
	import com.esri.ags.Map;
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.utils.JSONUtil;

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
	public class YouTubeTool implements IEventDispatcher
	{
		private static const YT:Namespace = Namespaces.YOUTUBE_NS;
		private static const GML:Namespace = Namespaces.GML_NS;
		private static const ATOM:Namespace = Namespaces.ATOM_NS;
		private static const MEDIA:Namespace = Namespaces.MEDIA_NS;
		private static const GEORSS:Namespace = Namespaces.GEORSS_NS;

		private var proxyUrl:String = "";
		private var eventDispatcher:EventDispatcher;
		private var _map:Map;

		public function set ProxyUrl(proxy:String):void {
			this.proxyUrl =	proxy;
		}

		public function get ProxyUrl():String {
			return this.proxyUrl;
		}

		public function YouTubeTool()
		{
			eventDispatcher = new EventDispatcher(this);
		}

		public function Search(keyword:String, fromDay:String, location:MapPoint, radius:Number, units:String, maxResults:Number=50, startIndex:Number=1):void {

			var youTubeUrl:String = "http://gdata.youtube.com/feeds/api/videos?"
			youTubeUrl += "q=" + keyword + "&time="+ fromDay + "&start-index=" + startIndex + "&max-results=" + maxResults;
			youTubeUrl += "&location=" + location.y + "," + location.x + "&location-radius=" + radius + "km";
			youTubeUrl += "&format=5&v=2&lr=en&alt=json";

			if (proxyUrl != "") {
				youTubeUrl = proxyUrl + "?" + youTubeUrl;
			}

			var youTubeService:HTTPService = new HTTPService();
			youTubeService.useProxy = false;
			youTubeService.url = youTubeUrl;
			youTubeService.resultFormat = "text";
			youTubeService.addEventListener(ResultEvent.RESULT, HttpServiceResult);
			youTubeService.addEventListener(FaultEvent.FAULT, HttpServiceFault);
			youTubeService.send();
		}

		//config fault
		private function HttpServiceFault(event:mx.rpc.events.FaultEvent):void
		{
			var sInfo:String = "Error: ";
			sInfo += "Event Target: " + event.target + "\n\n";
			sInfo += "Event Type: " + event.type + "\n\n";
			sInfo += "Fault Code: " + event.fault.faultCode + "\n\n";
			sInfo += "Fault Info: " + event.fault.faultString;
		    dispatchEvent(new ResultsReadyEvent(SocialMediaType.YouTube, null, sInfo));
		}

		//config result
		private function HttpServiceResult(event:ResultEvent):void
		{
			var videos:ArrayCollection = new ArrayCollection();

			try
			{
				var xmlResult:String = event.result as String;
				var entries:Object = JSON.parse(xmlResult);
				var entry:Array = entries.feed.entry;
				if (entry.length > 0) {
					for each (var entryXML:Object in entry) {
						var ytItem:YouTubeItem = new YouTubeItem();

						ytItem.title= entryXML.title.$t;
						ytItem.mediaUrl = entryXML.content.src;
						ytItem.publishDate = entryXML.published.$t;

						var mediaGroups:Object = entryXML.media$group;
						if (mediaGroups!=null) {
							ytItem.id = mediaGroups.yt$videoid.$t;
							//ytItem.aspectRatio = mediaGroups[0].YT::aspectRatio;
							ytItem.description = mediaGroups.media$description.$t;

							var thumbnails:Array = mediaGroups.media$thumbnail as Array;
							if (thumbnails && thumbnails.length > 0) {
								ytItem.thumbnail = thumbnails[0].url;
							}
						}

						var whereList:Object = entryXML.georss$where;
						if (whereList !=null)
						{
							var pos:String    = whereList.gml$Point.gml$pos.$t;
							var arr:Array     = pos.split(" ");
							var gmlLat:Number = Number(arr[0]);
							var gmlLon:Number = Number(arr[1]);
							ytItem.point = new MapPoint(gmlLon, gmlLat,new SpatialReference(102100));
							videos.addItem(ytItem)
						}
					}
				}

				dispatchEvent(new ResultsReadyEvent(SocialMediaType.YouTube, videos, ""));
			}
			catch (error:Error)
			{
				dispatchEvent(new ResultsReadyEvent(SocialMediaType.YouTube, null, "An error occurred while parsing the youTube results. " + error.message));
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