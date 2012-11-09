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

	public class MapSelectionEvent extends Event
	{
		public static const DRAW_EVENT_COMPLETE:String = "drawEventComplete";
		public static const SELECTED_GRAPHIC_EVENT:String = "selectedGraphicEvent";

		public var graphic:Graphic;

		public function MapSelectionEvent(type:String, value:Graphic)
		{
			super(type);
			graphic = value;
		}
		override public function clone():Event
		{
			return new MapSelectionEvent(type, graphic);
		}
		override public function toString():String
		{
			return formatToString("MapSelectionEvent", "type", "graphic",
				"eventPhase");
		}
	}//end of class
}