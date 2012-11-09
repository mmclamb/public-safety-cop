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
import com.esri.stl.ags.utils.FieldsConfigUtil;
import com.esri.stl.ags.utils.SortUtil;
import com.esri.stl.utils.ColorUtil;
import com.esri.stl.utils.DateUtils;
import com.esri.stl.utils.FormatterUtil;
import com.esri.stl.utils.StringUtils;

import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;

import mx.charts.ChartItem;
import mx.charts.HitData;
import mx.charts.chartClasses.CartesianCanvasValue;
import mx.charts.chartClasses.CartesianDataCanvas;
import mx.charts.chartClasses.IAxis;
import mx.charts.chartClasses.Series;
import mx.charts.events.ChartItemEvent;
import mx.charts.renderers.BoxItemRenderer;
import mx.collections.ArrayCollection;
import mx.graphics.IFill;
import mx.graphics.SolidColor;

import widgets.SalesAnalysis.event.ChartViewEvent;
import widgets.SalesAnalysis.event.ViewNavigationEvent;
import widgets.SalesAnalysis.model.ConfigModel;
import widgets.SalesAnalysis.model.SalesAnalysisModel;

public class ChartPresenter extends EventDispatcher
{
    private var _dispatcher:EventDispatcher;
    private var _configModel:ConfigModel;
    private var _salesAnalysisModel:SalesAnalysisModel;
    //--------------------------------------------------------------------------
    //
    // Bindable data member properties
    //
    //--------------------------------------------------------------------------
    private var _dataProvider:ArrayCollection = new ArrayCollection([
                                                                    { Month: "Jan", SalesRatio: 0.31, AssessedValue: 58360 },
                                                                    { Month: "Feb", SalesRatio: 0.43, AssessedValue: 103930 },
                                                                    { Month: "Mar", SalesRatio: 0.56, AssessedValue: 51280 },
                                                                    { Month: "Apr", SalesRatio: 0.81, AssessedValue: 128800 },
                                                                    { Month: "May", SalesRatio: 1.30, AssessedValue: 225000 }
                                                                    ]);
    [Bindable]
    private var _plotSeriesXFieldName:String = "AssessedValue";
    [Bindable]
    private var _plotSeriesYFieldName:String = "SalesRatio";
    [Bindable]
    private var _xMinimumValue:Number = 51280;
    [Bindable]
    private var _xMaximumValue:Number = 225000;
    [Bindable]
    private var _yMinimumValue:Number = 0.31;
    [Bindable]
    private var _yMaximumValue:Number = 1.30;
    [Bindable]
    private var _salesRatioMedianValue:Number = 0.50;
    //--------------------------------------------------------------------------
    //
    // Bindable UI related variables
    //
    //--------------------------------------------------------------------------
    [Bindable]
    private var _axisFontColor:uint = 0xFFFFFF;
    [Bindable]
    private var _axisStrokeColor:uint = 0xBBCCDD;
    [Bindable]
    private var _axisFontSize:Number = 12;
    [Bindable]
    private var _gridStrokeColor:uint = 0xEEEEEE;
    [Bindable]
    private var _medianLineColor:uint = 0xBB1F16;
    [Bindable]
    private var _medianLineThickness:Number = 6;
    [Bindable]
    private var _aboveMedianColor:uint = 0x008000;
    [Bindable]
    private var _belowMedianColor:uint = 0xBB1F16;
    [Bindable]
    private var _yAxisTitle:String = "Sales Ratio";
    [Bindable]
    private var _yAxisShapeLabel:String = "Sales Ratio: ";
    [Bindable]
    private var _xAxisTitle:String = "Assessed Value";
    [Bindable]
    private var _xAxisShapeLabel:String = "Assessed Value: ";

