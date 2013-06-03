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
package widgets.AdvanceDraw.nzgc.viewer.components
{

	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.formatters.NumberFormatter;

	import spark.components.DataGroup;
	import spark.components.supportClasses.ItemRenderer;

	import widgets.AdvanceDraw.nzgc.viewer.components.supportClasses.GraphicPropertiesItemRenderer;

	// these events bubble up from the GraphicPropertiesItemRenderer
	[Event(name="graphicClick", type="flash.events.Event")]
	[Event(name="graphicDoubleClick", type="flash.events.Event")]
	[Event(name="graphicDelete", type="flash.events.Event")]
	[Event(name="graphicEditProperties", type="flash.events.Event")]
	[Event(name="graphicMouseOver", type="flash.events.Event")]
	[Event(name="graphicMouseOut", type="flash.events.Event")]
	[Event(name="graphicBuffer", type="flash.events.Event")]
	[Event(name="graphicLabelMeasurements", type="flash.events.Event")]
	[Event(name="graphicHideMeasurements", type="flash.events.Event")]
	[Event(name="graphicCopy", type="flash.events.Event")]
	[Event(name="graphicPaste", type="flash.events.Event")]
	[Event(name="graphicTag", type="flash.events.Event")]
	[Event(name="graphicZoomTo", type="flash.events.Event")]

	/**
	 * Data component used to display smmary details for a
	 */
	public class GraphicDataGroup extends DataGroup
	{
		/* -------------------------------------------------------------------
		Component constructor
		---------------------------------------------------------------------- */

		public function GraphicDataGroup()
		{
			// Initialise base class
			super();

			// Set itemrenderer
			this.itemRenderer = new ClassFactory(GraphicPropertiesItemRenderer);
		}

		/* -------------------------------------------------------------------
		Component constants
		---------------------------------------------------------------------- */

		// Item event id constants
		public static const GRAPHIC_CLICK:String = "graphicClick";
		public static const GRAPHIC_DOUBLE_CLICK:String = "graphicDoubleClick";
		public static const GRAPHIC_MOUSE_OVER:String = "graphicMouseOver";
		public static const GRAPHIC_MOUSE_OUT:String = "graphicMouseOut";
		public static const GRAPHIC_DELETE:String = "graphicDelete";
		public static const GRAPHIC_EDIT_PROPERTIES:String = "graphicEditProperties";
		public static const GRAPHIC_BUFFER:String = "graphicBuffer";
		public static const GRAPHIC_COPY:String = "graphicCopy";
		public static const GRAPHIC_PASTE:String = "graphicPaste";
		public static const GRAPHIC_LABELMEASUREMENTS:String = "graphicLabelMeasurements";
		public static const GRAPHIC_HIDEMEASUREMENTS:String = "graphicHideMeasurements";
		public static const GRAPHIC_ZOOMTO:String = "graphicZoomTo";
		public static const GRAPHIC_TAG:String = "graphicTag";

		private const defaultLengthFormat:Object = { label: 'Meters', abbr: 'm', conversion: 1, precision: 0 };
		private const defaultAreaFormat:Object = { label: 'Square Meters', abbr: 'm²', conversion: 1, precision: 0 };



		/* -------------------------------------------------------------------
		Component variables
		---------------------------------------------------------------------- */

		// Number formatter for setting the format of areas, etc
		private var _numberformatter:NumberFormatter;

		// Measurement format setting objects
		private var _lengthFormat:Object = defaultLengthFormat;
		private var _areaFormat:Object = defaultAreaFormat;



		/* -------------------------------------------------------------------
		Component properties
		---------------------------------------------------------------------- */

		/**
		 * Number formatter used to format the style of areas and lengths rendered in the results
		 */
		[Bindable]
		public function set numberFormatter(value:NumberFormatter):void
		{
			if (value)
			{
				_numberformatter = value;
			}
			else
			{
				_numberformatter = new NumberFormatter();
			}
		}

		public function get numberFormatter():NumberFormatter
		{
			return _numberformatter;
		}


		/**
		 * Object containing the formatting properties
		 */
		[Bindable]
		public function set lengthFormat(value:Object):void
		{
			if (value)
			{
				_lengthFormat = value;
			}
			else
			{
				_lengthFormat = defaultLengthFormat;
			}
		}

		public function get lengthFormat():Object
		{
			return _lengthFormat;
		}

		/**
		 * Object containing the formatting properties
		 */
		[Bindable]
		public function set areaFormat(value:Object):void
		{
			if (value)
			{
				_areaFormat = value;
			}
			else
			{
				_areaFormat = defaultAreaFormat;
			}
		}

		public function get areaFormat():Object
		{
			return _areaFormat;
		}


		/* -------------------------------------------------------------------
		Component constructor
		---------------------------------------------------------------------- */


		/* -------------------------------------------------------------------
		Component actions
		---------------------------------------------------------------------- */

	}
}