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
package widgets.DynamicLegend.vo
{
	import mx.collections.ArrayCollection;

	public class LegendData
	{
		public var legendCollection:ArrayCollection = null;
		public var selectedName:String = "";
		public var resultDataGrid:ArrayCollection = null;
		public var chkSelected:Boolean = false;
		public var data:Object = null;
		public var onChangeListUpdate:Boolean = false;
		public var selectedData:Object = null;
		public var lname:String="";
	}
}