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
	import com.esri.ags.Graphic;

	import mx.collections.ArrayCollection;

	public class SalesAnalysisModel
	{
		public var resultsGraphicData:ArrayCollection;
		public var chartGraphicData:ArrayCollection;
		public var resultsSelectedItem:Object;
		public var chartSelectedItem:Object;
		public var mapSelectedGraphic:Graphic;

		private static var instance:SalesAnalysisModel;

		public function SalesAnalysisModel()
		{
			if (instance)
			{
				throw new Error("Please call SalesAnalysisModel.getInstance() instead of new.");
			}
		}
		public static function getInstance():SalesAnalysisModel
		{
			if (!instance)
			{
				instance = new SalesAnalysisModel();
			}
			return instance;
		}
	}
}