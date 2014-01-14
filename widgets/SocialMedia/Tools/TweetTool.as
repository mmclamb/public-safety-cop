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
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.utils.JSONUtil;
	import com.esri.ags.utils.WebMercatorUtil;
	import com.esri.viewer.components.toc.utils.MapUtil;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.MetadataEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	import widgets.SocialMedia.Events.ResultsReadyEvent;
	import widgets.SocialMedia.Events.SocialMediaType;


	[Event(type="widgets.SocialMedia.Events.ResultsReadyEvent")]
	public class TweetTool implements IEventDispatcher
	{
		private static const ATOM:Namespace = Namespaces.ATOM_NS;
		private static const GEORSS:Namespace = Namespaces.GEORSS_NS;
		private static const TWITTER:Namespace = Namespaces.TWITTER_NS;
		private var proxyUrl:String = "";
		public function set ProxyUrl(proxy:String):void {
			this.proxyUrl =	proxy;
		}

		public function get ProxyUrl():String {
			return this.proxyUrl;
		}
		private var eventDispatcher:EventDispatcher;

		public function TweetTool()
		{
			eventDispatcher = new EventDispatcher(this);
		}


		private var accessPin:String;
		private var accessToken:String;
		private var accessTokenSecret:String;
		private var customerName:String;
		private var numberOfPages:Number;
		public function Search(keyword:String=null, since:String=null, location:MapPoint=null, radius:Number=NaN, units:String=null, numPerPage:Number=100, page:Number=1, queryString:String=""):void
		{
			var tweetUrl:String = "https://api.twitter.com/1.1/search/tweets.json";

			if(queryString=="")
			{
				numberOfPages=page;
				tweets= new ArrayCollection();
				tweetUrl += "?q=" + keyword + "&until="+ since  + "&count=" + numPerPage;
				tweetUrl += "&geocode=" + location.y + "%2C" + location.x + "%2C" + radius + "km";
				tweetUrl += "&result_type=mixed";
				tweetUrl += "&locale=en";
			}
			else
			{
				tweetUrl +=queryString;
			}
 			var tweetService:HTTPService = new HTTPService();
			tweetService.useProxy = false;
			if(ProxyUrl!=""){
				tweetUrl = ProxyUrl+"?"+tweetUrl;
			}
			tweetService.url=tweetUrl;
			tweetService.resultFormat = "text";
			tweetService.addEventListener(ResultEvent.RESULT, HttpServiceResult);
			tweetService.addEventListener(FaultEvent.FAULT, HttpServiceFault);
			tweetService.send();
		}

		//config fault
		private function HttpServiceFault(event:mx.rpc.events.FaultEvent):void
		{
			strQueryString=null;
			var sInfo:String = "Error: ";
			sInfo += "Event Target: " + event.target + "\n";
			sInfo += "Event Type: " + event.type + "\n";
			sInfo += "Fault Code: " + event.fault.faultCode + "\n";
			sInfo += "Fault Info: " + event.fault.faultString;
		    dispatchEvent(new ResultsReadyEvent(SocialMediaType.Tweet, null, sInfo));
		}

		private var strQueryString:String;
		private var tweets:ArrayCollection = new ArrayCollection();

		//config result
		private function HttpServiceResult(event:ResultEvent):void
		{
			numberOfPages--;


				var xmlResult:XML = XML(event.result);
				var entries:Object=JSONUtil.decode(event.result.toString() );
				var entryarray:Array= entries.statuses;
				if (entryarray.length > 0) {
					for each (var entryObject:Object in entryarray) {
						var tweetItem:TweetItem = new TweetItem();

						tweetItem.title =entryObject.text ;
						tweetItem.content = entryObject.text;
						tweetItem.publishDate =entryObject.created_at;
						tweetItem.authorName =entryObject.user.name;
						tweetItem.authorUri = entryObject.user.url;
						tweetItem.screenName=entryObject.user.screen_name;
						var links:String = entryObject.user.profile_image_url;
							tweetItem.authorPhoto = links;

						var arr:Array=new Array() ;
						var gmlLat:Number =new Number();
						var gmlLon:Number =new Number();
						var geoXML:Object = entryObject.geo;
						if (geoXML != null )
						{
							arr = geoXML.coordinates;
							gmlLat = Number(arr[0]);
							gmlLon = Number(arr[1]);
							tweetItem.point =(WebMercatorUtil.geographicToWebMercator(new MapPoint(gmlLon,gmlLat,new SpatialReference(102100)) as Geometry) as MapPoint);
							tweets.addItem(tweetItem);
						}
						else
						{
							var n:String = (entryObject.user.location as String);
							if (n)
							{
								if (n.indexOf("iPhone:") > -1)
								{
									n = n.slice(7);
									arr = n.split(",");
									gmlLat = Number(arr[0]);
									gmlLon = Number(arr[1]);
									tweetItem.point =(WebMercatorUtil.geographicToWebMercator(new MapPoint(gmlLon,gmlLat,new SpatialReference(102100)) as Geometry) as MapPoint);
									tweets.addItem(tweetItem);
								}
								else if (n.indexOf("ÜT") > -1)
								{
									n = n.slice(3);
									arr = n.split(",");
									gmlLat = Number(arr[0]);
									gmlLon= Number(arr[1]);
									tweetItem.point =(WebMercatorUtil.geographicToWebMercator(new MapPoint(gmlLon,gmlLat,new SpatialReference(102100)) as Geometry) as MapPoint);
									tweets.addItem(tweetItem);
								}
								else if (n.indexOf("T") === 1)
								{
									n = n.slice(3);
									arr = n.split(",");
									gmlLat = Number(arr[0]);
									gmlLon = Number(arr[1]);
									tweetItem.point =(WebMercatorUtil.geographicToWebMercator(new MapPoint(gmlLon,gmlLat,new SpatialReference(102100)) as Geometry) as MapPoint);
									tweets.addItem(tweetItem);
								}
								else if (n.indexOf("Pre:") > -1)
								{
									n = n.slice(4);
									arr = n.split(",");
									gmlLat = Number(arr[0]);
									gmlLon = Number(arr[1]);
									tweetItem.point =(WebMercatorUtil.geographicToWebMercator(new MapPoint(gmlLon,gmlLat,new SpatialReference(102100)) as Geometry) as MapPoint);
									tweets.addItem(tweetItem);
								}
								else if (n.split(",").length === 2)
								{
									arr = n.split(",");
									gmlLat = Number(arr[0]);
									gmlLon = Number(arr[1]);
									if(!(gmlLat is Number)&&!(gmlLon is Number))
									{
										tweetItem.point =(WebMercatorUtil.geographicToWebMercator(new MapPoint(gmlLon,gmlLat,new SpatialReference(102100)) as Geometry) as MapPoint);
										tweets.addItem(tweetItem);
									}
								}
							}
						}
					}
					if(numberOfPages>0&&entries.search_metadata.next_results)
					{
						strQueryString=entries.search_metadata.next_results;
						Search(null,null,null,NaN,null,100,1,strQueryString);
					}
					else
					{
						strQueryString=null;
						dispatchEvent(new ResultsReadyEvent(SocialMediaType.Tweet, tweets, ""));
					}
				}
				else
				{
					dispatchEvent(new ResultsReadyEvent(SocialMediaType.Tweet, tweets, ""));
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