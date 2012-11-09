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
    
    import com.esri.ags.geometry.Geometry;
    import com.esri.ags.geometry.MapPoint;   
    import flash.events.EventDispatcher;
    
    [Bindable]
    [RemoteClass(alias="myWidgets.ReportByException.ReportByExceptionFeed")]
    
    public class ReportByExceptionFeed extends EventDispatcher
    {
        public var content:String;
        
        public var geometry:Geometry;
        
        public var icon:String;
        
        public var link:String;
        
        public var point:MapPoint;
        
        public var title:String;    
    }
}
