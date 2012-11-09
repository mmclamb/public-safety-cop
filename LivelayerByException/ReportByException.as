package widgets.LivelayerByException
{
    import com.esri.ags.geometry.Geometry;
    
    import flash.events.EventDispatcher;
    
    [Bindable]
    [RemoteClass(alias="widgets.ReportByException.ReportByException")]
    
    public class ReportByException extends EventDispatcher
    {
        public var content:String;
        public var geometry:Geometry;
        public var icon:String;
        public var link:String;
        public var point:Geometry;
        public var title:String;
    }
}