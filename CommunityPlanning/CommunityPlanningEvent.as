package widgets.CommunityPlanning
{
	import flash.events.Event;
	
	public class CommunityPlanningEvent extends Event
	{
		public var dataObject:Object;
		
		//when land use type of selected graphic is changed
		public static var LAND_USE_TYPE_CHANGED:String  = "landUseTypeChanged";
		
		public function CommunityPlanningEvent(type:String,ob:Object=null)
		{
			super(type);
			dataObject = ob;
		}
		
		public override function clone():Event
		{
			return new CommunityPlanningEvent(type,dataObject)
		}
	}
}