    private var _medianCanvas:CartesianDataCanvas;
    //--------------------------------------------------------------------------
    //
    // Calculate min and max axis range
    //
    //--------------------------------------------------------------------------
    private var _xMinimum:Number = xMinimumValue - (xMinimumValue * 0.25);
    private var _xMaximum:Number = xMaximumValue + (xMaximumValue * 0.25);
    private var _yMinimum:Number = yMinimumValue - (yMinimumValue * 0.25);
    private var _yMaximum:Number = yMaximumValue + (yMaximumValue * 0.25);

    private var _sortedByYAxisAC:ArrayCollection;
    private var _sortedByXAxisAC:ArrayCollection;
    private var _chartFieldsConfigUtil:FieldsConfigUtil;

    /**
     * Constructor
     *
     */
    public function ChartPresenter(dispatcher:EventDispatcher)
    {
        _dispatcher = dispatcher;
        _configModel = ConfigModel.getInstance();
        _salesAnalysisModel = SalesAnalysisModel.getInstance();
    }

    public function initializeConfiguration():void
    {
        plotSeriesXFieldName = _configModel.chartPlotSeriesXFieldName; // "CNTASSDVAL";
        plotSeriesYFieldName = _configModel.chartPlotSeriesYFieldName; //"SALESRATIO";
        axisFontColor = _configModel.chartAxisFontColor; //0xFFFFFF;
        axisStrokeColor = _configModel.chartAxisStrokeColor; //0xBBCCDD;
        axisFontSize = _configModel.chartAxisFontSize; //12;
        gridStrokeColor = _configModel.chartGridStrokeColor; //0xEEEEEE;
        medianLineColor = _configModel.chartMedianLineColor; //0x5197EC;
        medianLineThickness = _configModel.chartMedianLineThickness; //6;
        aboveMedianColor = _configModel.chartAboveMedianColor; //0x5FA351;//77C463,008000
        belowMedianColor = _configModel.chartBelowMedianColor; //0xBF3F0A;//BB1F16,B42F0B
        yAxisTitle = _configModel.chartYAxisTitle; //"Sales Ratio";
        yAxisShapeLabel = _configModel.chartYAxisShapeLabel; //"Sales Ratio: ";
        xAxisTitle = _configModel.chartXAxisTitle; //"Assessed Value";
        xAxisShapeLabel = _configModel.chartXAxisShapeLabel; //"Assessed Value: ";
    }

    public function plot_itemClickHandler(event:ChartItemEvent):void
    {
        var chartItem:Graphic = Graphic(event.hitData.chartItem.item);
        if (chartItem)
        {
            _salesAnalysisModel.chartSelectedItem = chartItem;
            _dispatcher.dispatchEvent(new ChartViewEvent(ChartViewEvent.CHART_ITEM_SELECTED, chartItem));
        }
    }

    public function goResults():void
    {
        _dispatcher.dispatchEvent(new ViewNavigationEvent(ViewNavigationEvent.GO_RESULTS_EVENT));
    }

    //--------------------------------------------------------------------------
    //
    //  Main functions
    //
    //--------------------------------------------------------------------------
    protected function calcluateChartData():void
    {
        _chartFieldsConfigUtil = _configModel.fieldsChartFieldsUtil;
        if (dataProvider.length < 1)
        {
            return;
        }
        _sortedByXAxisAC = SortUtil.sortFeatureSet(_dataProvider, _plotSeriesXFieldName);
        var lastXPos:int = _sortedByXAxisAC.length - 1;
        var xMminGraphic:Graphic = _sortedByXAxisAC.getItemAt(0) as Graphic;
        var xMaxGraphic:Graphic = _sortedByXAxisAC.getItemAt(lastXPos) as Graphic;

        xMinimumValue = Number(getValueFromGraphic(xMminGraphic, _plotSeriesXFieldName));
        xMaximumValue = Number(getValueFromGraphic(xMaxGraphic, _plotSeriesXFieldName));
        xMinimum = xMinimumValue - (xMinimumValue * 0.0625);
        xMaximum = xMaximumValue + (xMaximumValue * 0.0625);

        _sortedByYAxisAC = SortUtil.sortFeatureSet(_dataProvider, _plotSeriesYFieldName);
        salesRatioMedianValue = SortUtil.findMedianFeatureSet(_dataProvider, _plotSeriesYFieldName);

        var lastYPos:int = _sortedByYAxisAC.length - 1;
        var yMinGraphic:Graphic = _sortedByYAxisAC.getItemAt(0) as Graphic;
        var yMaxGraphic:Graphic = _sortedByYAxisAC.getItemAt(lastYPos) as Graphic;

        yMinimumValue = Number(getValueFromGraphic(yMinGraphic, _plotSeriesYFieldName));
        yMaximumValue = Number(getValueFromGraphic(yMaxGraphic, _plotSeriesYFieldName));
        yMinimum = yMinimumValue - (yMinimumValue * 0.0625);
        yMaximum = yMaximumValue + (yMaximumValue * 0.0625);
        renderMedianCanvas();
    }

