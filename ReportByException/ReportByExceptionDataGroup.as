////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2010 ESRI
//
// All rights reserved under the copyright laws of the United States.
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  See use restrictions in the file:
// <install location>/License.txt
//
////////////////////////////////////////////////////////////////////////////////
package widgets.ReportByException
{
    
    import mx.core.ClassFactory;
	import widgets.ReportByException.ReportByExceptionItemRenderer;
    
    import spark.components.DataGroup;
    
    // these events bubble up from the GeoRSSFeedItemRenderer
    [Event(name="rbeClick", type="flash.events.Event")]
    [Event(name="rbeMouseOver", type="flash.events.Event")]
    [Event(name="rbeouseOut", type="flash.events.Event")]
    
    public class ReportByExceptionDataGroup extends DataGroup
    {
        public function ReportByExceptionDataGroup()
        {
            super();
            this.itemRenderer = new ClassFactory(ReportByExceptionItemRenderer);
        }
    }
    
}
