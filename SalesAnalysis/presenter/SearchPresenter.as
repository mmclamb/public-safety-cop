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
import com.esri.ags.TimeExtent;
import com.esri.ags.tasks.supportClasses.Query;
import com.esri.stl.components.TextInputPrompt;
import com.esri.stl.utils.DateUtils;
import com.esri.stl.utils.DictionaryUtil;
import com.esri.stl.utils.FormatterUtil;
import com.esri.stl.utils.NumberUtil;
import com.esri.stl.utils.StringUtils;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

import mx.collections.ArrayList;
import mx.events.ValidationResultEvent;
import mx.validators.CurrencyValidator;
import mx.validators.NumberValidator;

import spark.components.TextInput;

import widgets.SalesAnalysis.event.SearchViewEvent;
import widgets.SalesAnalysis.model.ConfigModel;


public class SearchPresenter extends EventDispatcher
{
    public static var MAIN_STATE:String = "mainState";
    public static var MAIN_WITH_MESSAGE_STATE:String = "mainWithMessageState";
    public static var MAIN_WITH_ERROR_STATE:String = "mainWithErrorState";

    private var _dispatcher:EventDispatcher;
    private var _configModel:ConfigModel;
    private var _currentState:String = MAIN_STATE;

    //--------------------------------------------------------------------------
    //
    // Constants
    //
    //--------------------------------------------------------------------------
    // Input tool tips
    [Bindable]
    public var AMOUNT_TEXT_TOOLTIP:String = "Enter Amount";
    [Bindable]
    public var DATE_TEXT_TOOLTIP:String = "Enter Date";
    [Bindable]
    public var AREA_TEXT_TOOLTIP:String = "Enter Area";
    [Bindable]
    public var YEAR_TEXT_TOOLTIP:String = "Enter Year";
    // Clear button tool tips
    [Bindable]
    public var CLEAR_SALE_AMOUNT_TOOLTIP:String = "Clear Sale Amount";
    [Bindable]
    public var CLEAR_SALE_DATE_TOOLTIP:String = "Clear Sale Date";
    [Bindable]
    public var CLEAR_ASSESSED_VALUE_TOOLTIP:String = "Clear Assessed Value";
    [Bindable]
    public var CLEAR_STRUCTURE_TYPE_TOOLTIP:String = "Clear Structure Type";
    [Bindable]
    public var CLEAR_YEAR_BUILT_TOOLTIP:String = "Clear Year Built";
    [Bindable]
    public var CLEAR_FLOOR_AREA_TOOLTIP:String = "Clear Floor Area";
    [Bindable]
    public var CLEAR_NEIGHBORHOOD_TOOLTIP:String = "Clear Neighborhood Name";
    [Bindable]
    public var SALE_AMOUNT_START_PROMPT:String = "Start Amount";
    [Bindable]
    public var SALE_AMOUNT_END_PROMPT:String = "End Amount";
    [Bindable]
    public var ASSESSED_VALUE_START_PROMPT:String = "Start Value";
    [Bindable]
    public var ASSESSED_VALUE_END_PROMPT:String = "End Value";
    [Bindable]
    public var YEAR_BUILT_START_PROMPT:String = "Start Year";
    [Bindable]
    public var YEAR_BUILD_END_PROMPT:String = "End Year";
    [Bindable]
    public var FLOOR_AREA_START_PROMPT:String = "Start Area";
    [Bindable]
    public var FLOOR_AREA_END_PROMPT:String = "End Area";
    [Bindable]

    /*public var currencyMinValue:String = "0";
    public var currencyMaxValue:String = "20000000";
    public var yearMinValue:String =  "2004";
    public var yearMaxValue:String =  "2009";
    public var areaMinValue:String =  "900";
    public var areaMaxValue:String =  "12000";*/

    //--------------------------------------------------------------------------
    //
    // data members
    //
    //--------------------------------------------------------------------------
    [Bindable]
    public var structureTypes:ArrayList = new ArrayList([{ data: "-1", label: "Select Type" }]);
    ;
    [Bindable]
    public var neighborhoods:ArrayList = new ArrayList([{ data: "-1", label: "Select" }]);
    public var selectedIndex:int = 0;