    protected function getValueFromGraphic(value:Graphic, fieldName:String):String
    {
        return value.attributes[fieldName];
    }

    protected function renderMedianCanvas():void
    {
        if (_medianCanvas && _xMinimum && _xMaximum && _salesRatioMedianValue && (_sortedByXAxisAC.length > 1))
        {
            _medianCanvas.clear();
            _medianCanvas.toolTip = "Median " + _yAxisShapeLabel + FormatterUtil.formatAsPercentage(String(_salesRatioMedianValue), 2);
            //background line
            _medianCanvas.lineStyle(_medianLineThickness,
                                    _medianLineColor,
                                    0.3,
                                    true,
                                    LineScaleMode.NORMAL,
                                    CapsStyle.ROUND,
                                    JointStyle.MITER,
                                    2
                                    );
            _medianCanvas.moveTo(_xMinimum, _salesRatioMedianValue); //min value of Assessed Value
            _medianCanvas.lineTo(_xMaximum, _salesRatioMedianValue); //max value of Assessed Value
            //foreground line
            _medianCanvas.lineStyle(_medianLineThickness * 0.66,
                                    _medianLineColor,
                                    0.6,
                                    true,
                                    LineScaleMode.NORMAL,
                                    CapsStyle.ROUND,
                                    JointStyle.MITER,
                                    2
                                    );
            _medianCanvas.moveTo(_xMinimum, _salesRatioMedianValue); //min value of Assessed Value
            _medianCanvas.lineTo(_xMaximum, _salesRatioMedianValue); //max value of Assessed Value

            //foreground line
            _medianCanvas.lineStyle(_medianLineThickness * 0.33,
                                    _medianLineColor,
                                    1,
                                    true,
                                    LineScaleMode.NORMAL,
                                    CapsStyle.ROUND,
                                    JointStyle.MITER,
                                    2
                                    );
            _medianCanvas.moveTo(_xMinimum, _salesRatioMedianValue); //min value of Assessed Value
            _medianCanvas.lineTo(_xMaximum, _salesRatioMedianValue); //max value of Assessed Value

        }
    }

    public function chartGraphicDataFunction(series:Series, item:Object, fieldName:String):Object
    {
        var itemGraphic:Graphic = Graphic(item);
        if (fieldName == 'yValue')
        {
            return (itemGraphic.attributes[_plotSeriesYFieldName]);
        }
        else if (fieldName == "xValue")
        {
            return (itemGraphic.attributes[_plotSeriesXFieldName]);
        }
        else
        {
            return null;
        }
    }

