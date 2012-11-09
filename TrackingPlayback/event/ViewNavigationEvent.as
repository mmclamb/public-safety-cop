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
package widgets.TrackingPlayback.event
{
	import flash.events.Event;
	
	public class ViewNavigationEvent extends Event
	{
		public static const GO_BACK_EVENT:String = "goBackEvent";
		public static const GO_HELP_EVENT:String = "goHelpEvent";
		public static const GO_SEARCH_EVENT:String = "goSearchEvent";
		public static const GO_RESULTS_EVENT:String = "goResultsEvent";
		
		public function ViewNavigationEvent(type:String)
		{
			super(type);
		}
		
		override public function clone():Event
		{
			return new ViewNavigationEvent(type);
		}
		
	}
}