    private var _saleAmountStart:String;
    private var _saleAmountEnd:String;
    private var _saleDateStart:Date;
    private var _saleDateEnd:Date;
    private var _assessedValueStart:String;
    private var _assessedValueEnd:String;
    private var _yearBuiltStart:String;
    private var _yearBuiltEnd:String;
    private var _floorAreaStart:String;
    private var _floorAreaEnd:String;
    private var _structureTypeSelectedItem:Object;
    private var _structureTypeDefault:Object = { data: "-1", label: "Select Type" };
    private var _structureType:String;
    private var _neighborhoodSelectedItem:Object;
    private var _neighborhoodDefault:Object = { data: "-1", label: "Select" };
    private var _neighborhood:String;

    // Validators
    private var _currencyValidator:CurrencyValidator = new CurrencyValidator();
    private var _floorAreaValidator:NumberValidator = new NumberValidator();
    private var _yearValidator:NumberValidator = new NumberValidator();
    private var _validationDictionary:Dictionary = new Dictionary();

    [Bindable]
    private var _errorMessage:String;
    [Bindable]
    private var _message:String;

    private var _isValid:Boolean = true;

    //button label and tooltips
    private var _clearButtonLabel:String;
    private var _clearButtonToolTip:String;
    private var _mapToggleOnLabel:String;
    private var _mapToggleOnToolTip:String;
    private var _mapToggleOffLabel:String;
    private var _mapToggleOffToolTip:String;
    private var _searchButtonLabel:String;
    private var _searchButtonToolTip:String;

    //--------------------------------------------------------------------------
    //
    // These dates are zero bases where January is 0 and December is 11
    // You also want to make the start date one day before and the end date one day after if you want them inclusive
    // http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/controls/DateField.html
    // Time Extent: [2004/01/02 05:00:00 UTC, 2009/02/17 05:00:00 UTC]
    //
    //--------------------------------------------------------------------------
    private var _startDate:Date; // = new Date(2004,0,02);
    private var _endDate:Date; // = new Date(2009,01,17);
    private var _selectableDateRange:Object; // = {rangeStart: _startDateRange, rangeEnd: _endDateRange};

    [Bindable]
    public var dateFieldFormat:String = "MM-DD-YYYY";

    /**
     * Constructor
     *
     */
    public function SearchPresenter(dispatcher:EventDispatcher)
    {
        _dispatcher = dispatcher;
        _configModel = ConfigModel.getInstance();
    }

    public function initializeConfiguration():void
    {
        //<!-- validator for Sale Amount, Assessed Value -->
        _currencyValidator.required = false;
        _currencyValidator.allowNegative = false;
        _currencyValidator.minValue = _configModel.searchCurrencyMinValue;
        _currencyValidator.maxValue = _configModel.searchCurrencyMaxValue;
        _currencyValidator.lowerThanMinError = "Value must be greater than / equal to " + FormatterUtil.formatAsCurrency(_configModel.searchCurrencyMinValue);
        _currencyValidator.exceedsMaxError = "Value must be less than / equal to " + FormatterUtil.formatAsCurrency(_configModel.searchCurrencyMaxValue);
        _currencyValidator.negativeError = "Must be a non-negative number";
        _currencyValidator.invalidCharError = "Must be in the form of currency";
        //<!-- validator for Floor Area -->
        _floorAreaValidator.required = false;
        _floorAreaValidator.allowNegative = false;
        _floorAreaValidator.minValue = _configModel.searchAreaMinValue;
        _floorAreaValidator.maxValue = _configModel.searchAreaMaxValue;
        _floorAreaValidator.lowerThanMinError = "Value must be greater than / equal to " + FormatterUtil.formatAsNumber(_configModel.searchAreaMinValue);
        _floorAreaValidator.exceedsMaxError = "Value must be less than / equal to " + FormatterUtil.formatAsNumber(_configModel.searchAreaMaxValue);
        _floorAreaValidator.negativeError = "Must be a non-negative number";
        //<!-- validator for Year Built -->
        _yearValidator.required = false;
        _yearValidator.allowNegative = false;
        _yearValidator.minValue = _configModel.searchYearMinValue;
        _yearValidator.maxValue = _configModel.searchYearMaxValue;
        _yearValidator.lowerThanMinError = "Value must be greater than / equal to " + _configModel.searchYearMinValue;
        _yearValidator.exceedsMaxError = "Value must be less than / equal to " + _configModel.searchYearMaxValue;
        _yearValidator.negativeError = "Must be a non-negative number";

        _clearButtonLabel = _configModel.searchClearButtonLabel;
        _clearButtonToolTip = _configModel.searchClearButtonToolTip;
        _mapToggleOnLabel = _configModel.searchMapToggleOnLabel;
        _mapToggleOnToolTip = _configModel.searchMapToggleOnToolTip;
        _mapToggleOffLabel = _configModel.searchMapToggleOffLabel;
        _mapToggleOffToolTip = _configModel.searchMapToggleOffToolTip
        _searchButtonLabel = _configModel.searchSearchButtonLabel;
        _searchButtonToolTip = _configModel.searchSearchButtonToolTip;

    }

