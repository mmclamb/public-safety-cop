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
package widgets.TrackingPlayback.service
{
	import com.esri.ags.tasks.DetailsTask;
	import com.esri.ags.tasks.QueryTask;

	public class EsriServiceHolder
	{
		private var _serviceLayerDetailsTask:DetailsTask = new DetailsTask();
		private var _serviceTableDetailsTask:DetailsTask = new DetailsTask();
		private var _serviceQueryTask:QueryTask = new QueryTask();
		/**
		 * Constructor 
		 * 
		 */		
		public function EsriServiceHolder()
		{
		}

		

		public function get serviceQueryTask():QueryTask
		{
			return _serviceQueryTask;
		}

		public function set serviceQueryTask(value:QueryTask):void
		{
			_serviceQueryTask = value;
		}

		public function get serviceLayerDetailsTask():DetailsTask
		{
			return _serviceLayerDetailsTask;
		}

		public function set serviceLayerDetailsTask(value:DetailsTask):void
		{
			_serviceLayerDetailsTask = value;
		}

		public function get serviceTableDetailsTask():DetailsTask
		{
			return _serviceTableDetailsTask;
		}

		public function set serviceTableDetailsTask(value:DetailsTask):void
		{
			_serviceTableDetailsTask = value;
		}


	}
}