package widgets.EventType.event
{
	import flash.events.Event;
	
	public class COPEvent extends Event
	{
		public static const SET_LAYER_VISIBLE_ON_OFF:String = "setLayerVisibleOn";

		

		
		public var data:Object = new Object()
		public function COPEvent(type:String,data:Object=null ) 
		{
			super(type);
			if(data!=null)
				this.data = data;
		}
		
		
		
		override public function clone():Event 
		{
			return new COPEvent(type,data);
		}
	}

	
	
	
	
}