    //--------------------------------------------------------------------------
    //
    // Event dispatch functions
    //
    //--------------------------------------------------------------------------
    public function executeToggleMapSelection(event:Event, value:Boolean):void
    {
        _dispatcher.dispatchEvent(new SearchViewEvent(SearchViewEvent.CHANGE_MAP_SELECTION, value));
    }

    public function executeSearch(value:Graphic = null):void
    {
        if (value)
        {
            whereClauseQuery(value);
        }
        else
        {
            whereClauseQuery(null);
        }

    }

    //--------------------------------------------------------------------------
    //
    // Search View getters / setters /  functions
    //
    //--------------------------------------------------------------------------
    protected function whereClauseQuery(graphic:Graphic = null):void
    {
        var _queryEnabled:Boolean = false;
        var _queryTimeExtent:TimeExtent;
        var _queryStringDictionary:Dictionary = new Dictionary();


        //--------------------------------------------------------------------------
        // Sale Amount
        //--------------------------------------------------------------------------
        var saleAmountStartRep:String = StringUtils.replace(saleAmountStart, StringUtils.REPLACE_CURRENCY_FORMAT);
        var saleAmountEndRep:String = StringUtils.replace(saleAmountEnd, StringUtils.REPLACE_CURRENCY_FORMAT);
        if (saleAmountStart && saleAmountEnd)
        {

            var compareAmountResult:int = NumberUtil.compare(Number(saleAmountStartRep), Number(saleAmountEndRep));
            if (compareAmountResult == NumberUtil.STARTNUMBER_IS_LESSTHAN_ENDNUMBER || compareAmountResult == NumberUtil.STARTNUMBER_IS_EQUALTO_ENDNUMBER)
            {
                _queryStringDictionary["saleAmount"] = "(" + _configModel.querySaleAmountFieldName + " >= " + saleAmountStartRep + " AND " + _configModel.querySaleAmountFieldName + " <= " + saleAmountEndRep + ")";
            }
            if (compareAmountResult == NumberUtil.STARTNUMBER_IS_GREATERTHAN_ENDNUMBER)
            {
                showErrorMessage("Sale amount start is greater than sale amount end");
                _queryEnabled = false;
                return;
            }
        }
        else if (saleAmountStart)
        {
            _queryStringDictionary["saleAmount"] = _configModel.querySaleAmountFieldName + " >= " + saleAmountStartRep;
        }
        else if (saleAmountEnd)
        {
            _queryStringDictionary["saleAmount"] = _configModel.querySaleAmountFieldName + " <= " + saleAmountEndRep;
        }
        //--------------------------------------------------------------------------
        // Sale Date
        //--------------------------------------------------------------------------
        if (saleDateStart && saleDateEnd)
        {
            var compareDateResult:int = DateUtils.compare(saleDateStart, saleDateEnd);
            if (compareDateResult == DateUtils.STARTDATE_IS_BEFORE_ENDDATE || compareDateResult == DateUtils.STARTDATE_IS_EQUALTO_ENDDATE)
            {
                _queryTimeExtent = new TimeExtent(saleDateStart, saleDateEnd);
            }
            if (compareDateResult == DateUtils.STARTDATE_IS_AFTER_ENDDATE)
            {
                showErrorMessage("Sale start date is after sale end date");
                _queryEnabled = false;
                return;
            }
        }
        else if (saleDateStart)
        {
            _queryTimeExtent = new TimeExtent(saleDateStart, _configModel.layerTimeExtent.endTime);
        }
        else if (saleDateEnd)
        {
            _queryTimeExtent = new TimeExtent(_configModel.layerTimeExtent.startTime, saleDateEnd);
        }
        else
        {
            _queryTimeExtent = _configModel.layerTimeExtent;
        }
        //--------------------------------------------------------------------------
        // Assessed Value
        //--------------------------------------------------------------------------
        var assessedValueStartRep:String = StringUtils.replace(assessedValueStart, StringUtils.REPLACE_CURRENCY_FORMAT);
        var assessedValueEndRep:String = StringUtils.replace(assessedValueEnd, StringUtils.REPLACE_CURRENCY_FORMAT);
        if (assessedValueStart && assessedValueEnd)
        {

            var compareValueResult:int = NumberUtil.compare(Number(assessedValueStartRep), Number(assessedValueEndRep));
            if (compareValueResult == NumberUtil.STARTNUMBER_IS_LESSTHAN_ENDNUMBER || compareValueResult == NumberUtil.STARTNUMBER_IS_EQUALTO_ENDNUMBER)
            {
                _queryStringDictionary["assessedValue"] = "(" + _configModel.queryAssessedValueFieldName + " >= " + assessedValueStartRep + " AND " + _configModel.queryAssessedValueFieldName + " <= " + assessedValueEndRep + ")";
            }
            if (compareValueResult == NumberUtil.STARTNUMBER_IS_GREATERTHAN_ENDNUMBER)
            {
                showErrorMessage("Assessed value start is greater than assessed value end");
                _queryEnabled = false;
                return;
            }
        }
        else if (assessedValueStart)
        {
            _queryStringDictionary["assessedValue"] = _configModel.queryAssessedValueFieldName + " >= " + assessedValueStartRep;
        }
        else if (assessedValueEnd)
        {
            _queryStringDictionary["assessedValue"] = _configModel.queryAssessedValueFieldName + " <= " + assessedValueEndRep;
        }
        //--------------------------------------------------------------------------
        // Structure Type
        //--------------------------------------------------------------------------
        if (_structureType)
        {
            if (_structureType != "-1")
            {
                _queryStringDictionary["structureType"] = _configModel.queryStructureTypeFieldName + " = '" + _structureType + "'";
            }
        }
        //--------------------------------------------------------------------------
        // Year Built
        //--------------------------------------------------------------------------
        if (yearBuiltStart && yearBuiltEnd)
        {
            var compareYearBuiltResult:int = NumberUtil.compare(Number(yearBuiltStart), Number(yearBuiltEnd));
            if (compareYearBuiltResult == NumberUtil.STARTNUMBER_IS_LESSTHAN_ENDNUMBER || compareYearBuiltResult == NumberUtil.STARTNUMBER_IS_EQUALTO_ENDNUMBER)
            {
                _queryStringDictionary["yearBuilt"] = "(" + _configModel.queryYearBuiltFieldName + " >= " + yearBuiltStart + " AND " + _configModel.queryYearBuiltFieldName + " <= " + yearBuiltEnd + ")";
            }
            if (compareYearBuiltResult == NumberUtil.STARTNUMBER_IS_GREATERTHAN_ENDNUMBER)
            {
                showErrorMessage("Year built start is greater than year built end");
                _queryEnabled = false;
                return;
            }
        }
        else if (yearBuiltStart)
        {
            _queryStringDictionary["yearBuilt"] = _configModel.queryYearBuiltFieldName + " >= " + yearBuiltStart;
        }
        else if (yearBuiltEnd)
        {
            _queryStringDictionary["yearBuilt"] = _configModel.queryYearBuiltFieldName + " <= " + yearBuiltEnd;
        }
        //--------------------------------------------------------------------------
        // Floor Area
        //--------------------------------------------------------------------------
        var floorAreaStartRep:String = StringUtils.replace(floorAreaStart, StringUtils.REPLACE_CURRENCY_FORMAT);
        var floorAreaEndRep:String = StringUtils.replace(floorAreaEnd, StringUtils.REPLACE_CURRENCY_FORMAT);
        if (floorAreaStart && floorAreaEnd)
        {

            var compareFloorAreaResult:int = NumberUtil.compare(Number(floorAreaStartRep), Number(floorAreaEndRep));
            if (compareFloorAreaResult == NumberUtil.STARTNUMBER_IS_LESSTHAN_ENDNUMBER || compareFloorAreaResult == NumberUtil.STARTNUMBER_IS_EQUALTO_ENDNUMBER)
            {
                _queryStringDictionary["floorArea"] = "(" + _configModel.queryFloorAreaFieldName + " >= " + floorAreaStartRep + " AND " + _configModel.queryFloorAreaFieldName + " <= " + floorAreaEndRep + ")";
            }
            if (compareFloorAreaResult == NumberUtil.STARTNUMBER_IS_GREATERTHAN_ENDNUMBER)
            {
                showErrorMessage("Floor area start is greater than floor area end");
                _queryEnabled = false;
                return;
            }
        }
        else if (floorAreaStart)
        {
            _queryStringDictionary["floorArea"] = _configModel.queryFloorAreaFieldName + " >= " + floorAreaStartRep;
        }
        else if (floorAreaEnd)
        {
            _queryStringDictionary["floorArea"] = _configModel.queryFloorAreaFieldName + " <= " + floorAreaEndRep;
        }
        //--------------------------------------------------------------------------
        // Neighborhood
        //--------------------------------------------------------------------------
        if (_neighborhood)
        {
            if (_neighborhood != "-1")
            {
                _queryStringDictionary["neighborhood"] = _configModel.queryNeighborhoodFieldName + " = '" + _neighborhood + "'";
            }
        }

        var queryString:String = "";
        var dictArr:Array = DictionaryUtil.getKeys(_queryStringDictionary);
        var count:int = 0;
        for each (var value:Object in _queryStringDictionary)
        {
            if (value)
            {
                //cast it to your object type
                var val:String = String(value);
                count++;
                if (count < dictArr.length)
                {
                    queryString += val + " AND ";
                }
                else
                {
                    queryString += val;
                }
            }
        }
        _queryEnabled = true;
        var _query:Query = new Query();
        if (graphic)
        {
            _query.geometry = graphic.geometry;
        }
        _query.outSpatialReference = _configModel.mapSpatialReference;
        _query.returnGeometry = true;
        _query.outFields = _configModel.queryAllOutFieldsArr;
        if (queryString == "")
        {
            _query.where = _configModel.queryDefaultQuery;
        }
        else
        {
            _query.where = queryString;
        }
        _query.timeExtent = _queryTimeExtent;
        //dispatch Event
        message = "Searching....";
        currentState = MAIN_WITH_MESSAGE_STATE;
        if (_queryEnabled && _isValid)
        {
            _dispatcher.dispatchEvent(new SearchViewEvent(SearchViewEvent.EXECUTE_SEARCH, false, _query));
        }
        else
        {
            showErrorMessage("Search criteria invalid, please double check input.");
        }
    } //end function

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

