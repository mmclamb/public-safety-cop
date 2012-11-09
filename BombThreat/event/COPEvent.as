package widgets.BombThreat.event
{
	import flash.events.Event;
	
	public class COPEvent extends Event
	{
		public static const DROP_THE_IMAGE:String = "dropTheImage";
		
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


