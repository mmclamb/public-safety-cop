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
	import com.esri.stl.ags.layers.supportClasses.FieldFormat;
	import com.esri.stl.ags.utils.SortUtil;
	import com.esri.stl.components.CheckBoxDataGridItemRenderer;
	import com.esri.stl.utils.DateUtils;
	import com.esri.stl.utils.FormatterUtil;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import mx.events.DataGridEvent;
	import mx.events.ListEvent;

	import widgets.SalesAnalysis.event.ResultViewEvent;
	import widgets.SalesAnalysis.event.ViewNavigationEvent;
	import widgets.SalesAnalysis.model.ConfigModel;
	import widgets.SalesAnalysis.model.SalesAnalysisModel;


	public class ResultsPresenter extends EventDispatcher
	{
		public static var MAIN_STATE:String = "mainState";
		public static var MAIN_WITH_MESSAGE_STATE:String = "mainWithMessageState";
		public static var MAIN_WITH_ERROR_STATE:String = "mainWithErrorState";

		private var _dispatcher:EventDispatcher;
		private var _salesAnalysisModel:SalesAnalysisModel;
		private var _configModel:ConfigModel;
		private var _currentState:String = MAIN_STATE;
		private var _errorMessage:String;
		private var _message:String;
		//--------------------------------------------------------------------------
		//
		// Bindable properties
		//
		//--------------------------------------------------------------------------
		private var _enabled:Boolean = false;
		private var _resultsCount:int = 0;
		private var _selectedItem:Object;
		private var _selectedIndex:int;
		private var _dataProvider:ArrayCollection;
		private var _columnOrder:Array;
		private var _columns:Dictionary;
		private var _dataGridColumns:Array;

		//button label and tooltip
		private var _backButtonLabel:String;
		private var _backButtonToolTip:String;
		private var _chartButtonLabel:String;
		private var _chartButtonToolTip:String;
		private var _exportButtonLabel:String;
		private var _exportButtonToolTip:String;

		//--------------------------------------------------------------------------
		//
		// internal vars
		//
		//--------------------------------------------------------------------------
		private var dateFormat:String;
		private var _precision:String;
		/**
		 * Constructor
		 * @param dispatcher
		 *
		 */
		public function ResultsPresenter(dispatcher:EventDispatcher)
		{
			_dispatcher = dispatcher;
			_configModel = ConfigModel.getInstance();
			_salesAnalysisModel = SalesAnalysisModel.getInstance();
		}
		public function initializeConfiguration():void
		{
			_backButtonLabel = _configModel.resultsBackButtonLabel;
			_backButtonToolTip = _configModel.resultsBackButtonToolTip;
			_chartButtonLabel = _configModel.resultsChartButtonLabel;
			_chartButtonToolTip = _configModel.resultsChartButtonToolTip;
			_exportButtonLabel = _configModel.resultsExportButtonLabel;
			_exportButtonToolTip = _configModel.resultsExportButtonToolTip;
		}
		//--------------------------------------------------------------------------
		//
		// Visual Feedback: error messages, state changes
		//
		//--------------------------------------------------------------------------
		public function showErrorMessage(value:String):void
		{
			errorMessage = value;
			currentState = MAIN_WITH_ERROR_STATE;
		}
		public function clearErrorMessage():void
		{
			errorMessage = "";
			currentState = MAIN_STATE;
		}
		public function showMessage(value:String):void
		{
			message = value;
			currentState = MAIN_WITH_MESSAGE_STATE;
		}
		public function clearMessage():void
		{
			message = "";
			currentState = MAIN_STATE;
		}

		public function goSearch(event:MouseEvent):void
		{
			var navEvent:ViewNavigationEvent = new ViewNavigationEvent(ViewNavigationEvent.GO_SEARCH_EVENT);
			_dispatcher.dispatchEvent(navEvent);
		}

		public function resultsDataGrid_itemClickHandler(event:ListEvent):void
		{
			var dataGrid:DataGrid = DataGrid(event.currentTarget);
			var gra:Graphic = dataGrid.selectedItem as Graphic;
			_salesAnalysisModel.resultsSelectedItem = gra;
			_dispatcher.dispatchEvent(new ResultViewEvent(ResultViewEvent.RESULT_ITEM_SELECTED, gra));
		}
		public function clearResultsButton_clickHandler(event:MouseEvent):void
		{
			_dispatcher.dispatchEvent(new ResultViewEvent(ResultViewEvent.CLEAR_SEARCH_RESULTS));
		}
		public function showSalesChart_clickHandler(event:MouseEvent):void
		{
			var resultsAC:ArrayCollection = dataProvider;
			var chartResultsAC:ArrayCollection = new ArrayCollection();
			var currentGraphic:Graphic;
			if(resultsAC.length > 0)
			{
				for (var i:int = 0; i < resultsAC.length; i++)
				{
					currentGraphic = resultsAC.getItemAt(i) as Graphic;
					if(currentGraphic.attributes["CHECKBOX"] == true)
						chartResultsAC.addItem(currentGraphic);
				}
				_salesAnalysisModel.chartGraphicData = chartResultsAC;
			}
			_dispatcher.dispatchEvent(new ResultViewEvent(ResultViewEvent.SHOW_SALES_CHART));
		}
		public function exportResults_clickHandler(event:MouseEvent):void
		{
			_dispatcher.dispatchEvent(new ResultViewEvent(ResultViewEvent.EXPORT_RESULTS_TO_EXCEL));
		}
		//--------------------------------------------------------------------------
		//
		// Functions
		//
		//--------------------------------------------------------------------------

		public function createDataGridColumns():void
		{
			_columnOrder = _configModel.fieldsTableFieldsUtil.fieldsOrder;
			_columns = _configModel.fieldsTableFieldsUtil.fieldsDictionary;

			if(_columnOrder && _columns)
			{
				var m_columns:Array = [];
				for (var i:int = 0; i < _columnOrder.length; i++)
				{
					var ff:FieldFormat = _columns[_columnOrder[i]] as FieldFormat;
					if(ff)
					{
						var dgc:DataGridColumn = new DataGridColumn(ff.name);
						dgc.headerText = ff.alias;
						dgc.dataField = "attributes." + ff.name;
						if(ff.formatType == FieldFormat.FORMAT_TYPE_CURRENCY)
						{
							dgc.labelFunction = currencyLabelFunction;
							//dgc.setStyle("textAlign","right");
							dgc.setStyle("direction","rtl");
						}
						if(ff.formatType == FieldFormat.FORMAT_TYPE_DATE)
						{
							dgc.labelFunction = dateLabelFunction;
							dateFormat = ff.dateFormat;
						}
						if(ff.formatType == FieldFormat.FORMAT_TYPE_NUMBER)
						{
							dgc.labelFunction = numberLabelFunction;
							_precision = ff.precision;
						}
						if(ff.formatType == FieldFormat.FORMAT_TYPE_PERCENTAGE)
						{
							dgc.labelFunction = percentageLabelFunction;
							_precision = ff.precision;
						}
						if(ff.formatType == FieldFormat.FORMAT_TYPE_CHECKBOX)
						{
							dgc.editable = true;
							dgc.width = 15;
							dgc.dataField = ff.name;
							dgc.editorDataField = "selected";
							dgc.rendererIsEditor = true;
							dgc.itemRenderer = new ClassFactory(CheckBoxDataGridItemRenderer);
						}
						m_columns.push(dgc);
					}
				}
				dataGridColumns = m_columns;
			}
		}
		private function percentageLabelFunction(item:Object, column:DataGridColumn):String {
			var fieldNameComponents:Array = column.dataField.split(".");
			if(fieldNameComponents.length > 0)
			{
				return FormatterUtil.formatAsPercentage(item.attributes[fieldNameComponents[1]],_precision);
			}
			else
				return "NaN";
		}
		private function currencyLabelFunction(item:Object, column:DataGridColumn):String {
			var fieldNameComponents:Array = column.dataField.split(".");
			if(fieldNameComponents.length > 0)
			{
				return FormatterUtil.formatAsCurrency(item.attributes[fieldNameComponents[1]]);
			}
			else
				return "NaN";
		}
		private function numberLabelFunction(item:Object, column:DataGridColumn):String {
			var fieldNameComponents:Array = column.dataField.split(".");
			if(fieldNameComponents.length > 0)
			{
				return FormatterUtil.formatAsNumber(item.attributes[fieldNameComponents[1]],_precision);
			}
			else
				return "NaN";
		}
		private function dateLabelFunction(item:Object, column:DataGridColumn):String {
			var fieldNameComponents:Array = column.dataField.split(".");
			if(fieldNameComponents.length > 0)
			{

				return DateUtils.convertMillisecondsToDate(item.attributes[fieldNameComponents[1]],dateFormat,false);
			}
			else
				return "NaN";
		}

		public function headerReleaseEventHandler(event:DataGridEvent):void
		{
			var dgc:DataGridColumn = dataGridColumns[event.columnIndex];
			var dataField:String = event.dataField;
			var dotPos:int = dataField.indexOf('.');
			var field:String = dataField.substring(dotPos+1,dataField.length);
			var sortedAC:ArrayCollection = SortUtil.sortFeatureSet(_dataProvider,field);
			var currentItem:Object = selectedItem;
			dataProvider = sortedAC;
			if(currentItem)
				selectedItem = currentItem;
			event.preventDefault();
		}


		//--------------------------------------------------------------------------
		//
		// getters and setters
		//
		//--------------------------------------------------------------------------
		[Bindable(event="enabledChange")]
		/**
		 * Flag to control whether or not the model is enabled,
		 * based up whether or not the dataProvider has results; length > 0
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}

		/**
		 * @private
		 */
		public function set enabled(value:Boolean):void
		{
			if( _enabled !== value)
			{
				_enabled = value;
				dispatchEvent(new Event("enabledChange"));
			}
		}

		[Bindable(event="selectedItemChange")]
		/**
		 * The current selected item in the DataGrid
		 */
		public function get selectedItem():Object
		{
			return _selectedItem;
		}

		/**
		 * @private
		 */
		public function set selectedItem(value:Object):void
		{
			if( _selectedItem !== value)
			{
				_selectedItem = value;
				dispatchEvent(new Event("selectedItemChange"));
			}
		}

		[Bindable(event="dataProviderChange")]
		/**
		 * The data source for the DataGrid, this is an ArrayCollection of Esri Graphic Objects
		 */
		public function get dataProvider():ArrayCollection
		{
			return _dataProvider;
		}

		/**
		 * @private
		 */
		public function set dataProvider(value:ArrayCollection):void
		{
			if( _dataProvider !== value)
			{
				_dataProvider = value;
				if(_dataProvider && _dataProvider.length)
				{
					resultsCount = _dataProvider.length;
					enabled = true;
				}
				else
					enabled = false;
				dispatchEvent(new Event("dataProviderChange"));
			}
		}

		[Bindable(event="columnOrderChange")]
		/**
		 * Array of Strings representing the field order of columns to be displayed in the DataGrid
		 */
		public function get columnOrder():Array
		{
			return _columnOrder;
		}

		/**
		 * @private
		 */
		public function set columnOrder(value:Array):void
		{
			if( _columnOrder !== value)
			{
				_columnOrder = value;
				createDataGridColumns();
				dispatchEvent(new Event("columnOrderChange"));
			}
		}

		[Bindable(event="columnsChange")]
		/**
		 * Dictionary Object full of FieldFormat class Objects, this is populated by the FieldsConfigUtil class
		 */
		public function get columns():Dictionary
		{
			return _columns;
		}

		/**
		 * @private
		 */
		public function set columns(value:Dictionary):void
		{
			if( _columns !== value)
			{
				_columns = value;
				createDataGridColumns();
				dispatchEvent(new Event("columnsChange"));
			}
		}

		[Bindable(event="dataGridColumnsChange")]
		/**
		 * The Array of <code>DataGridColumns</code> populated from the <code>columnOrder</code> and <code>columns</code> properties
		 */
		public function get dataGridColumns():Array
		{
			return _dataGridColumns;
		}

		/**
		 * @private
		 */
		public function set dataGridColumns(value:Array):void
		{
			if( _dataGridColumns !== value)
			{
				_dataGridColumns = value;
				dispatchEvent(new Event("dataGridColumnsChange"));
			}
		}

		[Bindable(event="resultsCountChange")]
		public function get resultsCount():int
		{
			return _resultsCount;
		}

		public function set resultsCount(value:int):void
		{
			if( _resultsCount !== value)
			{
				_resultsCount = value;
				dispatchEvent(new Event("resultsCountChange"));
			}
		}

		[Bindable(event="selectedIndexChange")]
		/**
		 * The index in the data provider of the selected item.
		 */
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		/**
		 * @private
		 */
		public function set selectedIndex(value:int):void
		{
			if( _selectedIndex !== value)
			{
				_selectedIndex = value;
				dispatchEvent(new Event("selectedIndexChange"));
			}
		}

		[Bindable]
		public function get currentState():String
		{
			return _currentState;
		}

		public function set currentState(value:String):void
		{
			_currentState = value;
		}

		[Bindable]
		public function get errorMessage():String
		{
			return _errorMessage;
		}

		public function set errorMessage(value:String):void
		{
			_errorMessage = value;
		}

		[Bindable]
		public function get message():String
		{
			return _message;
		}

		public function set message(value:String):void
		{
			_message = value;
		}

		[Bindable]
		public function get backButtonLabel():String
		{
			return _backButtonLabel;
		}

		public function set backButtonLabel(value:String):void
		{
			_backButtonLabel = value;
		}

		[Bindable]
		public function get backButtonToolTip():String
		{
			return _backButtonToolTip;
		}

		public function set backButtonToolTip(value:String):void
		{
			_backButtonToolTip = value;
		}

		[Bindable]
		public function get chartButtonLabel():String
		{
			return _chartButtonLabel;
		}

		public function set chartButtonLabel(value:String):void
		{
			_chartButtonLabel = value;
		}

		[Bindable]
		public function get chartButtonToolTip():String
		{
			return _chartButtonToolTip;
		}

		public function set chartButtonToolTip(value:String):void
		{
			_chartButtonToolTip = value;
		}

		[Bindable]
		public function get exportButtonLabel():String
		{
			return _exportButtonLabel;
		}

		public function set exportButtonLabel(value:String):void
		{
			_exportButtonLabel = value;
		}

		[Bindable]
		public function get exportButtonToolTip():String
		{
			return _exportButtonToolTip;
		}

		public function set exportButtonToolTip(value:String):void
		{
			_exportButtonToolTip = value;
		}


	}//end class
}