    /**
     *
     * @param value
     *
     */
    public function clear(value:String):void
    {
        switch (value)
        {
            case CLEAR_SALE_AMOUNT_TOOLTIP:
            {
                saleAmountStart = "";
                saleAmountEnd = "";
                clearValidation("saleAmountStart");
                clearValidation("saleAmountEnd");
                break;
            }
            case CLEAR_SALE_DATE_TOOLTIP:
            {
                saleDateStart = null;
                saleDateEnd = null;
                break;
            }
            case CLEAR_ASSESSED_VALUE_TOOLTIP:
            {
                assessedValueStart = "";
                assessedValueEnd = "";
                clearValidation("assessedValueStart");
                clearValidation("assessedValueEnd");
                break;
            }
            case CLEAR_STRUCTURE_TYPE_TOOLTIP:
            {
                structureTypeSelectedItem = null;
                break;
            }
            case CLEAR_YEAR_BUILT_TOOLTIP:
            {
                yearBuiltStart = "";
                yearBuiltEnd = "";
                clearValidation("yearBuiltStart");
                clearValidation("yearBuiltEnd");
                break;
            }
            case CLEAR_FLOOR_AREA_TOOLTIP:
            {
                floorAreaStart = "";
                floorAreaEnd = "";
                clearValidation("floorAreaStart");
                clearValidation("floorAreaEnd");
                break;
            }
            case CLEAR_NEIGHBORHOOD_TOOLTIP:
            {
                neighborhoodSelectedItem = null;
                break;
            }

            default:
            {
                clearValidation("ALL");
                saleAmountStart = "";
                saleAmountEnd = "";
                saleDateStart = null;
                saleDateEnd = null;
                assessedValueStart = "";
                assessedValueEnd = "";
                structureTypeSelectedItem = null;
                yearBuiltStart = "";
                yearBuiltEnd = "";
                floorAreaStart = "";
                floorAreaEnd = "";
                neighborhoodSelectedItem = null;
                break;
            }
        } //end switch
        _isValid = true;
        clearErrorMessage();
    } //end clear

