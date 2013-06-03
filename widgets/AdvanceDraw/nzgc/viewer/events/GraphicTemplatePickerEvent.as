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

	import widgets.AdvanceDraw.nzgc.viewer.components.GraphicTemplatePicker;



	public class GraphicTemplatePickerEvent extends Event
	{
		public function GraphicTemplatePickerEvent(type:String, graphicTemplatePicker:GraphicTemplatePicker)
		{
			super(type);

			_picker = graphicTemplatePicker;
		}

		public static const GRAPHIC_TEMPLATE_PICKER_ORGANISEMODECHANGE:String = "organiseModeChange";
		public static const GRAPHIC_TEMPLATE_PICKER_REMOVETEMPLATE:String = "removeTemplate";
		public static const GRAPHIC_TEMPLATE_PICKER_MODIFYTEMPLATE:String = "modifyTemplate";
		public static const GRAPHIC_TEMPLATE_PICKER_TEMPLATESUPDATED:String = "templatesUpdated";

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		private var _picker:GraphicTemplatePicker;

		/**
		 * The Graphic Template Picker will be passed via the event. It allows the event dispatcher to publish
		 * data to event listener(s).
		 */
		public function get graphicTemplatePicker():GraphicTemplatePicker
		{
			return _picker;
		}

		/**
		 * @private
		 */
		public function set graphicTemplatePicker(value:GraphicTemplatePicker):void
		{
			_picker = value;
		}


		public override function clone():Event
		{
			return new GraphicTemplatePickerEvent(this.type, this.graphicTemplatePicker);
		}


	}
}