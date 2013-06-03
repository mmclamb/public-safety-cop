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
package widgets.AdvanceDraw.nzgc.viewer.utils
{
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.*;
	import com.esri.ags.layers.GraphicsLayer;

	import mx.utils.ObjectUtil;

	import widgets.AdvanceDraw.nzgc.viewer.components.supportClasses.GraphicPropertiesItem;

	public class GraphicUtil
	{
		/**
		 * Reconstitutes a serialised graphic.
		 */
		public static function SerialObjectToGraphic(object:Object):Graphic
		{
			// Create a new graphic
			var graphic:Graphic = new Graphic();

			// Check that an object was passed through
			if (object)
			{
				// Check the object for a geometry object
				if (object.geometry)
				{
					graphic.geometry = GeometryUtil.ObjectToGeometry(object.geometry);
				}

				// Check the object for a symbol object
				if (object.symbol)
				{
					graphic.symbol = SymbolUtil.SerialObjectToSymbol(object.symbol);
				}

				// Check the object for an attributes object
				if (object.attributes)
				{
					// Check to see if attributes came from a GraphicPropertiesItem
					if (object.attributes && object.attributes.objectType == "GraphicPropertiesItem")
					{
						var props:GraphicPropertiesItem = new widgets.AdvanceDraw.nzgc.viewer.components.supportClasses.GraphicPropertiesItem(graphic);
						props.areaMeasurement = object.attributes.areaMeasurement;
						props.lengthMeasurement = object.attributes.lengthMeasurement;
						props.content = object.attributes.content;
						props.showMeasurements = object.attributes.showMeasurements;
						props.title = object.attributes.title;
						props.link = object.attributes.link;
						props.attributes = object.attributes.attributes;
						graphic.attributes = props;
					}
					else
					{
						graphic.attributes = object.attributes;
					}
				}
			}
			return graphic;
		}

		/**
		 * Serialises a graphic to an object that can be saved.
		 */
		public static function GraphicToSerialObject(graphic:Graphic):Object
		{
			var object:Object = {};

			object.geometry = graphic.geometry;

			if (graphic.attributes is widgets.AdvanceDraw.nzgc.viewer.components.supportClasses.GraphicPropertiesItem)
			{
				object.attributes = GraphicPropertiesItem(graphic.attributes).toObject();
			}
			else
			{
				object.attributes = graphic.attributes;
			}
			object.symbol = SymbolUtil.SymbolToSerialObject(graphic.symbol);

			return object;
		}

		/**
		 * Makes an exact copy of an existing graphic
		 */
		public static function CopyGraphic(copyGraphic:Graphic):Graphic
		{
			// Copy the graphic
			var graphic:Graphic = new Graphic();
			graphic.geometry = copyGraphic.geometry;
			graphic.symbol = SymbolUtil.DuplicateSymbol(copyGraphic.symbol);

			if (copyGraphic.attributes is GraphicPropertiesItem)
			{
				var props:GraphicPropertiesItem = new GraphicPropertiesItem(graphic);
				var copyProps:GraphicPropertiesItem = GraphicPropertiesItem(copyGraphic.attributes);
				props.attributes = copyProps.attributes;
				props.showMeasurements = copyProps.showMeasurements;
				props.title = copyProps.title;
				props.content = copyProps.content;
				props.point = copyProps.point;
				props.link = copyProps.link;
				props.areaMeasurement = copyProps.areaMeasurement;
				props.lengthMeasurement = copyProps.lengthMeasurement;
				graphic.attributes = props;
			}
			else
			{
				graphic.attributes = copyGraphic.attributes;
			}

			return graphic;
		}
	}
}