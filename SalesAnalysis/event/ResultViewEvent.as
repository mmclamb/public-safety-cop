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
	import com.esri.ags.Graphic;

	import flash.events.Event;
	/**
	 *
	 *
	 */
	public class ResultViewEvent extends Event
	{
		/**
		 * An item in the DataGrid has been selected
		 */
		public static const RESULT_ITEM_SELECTED:String = "resultItemSelected";
		/**
		 * An item in the DataGrid has been rolled over
		 */
		public static const RESULT_ITEM_ROLLOVER:String = "resultItemRollOver";
		/**
		 * Clear the search results
		 */
		public static const CLEAR_SEARCH_RESULTS:String = "clearSearchResults";
		/**
		 * Show the sales chart
		 */
		public static const SHOW_SALES_CHART:String = "showSalesChart";
		/**
		 * Export the results to xls or csv
		 */
		public static const EXPORT_RESULTS_TO_EXCEL:String = "exportResultsToExcel";

		/**
		 * The record in the DataGrid that is a Graphic Object
		 */
		public var graphic:Graphic;
		/**
		 *
		 * @param type The constant representing the event type
		 * @param value The graphic to pass along with this event
		 *
		 */
		public function ResultViewEvent(type:String, value:Graphic=null)
		{
			super(type);
			graphic = value;
		}
		/**
		 * @private
		 */
		override public function clone():Event
		{
			return new ResultViewEvent(type, graphic);
		}
		/**
		 * @private
		 */
		override public function toString():String
		{
			return formatToString("SalesResultEvent", "type", "graphic");
		}

	}
}