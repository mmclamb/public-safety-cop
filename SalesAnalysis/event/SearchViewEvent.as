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
package widgets.SalesAnalysis.event
{
	import com.esri.ags.tasks.supportClasses.Query;

	import flash.events.Event;

	/**
	 * Event class for dispatching event properties from the Sales Analysis Search View
	 *
	 */
	public class SearchViewEvent extends Event
	{
		/**
		 * Constant for event type related to map selection toggle
		 */
		public static const CHANGE_MAP_SELECTION:String = "changeMapSelection";
		/**
		 * Constant for event type related to executing a search
		 */
		public static const EXECUTE_SEARCH:String = "executeSearch";
		/**
		 * Constant for event type related to clearing the search results
		 */
		public static const CLEAR_RESULTS:String = "clearResults";
		/**
		 * Search parameters object
		 */
		public var searchCriteria:Query;
		/**
		 * Boolean for state of map selection toggle button
		 */
		public var mapSelectionToggleEnabled:Boolean;
		/**
		 *
		 * @param type
		 * @param mapSelectionToggle
		 * @param searchParams
		 *
		 */
		public function SearchViewEvent(type:String, mapSelectionToggle:Boolean=false, searchParams:Query=null)
		{
			super(type);
			this.mapSelectionToggleEnabled = mapSelectionToggle;
			this.searchCriteria = searchParams;
		}
		/**
		 * @private
		 */
		override public function clone():Event
		{
			return new SearchViewEvent(type, mapSelectionToggleEnabled, searchCriteria);
		}
		/**
		 * @private
		 */
		override public function toString():String
		{
			return formatToString("SearchViewEvent", "type", "mapSelectionToggleEnabled", "searchParameters",
				"eventPhase");
		}

	}//end class
}//end of package