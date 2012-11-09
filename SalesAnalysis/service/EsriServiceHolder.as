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
package widgets.SalesAnalysis.service
{
	import com.esri.ags.tasks.DetailsTask;
	import com.esri.ags.tasks.QueryTask;

	public class EsriServiceHolder
	{
		private var _serviceDetailsTask:DetailsTask = new DetailsTask();
		private var _serviceViewQueryTask:QueryTask = new QueryTask();
		private var _serviceQueryTask:QueryTask = new QueryTask();
		/**
		 * Constructor
		 *
		 */
		public function EsriServiceHolder()
		{
		}

		public function get serviceDetailsTask():DetailsTask
		{
			return _serviceDetailsTask;
		}

		public function set serviceDetailsTask(value:DetailsTask):void
		{
			_serviceDetailsTask = value;
		}

		public function get serviceViewQueryTask():QueryTask
		{
			return _serviceViewQueryTask;
		}

		public function set serviceViewQueryTask(value:QueryTask):void
		{
			_serviceViewQueryTask = value;
		}

		public function get serviceQueryTask():QueryTask
		{
			return _serviceQueryTask;
		}

		public function set serviceQueryTask(value:QueryTask):void
		{
			_serviceQueryTask = value;
		}


	}
}