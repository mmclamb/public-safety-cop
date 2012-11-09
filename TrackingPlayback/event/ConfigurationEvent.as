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
	
	public class ConfigurationEvent extends Event
	{
		public static const PARSE_BEGIN:String = "parseBegin";
		public static const PARSE_COMPLETE:String = "parseComplete";
		public static const LOADING_SERVICE_INFO:String = "loadingServiceInfo";
		
		public static var STEPS:int = 0;
		
		public function ConfigurationEvent(type:String)
		{
			super(type);
		}
		override public function clone():Event
		{
			return new ConfigurationEvent(type);
		}
		override public function toString():String
		{
			return formatToString("ConfigurationEvent", "eventPhase");
		}
	}
}