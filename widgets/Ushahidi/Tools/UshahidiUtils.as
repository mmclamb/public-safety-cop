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
package widgets.Ushahidi.Tools
{
	import com.esri.ags.clusterers.ESRIClusterer;
	import com.esri.ags.clusterers.IClusterer;
	import com.esri.ags.clusterers.WeightedClusterer;
	import com.esri.ags.clusterers.supportClasses.FlareSymbol;
	import com.esri.ags.clusterers.supportClasses.SimpleClusterSymbol;
	import com.esri.ags.symbols.Symbol;
	import com.esri.viewer.utils.Hashtable;

	import flash.text.TextFormat;

	import mx.collections.ArrayCollection;

	[Bindable]
	public class UshahidiUtils
	{
		private static var instance:UshahidiUtils;

		public var proxyUrl:String = "";
		public var apiUrl:String = "";
		public var parameterName:String = "";
		public var parameterLimitValue:Number = 0;
		public var sortByValue:Number = 0;
		public var idValue:Number = 0;
		public var orderField:String="";
		public var categoryDropDownFirstLabel:String="";
		public var categoryDropDownFirstColor:Number=0;

		public static function getInstance():UshahidiUtils
		{
			if(instance == null)
			{
				instance = new UshahidiUtils()
			}
			return instance;
		}

		public function parseConfigXml(configXml:XML):void
		{
			proxyUrl = configXml.proxyUrl.toString();
			apiUrl = configXml.apiUrl.toString();
			parameterName = configXml.parameterName.toString();
			parameterLimitValue = configXml.parameterLimitValue;
			sortByValue=configXml.sortByValue;
			idValue=configXml.idValue;
			orderField=configXml.orderField;
			categoryDropDownFirstLabel=configXml.dropDownFirstLabel[0].toString();
			categoryDropDownFirstColor=new Number(configXml.dropDownFirstColor[0]);

		}

		private function parseClusterSymbol(clusterSymbolXML:XML):Symbol
		{
			var clusterSymbol:Symbol;

			var type:String = clusterSymbolXML.@type;

			if (type == "simple")
			{
				clusterSymbol = parseSimpleClusterSymbol(clusterSymbolXML);
			}
			else if (type == "flare")
			{
				clusterSymbol = parseFlareSymbol(clusterSymbolXML);
			}

			return clusterSymbol;
		}

		private function parseSimpleClusterSymbol(clusterSymbolXML:XML):Symbol
		{
			var simpleClusterSymbol:SimpleClusterSymbol = new SimpleClusterSymbol();

			if (clusterSymbolXML.@alpha[0])
			{
				simpleClusterSymbol.alpha = parseFloat(clusterSymbolXML.@alpha[0]);
			}
			if (clusterSymbolXML.@color[0])
			{
				simpleClusterSymbol.color = parseInt(clusterSymbolXML.@color[0]);
			}
			if (clusterSymbolXML.@size[0])
			{
				simpleClusterSymbol.size = parseFloat(clusterSymbolXML.@size[0]);
			}
			if (clusterSymbolXML.@alphas[0])
			{
				simpleClusterSymbol.alphas = parseAlphas(clusterSymbolXML.@alphas[0]);
			}
			if (clusterSymbolXML.@sizes[0])
			{
				simpleClusterSymbol.sizes = parseSizes(clusterSymbolXML.@sizes[0]);
			}
			if (clusterSymbolXML.@weights[0])
			{
				simpleClusterSymbol.weights = parseWeights(clusterSymbolXML.@weights[0]);
			}
			if (clusterSymbolXML.@colors[0])
			{
				simpleClusterSymbol.colors = parseColors(clusterSymbolXML.@colors[0]);
			}
			var textFormat:TextFormat = parseTextFormat(clusterSymbolXML);

			simpleClusterSymbol.textFormat = textFormat;

			return simpleClusterSymbol;
		}

		public function parseFlareSymbol(flareSymbolXML:XML):Symbol
		{
			var flareSymbol:FlareSymbol = new FlareSymbol();

			if (flareSymbolXML)
			{
				if (flareSymbolXML.@alpha[0])
				{
					flareSymbol.backgroundAlpha = parseFloat(flareSymbolXML.@alpha[0]);
				}
				if (flareSymbolXML.@color[0])
				{
					flareSymbol.backgroundColor = parseInt(flareSymbolXML.@color[0])
				}
				if (flareSymbolXML.@bordercolor[0])
				{
					flareSymbol.borderColor = parseInt(flareSymbolXML.@bordercolor[0]);
				}
				if (flareSymbolXML.@flaremaxcount[0])
				{
					flareSymbol.flareMaxCount = parseInt(flareSymbolXML.@flaremaxcount[0])
				}
				if (flareSymbolXML.@size[0])
				{
					flareSymbol.size = parseFloat(flareSymbolXML.@size[0]);
				}
				if (flareSymbolXML.@alphas[0])
				{
					flareSymbol.backgroundAlphas = parseAlphas(flareSymbolXML.@alphas[0]);
				}
				if (flareSymbolXML.@sizes[0])
				{
					flareSymbol.sizes = parseSizes(flareSymbolXML.@sizes[0]);
				}
				if (flareSymbolXML.@weights[0])
				{
					flareSymbol.weights = parseWeights(flareSymbolXML.@weights[0]);
				}
				if (flareSymbolXML.@colors[0])
				{
					flareSymbol.backgroundColors = parseColors(flareSymbolXML.@colors[0]);
				}

				flareSymbol.textFormat = parseTextFormat(flareSymbolXML);
			}

			return flareSymbol;
		}

		private function parseAlphas(delimitedAlphas:String):Array
		{
			var alphas:Array = [];
			var alphasToParse:Array = delimitedAlphas.split(',');
			for each (var alpha:String in alphasToParse)
			{
				alphas.push(parseFloat(alpha));
			}

			return alphas;
		}

		private function parseSizes(delimitedSizes:String):Array
		{
			var sizes:Array = [];
			var sizesToParse:Array = delimitedSizes.split(',');
			for each (var size:String in sizesToParse)
			{
				sizes.push(parseFloat(size));
			}

			return sizes;
		}

		private function parseColors(delimitedColors:String):Array
		{
			var colors:Array = [];
			var colorsToParse:Array = delimitedColors.split(',');
			for each (var color:String in colorsToParse)
			{
				colors.push(parseInt(color));
			}
			return colors;
		}

		private function parseTextFormat(clusterSymbolXML:XML):TextFormat
		{
			var textFormat:TextFormat = new TextFormat();

			if (clusterSymbolXML.@textcolor[0])
			{
				textFormat.color = parseInt(clusterSymbolXML.@textcolor);
			}
			if (clusterSymbolXML.@textsize[0])
			{
				textFormat.size = parseInt(clusterSymbolXML.@textsize);
			}

			return textFormat;
		}
		private function parseWeights(delimitedWeights:String):Array
		{
			var weights:Array = [];
			var weightsToParse:Array = delimitedWeights.split(',');
			for each (var weight:String in weightsToParse)
			{
				weights.push(parseFloat(weight));
			}

			return weights;
		}
	}
}