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
package widgets.TrackingPlayback.model
{
	import widgets.TrackingPlayback.controller.WidgetConfigParser;
	import widgets.TrackingPlayback.presenter.HelpPresenter;
	import widgets.TrackingPlayback.presenter.LoadingPresenter;
	import widgets.TrackingPlayback.presenter.MainPresenter;
	import widgets.TrackingPlayback.presenter.PlaybackPresenter;
	

	public class AppModel
	{
		public var widgetConfigParser:WidgetConfigParser;
		
		public var loadingPresenter:LoadingPresenter;
		public var helpPresenter:HelpPresenter;
		public var mainPresenter:MainPresenter;
		public var playbackPresenter:PlaybackPresenter;
		
		private static var instance:AppModel;
		
		public function AppModel()
		{
			if (instance)
			{
				throw new Error("Please call AppModel.getInstance() instead of new.");
			}
		}
		
		public static function getInstance():AppModel
		{
			if (!instance)
			{
				instance = new AppModel();
			}
			return instance;
		}

	}
}