    public function plotDataTipFunction(hitData:HitData):String
    {
        var hitItem:Object = Graphic(hitData.item).attributes;
        var labelString:String = "";

        if (_chartFieldsConfigUtil)
        {
            var m_fieldsOrder:Array = _chartFieldsConfigUtil.fieldsOrder;
            var m_fieldsDictionary:Dictionary = _chartFieldsConfigUtil.fieldsDictionary;
            for (var i:int = 0; i < m_fieldsOrder.length; i++)
            {
                var ff:FieldFormat = m_fieldsDictionary[m_fieldsOrder[i]] as FieldFormat;
                if (ff)
                {
                    labelString += "<I>" + ff.alias + ":</I> "; //field alias
                    if (ff.formatType == FieldFormat.FORMAT_TYPE_CURRENCY)
                    {
                        labelString += FormatterUtil.formatAsCurrency(hitItem[ff.name]) + "\n";
                    }
                    else if (ff.formatType == FieldFormat.FORMAT_TYPE_DATE)
                    {
                        labelString += DateUtils.convertMillisecondsToDate(hitItem[ff.name], ff.dateFormat, false) + "\n";
                    }
                    else if (ff.formatType == FieldFormat.FORMAT_TYPE_NUMBER)
                    {
                        labelString += FormatterUtil.formatAsNumber(hitItem[ff.name], ff.precision) + "\n";
                    }
                    else if (ff.formatType == FieldFormat.FORMAT_TYPE_PERCENTAGE)
                    {
                        labelString += FormatterUtil.formatAsPercentage(hitItem[ff.name], 2) + "\n";
                    }
                    else
                    {
                        labelString += hitItem[ff.name] + "\n";
                    }
                }
            }
        } //end if

        if (hitItem[_plotSeriesYFieldName] < _salesRatioMedianValue)
        {
            var _colorBelow:String = ColorUtil.convertToHexadecimal(_belowMedianColor);
            labelString += "<I>" + _yAxisShapeLabel + "</I><B><FONT COLOR='" + _colorBelow + "'>" + FormatterUtil.formatAsPercentage(hitItem[_plotSeriesYFieldName], 2) + "</FONT></B>\n";
            labelString += "<I>" + _xAxisShapeLabel + "</I>" + FormatterUtil.formatAsCurrency(hitItem[_plotSeriesXFieldName]) + "\n";
        }
        else if (hitItem[_plotSeriesYFieldName] == _salesRatioMedianValue)
        {
            var _color:String = ColorUtil.convertToHexadecimal(_medianLineColor);
            labelString += "<I>" + _yAxisShapeLabel + "</I><B><FONT COLOR='" + _color + "'>" + FormatterUtil.formatAsPercentage(hitItem[_plotSeriesYFieldName], 2) + "</FONT></B>\n";
            labelString += "<I>" + _xAxisShapeLabel + "</I>" + FormatterUtil.formatAsCurrency(hitItem[_plotSeriesXFieldName]) + "\n";
        }
        else
        {
            var _colorAbove:String = ColorUtil.convertToHexadecimal(_aboveMedianColor);
            labelString += "<I>" + _yAxisShapeLabel + "</I><B><FONT COLOR='" + _colorAbove + "'>" + FormatterUtil.formatAsPercentage(hitItem[_plotSeriesYFieldName], 2) + "</FONT></B>\n";
            labelString += "<I>" + _xAxisShapeLabel + "</I>" + FormatterUtil.formatAsCurrency(hitItem[_plotSeriesXFieldName]) + "\n";
        }

        return labelString;
    }

    public function xLabelFunction(labelValue:Object, previousValue:Object, axis:IAxis):String
    {
        var fullItem:String = FormatterUtil.formatAsCurrency(String(labelValue));
        return fullItem ? StringUtils.replace(fullItem, StringUtils.REPLACE_ENDING_THOUSAND_PRICE_FORMAT, "K") : String(labelValue);
    }

    public function yLabelFunction(labelValue:Object, previousValue:Object, axis:IAxis):String
    {
        return FormatterUtil.formatAsPercentage(String(labelValue));

    }