    //--------------------------------------------------------------------------
    //
    //  Functions for formatting form input
    //
    //--------------------------------------------------------------------------
    /**
     *
     * @param event
     *
     */
    public function formatCurrency(event:Event):void
    {
        var target:TextInput = TextInput(event.currentTarget);
        target.text = FormatterUtil.formatAsCurrency(event.currentTarget.text);
    }

    public function formatNumber(event:Event):void
    {
        var target:TextInput = TextInput(event.currentTarget);
        target.text = FormatterUtil.formatAsNumber(event.currentTarget.text);
    }

    public function focusInHandler(event:FocusEvent):void
    {
        var target:TextInput = TextInput(event.currentTarget);
        target.selectRange(0, target.text.length);
    }

    //--------------------------------------------------------------------------
    //
    // Validation
    //
    //--------------------------------------------------------------------------
    private function clearValidation(value:String):void
    {
        if (value == "ALL")
        {
            for each (var _value:Object in _validationDictionary)
            {
                if (_value)
                {
                    //cast it to your object type
                    var objectType:TextInputPrompt = TextInputPrompt(_value);
                    if (objectType != null)
                    {
                        objectType.errorString = "";
                    }
                }
            }
        }
        else
        {
            var uiComponent:TextInputPrompt = _validationDictionary[value] as TextInputPrompt;
            if (uiComponent != null)
            {
                uiComponent.errorString = "";
            }
        }
    }

