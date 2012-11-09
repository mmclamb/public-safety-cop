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
package widgets.TrackingPlayback.presenter
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.ProgressBar;
	import mx.events.FlexEvent;
	
	public class LoadingPresenter extends EventDispatcher
	{
		private var _message:String = "Initializing configuration...";
		
		private var _dispatcher:EventDispatcher;
		
		
		private var _progressBar:ProgressBar;
		
		public function LoadingPresenter(dispatcher:EventDispatcher)
		{
			_dispatcher = dispatcher;
		}
		
		
		
		[Bindable(event="messageChange")]
		public function get message():String
		{
			return _message;
		}

		public function set message(value:String):void
		{
			if( _message !== value)
			{
				_message = value;
				dispatchEvent(new Event("messageChange"));
			}
		}



	}
}