    public function plotFillFunction(value:ChartItem, index:Number):IFill
    {
        var aboveMedianShapeFillColor:SolidColor = new SolidColor(_aboveMedianColor);
        var belowMedianShapeFillColor:SolidColor = new SolidColor(_belowMedianColor);
        var medianShapeFillColor:SolidColor = new SolidColor(_medianLineColor);

        var item:Object = Graphic(value.item).attributes;
        if (item[_plotSeriesYFieldName] < _salesRatioMedianValue)
        {
            return belowMedianShapeFillColor;
        }
        else if (item[_plotSeriesYFieldName] == _salesRatioMedianValue)
        {
            return medianShapeFillColor;
        }
        else
        {
            return aboveMedianShapeFillColor;
        }
    }

    //--------------------------------------------------------------------------
    //
    // Getters and setters
    //
    //--------------------------------------------------------------------------
    [Bindable(event="dataProviderChange")]
    /**
     * DataProvider for the PlotChart, this will be an <code>ArrayCollection</code> of Esri Graphic Objects
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
        if (_dataProvider !== value)
        {
            _dataProvider = value;
            if (_dataProvider)
            {
                calcluateChartData();
            }
            dispatchEvent(new Event("dataProviderChange"));
        }
    }

    [Bindable(event="plotSeriesXFieldNameChange")]
    /**
     * Name of the field in the data provider for the x axis
     */
    public function get plotSeriesXFieldName():String
    {
        return _plotSeriesXFieldName;
    }

    /**
     * @private
     */
    public function set plotSeriesXFieldName(value:String):void
    {
        if (_plotSeriesXFieldName !== value)
        {
            _plotSeriesXFieldName = value;
            dispatchEvent(new Event("plotSeriesXFieldNameChange"));
        }
    }

    [Bindable(event="plotSeriesYFieldNameChange")]
    /**
     * Name of the field in the data provider for the y axis
     */
    public function get plotSeriesYFieldName():String
    {
        return _plotSeriesYFieldName;
    }

    /**
     * @private
     */
    public function set plotSeriesYFieldName(value:String):void
    {
        if (_plotSeriesYFieldName !== value)
        {
            _plotSeriesYFieldName = value;
            dispatchEvent(new Event("plotSeriesYFieldNameChange"));
        }
    }

    [Bindable(event="xMinimumValueChange")]
    /**
     * Minimum value for the x field in the data provider
     */
    public function get xMinimumValue():Number
    {
        return _xMinimumValue;
    }

    /**
     * @private
     */
    public function set xMinimumValue(value:Number):void
    {
        if (_xMinimumValue !== value)
        {
            _xMinimumValue = value;
            dispatchEvent(new Event("xMinimumValueChange"));
        }
    }

    [Bindable(event="xMaximumValueChange")]
    /**
     * Maximum value for the x field in the data provider
     */
    public function get xMaximumValue():Number
    {
        return _xMaximumValue;
    }

    /**
     * @private
     */
    public function set xMaximumValue(value:Number):void
    {
        if (_xMaximumValue !== value)
        {
            _xMaximumValue = value;
            dispatchEvent(new Event("xMaximumValueChange"));
        }
    }

    [Bindable(event="yMinimumValueChange")]
    /**
     * Minimum value for the y field in the data provider
     */
    public function get yMinimumValue():Number
    {
        return _yMinimumValue;
    }

    /**
     * @private
     */
    public function set yMinimumValue(value:Number):void
    {
        if (_yMinimumValue !== value)
        {
            _yMinimumValue = value;
            dispatchEvent(new Event("yMinimumValueChange"));
        }
    }

    [Bindable(event="yMaximumValueChange")]
    /**
     * Maximum value for the y field in the data provider
     */
    public function get yMaximumValue():Number
    {
        return _yMaximumValue;
    }

    /**
     * @private
     */
    public function set yMaximumValue(value:Number):void
    {
        if (_yMaximumValue !== value)
        {
            _yMaximumValue = value;
            dispatchEvent(new Event("yMaximumValueChange"));
        }
    }

    [Bindable(event="salesRatioMedianValueChange")]
    /**
     * Median value for the sales ratio
     */
    public function get salesRatioMedianValue():Number
    {
        return _salesRatioMedianValue;
    }

