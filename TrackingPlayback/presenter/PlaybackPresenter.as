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
package widgets.TrackingPlayback.presenter
{

import com.esri.ags.Graphic;
import com.esri.ags.TimeExtent;
import com.esri.ags.components.TimeSlider;
import com.esri.ags.events.TimeExtentEvent;
import com.esri.stl.ags.layers.supportClasses.FieldFormat;
import com.esri.stl.ags.utils.SortUtil;
import com.esri.stl.events.CheckBoxDataGridItemRendererChangeEvent;
import com.esri.stl.events.DateTimeChangeEvent;
import com.esri.stl.utils.DateUtils;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

import mx.binding.utils.ChangeWatcher;
import mx.collections.ArrayCollection;
import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.CollectionEvent;
import mx.events.DataGridEvent;
import mx.events.ListEvent;

import spark.components.TextInput;

import widgets.TrackingPlayback.event.PlaybackViewEvent;
import widgets.TrackingPlayback.model.ConfigModel;

public class PlaybackPresenter extends EventDispatcher
{
    public static var MAIN_STATE:String = "mainState";
    public static var MAIN_WITH_MESSAGE_STATE:String = "mainWithMessageState";
    public static var MAIN_WITH_ERROR_STATE:String = "mainWithErrorState";

    private var _dispatcher:EventDispatcher;
    [Bindable]
    private var _configModel:ConfigModel;
    private var _currentState:String = MAIN_STATE;

    [Bindable]
    private var _errorMessage:String;
    [Bindable]
    private var _message:String;

    private var _dataProvider:ArrayCollection;
    private var _dataGridColumns:Array;
    private var _filterFields:Array;
    private var _filterSelectedItem:Object;
    private var _filterKeywordText:String;

    private var _selectedAssetsAC:ArrayCollection;

    private var _startDateTime:Date;
    private var _endDateTime:Date;

    private var _dateRange:Object;

    private var _timeExtent:TimeExtent;
    private var _timeInterval:Number;
    private var _timeIntervalUnits:String;

    private var _timeSliderIsEnabled:Boolean;
    private var _timeSliderIsPlaying:Boolean;

    private var _timeSliderThumbIndexes:Array = [];

    public function PlaybackPresenter(dispatcher:EventDispatcher)
    {
        _dispatcher = dispatcher;
        _configModel = ConfigModel.getInstance();
    }

    public function initializeConfiguration():void
    {
        timeSliderIsEnabled = true;
        timeSliderIsPlaying = false;
        dataGridColumns = _configModel.playbackViewTrackingTableDataGridColumns;
        dataProvider = _configModel.playbackViewTrackingTableDataProvider;
        startDateTime = _configModel.playbackViewStartDateTime;
        endDateTime = _configModel.playbackViewEndDateTime;
        dateRange = _configModel.playbackViewDateRange;

        timeExtent = _configModel.playbackViewTimeExtent;
        timeInterval = _configModel.playbackViewTimeInterval;
        timeIntervalUnits = _configModel.playbackViewTimeIntervalUnits;
        timeSliderThumbIndexes = [ 0, 10 ];

        if (_configModel.fieldsTrackingTableFieldsUtil)
        {
            var fields:Array = _configModel.fieldsTrackingTableFieldsUtil.fieldsOrder;
            var fieldsDictionary:Dictionary = _configModel.fieldsTrackingTableFieldsUtil.fieldsDictionary;
            _filterFields = [];
            for (var i:int = 0; i < fields.length; i++)
            {
                var ff:FieldFormat = fieldsDictionary[fields[i]] as FieldFormat;
                if (ff.name.toLowerCase() != "checkbox")
                {
                    _filterFields.push({ data: ff.name, label: ff.alias });
                }
            }


        }
        _configModel.playbackViewNumberOfAssets = dataProvider.length;
        _selectedAssetsAC = new ArrayCollection();
        for (var j:int = 0; j < dataProvider.length; j++)
        {
            _selectedAssetsAC.addItem(dataProvider.getItemAt(j));
        }

        createDefinitionExpression();
    }



    public function dtcStart_DateTimeChangedHandler(event:DateTimeChangeEvent):void
    {
        var compareDateResult:int = DateUtils.compare(event.newDate, endDateTime);
        if (compareDateResult == DateUtils.STARTDATE_IS_BEFORE_ENDDATE || compareDateResult == DateUtils.STARTDATE_IS_EQUALTO_ENDDATE)
        {
            _configModel.playbackViewTimeExtent.startTime = event.newDate;
            clearErrorMessage();
            resetTimeSliderAndMap();
        }
        if (compareDateResult == DateUtils.STARTDATE_IS_AFTER_ENDDATE)
        {
            showErrorMessage("You tried to set the start date after the end date");
            startDateTime = _configModel.playbackViewTimeExtent.startTime;
            resetTimeSliderAndMap();
        }

    }

    public function dtcEnd_DateTimeChangedHandler(event:DateTimeChangeEvent):void
    {


        var compareDateResult:int = DateUtils.compare(startDateTime, event.newDate);
        if (compareDateResult == DateUtils.STARTDATE_IS_BEFORE_ENDDATE || compareDateResult == DateUtils.STARTDATE_IS_EQUALTO_ENDDATE)
        {
            _configModel.playbackViewTimeExtent.endTime = event.newDate;
            clearErrorMessage();
            resetTimeSliderAndMap();
        }
        if (compareDateResult == DateUtils.STARTDATE_IS_AFTER_ENDDATE)
        {
            showErrorMessage("You tried to set the end date before the start date");
            endDateTime = _configModel.playbackViewTimeExtent.endTime;
            resetTimeSliderAndMap();
        }
    }

    public function timeSlider_timeExtentChangeHandler(event:TimeExtentEvent):void
    {
        _configModel.playbackViewTimeExtent = event.timeExtent;
        _dispatcher.dispatchEvent(new PlaybackViewEvent(PlaybackViewEvent.TIME_EXTENT_CHANGE));
    }

    private function resetTimeSliderAndMap():void
    {
        timeExtent = _configModel.playbackViewTimeExtent;
        timeInterval = _configModel.playbackViewTimeInterval;
        timeIntervalUnits = _configModel.playbackViewTimeIntervalUnits;
        timeSliderThumbIndexes = [ 0, 10 ];
        _dispatcher.dispatchEvent(new PlaybackViewEvent(PlaybackViewEvent.TIME_EXTENT_CHANGE));
    }

    public function headerReleaseEventHandler(event:DataGridEvent):void
    {
        var dgc:DataGridColumn = dataGridColumns[event.columnIndex];
        var dataField:String = event.dataField;
        var dotPos:int = dataField.indexOf('.');
        var field:String = dataField.substring(dotPos + 1, dataField.length);
        var sortedAC:ArrayCollection = SortUtil.sortFeatureSet(_dataProvider, field);
        dataProvider = sortedAC;
        event.preventDefault();
    }

    public function filterButton_clickHandler(event:MouseEvent):void
    {
        if (filterSelectedItem)
        {
            var filterField:String = filterSelectedItem.data as String;
            var sortCollection:ArrayCollection = dataProvider as ArrayCollection;
            var ac:ArrayCollection = SortUtil.uniqueFilterAttributeValue(sortCollection, filterField, filterKeywordText);
        }
    }

    public function resetButton_clickHandler(event:MouseEvent):void
    {
        filterKeywordText = "";
        var ac:ArrayCollection = dataProvider as ArrayCollection;
        ac.filterFunction = null;
        ac.refresh();
    }

    public function focusInHandler(event:FocusEvent):void
    {
        var target:TextInput = TextInput(event.currentTarget);
        target.selectRange(0, target.text.length);
    }

    public function toggleSelection(event:Event, isSelected:Boolean):void
    {
        _configModel.playbackViewNumberOfAssets = 0;
        var length:int = dataProvider.length;
        //normall this would be true, but the click event client-side immediately changes the selected property
        if (!isSelected)
        {
            for (var i:int = 0; i < length; i++)
            {
                var graOn:Graphic = dataProvider.getItemAt(i) as Graphic;
                graOn.attributes["CHECKBOX"] = true;
                _selectedAssetsAC.addItem(graOn);
            }
            _configModel.playbackViewNumberOfAssets++;
        }
        else
        {
            for (var j:int = 0; j < length; j++)
            {
                var graOff:Graphic = dataProvider.getItemAt(j) as Graphic;
                graOff.attributes["CHECKBOX"] = false;
            }
            _selectedAssetsAC.removeAll();
        }
        dataProvider.refresh();
        validatePlaybackViewSelection();
    }

    public function checkBoxSelectionChangeHandler(event:CheckBoxDataGridItemRendererChangeEvent):void
    {
        var gra:Graphic = event.graphic;
        if (gra.attributes["CHECKBOX"])
        {
            _configModel.playbackViewNumberOfAssets++;
            _selectedAssetsAC.addItem(gra);
        }
        else
        {
            _configModel.playbackViewNumberOfAssets--;
            for (var i:int = 0; i < _selectedAssetsAC.length; i++)
            {
                var currentGra:Graphic = _selectedAssetsAC.getItemAt(i) as Graphic;
                if (currentGra.attributes[_configModel.layerTrackingLayerForeignKey] == gra.attributes[_configModel.layerTrackingLayerForeignKey])
                {
                    _selectedAssetsAC.removeItemAt(i);
                }
            }

        }
        validatePlaybackViewSelection();
    }

    protected function validatePlaybackViewSelection():void
    {
        if (_configModel.playbackViewNumberOfAssets > 0)
        {
            clearErrorMessage();
            timeSliderIsEnabled = true;
            createDefinitionExpression();
        }
        else
        {
            _configModel.playbackViewNumberOfAssets = 0;
            timeSliderIsEnabled = false;
            showErrorMessage("Playback will not be enabled unless you have at least one asset selected in the table.");
        }
    }

    protected function createDefinitionExpression():void
    {
        var selectedAssetsDefExpr:String = "";
        var defStr:String = "";
        var length:int = _selectedAssetsAC.length;
        for (var i:int = 0; i < length; i++)
        {
            var gra:Graphic = _selectedAssetsAC.getItemAt(i) as Graphic;
            defStr += _configModel.layerTrackingLayerForeignKey + " = '" + gra.attributes[_configModel.tableTrackingTablePrimaryKey] + "'";
            if (i < _selectedAssetsAC.length - 1)
            {
                defStr += " OR ";
            }
        }
        if (_selectedAssetsAC.length > 1)
        {
            selectedAssetsDefExpr = "(" + defStr + ")";
        }
        else if (_selectedAssetsAC.length == 1)
        {
            selectedAssetsDefExpr = defStr;
        }

        _configModel.playbackViewDefinitionExpression = selectedAssetsDefExpr;
        //DISPATCH EVENT TO UPDATE DEFINITION EXPRESSION
        _dispatcher.dispatchEvent(new PlaybackViewEvent(PlaybackViewEvent.VEHICLE_SELECTION_CHANGE));
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

    //--------------------------------------------------------------------------
    //
    // getters and setters 
    //
    //--------------------------------------------------------------------------

    [Bindable(event="currentStateChange")]
    public function get currentState():String
    {
        return _currentState;
    }

    public function set currentState(value:String):void
    {
        if (_currentState !== value)
        {
            _currentState = value;
            dispatchEvent(new Event("currentStateChange"));
        }
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
    public function get dataProvider():ArrayCollection
    {
        return _dataProvider;
    }

    public function set dataProvider(value:ArrayCollection):void
    {
        _dataProvider = value;
    }

    [Bindable]
    public function get dataGridColumns():Array
    {
        return _dataGridColumns;
    }

    public function set dataGridColumns(value:Array):void
    {
        _dataGridColumns = value;
    }

    [Bindable]
    public function get startDateTime():Date
    {
        return _startDateTime;
    }

    public function set startDateTime(value:Date):void
    {
        _startDateTime = value;
    }

    [Bindable]
    public function get endDateTime():Date
    {
        return _endDateTime;
    }

    public function set endDateTime(value:Date):void
    {
        _endDateTime = value;
    }

    [Bindable]
    public function get timeExtent():TimeExtent
    {
        return _timeExtent;
    }

    public function set timeExtent(value:TimeExtent):void
    {
        _timeExtent = value;
    }

    [Bindable]
    public function get timeInterval():Number
    {
        return _timeInterval;
    }

    public function set timeInterval(value:Number):void
    {
        _timeInterval = value;
    }

    [Bindable]
    public function get timeIntervalUnits():String
    {
        return _timeIntervalUnits;
    }

    public function set timeIntervalUnits(value:String):void
    {
        _timeIntervalUnits = value;
    }

    [Bindable]
    public function get timeSliderThumbIndexes():Array
    {
        return _timeSliderThumbIndexes;
    }

    public function set timeSliderThumbIndexes(value:Array):void
    {
        _timeSliderThumbIndexes = value;
    }

    [Bindable]
    public function get dateRange():Object
    {
        return _dateRange;
    }

    public function set dateRange(value:Object):void
    {
        _dateRange = value;
    }

    [Bindable]
    public function get filterSelectedItem():Object
    {
        return _filterSelectedItem;
    }

    public function set filterSelectedItem(value:Object):void
    {
        _filterSelectedItem = value;
    }

    [Bindable]
    public function get filterKeywordText():String
    {
        return _filterKeywordText;
    }

    public function set filterKeywordText(value:String):void
    {
        _filterKeywordText = value;
    }

    [Bindable]
    public function get filterFields():Array
    {
        return _filterFields;
    }

    public function set filterFields(value:Array):void
    {
        _filterFields = value;
    }

    [Bindable]
    public function get timeSliderIsEnabled():Boolean
    {
        return _timeSliderIsEnabled;
    }

    public function set timeSliderIsEnabled(value:Boolean):void
    {
        _timeSliderIsEnabled = value;
    }

    [Bindable]
    public function get timeSliderIsPlaying():Boolean
    {
        return _timeSliderIsPlaying;
    }

    public function set timeSliderIsPlaying(value:Boolean):void
    {
        _timeSliderIsPlaying = value;
    }






} //end class
}
