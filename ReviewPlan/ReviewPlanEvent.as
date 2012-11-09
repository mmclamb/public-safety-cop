package widgets.ReviewPlan
{
	import flash.events.Event;
	
	public class ReviewPlanEvent extends Event
	{
		public var dataObject:Object;
		
		//when plan is selected from the result list
		public static var PLAN_SELECTED:String  = "planSelected";
		
		//when selected plan is loaded on the map
		public static var PLAN_LOADED:String = "planLoaded";
		
		public function ReviewPlanEvent(type:String,ob:Object=null)
		{
			super(type);
			dataObject = ob;
		}
		
		public override function clone():Event
		{
			return new ReviewPlanEvent(type,dataObject)
		}
	}
}