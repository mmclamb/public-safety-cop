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
package widgets.SalesAnalysis.event
{

import com.esri.ags.Graphic;

import flash.events.Event;

public class ChartViewEvent extends Event
{
    /**
     * An item in the Chart has been selected
     */
    public static const CHART_ITEM_SELECTED:String = "chartItemSelected";
    /**
     * The record in the DataGrid that is a Graphic Object
     */
    public var graphic:Graphic;

    /**
     *
     * @param type The constant representing the event type
     * @param value The graphic to pass along with this event
     *
     */
    public function ChartViewEvent(type:String, value:Graphic)
    {
        super(type);
        graphic = value;
    }

    /**
     * @private
     */
    override public function clone():Event
    {
        return new ChartViewEvent(type, graphic);
    }

    /**
     * @private
     */
    override public function toString():String
    {
        return formatToString("ChartViewEvent", "type", "graphic");
    }
}
}
