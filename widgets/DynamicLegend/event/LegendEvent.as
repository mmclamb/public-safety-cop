/*
 | Version 10.2
 | Copyright 2013 Esri
 |
 | Licensed under the Apache License, Version 2.0 (the "License");
 | you may not use this file except in compliance with the License.
 | You may obtain a copy of the License at
 |
 |    http://www.apache.org/licenses/LICENSE-2.0
 |
 | Unless required by applicable law or agreed to in writing, software
 | distributed under the License is distributed on an "AS IS" BASIS,
 | WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 | See the License for the specific language governing permissions and
 | limitations under the License.
 */
package widgets.DynamicLegend.event
{
	import flash.events.Event;

	import widgets.DynamicLegend.vo.LegendData;



	public class LegendEvent extends Event
	{
		public static const LIST_UPDATE:String = "ListUpdate";

		public static const DATAGRID_UPDATE:String = "datagridUpdate";

		public static const DATAGRID_UPDATE_FAULT:String="dataGridUpdateFault"

		public static const CHECK_BOX_SELECTED:String = "onCheckBoxSelected";

		public static const CHECK_BOX_LIST_UPDATE:String = "onCheckLIstUpdate";

		public static const NO_RESULT_FOUND:String = "noResultFound";

		public static const NO_RESULT_FOUND_FOR_ALL:String = "noResultFoundForAll";

		public var legendData:LegendData;
		public function LegendEvent(type:String, legendData:LegendData)
		{
			super(type);
			this.legendData = legendData;
		}
	}
}