    /**
     * @private
     */
    public function set salesRatioMedianValue(value:Number):void
    {
        if (_salesRatioMedianValue !== value)
        {
            _salesRatioMedianValue = value;
            dispatchEvent(new Event("salesRatioMedianValueChange"));
        }
    }

    [Bindable(event="axisFontColorChange")]
    /**
     * Font color for the x and y axis labels
     */
    public function get axisFontColor():uint
    {
        return _axisFontColor;
    }

    /**
     * @private
     */
    public function set axisFontColor(value:uint):void
    {
        if (_axisFontColor !== value)
        {
            _axisFontColor = value;
            dispatchEvent(new Event("axisFontColorChange"));
        }
    }

    [Bindable(event="axisStrokeColorChange")]
    /**
     * Color for the x and y bar axis
     */
    public function get axisStrokeColor():uint
    {
        return _axisStrokeColor;
    }

    /**
     * @private
     */
    public function set axisStrokeColor(value:uint):void
    {
        if (_axisStrokeColor !== value)
        {
            _axisStrokeColor = value;
            dispatchEvent(new Event("axisStrokeColorChange"));
        }
    }

    [Bindable(event="axisFontSizeChange")]
    /**
     * Font size for the x and y axis labels
     */
    public function get axisFontSize():Number
    {
        return _axisFontSize;
    }

    /**
     * @private
     */
    public function set axisFontSize(value:Number):void
    {
        if (_axisFontSize !== value)
        {
            _axisFontSize = value;
            dispatchEvent(new Event("axisFontSizeChange"));
        }
    }

    [Bindable(event="gridStrokeColorChange")]
    /**
     * Color for the chart grid
     */
    public function get gridStrokeColor():uint
    {
        return _gridStrokeColor;
    }

    /**
     * @private
     */
    public function set gridStrokeColor(value:uint):void
    {
        if (_gridStrokeColor !== value)
        {
            _gridStrokeColor = value;
            dispatchEvent(new Event("gridStrokeColorChange"));
        }
    }

    [Bindable(event="medianLineColorChange")]
    /**
     * Color for the sales ratio median line
     */
    public function get medianLineColor():uint
    {
        return _medianLineColor;
    }

    /**
     * @private
     */
    public function set medianLineColor(value:uint):void
    {
        if (_medianLineColor !== value)
        {
            _medianLineColor = value;
            dispatchEvent(new Event("medianLineColorChange"));
        }
    }

    [Bindable(event="medianLineThicknessChange")]
    /**
     * Thickness for the sales ratio median line
     */
    public function get medianLineThickness():Number
    {
        return _medianLineThickness;
    }

    /**
     * @private
     */
    public function set medianLineThickness(value:Number):void
    {
        if (_medianLineThickness !== value)
        {
            _medianLineThickness = value;
            dispatchEvent(new Event("medianLineThicknessChange"));
        }
    }

    [Bindable(event="aboveMedianColorChange")]
    /**
     * Color for shape values that fall above the sales ratio median line
     */
    public function get aboveMedianColor():uint
    {
        return _aboveMedianColor;
    }

    /**
     * @private
     */
    public function set aboveMedianColor(value:uint):void
    {
        if (_aboveMedianColor !== value)
        {
            _aboveMedianColor = value;
            dispatchEvent(new Event("aboveMedianColorChange"));
        }
    }

    [Bindable(event="belowMedianColorChange")]
    /**
     * Color for shape values that fall below the sales ratio median line
     */
    public function get belowMedianColor():uint
    {
        return _belowMedianColor;
    }

    /**
     * @private
     */
    public function set belowMedianColor(value:uint):void
    {
        if (_belowMedianColor !== value)
        {
            _belowMedianColor = value;
            dispatchEvent(new Event("belowMedianColorChange"));
        }
    }

    [Bindable(event="yAxisTitleChange")]
    /**
     * Title label for the y axis
     */
    public function get yAxisTitle():String
    {
        return _yAxisTitle;
    }

