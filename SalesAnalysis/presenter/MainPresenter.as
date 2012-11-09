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
package widgets.SalesAnalysis.presenter
{
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.events.DrawEvent;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.layers.ArcGISTiledMapServiceLayer;
	import com.esri.ags.layers.FeatureLayer;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.tools.DrawTool;
	import com.esri.stl.ags.layers.supportClasses.FieldFormat;
	import com.esri.stl.ags.utils.DrawToolUtil;
	import com.esri.stl.ags.utils.GeometryUtil;
	import com.esri.stl.utils.FormatterUtil;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	import mx.events.StateChangeEvent;

	import widgets.SalesAnalysis.enum.StateEnum;
	import widgets.SalesAnalysis.event.MapSelectionEvent;
	import widgets.SalesAnalysis.event.SearchViewEvent;
	import widgets.SalesAnalysis.event.ViewNavigationEvent;
	import widgets.SalesAnalysis.model.ConfigModel;
	import widgets.SalesAnalysis.model.SalesAnalysisModel;
	import widgets.SalesAnalysis.model.SymbolHolder;


	public class MainPresenter extends EventDispatcher
	{
		private var _dispatcher:EventDispatcher;
		private var _currentState:String = StateEnum.LOADING_STATE;
		private var _lastState:String;

		private var _map:Map;
		private var _drawTool:DrawTool;
		private var _drawToolEnabled:Boolean = false;
		private var _drawToolType:String;
		private var _drawToolGraphicsLayer:GraphicsLayer;
		private var _resultsGraphicsLayer:GraphicsLayer;
		private var _symbolHolder:SymbolHolder;
		private var _configModel:ConfigModel;
		private var _salesAnalysisModel:SalesAnalysisModel;

		private var _lastSelectedGraphic:Graphic;

		public function MainPresenter(dispatcher:EventDispatcher)
		{
			_dispatcher = dispatcher;
			_configModel = ConfigModel.getInstance();
			_salesAnalysisModel = SalesAnalysisModel.getInstance();

		}

		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------
		public function initializeConfiguration():void
		{
			_symbolHolder = new SymbolHolder();
			_configModel.mapSpatialReference = map.spatialReference;
			_drawToolType = _configModel.mapDrawToolType;
			addLayers();
			configureDrawTool();
		}
		public function goHelp():void
		{
			_dispatcher.dispatchEvent(new ViewNavigationEvent(ViewNavigationEvent.GO_HELP_EVENT));
		}

		public function zoomToExtent(extent:Extent):void
		{
			if(extent)
				map.extent = extent;
		}
		public function clearGraphicsLayers():void
		{
			_drawToolGraphicsLayer.clear();
			_resultsGraphicsLayer.clear();
		}
		public function addGraphics(features:Array):void
		{
			for (var i:int = 0; i < features.length; i++)
			{
				var rGraphic:Graphic = features[i] as Graphic;
				rGraphic.attributes["CHECKBOX"] = true;
				rGraphic.addEventListener(MouseEvent.MOUSE_OVER,resultGraphicMouseOverHandler,false,0,true);
				_resultsGraphicsLayer.add(rGraphic);
			}
		}

		//--------------------------------------------------------------------------
		// Called when the user mouses over a graphic result
		//--------------------------------------------------------------------------
		protected function resultGraphicMouseOverHandler(event:MouseEvent):void
		{

			if(_lastSelectedGraphic)
				_lastSelectedGraphic.symbol = _symbolHolder.salesResultCompositeSymbol;
			var eGraphic:Graphic = Graphic(event.currentTarget);
			eGraphic.symbol = _symbolHolder.selectedItemCompositeSymbol;
			_lastSelectedGraphic = eGraphic;

			//_resultsViewPM.selectedItem = eGraphic;
			_salesAnalysisModel.mapSelectedGraphic = eGraphic;
			_dispatcher.dispatchEvent(new MapSelectionEvent(MapSelectionEvent.SELECTED_GRAPHIC_EVENT,eGraphic));

			var m_toolTip:String = "";
			var m_fieldsOrder:Array = _configModel.fieldsToolTipFieldsUtil.fieldsOrder;
			var m_fieldsDictionary:Dictionary = _configModel.fieldsToolTipFieldsUtil.fieldsDictionary;
			for (var i:int = 0; i < m_fieldsOrder.length; i++)
			{
				var ff:FieldFormat = m_fieldsDictionary[m_fieldsOrder[i]] as FieldFormat;
				if(ff)
				{
					m_toolTip += ff.alias + ": ";//field alias
					if(ff.formatType == FieldFormat.FORMAT_TYPE_CURRENCY)
					{
						m_toolTip += FormatterUtil.formatAsCurrency(eGraphic.attributes[ff.name]) + "\n";
					}
					else if(ff.formatType == FieldFormat.FORMAT_TYPE_DATE)
					{
						m_toolTip += FormatterUtil.formatAsDate(eGraphic.attributes[ff.name],ff.dateFormat) + "\n";
					}
					else if(ff.formatType == FieldFormat.FORMAT_TYPE_NUMBER)
					{
						m_toolTip += FormatterUtil.formatAsNumber(eGraphic.attributes[ff.name],ff.precision) + "\n";
					}
					else if(ff.formatType == FieldFormat.FORMAT_TYPE_PERCENTAGE)
					{
						m_toolTip += FormatterUtil.formatAsPercentage(eGraphic.attributes[ff.name],2) + "\n";
					}
					else
						m_toolTip += eGraphic.attributes[ff.name] + "\n";
				}
			}
			eGraphic.toolTip = m_toolTip;
		}
		//--------------------------------------------------------------------------
		// Called when the user clicks on an item in the DataGrid in the Results View
		//--------------------------------------------------------------------------
		public function zoomToGraphic(value:Graphic):void
		{
			if(_lastSelectedGraphic)
				_lastSelectedGraphic.symbol = _symbolHolder.salesResultCompositeSymbol;
			var gra:Graphic = value;
			_resultsGraphicsLayer.moveToTop(gra);
			gra.symbol = _symbolHolder.selectedItemCompositeSymbol;
			if (map.scale > _configModel.mapZoomScale)
			{
				map.scale = _configModel.mapZoomScale;
			}
			map.centerAt(GeometryUtil.getGeomCenter(gra.geometry));
			_lastSelectedGraphic = value;
		}
		protected function addLayers():void
		{
			_drawToolGraphicsLayer = new GraphicsLayer();
			_drawToolGraphicsLayer.name = "salesAnalysisDrawToolGraphicsLayer";
			_resultsGraphicsLayer = new GraphicsLayer();
			_resultsGraphicsLayer.name = "salesAnalysisResultsGraphicsLayer";
			_resultsGraphicsLayer.symbol = _symbolHolder.salesResultCompositeSymbol;
			_map.addLayer(_resultsGraphicsLayer);
			_map.addLayer(_drawToolGraphicsLayer);
		}
		protected function configureDrawTool():void
		{
			//DrawTool for selecting features
			_drawTool = new DrawTool(_map);
			_drawTool.graphicsLayer = _drawToolGraphicsLayer;
			_drawTool.addEventListener(DrawEvent.DRAW_START,drawTool_drawStartHandler,false,0,true);
			_drawTool.addEventListener(DrawEvent.DRAW_END,drawTool_drawEndHandler,false,0,true);
			_drawTool.markerSymbol = _symbolHolder.sms;
			_drawTool.lineSymbol = _symbolHolder.sls;
			_drawTool.fillSymbol = _symbolHolder.sfs;

		}
		protected function drawTool_drawStartHandler(event:DrawEvent):void
		{
			_drawToolGraphicsLayer.clear();
		}
		protected function drawTool_drawEndHandler(event:DrawEvent):void
		{
			_dispatcher.dispatchEvent(new MapSelectionEvent(MapSelectionEvent.DRAW_EVENT_COMPLETE,event.graphic));
		}
		//--------------------------------------------------------------------------
		// Called when currentState changes
		//--------------------------------------------------------------------------
		public function toggleDrawTool(drawToolActive:Boolean):void
		{
			if(_drawToolGraphicsLayer && _drawTool && drawToolType != "")
			{
				if(drawToolActive)
				{
					_drawTool.activate(DrawToolUtil.getToolTypeConstant(_drawToolType));
					//_drawToolEnabled = false;
				}
				else
				{
					_drawTool.deactivate();
					//_drawToolEnabled = true;
				}
			}
		}
		//--------------------------------------------------------------------------
		//
		// minimizing layers
		//
		//--------------------------------------------------------------------------
		public function openedHandler():void
		{
			if(_drawToolGraphicsLayer)
			{
				_drawToolGraphicsLayer.visible = true;
				_resultsGraphicsLayer.visible = true;
			}
			if(_drawToolEnabled && currentState == StateEnum.SEARCH_STATE)_drawTool.activate(DrawToolUtil.getToolTypeConstant(_drawToolType));
		}
		public function closedHandler():void
		{
			if(_drawToolGraphicsLayer)
			{
				_drawToolGraphicsLayer.visible = false;
				_resultsGraphicsLayer.visible = false;
			}
			if(_drawToolEnabled)_drawTool.deactivate();
		}
		public function minimizedHandler():void
		{
			if(_drawToolGraphicsLayer)
			{
				_drawToolGraphicsLayer.visible = false;
				_resultsGraphicsLayer.visible = false;
			}
			if(_drawToolEnabled)_drawTool.deactivate();
		}

		//--------------------------------------------------------------------------
		//
		// Search View Event Handlers
		//
		//--------------------------------------------------------------------------
		public function changeMapSelectionHandler(event:SearchViewEvent):void
		{
			if(!event.mapSelectionToggleEnabled){
				_drawTool.activate(DrawToolUtil.getToolTypeConstant(_drawToolType));
				_drawToolEnabled = true;
			}
			else
			{
				_drawToolEnabled = false;
				_drawTool.deactivate();
				_drawToolGraphicsLayer.clear();
			}
		}

		//--------------------------------------------------------------------------
		//
		// Getters and setters
		//
		//--------------------------------------------------------------------------
		[Bindable(event="currentStateChange")]
		public function get currentState():String
		{
			return _currentState;
		}

		public function set currentState(value:String):void
		{
			if( _currentState !== value)
			{
				_lastState = _currentState;
				_currentState = value;
				dispatchEvent(new Event("currentStateChange"));
			}
		}

		[Bindable(event="lastStateChange")]
		public function get lastState():String
		{
			return _lastState;
		}

		public function set lastState(value:String):void
		{
			if( _lastState !== value)
			{
				_lastState = value;
				dispatchEvent(new Event("lastStateChange"));
			}
		}

		public function get map():Map
		{
			return _map;
		}

		public function set map(value:Map):void
		{
			_map = value;
		}

		public function get drawToolEnabled():Boolean
		{
			return _drawToolEnabled;
		}

		public function set drawToolEnabled(value:Boolean):void
		{
			_drawToolEnabled = value;
		}

		public function get drawToolType():String
		{
			return _drawToolType;
		}

		public function set drawToolType(value:String):void
		{
			_drawToolType = value;
		}


	}
}