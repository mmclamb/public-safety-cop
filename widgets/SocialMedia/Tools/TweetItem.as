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
	import com.esri.ags.geometry.MapPoint;

	public class TweetItem {
		public var title:String;

		public var content:String;

		public var authorName:String;

		public var authorUri:String;

		public var authorPhoto:String;

		public var publishDate:String;

		public var point:MapPoint;

		public var screenName:String;
	}
}