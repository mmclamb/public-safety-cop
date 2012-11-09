package widgets.ReportByException
{
    import mx.core.ClassFactory;
    
    import widgets.ReportByException.UserDefinedLocationItemRenderer;
    
    import spark.components.DataGroup;
    
    public class UserDefinedLocationDataGroup extends DataGroup
    {
        public function UserDefinedLocationDataGroup()
        {
            super();
            
            this.itemRenderer = new ClassFactory(UserDefinedLocationItemRenderer);
        }
    }
}