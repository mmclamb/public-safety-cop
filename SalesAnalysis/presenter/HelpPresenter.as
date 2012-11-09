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
package widgets.SalesAnalysis.presenter
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import widgets.SalesAnalysis.event.ViewNavigationEvent;
	import widgets.SalesAnalysis.model.ConfigModel;


	public class HelpPresenter extends EventDispatcher
	{
		private var _dispatcher:EventDispatcher;
		private var _configModel:ConfigModel;

		private var _helpDirections:String

		public function HelpPresenter(dispatcher:EventDispatcher)
		{
			_dispatcher = dispatcher;
			_configModel = ConfigModel.getInstance();
		}
		public function initalizeConfiguration():void
		{
			_helpDirections = _configModel.helpText;
		}

		public function goBack():void
		{
			_dispatcher.dispatchEvent(new ViewNavigationEvent(ViewNavigationEvent.GO_BACK_EVENT));
		}

		[Bindable]
		public function get helpDirections():String
		{
			return _helpDirections;
		}

		public function set helpDirections(value:String):void
		{
			_helpDirections = value;
		}

	}
}