    /**
     *
     * @param event
     *
     */
    public function currencyValidation(event:Event):void
    {
        var target:TextInput = TextInput(event.currentTarget);
        _validationDictionary[target.id] = target;
        _currencyValidator.listener = event.currentTarget;
        var vCurrencyResult:ValidationResultEvent = _currencyValidator.validate(target.text);
        if (vCurrencyResult.type == ValidationResultEvent.VALID)
        {
            _isValid = true;
            clearErrorMessage();
        }
        else
        {
            showErrorMessage(vCurrencyResult.message);
            //target.selectRange(0, target.text.length);
            _isValid = false;
        }
    }

    /**
     *
     * @param event
     *
     */
    public function floorAreaValidation(event:Event):void
    {
        var target:TextInput = TextInput(event.currentTarget);
        _validationDictionary[target.id] = target;
        _floorAreaValidator.listener = event.currentTarget;
        var vNumberResult:ValidationResultEvent = _floorAreaValidator.validate(target.text);
        if (vNumberResult.type == ValidationResultEvent.VALID)
        {
            _isValid = true;
            clearErrorMessage();
        }
        else
        {
            showErrorMessage(vNumberResult.message);
            //target.selectRange(0, target.text.length);
            _isValid = false;
        }
    }

    /**
     *
     * @param event
     *
     */
    public function yearValidation(event:Event):void
    {
        var target:TextInput = TextInput(event.currentTarget);
        _validationDictionary[target.id] = target;
        _yearValidator.listener = event.currentTarget;
        var vNumberResult:ValidationResultEvent = _yearValidator.validate(target.text);
        if (vNumberResult.type == ValidationResultEvent.VALID)
        {
            _isValid = true;
            clearErrorMessage();
        }
        else
        {
            showErrorMessage(vNumberResult.message);
            //target.selectRange(0, target.text.length);
            _isValid = false;
        }
    }

