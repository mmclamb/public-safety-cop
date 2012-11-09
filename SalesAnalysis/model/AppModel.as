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
package widgets.SalesAnalysis.model
{
	import widgets.SalesAnalysis.controller.WidgetConfigParser;
	import widgets.SalesAnalysis.presenter.ChartPresenter;
	import widgets.SalesAnalysis.presenter.HelpPresenter;
	import widgets.SalesAnalysis.presenter.LoadingPresenter;
	import widgets.SalesAnalysis.presenter.MainPresenter;
	import widgets.SalesAnalysis.presenter.ResultsPresenter;
	import widgets.SalesAnalysis.presenter.SearchPresenter;


	public class AppModel
	{
		public var widgetConfigParser:WidgetConfigParser;

		public var loadingPresenter:LoadingPresenter;
		public var helpPresenter:HelpPresenter;
		public var mainPresenter:MainPresenter;
		public var searchPresenter:SearchPresenter;
		public var resultsPresenter:ResultsPresenter;
		public var chartPresenter:ChartPresenter;


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