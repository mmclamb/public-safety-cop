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
package widgets.Ushahidi.events
{
	import flash.events.Event;

	import mx.collections.ArrayCollection;

	public class ResultsReadyEvent extends Event
	{
		public static const RESULTS_REARDY:String = "MediaResultsReady";

		public var MediaType:String;
		public var ErrorMsg:String = "";
		public var Results:ArrayCollection;

		public function ResultsReadyEvent(mediaType:String, results:ArrayCollection, error:String)
		{
			super(RESULTS_REARDY, false, false);
			this.MediaType = mediaType;
			this.Results = results;
			this.ErrorMsg = error;
		}

		override public function clone():Event
		{
			return new ResultsReadyEvent(this.MediaType, this.Results, this.ErrorMsg);
		}
	}
}