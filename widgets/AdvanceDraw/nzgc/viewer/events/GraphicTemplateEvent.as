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
package widgets.AdvanceDraw.nzgc.viewer.events
{

	import flash.events.Event;

	import widgets.AdvanceDraw.nzgc.viewer.components.supportClasses.GraphicTemplate;


	public class GraphicTemplateEvent extends Event
	{
		public function GraphicTemplateEvent(type:String, selectedTemplate:GraphicTemplate = null)
		{
			super(type);

			_template = selectedTemplate;
		}

		public static const SELECTED_TEMPLATE_CHANGE:String = "selectedTemplateChange";


		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		private var _template:GraphicTemplate;

		/**
		 * The template will be passed via the event. It allows the event dispatcher to publish
		 * data to event listener(s).
		 */
		public function get selectedTemplate():GraphicTemplate
		{
			return _template;
		}

		/**
		 * @private
		 */
		public function set selectedTemplate(value:GraphicTemplate):void
		{
			_template = value;
		}


		public override function clone():Event
		{
			return new GraphicTemplateEvent(this.type, this.selectedTemplate);
		}

	}
}