    //--------------------------------------------------------------------------
    //
    // getters and setters
    //
    //--------------------------------------------------------------------------
    [Bindable("dateRangeChanged")]
    /**
     *
     * @return
     *
     */
    public function get selectableDateRange():Object
    {
        return { rangeStart: _startDate, rangeEnd: _endDate };
    }

    /**
     *
     * @param startValue
     * @param endValue
     *
     */
    public function startEndDateRange(startValue:Date, endValue:Date):void
    {
        _startDate = startValue;
        _endDate = endValue;
        dispatchEvent(new Event("dateRangeChanged"));
    }

    [Bindable(event="saleAmountStartChange")]
    /**
     * Starting sale amount
     */
    public function get saleAmountStart():String
    {
        return _saleAmountStart;
    }

    /**
     * @private
     */
    public function set saleAmountStart(value:String):void
    {
        if (_saleAmountStart !== value)
        {
            _saleAmountStart = value;
            dispatchEvent(new Event("saleAmountStartChange"));
        }
    }

    [Bindable(event="saleAmountEndChange")]
    /**
     * Ending sale amount
     */
    public function get saleAmountEnd():String
    {
        return _saleAmountEnd;
    }

    /**
     * @private
     */
    public function set saleAmountEnd(value:String):void
    {
        if (_saleAmountEnd !== value)
        {
            _saleAmountEnd = value;
            dispatchEvent(new Event("saleAmountEndChange"));
        }
    }

    [Bindable(event="saleDateStartChange")]
    /**
     * Starting sale date
     */
    public function get saleDateStart():Date
    {
        return _saleDateStart;
    }

    /**
     * @private
     */
    public function set saleDateStart(value:Date):void
    {
        if (_saleDateStart !== value)
        {
            _saleDateStart = value;
            dispatchEvent(new Event("saleDateStartChange"));
        }
    }

    [Bindable(event="saleDateEndChange")]
    /**
     * Ending sale date
     */
    public function get saleDateEnd():Date
    {
        return _saleDateEnd;
    }

    /**
     * @private
     */
    public function set saleDateEnd(value:Date):void
    {
        if (_saleDateEnd !== value)
        {
            _saleDateEnd = value;
            dispatchEvent(new Event("saleDateEndChange"));
        }
    }

    [Bindable(event="assessedValueStartChange")]
    /**
     * Starting assessed value
     */
    public function get assessedValueStart():String
    {
        return _assessedValueStart;
    }

    /**
     * @private
     */
    public function set assessedValueStart(value:String):void
    {
        if (_assessedValueStart !== value)
        {
            _assessedValueStart = value;
            dispatchEvent(new Event("assessedValueStartChange"));
        }
    }

    [Bindable(event="assessedValueEndChange")]
    /**
     * Ending assessed value
     */
    public function get assessedValueEnd():String
    {
        return _assessedValueEnd;
    }

    /**
     * @private
     */
    public function set assessedValueEnd(value:String):void
    {
        if (_assessedValueEnd !== value)
        {
            _assessedValueEnd = value;
            dispatchEvent(new Event("assessedValueEndChange"));
        }
    }



    [Bindable(event="yearBuiltStartChange")]
    /**
     * Starting year built
     */
    public function get yearBuiltStart():String
    {
        return _yearBuiltStart;
    }

    /**
     * @private
     */
    public function set yearBuiltStart(value:String):void
    {
        if (_yearBuiltStart !== value)
        {
            _yearBuiltStart = value;
            dispatchEvent(new Event("yearBuiltStartChange"));
        }
    }

    [Bindable(event="yearBuiltEndChange")]
    /**
     * Ending year Built
     */
    public function get yearBuiltEnd():String
    {
        return _yearBuiltEnd;
    }

    /**
     * @private
     */
    public function set yearBuiltEnd(value:String):void
    {
        if (_yearBuiltEnd !== value)
        {
            _yearBuiltEnd = value;
            dispatchEvent(new Event("yearBuiltEndChange"));
        }
    }

    [Bindable(event="floorAreaStartChange")]
    /**
     * Starting floor area (square footage)
     */
    public function get floorAreaStart():String
    {
        return _floorAreaStart;
    }

    /**
     * @private
     */
    public function set floorAreaStart(value:String):void
    {
        if (_floorAreaStart !== value)
        {
            _floorAreaStart = value;
            dispatchEvent(new Event("floorAreaStartChange"));
        }
    }

