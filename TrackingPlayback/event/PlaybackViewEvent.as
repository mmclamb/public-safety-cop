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
	
	public class PlaybackViewEvent extends Event
	{
		public static const TIME_EXTENT_CHANGE:String = "timeExtentChange";
		public static const VEHICLE_SELECTION_CHANGE:String = "vehicleSelectionChange";
		
		public function PlaybackViewEvent(type:String)
		{
			super(type);
		}
		override public function clone():Event
		{
			return new PlaybackViewEvent(type);
		}
	}
}