    /**
     * @private
     */
    public function set yAxisTitle(value:String):void
    {
        if (_yAxisTitle !== value)
        {
            _yAxisTitle = value;
            dispatchEvent(new Event("yAxisTitleChange"));
        }
    }

    [Bindable(event="yAxisShapeLabelChange")]
    /**
     * Title label for the y axis shapes
     */
    public function get yAxisShapeLabel():String
    {
        return _yAxisShapeLabel;
    }

    /**
     * @private
     */
    public function set yAxisShapeLabel(value:String):void
    {
        if (_yAxisShapeLabel !== value)
        {
            _yAxisShapeLabel = value;
            dispatchEvent(new Event("yAxisShapeLabelChange"));
        }
    }

    [Bindable(event="xAxisTitleChange")]
    /**
     * Title label for the x axis
     */
    public function get xAxisTitle():String
    {
        return _xAxisTitle;
    }

    /**
     * @private
     */
    public function set xAxisTitle(value:String):void
    {
        if (_xAxisTitle !== value)
        {
            _xAxisTitle = value;
            dispatchEvent(new Event("xAxisTitleChange"));
        }
    }

    [Bindable(event="xAxisShapeLabelChange")]
    /**
     * Title label for the x axis shapes
     */
    public function get xAxisShapeLabel():String
    {
        return _xAxisShapeLabel;
    }

    /**
     * @private
     */
    public function set xAxisShapeLabel(value:String):void
    {
        if (_xAxisShapeLabel !== value)
        {
            _xAxisShapeLabel = value;
            dispatchEvent(new Event("xAxisShapeLabelChange"));
        }
    }

    [Bindable(event="xMinimumChange")]
    /**
     * Calculated x minimum value for x axis
     */
    public function get xMinimum():Number
    {
        return _xMinimum;
    }

    /**
     * @private
     */
    public function set xMinimum(value:Number):void
    {
        if (_xMinimum !== value)
        {
            _xMinimum = value;
            dispatchEvent(new Event("xMinimumChange"));
        }
    }

    [Bindable(event="xMaximumChange")]
    /**
     * Calculated x maximum value for x axis
     */
    public function get xMaximum():Number
    {
        return _xMaximum;
    }

    /**
     * @private
     */
    public function set xMaximum(value:Number):void
    {
        if (_xMaximum !== value)
        {
            _xMaximum = value;
            dispatchEvent(new Event("xMaximumChange"));
        }
    }

    [Bindable(event="yMinimumChange")]
    /**
     * Calculated y minimum value for y axis
     */
    public function get yMinimum():Number
    {
        return _yMinimum;
    }

    /**
     * @private
     */
    public function set yMinimum(value:Number):void
    {
        if (_yMinimum !== value)
        {
            _yMinimum = value;
            dispatchEvent(new Event("yMinimumChange"));
        }
    }

    [Bindable(event="yMaximumChange")]
    /**
     * Calculated y maximum value for the y axis
     */
    public function get yMaximum():Number
    {
        return _yMaximum;
    }

    /**
     * @private
     */
    public function set yMaximum(value:Number):void
    {
        if (_yMaximum !== value)
        {
            _yMaximum = value;
            dispatchEvent(new Event("yMaximumChange"));
        }
    }

    [Bindable(event="medianCanvasChange")]
    public function get medianCanvas():CartesianDataCanvas
    {
        return _medianCanvas;
    }

    public function set medianCanvas(value:CartesianDataCanvas):void
    {
        if (_medianCanvas !== value)
        {
            _medianCanvas = value;
            if (_medianCanvas)
            {
                renderMedianCanvas();
            }
            dispatchEvent(new Event("medianCanvasChange"));
        }
    }

    public function get chartFieldsConfigUtil():FieldsConfigUtil
    {
        return _chartFieldsConfigUtil;
    }

    public function set chartFieldsConfigUtil(value:FieldsConfigUtil):void
    {
        _chartFieldsConfigUtil = value;
    }
} //end of class
}