    [Bindable(event="floorAreaEndChange")]
    /**
     * Ending floor area (square footage)
     */
    public function get floorAreaEnd():String
    {
        return _floorAreaEnd;
    }

    /**
     * @private
     */
    public function set floorAreaEnd(value:String):void
    {
        if (_floorAreaEnd !== value)
        {
            _floorAreaEnd = value;
            dispatchEvent(new Event("floorAreaEndChange"));
        }
    }



    [Bindable(event="structureTypeSelectedItemChange")]
    /**
     * Current selected item object, structureType
     */
    public function get structureTypeSelectedItem():Object
    {
        return _structureTypeSelectedItem;
    }

    /**
     * @private
     */
    public function set structureTypeSelectedItem(value:Object):void
    {
        if (_structureTypeSelectedItem !== value)
        {
            _structureTypeSelectedItem = value;
            if (value && value.data != -1 && value.data != "-1")
            {
                _structureType = value.data;
            }
            else
            {
                _structureTypeSelectedItem = _structureTypeDefault;
                _structureType = _structureTypeDefault.data;
            }
            dispatchEvent(new Event("structureTypeSelectedItemChange"));
        }
        else if (value == null)
        {
            _structureTypeSelectedItem = _structureTypeDefault;
            _structureType = _structureTypeDefault.data;
            dispatchEvent(new Event("structureTypeSelectedItemChange"));
        }
    }

    [Bindable(event="neighborhoodSelectedItemChange")]
    /**
     * Current selected item object, neighborhood
     */
    public function get neighborhoodSelectedItem():Object
    {
        return _neighborhoodSelectedItem;
    }

    /**
     * @private
     */
    public function set neighborhoodSelectedItem(value:Object):void
    {
        if (_neighborhoodSelectedItem !== value)
        {
            _neighborhoodSelectedItem = value;
            if (value && value.data != -1 && value.data != "-1")
            {
                _neighborhood = value.data;
            }
            else
            {
                _neighborhoodSelectedItem = _neighborhoodDefault;
                _neighborhood = _neighborhoodSelectedItem.data;
            }
            dispatchEvent(new Event("neighborhoodSelectedItemChange"));
        }
        else if (value == null)
        {
            _neighborhoodSelectedItem = _neighborhoodDefault;
            _neighborhood = _neighborhoodSelectedItem.data;
            dispatchEvent(new Event("neighborhoodSelectedItemChange"));
        }
    }

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
    public function get clearButtonLabel():String
    {
        return _clearButtonLabel;
    }

    public function set clearButtonLabel(value:String):void
    {
        _clearButtonLabel = value;
    }

    [Bindable]
    public function get clearButtonToolTip():String
    {
        return _clearButtonToolTip;
    }

    public function set clearButtonToolTip(value:String):void
    {
        _clearButtonToolTip = value;
    }

    [Bindable]
    public function get mapToggleOnLabel():String
    {
        return _mapToggleOnLabel;
    }

    public function set mapToggleOnLabel(value:String):void
    {
        _mapToggleOnLabel = value;
    }

    [Bindable]
    public function get mapToggleOnToolTip():String
    {
        return _mapToggleOnToolTip;
    }

    public function set mapToggleOnToolTip(value:String):void
    {
        _mapToggleOnToolTip = value;
    }

    [Bindable]
    public function get mapToggleOffLabel():String
    {
        return _mapToggleOffLabel;
    }

    public function set mapToggleOffLabel(value:String):void
    {
        _mapToggleOffLabel = value;
    }

    [Bindable]
    public function get mapToggleOffToolTip():String
    {
        return _mapToggleOffToolTip;
    }

    public function set mapToggleOffToolTip(value:String):void
    {
        _mapToggleOffToolTip = value;
    }

    [Bindable]
    public function get searchButtonLabel():String
    {
        return _searchButtonLabel;
    }

    public function set searchButtonLabel(value:String):void
    {
        _searchButtonLabel = value;
    }

    [Bindable]
    public function get searchButtonToolTip():String
    {
        return _searchButtonToolTip;
    }

    public function set searchButtonToolTip(value:String):void
    {
        _searchButtonToolTip = value;
    }



} //end class
}
